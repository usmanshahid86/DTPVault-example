// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/BitcoinSyntheticTokens.sol";

contract DeployBitcoinSyntheticTokens is Script {
    function run() external {
        // Retrieve private key from environment
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the factory contract which will deploy both tokens
        BitcoinSyntheticTokens factory = new BitcoinSyntheticTokens();

        // Get token addresses
        address bnBTCAddress = address(factory.bnBTC());
        address anBTCAddress = address(factory.anBTC());

        // Log the addresses
        console.log("BitcoinSyntheticTokens Factory deployed to:", address(factory));
        console.log("bnBTC Token deployed to:", bnBTCAddress);
        console.log("anBTC Token deployed to:", anBTCAddress);

        vm.stopBroadcast();
    }
}
