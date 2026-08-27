#!/bin/zsh
# Searchable picker over every kitty pane, in tab and pane order.
# Type to filter, arrows to move, enter to focus, esc to cancel.

# kitty inherits the PATH of whatever launched it (Dock/Spotlight), not the
# login shell's, so Homebrew binaries are not on PATH here.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

for bin in fzf jq; do
  command -v $bin >/dev/null || { print -u2 "window-picker: $bin not found on PATH"; exit 1; }
done

list_panes() {
  kitten @ ls | jq -r --arg home "$HOME" --arg self "${KITTY_WINDOW_ID:-0}" '
    def pad($n): (. + (" " * $n))[0:$n];
    def marker:
      if .has_activity_since_last_focus then "\u001b[33m*\u001b[0m"
      elif (.at_prompt | not) then "\u001b[36m>\u001b[0m"
      else " " end;
    def basename: sub("/$"; "") | split("/") | last;
    def looks_like_path: startswith("~") or startswith("/");
    # argv[0] is often an absolute path, so keep only its basename but retain
    # the arguments, which are what distinguish one ssh or editor from another.
    def shortcmd:
      if length == 0 then ""
      elif length == 1 then (.[0] | basename)
      else (.[0] | basename) + " " + (.[1:] | join(" "))
      end;
    # Shell integration reports the command that was actually typed, so a claude
    # session stays "claude" instead of whichever helper process it spawned.
    # Fall back to the foreground process for panes it never reported.
    # last_reported_cmdline keeps its value after the command exits, so an idle
    # pane must be blank rather than advertising what it ran a while ago.
    def cmdlabel:
      if .at_prompt then ""
      else
        (.last_reported_cmdline // "") as $reported
        | if ($reported | length) > 0 then ($reported | split(" ") | shortcmd)
          else ((.foreground_processes[0].cmdline // []) | shortcmd)
          end
      end;
    # The window title is what apps advertise themselves as: claude reports its
    # session name there. Append it to the command unless it merely repeats the
    # command or is the directory that the last column already shows.
    def what:
      cmdlabel as $cmd
      | ($cmd | split(" ") | first // "") as $cmd_name
      | (.title // "") as $title
      | if ($title | length) == 0
           or ($title | looks_like_path)
           or (($cmd_name | length) > 0 and ($title | startswith($cmd_name)))
        then $cmd
        elif ($cmd | length) == 0 then $title
        else $cmd + " " + $title
        end;
    [ .[] as $osw
      | $osw.tabs[].windows[]
      | select(.id != ($self | tonumber))
      | { id,
          mark: marker,
          what: (what | pad(28)),
          cwd: (.cwd | sub("^" + $home; "~"))
        }
    ]
    | .[]
    | [ (.id | tostring), (.mark + "  " + .what + "  " + .cwd) ]
    | @tsv'
}

# Collect the list BEFORE fzf starts. Without a listen_on socket, kitten @ uses
# the TTY channel and kitty returns the response as terminal input; if fzf is
# already running it eats that response and the JSON ends up in the query box.
rows=$(list_panes)
if [[ -z "$rows" ]]; then
  print -u2 "window-picker: no panes found"
  exit 1
fi

sel=$(print -r -- "$rows" | fzf \
  --ansi \
  --delimiter=$'\t' --with-nth=2 \
  --layout=reverse --cycle \
  --height='~80%' --margin='1,1%' --padding=1 \
  --border=rounded --border-label=' panes ' --border-label-pos=center \
  --info=inline-right \
  --prompt='search: ' \
  --header='enter focus / esc cancel' --header-first \
  --color='border:4,label:4,prompt:4,hl:3,hl+:3,info:8,header:8') || true

[[ -n "$sel" ]] && kitten @ focus-window --match "id:${sel%%$'\t'*}"
