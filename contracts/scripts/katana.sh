#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

katana --disable-fee --allowed-origins "*"

# for controller compatible
# do
#     katana --disable-fee --allowed-origins "*" --slot.controller
# done