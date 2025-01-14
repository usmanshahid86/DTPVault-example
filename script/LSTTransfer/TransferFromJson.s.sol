// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/BitcoinSyntheticTokens.sol";

contract TransferTokensFromJson is Script {
    struct TransferDetail {
        address recipient;
        uint256 amount;
    }

    function run() external {
        // Load configuration
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/config/transfers.json");
        string memory json = vm.readFile(path);
        bytes memory transfers = vm.parseJson(json);
        
        TransferDetail[] memory transferDetails = abi.decode(transfers, (TransferDetail[]));

        // Load deployment details
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");
        
        BitcoinSyntheticTokens factory = BitcoinSyntheticTokens(factoryAddress);
        BoundBTC bnBTC = BoundBTC(address(factory.bnBTC()));
        AnchoredBTC anBTC = AnchoredBTC(address(factory.anBTC()));

        vm.startBroadcast(deployerPrivateKey);

        for (uint256 i = 0; i < transferDetails.length; i++) {
            TransferDetail memory transfer = transferDetails[i];
            
            // Transfer tokens
            bnBTC.transfer(transfer.recipient, transfer.amount);
            anBTC.transfer(transfer.recipient, transfer.amount);

            console.log("Transferred %s tokens to %s", 
                transfer.amount / 10**8,
                transfer.recipient
            );
        }

        vm.stopBroadcast();
    }
}