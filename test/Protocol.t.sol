// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {PeerToken} from "../src/PeerToken.sol";
import {Protocol} from "../src/Protocol.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IProtocolTest} from "./IProtocolTest.sol";
// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "../src/Libraries/Errors.sol";

contract ProtocolTest is Test, IProtocolTest {
    PeerToken private peerToken;
    Protocol public protocol;
    address[] tokens;
    bytes4[] priceFeed;

    address owner = address(0xa);
    address B = address(0xb);
    address C = address(0xc);

    event log(string message, Protocol.Offer[] _twoOffers);
    event logs(string message, uint amount);

    address witnetPricefeedAddress = 0xD9f5Af15288294678B0863A20F4B83eeeEAa775C;

    address USDTHolders = 0xC43a01aCbB19edfE40Bc03b5759Ae928663a7105;
    address MTRGHolders = 0x1DE8ca2f973d026300Af89041B0eCb1c0803a7e6;
    address WETHHolders = 0x1DE8ca2f973d026300Af89041B0eCb1c0803a7e6;

    bytes4 USDT_USD = 0x538f5a25;
    bytes4 MTRG_USD = 0x89e4cf54;
    bytes4 WETH_USD = 0x3d15f701;

    address USDT_CONTRACT_ADDRESS = 0xB74902F10F56f971192334782DFED7C2ca0D18ad;
    address MTRG_CONTRACT_ADDRESS = 0x8A419Ef4941355476cf04933E90Bf3bbF2F73814;
    address WETH_CONTRACT_ADDRESS = 0xE8876830E7Cc85dAE8cE31b0802313caF856886F;

    function setUp() public {
        owner = mkaddr("owner");
        // switchSigner(owner);
        B = mkaddr("B address");
        C = mkaddr("C address");
        peerToken = new PeerToken(owner);
        protocol = new Protocol();

        // tokens.push(USDT_CONTRACT_ADDRESS);
        // tokens.push(MTRG_CONTRACT_ADDRESS);
        // tokens.push(WETH_CONTRACT_ADDRESS);

        // priceFeed.push(USDT_USD);
        // priceFeed.push(MTRG_USD);
        // priceFeed.push(WETH_USD);
        protocol.initialize(owner, tokens, priceFeed, address(peerToken), witnetPricefeedAddress);

        IERC20(USDT_CONTRACT_ADDRESS).approve(address(protocol),type(uint).max);
        IERC20(MTRG_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
        IERC20(WETH_CONTRACT_ADDRESS).approve(address(protocol),type(uint).max);
        // IERC20(LINK_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);

        protocol.updateEmail(owner, "owner@mail", true);
        protocol.updateEmail(B, "ebukizy1@gmail.com", true);
        protocol.updateEmail(C, "c@mail", true);

        // transferTokenToOwner();
    }

    function testUsdValue() public{
        switchSigner(USDTHolders);
       uint amount =  protocol.getUsdValue(USDT_CONTRACT_ADDRESS, 1000);  
       emit logs("this is the amount ######3*********", amount);
    }

    // function testDepositTCollateral() public {
    //     switchSigner(owner);
    //     protocol.depositCollateral(USDT_CONTRACT_ADDRESS, 1000000);
    //     uint256 _amountQualaterized = protocol
    //         .gets_addressToCollateralDeposited(owner, USDT_CONTRACT_ADDRESS);
    //     assertEq(_amountQualaterized, 1000000);
    // }

    // function testUserCanCreateTwoRequest() public {
    //     depositCollateral(owner, LINK_CONTRACT_ADDRESS, 1e18);
    //     switchSigner(owner);

    //     uint256 requestAmount = 10000;
    //     uint8 interestRate = 5;
    //     uint256 returnDate = block.timestamp + 365 days;

    //     protocol.createLendingRequest(
    //         requestAmount,
    //         interestRate,
    //         returnDate,
    //         DIA_CONTRACT_ADDRESS
    //     );
    //     protocol.createLendingRequest(
    //         requestAmount,
    //         interestRate,
    //         returnDate,
    //         DIA_CONTRACT_ADDRESS
    //     );

    //     // Verify that the request is correctly added
    //     Protocol.Request[] memory requests = protocol.getAllRequest();
    //     assertEq(requests.length, 2);
    //     assertEq(requests[0].amount, requestAmount);
    // }

    // function testExcessiveBorrowing() public {
    //     testDepositTCollateral();
    //     switchSigner(owner);

    //     uint256 requestAmount = 100000000000;

    //     uint8 interestRate = 5;
    //     uint256 returnDate = block.timestamp + 365 days; // 1 year later
    //     vm.expectRevert(
    //         abi.encodeWithSelector(Protocol__InsufficientCollateral.selector)
    //     );
    //     protocol.createLendingRequest(
    //         requestAmount,
    //         interestRate,
    //         returnDate,
    //         DIA_CONTRACT_ADDRESS
    //     );
    // }

    // function testUserCanGiveOfferToRequest() public {
    //     testUserCanCreateTwoRequest();

    //     // note test user can give one offer to 1 request
    //     // switchSigner(B);

    //     switchSigner(owner);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(B, 20000);
    //     switchSigner(B);
    //     IERC20(DIA_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
    //     protocol.makeLendingOffer(
    //         owner,
    //         1,
    //         10000,
    //         7,
    //         block.timestamp + 10 days,
    //         DIA_CONTRACT_ADDRESS
    //     );

    //     Protocol.Offer[] memory offers = protocol.getAllOfferForUser(owner, 1);
    //     assertEq(offers.length, 1);

    //     // note TEST another user can give another offer  to  request with ID ONE

    //     switchSigner(owner);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(C, 20000);
    //     switchSigner(C);
    //     IERC20(DIA_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
    //     protocol.makeLendingOffer(
    //         owner,
    //         1,
    //         10000,
    //         8,
    //         block.timestamp + 20 days,
    //         DIA_CONTRACT_ADDRESS
    //     );
    //     Protocol.Offer[] memory _twoOffers = protocol.getAllOfferForUser(
    //         owner,
    //         1
    //     );
    //     assertEq(_twoOffers.length, 2);

    //     //note TEST user can give another offer  to  request with ID TWO
    //     switchSigner(owner);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(B, 20000);
    //     switchSigner(B);
    //     IERC20(DIA_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
    //     protocol.makeLendingOffer(
    //         owner,
    //         2,
    //         10000,
    //         7,
    //         block.timestamp + 10 days,
    //         DIA_CONTRACT_ADDRESS
    //     );

    //     Protocol.Offer[] memory _Id2RequestOfferList = protocol
    //         .getAllOfferForUser(owner, 2);
    //     assertEq(_Id2RequestOfferList.length, 1);

    //     //note TEST user can give another offer  to  request with ID TWO

    //     switchSigner(owner);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(C, 20000);
    //     switchSigner(C);
    //     IERC20(DIA_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
    //     protocol.makeLendingOffer(
    //         owner,
    //         2,
    //         10000,
    //         8,
    //         block.timestamp + 20 days,
    //         DIA_CONTRACT_ADDRESS
    //     );

    //     Protocol.Offer[] memory _Id2Request_OfferList = protocol
    //         .getAllOfferForUser(owner, 2);
    //     assertEq(_Id2Request_OfferList.length, 2);
    // }

    // function testBorrowerCan_AcceptLendingOffer() public {
    //     testUserCanCreateTwoRequest();

    //     // note test user can give one offer to 1 request
    //     // switchSigner(B);
    //     switchSigner(owner);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(B, 20000);
    //     switchSigner(B);
    //     IERC20(DIA_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
    //     protocol.makeLendingOffer(
    //         owner,
    //         1,
    //         10000,
    //         7,
    //         block.timestamp + 10 days,
    //         DIA_CONTRACT_ADDRESS
    //     );
    //     Protocol.Offer[] memory offers = protocol.getAllOfferForUser(owner, 1);
    //     assertEq(offers.length, 1);

    //     // note TEST another user can give another offer  to  request with ID ONE
    //     switchSigner(owner);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(C, 20000);
    //     switchSigner(C);
    //     IERC20(DIA_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
    //     protocol.makeLendingOffer(
    //         owner,
    //         1,
    //         10000,
    //         8,
    //         block.timestamp + 20 days,
    //         DIA_CONTRACT_ADDRESS
    //     );
    //     Protocol.Offer[] memory _twoOffers = protocol.getAllOfferForUser(
    //         owner,
    //         1
    //     );

    //     assertEq(_twoOffers.length, 2);

    //     //NOTE BORROWER CAN ACCEPT OFFER TWO
    //     switchSigner(owner);
    //     protocol.respondToLendingOffer(1, 1, Protocol.OfferStatus.ACCEPTED);
    //     Protocol.Request memory requests = protocol.getRequestById(1);
    //     // Protocol.Request[] memory _requests = protocol.getAllRequest();
    //     assertEq(uint8(protocol.getAllRequest()[0].status), 1);
    //     assertEq(uint8(requests.offer[1].offerStatus), 2);
    //     assertEq(uint8(requests.status), 1);
    // }

    // function testBorrowerCan_RejectLendingOffer() public {
    //     testUserCanCreateTwoRequest();

    //     // note test user can give one offer to 1 request
    //     // switchSigner(B);
    //     switchSigner(owner);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(B, 20000);
    //     switchSigner(B);
    //     IERC20(DIA_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
    //     protocol.makeLendingOffer(
    //         owner,
    //         1,
    //         10000,
    //         7,
    //         block.timestamp + 10 days,
    //         DIA_CONTRACT_ADDRESS
    //     );
    //     Protocol.Offer[] memory offers = protocol.getAllOfferForUser(owner, 1);
    //     assertEq(offers.length, 1);

        // // note TEST another user can give another offer  to  request with ID ONE
        // switchSigner(owner);
        // IERC20(DIA_CONTRACT_ADDRESS).transfer(C, 20000);
        // switchSigner(C);
        // IERC20(DIA_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);
        // protocol.makeLendingOffer(owner, 1, 10000,  8, block.timestamp + 20 days,DIA_CONTRACT_ADDRESS);
        // Protocol.Offer[] memory _twoOffers = protocol.getAllOfferForUser(owner, 1);
        // assertEq(_twoOffers.length, 2);

        // //NOTE BORROWER CAN REJECT OFFER ONE
        // switchSigner(owner);
        // protocol.respondToLendingOffer(1, 0, Protocol.OfferStatus.REJECTED);
        // Protocol.Request memory requests = protocol.getRequestById(1);
        // //  Protocol.Request []memory _requests  =   protocol.getAllRequest();
        //  assertEq( uint8(protocol.getAllRequest()[0].offer[0].offerStatus), 1);
        // assertEq(uint8(requests.offer[0].offerStatus), 1);

        // //NOTE TEST BORROWER CAN REJECT SECOND OFFER
        //  switchSigner(owner);
        // protocol.respondToLendingOffer(1, 1, Protocol.OfferStatus.REJECTED);
        // Protocol.Request memory _requests = protocol.getRequestById(1);
        // //  Protocol.Request []memory _requests  =   protocol.getAllRequest();
        //  assertEq( uint8(protocol.getAllRequest()[0].offer[1].offerStatus), 1);
        // assertEq(uint8(_requests.offer[1].offerStatus), 1);
    // }

    // function testServiceRequest() public {
    //     // IERC20 daiContract = IERC20(WETHHolders);
    //     // switchSigner(WETHHolders);
    //     switchSigner(owner);
    //     IERC20(LINK_CONTRACT_ADDRESS).transfer(B, 10000);
    //     testDepositTCollateral();

    //     uint256 requestAmount = 10000;
    //     uint8 interestRate = 5;
    //     uint256 returnDate = block.timestamp + 365 days; // 1 year later

    //     uint256 borrowerDAIStartBalance = IERC20(LINK_CONTRACT_ADDRESS)
    //         .balanceOf(owner);
    //     switchSigner(owner);
    //     protocol.createLendingRequest(
    //         requestAmount,
    //         interestRate,
    //         returnDate,
    //         LINK_CONTRACT_ADDRESS
    //     );

    //     switchSigner(B);
    //     IERC20(LINK_CONTRACT_ADDRESS).approve(address(protocol), requestAmount);
    //     protocol.serviceRequest(owner, 1, LINK_CONTRACT_ADDRESS);
    //     assertEq(
    //         IERC20(LINK_CONTRACT_ADDRESS).balanceOf(owner),
    //         borrowerDAIStartBalance + requestAmount
    //     );
    //     Protocol.Request memory _borrowRequest = protocol.getUserRequest(
    //         owner,
    //         1
    //     );

    //     assertEq(_borrowRequest.lender, B);
    //     assertEq(uint8(_borrowRequest.status), uint8(1));
    // }

    // function testServiceRequestFailsAfterFirstService() public {
    //     switchSigner(owner);
    //     IERC20(LINK_CONTRACT_ADDRESS).transfer(B, 10000);
    //     testDepositTCollateral();

    //     uint256 requestAmount = 10000;
    //     uint8 interestRate = 5;
    //     uint256 returnDate = block.timestamp + 365 days; // 1 year later

    //     protocol.createLendingRequest(
    //         requestAmount,
    //         interestRate,
    //         returnDate,
    //         LINK_CONTRACT_ADDRESS
    //     );

    //     switchSigner(B);
    //     IERC20(LINK_CONTRACT_ADDRESS).approve(address(protocol), requestAmount);
    //     protocol.serviceRequest(owner, 1, LINK_CONTRACT_ADDRESS);

    //     vm.expectRevert(
    //         abi.encodeWithSelector(Protocol__RequestNotOpen.selector)
    //     );

    //     protocol.serviceRequest(owner, 1, LINK_CONTRACT_ADDRESS);

    //     // NOTE to ensure it is not just the first person to service the request it fails for
    //     switchSigner(C);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(Protocol__RequestNotOpen.selector)
    //     );

    //     protocol.serviceRequest(owner, 1, LINK_CONTRACT_ADDRESS);
    // }

    // function testServiceRequestFailsWithoutTokenAllowance() public {
    //     switchSigner(owner);
    //     IERC20(LINK_CONTRACT_ADDRESS).transfer(B, 10000);
    //     testDepositTCollateral();

    //     uint256 requestAmount = 10000;
    //     uint8 interestRate = 5;
    //     uint256 returnDate = block.timestamp + 365 days; // 1 year later

    //     protocol.createLendingRequest(
    //         requestAmount,
    //         interestRate,
    //         returnDate,
    //         LINK_CONTRACT_ADDRESS
    //     );
    //     switchSigner(B);

    //     // daiContract.approve(address(protocol), requestAmount);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(Protocol__InsufficientAllowance.selector)
    //     );

    //     protocol.serviceRequest(owner, 1, LINK_CONTRACT_ADDRESS);
    // }

    // function testServiceRequestFailsWithoutEnoughBalance() public {
    //     IERC20 daiContract = IERC20(WETHHolders);
    //     switchSigner(owner);
    //     daiContract.transfer(B, 10000);
    //     testDepositTCollateral();

    //     uint256 requestAmount = 50e18;
    //     uint8 interestRate = 5;
    //     uint256 returnDate = block.timestamp + 365 days; // 1 year later

    //     protocol.createLendingRequest(
    //         requestAmount,
    //         interestRate,
    //         returnDate,
    //         LINK_CONTRACT_ADDRESS
    //     );

    //     switchSigner(B);
    //      IERC20(LINK_CONTRACT_ADDRESS).approve(address(protocol), requestAmount);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(Protocol__InsufficientBalance.selector)
    //     );
    //     protocol.serviceRequest(owner, 1, LINK_CONTRACT_ADDRESS);
    // }

    // function testLoanRepayment() public {

    //     testServiceRequest();

    //     switchSigner(owner);
    //     IERC20(LINK_CONTRACT_ADDRESS).approve(address(protocol), type(uint).max);

    //     protocol.repayLoan(1, 10000);

    //     Protocol.Request memory _borrowRequest = protocol.getUserRequest(
    //         owner,
    //         1
    //     );
    //     // assertEq(_borrowRequest._totalRepayment, 0);
    //     assertEq(uint8(_borrowRequest.status), 2);
    // }

    // function testProgressiveLoanRepayment() public {
    //     switchSigner(WETHHolders);
    //     IERC20(WETHHolders).transfer(owner, 100e18);
    //     testServiceRequest();

    //     switchSigner(owner);
    //     IERC20 daiContract = IERC20(WETHHolders);
    //     daiContract.approve(address(protocol), type(uint).max);

    //     protocol.repayLoan(1, 50e18);

    //     protocol.repayLoan(1, 50e18);

    //     Protocol.Request memory _borrowRequestAfterLastRepay = protocol
    //         .getUserRequest(owner, 1);
    //     // uint256 _userBalanceAfter = daiContract.balanceOf(owner);

    //     assertEq(_borrowRequestAfterLastRepay._totalRepayment, 0);
    //     assertEq(uint8(_borrowRequestAfterLastRepay.status), 2);
    //     // assertEq(
    //     //     _userBalanceBefore - _borrowRequestAfterFirstRepay._totalRepayment,
    //     //     _userBalanceAfter
    //     // );
    // }

    // function testAddCollateralTokens() public {
    //     address[] memory _tokens = new address[](5);
    //     address[] memory _priceFeed = new address[](5);

    //     address[] memory _collateralTokens = protocol.getAllCollateralToken();

    //     for (uint256 i = 0; i < 5; i++) {
    //         _tokens[i] = mkaddr(string(abi.encodePacked("Token", i)));
    //         _priceFeed[i] = mkaddr(string(abi.encodePacked("priceFeed", i)));
    //     }
    //     protocol.addCollateralTokens(_tokens, _priceFeed);

    //     protocol.getAllCollateralToken();

    //     assertEq(
    //         protocol.getAllCollateralToken().length,
    //         _collateralTokens.length + 5
    //     );
    // }

    // function testRemoveCollateralTokens() public {
    //     testAddCollateralTokens();
    //     address[] memory _tokens = new address[](5);
    //     address[] memory _priceFeed = new address[](5);

    //     address[] memory _collateralTokens = protocol.getAllCollateralToken();

    //     for (uint256 i = 0; i < 5; i++) {
    //         _tokens[i] = mkaddr(string(abi.encodePacked("Token", i)));
    //         _priceFeed[i] = mkaddr(string(abi.encodePacked("priceFeed", i)));
    //     }

    //     protocol.removeCollateralTokens(_tokens);

    //     assertEq(
    //         protocol.getAllCollateralToken().length,
    //         _collateralTokens.length - 5
    //     );
    // }

    // function transferTokenToOwner() public {
    //     switchSigner(USDTHolders);
    //     IERC20(USDT_CONTRACT_ADDRESS).transfer(owner, 500000000000);
    //     switchSigner(DAIHolders);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(owner, 500000000000);
    //     switchSigner(WETHHolders);
    //     IERC20(WETH_CONTRACT_ADDRESS).transfer(owner, 500000000000);
    //     switchSigner(LINKHolders);
    //     IERC20(LINK_CONTRACT_ADDRESS).transfer(owner, 500000000000);
    // }

    // function createRequest() public {
    //     depositCollateral(owner, LINK_CONTRACT_ADDRESS, 1e18);
    //     switchSigner(owner);

    //     uint256 requestAmount = 1e18;
    //     uint8 interestRate = 5;
    //     uint256 returnDate = block.timestamp + 365 days;

    //     protocol.createLendingRequest(
    //         requestAmount,
    //         interestRate,
    //         returnDate,
    //         WETHHolders
    //     );
    // }

    // function transferTokenToOwner() public {
    //     switchSigner(LINKHolders);
    //     IERC20(LINK_CONTRACT_ADDRESS).transfer(owner, 100e18);
    //     switchSigner(DAIHolders);
    //     IERC20(DIA_CONTRACT_ADDRESS).transfer(owner, 100e18);
    // }

    // function depositCollateral(
    //     address user,
    //     address token,
    //     uint256 amount
    // ) public {
    //     switchSigner(user);
    //     IERC20(token).approve(address(protocol), type(uint).max);
    //     protocol.depositCollateral(token, amount);
    // }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    function switchSigner(address _newSigner) public {
        address foundrySigner = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
        if (msg.sender == foundrySigner) {
            vm.startPrank(_newSigner);
        } else {
            vm.stopPrank();
            vm.startPrank(_newSigner);
        }
    }
}
