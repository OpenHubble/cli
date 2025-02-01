#!/bin/bash

export PYTHONPATH=/opt/openhubble-cli

/opt/openhubble-cli/.venv/bin/python3 /opt/openhubble-cli/cli.py "$@"
