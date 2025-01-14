#!/bin/bash

# Load environment variables
source .env

# Function to deploy to a specific network
deploy_to_network() {
    local network=$1
    echo "Deploying to $network..."
    
    forge script script/BitcoinSyntheticTokens.s.sol:DeployBitcoinSyntheticTokens \
        --rpc-url $network \
        --broadcast \
        -vvvv
}
# --verify \
# Check if network argument is provided
if [ -z "$1" ]
then
    echo "Please specify network (holesky, mainnet, etc.)"
    exit 1
fi

# Deploy to specified network
deploy_to_network "$1"