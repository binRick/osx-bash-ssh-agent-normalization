
KEYS_TO_LOAD="~/.ssh/id_rsa"
CUR_SSH_AGENT_PIDS="$(ps -o pid=,comm= -U $USER| grep ssh-agent| cut -d' ' -f1| sort -u)"
LATEST_SSH_AGENT_PID="$(echo $CUR_SSH_AGENT_PIDS|sort -u|tail -n1)"

CUR_SSH_AGENT_SOCKETS="$(find /var/folders 2>/dev/null| grep 'agent\.[0-9].*[0-9]$')"
LATEST_SSH_AGENT_SOCKET="$(find /var/folders 2>/dev/null| grep 'agent\.[0-9].*[0-9]$' | xargs ls -tr| tail -n1)"

>&2 echo "ssh-agent pids qty: $(echo $CUR_SSH_AGENT_PIDS|wc -l)"
>&2 echo "ssh-agent sockets qty: $(echo $CUR_SSH_AGENT_SOCKETS|wc -l)"
>&2 echo "latest pid: $LATEST_SSH_AGENT_PID"
>&2 echo "latest socket: $LATEST_SSH_AGENT_SOCKET"


if [[ -S "$LATEST_SSH_AGENT_SOCKET" && -w "$LATEST_SSH_AGENT_SOCKET" && "$LATEST_SSH_AGENT_PID" -gt 0 ]]; then
    >&2 echo "existing socket found: socket=$LATEST_SSH_AGENT_SOCKET pid=$LATEST_SSH_AGENT_PID"
    export SSH_AUTH_SOCK="$LATEST_SSH_AGENT_SOCKET"
    export SSH_AGENT_PID="$LATEST_SSH_AGENT_PID"
    CUR_LOCAL_KEYS_LOADED="$(ssh-add -L 2>/dev/null|cut -d' ' -f3)"
    echo CUR_LOCAL_KEYS_LOADED=$CUR_LOCAL_KEYS_LOADED
else
    >&2 echo "no existing socket found. creating new"
    eval $(ssh-agent)
    ssh-add    2>/dev/null
fi


#env|grep '^SSH_'




