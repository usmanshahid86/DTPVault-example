#!/bin/bash
source .env

# Check if network is provided
if [ -z "$1" ]; then
    echo "Please specify network (holesky, mainnet)"
    exit 1
fi

# Execute transfer script
forge script script/LSTTransfer/TransferFromJson.s.sol:TransferTokensFromJson \
    --rpc-url ${1^^}_RPC_URL \
    --broadcast \
    -vvvv