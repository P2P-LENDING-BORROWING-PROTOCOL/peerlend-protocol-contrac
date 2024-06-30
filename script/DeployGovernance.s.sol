
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import {Script, console} from "forge-std/Script.sol";

import {Governance} from "../src/Governance.sol";


contract DeployScript is Script {

    Governance governance;
    address peerToken = 0x57071b0e17169Ffa2E270CA830170731659294aE;

    function setUp() public {}

    function run() public {

        vm.startBroadcast();

        governance = new Governance(address(peerToken));

        // Log the addresses of the proxy and the implementation contract
        
        console.log("Governance address", address(governance));

        vm.stopBroadcast();
    }
}


