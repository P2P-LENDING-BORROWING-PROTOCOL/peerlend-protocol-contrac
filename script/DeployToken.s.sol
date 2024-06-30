
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import {Script, console} from "forge-std/Script.sol";

import {PeerToken} from "../src/PeerToken.sol";



contract DeployScript is Script {

    PeerToken peerToken;


    function setUp() public {}

    function run() public {
      
             

        vm.startBroadcast();

        peerToken = new PeerToken(msg.sender);

        // Log the addresses of the proxy and the implementation contract
        
        console.log("$PEER address", address(peerToken));


        vm.stopBroadcast();
    }
}


