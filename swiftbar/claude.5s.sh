#!/bin/bash
# <swiftbar.type>streamable</swiftbar.type>
# Shows shepherd-supervised agents; red count when any are waiting for input.
# Clicking an agent focuses its iTerm2 tab / tmux pane via focus-agent.sh.

FOCUS="$HOME/workspace/shepherd/tools/focus-agent.sh"

render() {
  local agents n
  agents=$(curl -sf --max-time 2 localhost:4650/agents) || {
    echo "🤖 | color=#888888"
    echo "---"
    echo "shepherd server not running | color=#888888"
    return
  }
  n=$(jq '[.[] | select(.agent_status == "blocked" or .agent_status == "done")] | length' <<<"$agents")
  if [ "$n" -gt 0 ]; then
    echo "🔴 $n | color=#f85149"
  else
    echo "🤖 | color=#888888"
  fi
  echo "---"
  jq -r --arg focus "$FOCUS" '.[]
    | ((if .agent_status == "blocked" or .agent_status == "done" then ["color=#f85149"] else [] end)
       + (if .terminal then ["bash=\"" + $focus + "\"", "param1=" + .terminal.session_id, "terminal=false"] else [] end)) as $params
    | (.name // ((.cwd // .agent_id) | split("/") | last))
      + " — " + .agent_status
      + (if .blocked_reason then " (" + .blocked_reason + ")" else "" end)
      + (if $params | length > 0 then " | " + ($params | join(" ")) else "" end)' <<<"$agents"
}

# ponytail: 1s poll; switch to shepherd socket events if polling ever matters
prev=""
while :; do
  out=$(render)
  if [ "$out" != "$prev" ]; then
    echo "~~~"
    echo "$out"
    prev="$out"
  fi
  sleep 1
done
