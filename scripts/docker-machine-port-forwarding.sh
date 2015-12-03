#!/bin/bash
#
# Set up kubectl port forwarding to docker-machine VM if needed.

KUBERNETES_API_PORT=8080

function active_machine {
    if [ $(command -v docker-machine) ]; then
        docker-machine active
    fi
}

# Kube API is accessible on host at 8080, use ssh tunnel
function forward_port_if_not_forwarded {
    local port=$1
    local machine=$(active_machine)

    if [ -n "$machine" ]; then
        if ! pgrep -f "ssh.*$port:localhost:$port" > /dev/null; then
            docker-machine ssh "$machine" -f -N -L "$port:localhost:$port"
        fi
    fi
}

function remove_port_if_forwarded {
    local port=$1
    pkill -f "ssh.*docker.*$port:localhost:$port"
}

