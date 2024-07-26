# zsh options
setopt NO_BG_NICE       # Do not run background jobs at a lower priority (Do not "nice" background jobs)
setopt NO_HUP           # Do not send HUP signal to jobs when the shell exits
setopt NO_LIST_BEEP     # Do not beep on ambiguous completion
setopt LOCAL_OPTIONS    # Use local options in functions and sourced scripts
setopt LOCAL_TRAPS      # Use local traps in functions and sourced scripts
setopt PROMPT_SUBST     # Enable substitution in the prompt string
setopt COMPLETE_ALIASES # Attempt completion on the command word if it is an alias

# zsh history settings
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY     # write the history file in the ":start:elapsed;command" format.
setopt HIST_REDUCE_BLANKS   # remove superfluous blanks before recording entry.
setopt SHARE_HISTORY        # share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS # delete old recorded entry if new entry is a duplicate.
