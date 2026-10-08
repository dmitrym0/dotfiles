import {
  Action,
  ActionPanel,
  Detail,
  Icon,
  LaunchProps,
  List,
} from "@raycast/api";
import { spawn } from "child_process";
import { homedir, userInfo } from "os";
import { useEffect, useState } from "react";

const CLAUDE = "/opt/homebrew/bin/claude";

type Match = {
  project: string;
  cwd: string;
  sessionId: string;
  path: string;
  dateRange: string;
  summary: string;
  openingPrompts: string[];
};

function buildPrompt(query: string): string {
  return [
    `Use the find-conversation skill to locate past Claude Code sessions matching this description: "${query}".`,
    "Extract 2-4 distinctive keywords and run the skill's search.py. Skip the currently-running session.",
    "Then output ONLY a JSON array (no markdown fences, no prose) of up to 5 matches, best first:",
    '[{"project":"<project slug>","cwd":"<original working directory from the session\'s cwd field>","sessionId":"<uuid, the jsonl filename without extension>","path":"<full jsonl path>","dateRange":"<YYYY-MM-DD .. YYYY-MM-DD>","summary":"<one line: what the session was about>","openingPrompts":["<up to 3 opening user prompts, each truncated to ~200 chars>"]}]',
    "If nothing matches, output [].",
  ].join("\n");
}

function searchSessions(query: string): Promise<Match[]> {
  return new Promise((resolve, reject) => {
    const child = spawn(
      CLAUDE,
      [
        "-p",
        buildPrompt(query),
        // ponytail: haiku for speed; bump to sonnet if keyword extraction misses
        "--model",
        "haiku",
        "--allowedTools",
        "Skill,Bash(python3:*),Bash(ls:*),Read",
      ],
      {
        // stdin must be closed or claude stalls waiting for piped input
        stdio: ["ignore", "pipe", "pipe"],
        timeout: 180_000,
        // Raycast's env lacks USER, which claude's keychain credential lookup needs
        env: {
          ...process.env,
          HOME: process.env.HOME ?? homedir(),
          USER: process.env.USER ?? userInfo().username,
          PATH: process.env.PATH ?? "/usr/bin:/bin:/opt/homebrew/bin",
        },
      },
    );
    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (d) => (stdout += d));
    child.stderr.on("data", (d) => (stderr += d));
    child.on("error", reject);
    child.on("close", (code) => {
      if (code !== 0)
        return reject(
          new Error(`claude exited with ${code}\nstdout: ${stdout.slice(0, 500)}\nstderr: ${stderr.slice(0, 500)}`),
        );
      const start = stdout.indexOf("[");
      const end = stdout.lastIndexOf("]");
      if (start === -1 || end <= start) return reject(new Error(`No JSON in output:\n${stdout.slice(0, 500)}`));
      try {
        resolve(JSON.parse(stdout.slice(start, end + 1)));
      } catch (e) {
        reject(new Error(`Bad JSON from claude: ${e}`));
      }
    });
  });
}

function resumeCommand(m: Match): string {
  return `cd ${JSON.stringify(m.cwd || "~")} && claude --resume ${m.sessionId}`;
}

function SessionDetail({ match }: { match: Match }) {
  const md = [
    `# ${match.summary}`,
    ``,
    `**Project:** \`${match.project}\``,
    `**Dates:** ${match.dateRange}`,
    `**Session:** \`${match.sessionId}\``,
    ``,
    `## Opening prompts`,
    ...match.openingPrompts.map((p) => `> ${p.replace(/\n/g, " ")}\n`),
  ].join("\n");
  return (
    <Detail
      markdown={md}
      actions={
        <ActionPanel>
          <Action.CopyToClipboard title="Copy Resume Command" content={resumeCommand(match)} />
          <Action.Open title="Open Log File" target={match.path} />
          <Action.CopyToClipboard title="Copy Session Id" content={match.sessionId} />
        </ActionPanel>
      }
    />
  );
}

export default function Command(props: LaunchProps<{ arguments: { query: string } }>) {
  const { query } = props.arguments;
  const [matches, setMatches] = useState<Match[] | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    searchSessions(query)
      .then(setMatches)
      .catch((e) => setError(String(e)));
  }, [query]);

  if (error) {
    return <Detail markdown={`# Search failed\n\n\`\`\`\n${error}\n\`\`\``} />;
  }

  if (matches === null) {
    return <Detail isLoading markdown={`# Searching for "${query}"…\n\nClaude is scanning your session logs — takes ~30s.`} />;
  }

  return (
    <List searchBarPlaceholder="Filter results">
      {matches.length === 0 && (
        <List.EmptyView icon={Icon.MagnifyingGlass} title="No matching sessions" description={`Nothing matched "${query}"`} />
      )}
      {matches.map((m) => (
        <List.Item
          key={m.path}
          icon={Icon.Message}
          title={m.summary}
          subtitle={m.project}
          accessories={[{ text: m.dateRange }]}
          actions={
            <ActionPanel>
              <Action.Push title="Show Details" target={<SessionDetail match={m} />} />
              <Action.CopyToClipboard title="Copy Resume Command" content={resumeCommand(m)} />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
