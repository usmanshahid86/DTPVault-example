# Bitcoin Synthetic Tokens

A Foundry project implementing synthetic Bitcoin ERC20 tokens (bnBTC and anBTC) with a fixed supply matching Bitcoin's 21 million cap.

## Overview

This project implements two ERC20 tokens:
- **bnBTC (Bound Bitcoin)**: A synthetic Bitcoin token
- **anBTC (Anchored Bitcoin)**: A synthetic Bitcoin token
- Both tokens maintain Bitcoin's properties:
  - 21 million total supply
  - 8 decimal places
  - Full ERC20 compatibility

## Features

- Factory pattern for deterministic token deployment
- Full ERC20 compliance
- Owner-controlled token management
- Comprehensive test coverage
- Gas-optimized operations

## Installation

```bash
# Clone the repository
git clone https://github.com/usmanshahid86/DTPVault/DTPVault-example.git
cd DTPVault-example

# Install dependencies
forge install
```

## Configuration

1. Create a `.env` file:
```env
# Network RPC URLs
HOLESKY_RPC_URL=https://holesky.infura.io/v3/your-api-key
MAINNET_RPC_URL=https://mainnet.infura.io/v3/your-api-key

# Private key (without 0x prefix)
PRIVATE_KEY=your_private_key_here

# Etherscan API Key for verification
ETHERSCAN_API_KEY=your_etherscan_api_key
```

2. Configure `foundry.toml`:
```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
remappings = [
    "@openzeppelin/= /openzeppelin-contracts/",
    "forge-std/=lib/forge-std/src/"
]
```

## Usage

### Build
```bash
forge build
```

### Test
```bash
forge test
forge test -vv  # Verbose output
forge test -vvv # Very verbose output
```

### Deploy
```bash
# Deploy to Sepolia testnet
forge script script/DeployBitcoinSyntheticToken.s.sol:DeployBitcoinSyntheticTokens --rpc-url $HOLESKY_RPC_URL --broadcast --verify

# Deploy to Mainnet
forge script script/DeployBitcoinSyntheticToken.s.sol:DeployBitcoinSyntheticTokens --rpc-url $MAINNET_RPC_URL --broadcast --verify
```

### Transfer Tokens
```bash
# Using JSON configuration
forge script script/TransferFromJson.s.sol:TransferTokensFromJson --rpc-url $RPC_URL --broadcast
```

## Contract Addresses

| Network | Contract | Address |
|---------|----------|---------|
| Holesky | Factory  | TBD     |
| Holesky | bnBTC    | TBD     |
| Holesky | anBTC    | TBD     |

## Testing

The project includes comprehensive tests covering:
- Token initialization
- Transfer functionality
- Approval mechanisms
- Ownership management
- Event emissions
- Failure cases


## Security

- All contracts use OpenZeppelin's battle-tested implementations
- Full test coverage
- Access control mechanisms
- Fixed supply with no minting capability
- Ownership controls

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

