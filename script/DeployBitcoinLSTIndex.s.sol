// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/BitcoinLSTIndex.sol";
import "../src/BitcoinSyntheticTokens.sol";

contract DeployBitcoinLSTIndex is Script {
    function run() external {
        // Load private key and addresses from environment
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address syntheticTokensFactory = vm.envAddress("FACTORY_ADDRESS"); // SYNTHETIC_TOKENS_FACTORY_ADDRESS

        // Get synthetic token instances
        BitcoinSyntheticTokens factory = BitcoinSyntheticTokens(syntheticTokensFactory);
        ERC20 bnBTC = ERC20(address(factory.bnBTC()));
        ERC20 anBTC = ERC20(address(factory.anBTC()));

        // Initial weights (50-50 split)
        uint256 bnBTCWeight = 50;
        uint256 anBTCWeight = 50;

        vm.startBroadcast(deployerPrivateKey);

        // Deploy BitcoinLSTIndex
        BitcoinLSTIndex lstIndex = new BitcoinLSTIndex(
            bnBTC,
            anBTC,
            bnBTCWeight,
            anBTCWeight,
            "Bitcoin LST Index",
            "BLIndex"
        );

        // Log deployments
        console.log("BitcoinLSTIndex deployed to:", address(lstIndex));
        console.log("Using bnBTC at:", address(bnBTC));
        console.log("Using anBTC at:", address(anBTC));

        vm.stopBroadcast();
    }
}