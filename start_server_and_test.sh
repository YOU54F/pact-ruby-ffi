#!/bin/bash

TEST_COMMAND=${TEST_COMMAND:-'make verify_demo_gprc_broker'}
SERVER_COMMAND=${SERVER_COMMAND:-'make start_demo_gprc_provider'}
WAIT_FOR=${WAIT_FOR:-'http://localhost:37757'}

start_server() {
    echo "Start server ..."
    $SERVER_COMMAND &
    server_pid=$!
}

stop_server() {
    echo "Stop Server ...$server_pid"
    kill $server_pid
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

start_server

wget -qO- https://raw.githubusercontent.com/eficode/wait-for/v2.2.3/wait-for | sh -s -- $WAIT_FOR --timeout 60 -- $TEST_COMMAND

rc=$?

stop_server

exit $rc