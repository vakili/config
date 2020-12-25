# open new instances of qutebrowser faster
# taken from https://maxwell.ydns.eu/git/rnhmjoj/misc/src/branch/master/scripts/qutebrowser
# see also https://old.reddit.com/r/qutebrowser/comments/a2bfkm/qutebrowserclient_a_wrapper_script_to_open/
# currently causes qutebrowser to crash after running script several times
# see python alternative work in progress https://github.com/qutebrowser/qutebrowser/pull/4484#thread-subscription-status#!/usr/bin/env bash

url="$1"
ver='1.9.0'
proto=1
sock="$XDG_RUNTIME_DIR/qutebrowser/ipc-$(printf "%s" "$USER" | md5sum | cut -d\  -f1)"
bin=$(env PATH="$(echo "$PATH" | sed "s|$(dirname "$0"):||g")" sh -c 'command -v qutebrowser')
fmt='{"args": ["%s"], "target_arg": null, "version": "%s", "protocol_version": %d, "cwd": "%s"}\n'

printf "$fmt" "$url" "$ver" "$proto" "$PWD" | nc -U "$sock" 2>/dev/null || exec "$bin" "$@" &
