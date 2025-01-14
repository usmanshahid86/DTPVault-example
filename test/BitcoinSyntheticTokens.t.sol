// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BitcoinSyntheticTokens.sol";

contract BitcoinSyntheticTokensTest is Test {
    BitcoinSyntheticTokens public factory;
    BoundBTC public bnBTC;
    AnchoredBTC public anBTC;
    
    address public owner;
    address public user1;
    address public user2;
    
    // Define events to test
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    uint256 constant TOTAL_SUPPLY = 21_000_000 * 10**8; // 21 million with 8 decimals

    function setUp() public {
        // Setup accounts
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        
        // Deploy contracts
        factory = new BitcoinSyntheticTokens();
        bnBTC = BoundBTC(address(factory.bnBTC()));
        anBTC = AnchoredBTC(address(factory.anBTC()));
        
        // Label addresses for better trace output
        vm.label(address(factory), "Factory");
        vm.label(address(bnBTC), "bnBTC");
        vm.label(address(anBTC), "anBTC");
        vm.label(user1, "User1");
        vm.label(user2, "User2");
    }

    // Basic Token Tests for bnBTC
    function testBnBTCInitialState() public view {
        assertEq(bnBTC.name(), "Bound Bitcoin");
        assertEq(bnBTC.symbol(), "bnBTC");
        assertEq(bnBTC.decimals(), 8);
        assertEq(bnBTC.totalSupply(), TOTAL_SUPPLY);
        assertEq(bnBTC.balanceOf(owner), TOTAL_SUPPLY);
    }

    // Basic Token Tests for anBTC
    function testAnBTCInitialState() public view {
        assertEq(anBTC.name(), "Anchored Bitcoin");
        assertEq(anBTC.symbol(), "anBTC");
        assertEq(anBTC.decimals(), 8);
        assertEq(anBTC.totalSupply(), TOTAL_SUPPLY);
        assertEq(anBTC.balanceOf(owner), TOTAL_SUPPLY);
    }

    // Transfer Tests for bnBTC
    function testBnBTCTransfer() public {
        uint256 amount = 100 * 10**8; // 100 bnBTC
        bnBTC.transfer(user1, amount);
        assertEq(bnBTC.balanceOf(user1), amount);
        assertEq(bnBTC.balanceOf(owner), TOTAL_SUPPLY - amount);
    }

    // Transfer Tests for anBTC
    function testAnBTCTransfer() public {
        uint256 amount = 100 * 10**8; // 100 anBTC
        anBTC.transfer(user1, amount);
        assertEq(anBTC.balanceOf(user1), amount);
        assertEq(anBTC.balanceOf(owner), TOTAL_SUPPLY - amount);
    }

    // Approval and TransferFrom Tests for bnBTC
    function testBnBTCApproveAndTransferFrom() public {
        uint256 amount = 100 * 10**8; // 100 bnBTC
        
        // First transfer some tokens to user1
        bnBTC.transfer(user1, amount);
        
        // Test approval and transferFrom
        vm.prank(user1);
        bnBTC.approve(user2, amount);
        
        vm.prank(user2);
        bnBTC.transferFrom(user1, user2, amount);
        
        assertEq(bnBTC.balanceOf(user2), amount);
        assertEq(bnBTC.balanceOf(user1), 0);
    }

    // Approval and TransferFrom Tests for anBTC
    function testAnBTCApproveAndTransferFrom() public {
        uint256 amount = 100 * 10**8; // 100 anBTC
        
        // First transfer some tokens to user1
        anBTC.transfer(user1, amount);
        
        // Test approval and transferFrom
        vm.prank(user1);
        anBTC.approve(user2, amount);
        
        vm.prank(user2);
        anBTC.transferFrom(user1, user2, amount);
        
        assertEq(anBTC.balanceOf(user2), amount);
        assertEq(anBTC.balanceOf(user1), 0);
    }

    // Failure Tests
    function testFailTransferInsufficientBalance() public {
        uint256 amount = TOTAL_SUPPLY + 1;
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        bnBTC.transfer(user1, amount);
    }

    function testFailTransferFromInsufficientAllowance() public {
        uint256 amount = 100 * 10**8;
        bnBTC.transfer(user1, amount);
        
        vm.prank(user2);
        vm.expectRevert("ERC20: insufficient allowance");
        bnBTC.transferFrom(user1, user2, amount);
    }

    // Ownership Tests
    function testBnBTCOwnership() public view {
        assertEq(bnBTC.owner(), owner);
    }

    function testAnBTCOwnership() public view {
        assertEq(anBTC.owner(), owner);
    }

    function testTransferBnBTCOwnership() public {
        bnBTC.transferOwnership(user1);
        assertEq(bnBTC.owner(), user1);
    }

    // Fuzz Tests
    function testFuzzTransfer(uint256 amount) public {
        // Bound the amount to be within total supply
        amount = bound(amount, 0, TOTAL_SUPPLY);
        
        bool success = bnBTC.transfer(user1, amount);
        assertTrue(success);
        assertEq(bnBTC.balanceOf(user1), amount);
        assertEq(bnBTC.balanceOf(owner), TOTAL_SUPPLY - amount);
    }

    // Event Tests
    function testTransferEvent() public {
        uint256 amount = 100 * 10**8;
        
        vm.expectEmit(true, true, false, true);
        emit Transfer(owner, user1, amount);
        
        bnBTC.transfer(user1, amount);
    }

    function testApprovalEvent() public {
        uint256 amount = 100 * 10**8;
        
        vm.expectEmit(true, true, false, true);
        emit Approval(owner, user1, amount);
        
        bnBTC.approve(user1, amount);
    }
}