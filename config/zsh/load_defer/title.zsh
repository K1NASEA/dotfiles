# Executed just after a command has been read and is about to be executed.
preexec() {
    echo -ne "\e]2;$1\a"
}
# Executed before each prompt.
precmd() {
    echo -ne "\e]2;$HOST\a"
}
