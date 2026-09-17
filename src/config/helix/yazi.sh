#!/usr/bin/env bash
rm -f /tmp/unique-file
yazi --chooser-file=/tmp/unique-file
if [ -f /tmp/unique-file ]; then
    cat /tmp/unique-file
fi
