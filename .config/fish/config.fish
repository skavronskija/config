if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x JAVA_HOME (/usr/libexec/java_home -v 21)
end

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
