// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

// import {PeerToken} from "../src/PeerToken.sol";
import {Protocol} from "../src/Protocol.sol";
// import {Governance} from "../src/Governance.sol";
// import {IProtocolTest} from "../IProtocolTest.sol";
import "../src/Libraries/Errors.sol";

// deployment script
// forge script ./script/Deploy.s.sol --broadcast -vvvv --account <wallet-account> --sender <sender-address>

contract DeployScript is Script {
    address peerToken = 0x57071b0e17169Ffa2E270CA830170731659294aE;
    address governance = 0xE4dC120c1984111858198f81f5251b537e9dD8C2;
    Protocol protocol;

    ERC1967Proxy proxy;

    address[] _tokenAddresses;
    bytes4 [] _priceFeedAddresses;

    //router address
    address witnetPricefeedAddress = 0xD9f5Af15288294678B0863A20F4B83eeeEAa775C;



    bytes4 USDT_USD = 0x538f5a25;
    bytes4 MTRG_USD = 0x89e4cf54;
    bytes4 WETH_USD = 0x3d15f701;

    //METER TESTNET ADDRESSES
    address USDT_CONTRACT_ADDRESS = 0xB74902F10F56f971192334782DFED7C2ca0D18ad;
    address MTRG_CONTRACT_ADDRESS = 0x8A419Ef4941355476cf04933E90Bf3bbF2F73814;
    address WETH_CONTRACT_ADDRESS = 0xE8876830E7Cc85dAE8cE31b0802313caF856886F;


    function setUp() public {
        // _tokenAddresses.push(daiToken);
        _tokenAddresses.push(USDT_CONTRACT_ADDRESS);
        _tokenAddresses.push(MTRG_CONTRACT_ADDRESS);
        _tokenAddresses.push(WETH_CONTRACT_ADDRESS);

        _priceFeedAddresses.push(USDT_USD);
        _priceFeedAddresses.push(MTRG_USD);
        _priceFeedAddresses.push(WETH_USD);

    }

    function run() public {
        vm.startBroadcast();

        Protocol implementation = new Protocol();
        // Deploy the proxy and initialize the contract through the proxy
        proxy = new ERC1967Proxy(
            address(implementation),
            abi.encodeCall(
                implementation.initialize,
                (
                    msg.sender,
                    _tokenAddresses,
                    _priceFeedAddresses,
                    peerToken, 
                    witnetPricefeedAddress
                )
            )
        );
        // Attach the MyToken interface to the deployed proxy
        console.log("$PEER address", address(peerToken));
        console.log("Governance address", address(governance));
        console.log("Proxy Address", address(proxy));
        console.log("Protocol address", address(implementation));

        Protocol(address(proxy)).addLoanableToken(
            address(peerToken),
            USDT_USD
        );
        console.log("Loanable Token Added");

        vm.stopBroadcast();
    }
}
