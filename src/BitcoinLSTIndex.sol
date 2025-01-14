// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./BitcoinSyntheticTokens.sol";

/**
 * @title BitcoinLSTIndex
 * @dev An ERC-4626 vault implementation for Bitcoin LST Index.
 */
contract BitcoinLSTIndex is ERC20, ERC4626, Ownable {
    // Event to track rebalancing
    event Rebalanced(uint256 newBnBTCWeight, uint256 newAnBTCWeight);

    // Underlying reward tokens (e.g., bnBTC, anBTC)
    ERC20 public bnBTC;
    ERC20 public anBTC;

    // Target allocation weights for the index
    uint256 public bnBTCWeight; // e.g., 50 (represents 50%)
    uint256 public anBTCWeight; // e.g., 50 (represents 50%)

    constructor(
        ERC20 _bnBTC,
        ERC20 _anBTC,
        uint256 _bnBTCWeight,
        uint256 _anBTCWeight,
        string memory name,
        string memory symbol
    ) ERC20(name, symbol) ERC4626(_bnBTC) Ownable(msg.sender) {
        require(_bnBTCWeight + _anBTCWeight == 100, "Invalid weights");
        bnBTC = _bnBTC;
        anBTC = _anBTC;
        bnBTCWeight = _bnBTCWeight;
        anBTCWeight = _anBTCWeight;

    }
    function decimals() public view virtual override(ERC4626, ERC20) returns (uint8) {
        return 8; // Using 8 decimals to match Bitcoin
    }
    /**
     * @notice Deposit function that supports multiple assets.
     * @dev Overrides ERC4626 deposit for multi-token handling.
     */
    function depositWithMultipleAssets(
        uint256 bnBTCAmount,
        uint256 anBTCAmount,
        address receiver
    ) external returns (uint256 shares) {
        require(bnBTCAmount > 0 || anBTCAmount > 0, "Must deposit tokens");

        if (bnBTCAmount > 0) {
            bnBTC.transferFrom(msg.sender, address(this), bnBTCAmount);
        }
        if (anBTCAmount > 0) {
            anBTC.transferFrom(msg.sender, address(this), anBTCAmount);
        }

        uint256 totalValue = _calculateTotalValue(bnBTCAmount, anBTCAmount);
        shares = previewDeposit(totalValue);
        _mint(receiver, shares);

        emit Deposit(msg.sender, receiver, totalValue, shares);
    }

    /**
     * @notice Calculate total value of deposited assets.
     */
    function _calculateTotalValue(uint256 bnBTCAmount, uint256 anBTCAmount)
        internal
        pure
        returns (uint256)
    {
        uint256 bnBTCValue = bnBTCAmount * _getBnBTCPrice(); // Fetch price of bnBTC
        uint256 anBTCValue = anBTCAmount * _getAnBTCPrice(); // Fetch price of anBTC
        return bnBTCValue + anBTCValue;
    }

    /**
     * @notice Simulate rebalancing to adjust asset weights.
     */
    function rebalance(uint256 newBnBTCWeight, uint256 newAnBTCWeight)
        external
        onlyOwner
    {
        require(
            newBnBTCWeight + newAnBTCWeight == 100,
            "Invalid weights"
        );
        bnBTCWeight = newBnBTCWeight;
        anBTCWeight = newAnBTCWeight;
        emit Rebalanced(newBnBTCWeight, newAnBTCWeight);
    }

    /**
     * @notice Placeholder for fetching bnBTC price.
     */
    function _getBnBTCPrice() internal pure returns (uint256) {
        // TODO: Implement price fetching logic
        return 90000; // Placeholder price for bnBTC in dollars
    }

    /**
     * @notice Placeholder for fetching anBTC price.
     */
    function _getAnBTCPrice() internal pure returns (uint256) {
        // TODO: Implement price fetching logic
        return 90000; // Placeholder price for anBTC in dollars 
    }

    /**
     * @notice Withdraw function.
     * @dev Redeems shares for underlying assets proportionally.
     */
    function withdrawWithMultipleAssets(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256 bnBTCWithdrawn, uint256 anBTCWithdrawn) {
        require(balanceOf(owner) >= shares, "Insufficient balance");

        uint256 totalValue = previewRedeem(shares);

        // Calculate proportional withdrawals
        bnBTCWithdrawn = (totalValue * bnBTCWeight) / 100;
        anBTCWithdrawn = (totalValue * anBTCWeight) / 100;

        // Transfer assets to the receiver
        if (bnBTCWithdrawn > 0) {
            bnBTC.transfer(receiver, bnBTCWithdrawn);
        }
        if (anBTCWithdrawn > 0) {
            anBTC.transfer(receiver, anBTCWithdrawn);
        }

        _burn(owner, shares);

        emit Withdraw(msg.sender, receiver, owner, totalValue, shares);
    }
}
