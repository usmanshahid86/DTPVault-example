// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BitcoinLSTIndex.sol";
import "../src/BitcoinSyntheticTokens.sol";

contract BitcoinLSTIndexTest is Test {
    BitcoinLSTIndex public lstIndex;
    BitcoinSyntheticTokens public syntheticTokens;
    ERC20 public bnBTC;
    ERC20 public anBTC;
    
    address public owner;
    address public user1;
    address public user2;
    
    uint256 constant INITIAL_BALANCE = 1000 * 10**8; // 1000 tokens
    
    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        
        // Deploy synthetic tokens
        syntheticTokens = new BitcoinSyntheticTokens();
        bnBTC = ERC20(address(syntheticTokens.bnBTC()));
        anBTC = ERC20(address(syntheticTokens.anBTC()));
        
        // Deploy LST index with 50-50 split
        lstIndex = new BitcoinLSTIndex(
            bnBTC,
            anBTC,
            50, // bnBTC weight
            50, // anBTC weight
            "Bitcoin LST Index",
            "btcLST"
        );
        
        // Label addresses for better trace output
        vm.label(address(lstIndex), "LSTIndex");
        vm.label(address(bnBTC), "bnBTC");
        vm.label(address(anBTC), "anBTC");
        vm.label(user1, "User1");
        vm.label(user2, "User2");
    }

    function testInitialState() public {
        assertEq(lstIndex.name(), "Bitcoin LST Index");
        assertEq(lstIndex.symbol(), "btcLST");
        assertEq(lstIndex.decimals(), 8);
        assertEq(lstIndex.bnBTCWeight(), 50);
        assertEq(lstIndex.anBTCWeight(), 50);
    }

    // function testDeposit() public {
    //     uint256 depositAmount = 100 * 10**8; // 100 tokens
        
    //     // Approve tokens
    //     bnBTC.approve(address(lstIndex), depositAmount);
    //     anBTC.approve(address(lstIndex), depositAmount);
        
    //     // Deposit tokens
    //     lstIndex.depositWithMultipleAssets(
    //         depositAmount,
    //         depositAmount,
    //         address(this)
    //     );
        
    //     // Check balances
    //     assertGt(lstIndex.balanceOf(address(this)), 0);
    //     assertEq(bnBTC.balanceOf(address(lstIndex)), depositAmount);
    //     assertEq(anBTC.balanceOf(address(lstIndex)), depositAmount);
    // }

    // function testWithdraw() public {
    //     uint256 depositAmount = 100 * 10**8;
        
    //     // First deposit
    //     bnBTC.approve(address(lstIndex), depositAmount);
    //     anBTC.approve(address(lstIndex), depositAmount);
    //     lstIndex.depositWithMultipleAssets(
    //         depositAmount,
    //         depositAmount,
    //         address(this)
    //     );
        
    //     uint256 shares = lstIndex.balanceOf(address(this));
        
    //     // Then withdraw
    //     lstIndex.withdrawWithMultipleAssets(
    //         shares,
    //         address(this),
    //         address(this)
    //     );
        
    //     // Check balances
    //     assertEq(lstIndex.balanceOf(address(this)), 0);
    //     assertEq(bnBTC.balanceOf(address(this)), depositAmount);
    //     assertEq(anBTC.balanceOf(address(this)), depositAmount);
    // }

    // function testRebalance() public {
    //     // Test rebalancing weights
    //     lstIndex.rebalance(60, 40);
    //     assertEq(lstIndex.bnBTCWeight(), 60);
    //     assertEq(lstIndex.anBTCWeight(), 40);
    // }

    // function testFailRebalanceInvalidWeights() public {
    //     // Should fail as weights don't add up to 100
    //     lstIndex.rebalance(60, 50);
    // }

    // function testFailRebalanceUnauthorized() public {
    //     vm.prank(user1);
    //     // Should fail as non-owner tries to rebalance
    //     lstIndex.rebalance(60, 40);
    // }

    // receive() external payable {}
}