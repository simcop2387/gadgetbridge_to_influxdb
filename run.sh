#!/bin/bash

set -aexuo pipefail

source ../.env
source venv/bin/activate

python app/gadgetbridge_to_influxdb.py
