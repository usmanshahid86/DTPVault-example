// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title BitcoinSyntheticTokens
 * @notice Creates two ERC20 tokens: bnBTC and anBTC
 * @dev Both tokens have a fixed supply of 21 million with 8 decimals (like Bitcoin)
 */
contract BitcoinSyntheticTokens {
    ERC20 public bnBTC;
    ERC20 public anBTC;

    constructor() {
        // Create bnBTC token
        bnBTC = new BoundBTC();
        
        // Create anBTC token
        anBTC = new AnchoredBTC();
    }
}

/**
 * @title BoundBTC
 * @notice ERC20 token representing bnBTC
 */
contract BoundBTC is ERC20, Ownable {
    uint8 private constant DECIMALS = 8;
    uint256 private constant TOTAL_SUPPLY = 21_000_000 * 10**8; // 21 million with 8 decimals

    constructor() ERC20("Bound Bitcoin", "bnBTC") Ownable(msg.sender) {
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    function decimals() public pure override returns (uint8) {
        return DECIMALS;
    }
}

/**
 * @title AnchoredBTC
 * @notice ERC20 token representing anBTC
 */
contract AnchoredBTC is ERC20, Ownable {
    uint8 private constant DECIMALS = 8;
    uint256 private constant TOTAL_SUPPLY = 21_000_000 * 10**8; // 21 million with 8 decimals

    constructor() ERC20("Anchored Bitcoin", "anBTC") Ownable(msg.sender) {
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    function decimals() public pure override returns (uint8) {
        return DECIMALS;
    }
}