// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}

//     function testTransfer() public {
//         uint256 transferAmount = 10 ether;

//         // User1 transfers tokens to user2
//         vm.startPrank(user1);
//         ourToken.transfer(user2, transferAmount);
//         assertEq(
//             ourToken.balanceOf(user1),
//             INITIAL_USER1_BALANCE - transferAmount
//         );
//         assertEq(ourToken.balanceOf(user2), transferAmount);
//         vm.stopPrank();
//     }

//     function testTransferInsufficientBalance() public {
//         uint256 transferAmount = INITIAL_USER1_BALANCE + 1;

//         // User1 tries to transfer more tokens than they have
//         vm.startPrank(user1);
//         vm.expectRevert("ERC20: transfer amount exceeds balance");
//         ourToken.transfer(user2, transferAmount);
//         vm.stopPrank();
//     }

//     function testTransferFromInsufficientAllowance() public {
//         uint256 allowanceAmount = 50 ether;
//         uint256 transferAmount = allowanceAmount + 1;

//         // User1 approves user2 for a certain allowance
//         vm.startPrank(user1);
//         ourToken.approve(user2, allowanceAmount);
//         vm.stopPrank();

//         // User2 tries to transfer more than the approved allowance
//         vm.startPrank(user2);
//         vm.expectRevert("ERC20: insufficient allowance");
//         ourToken.transferFrom(user1, user2, transferAmount);
//         vm.stopPrank();
//     }

//     function testApproveIncreasesAllowance() public {
//         uint256 initialAllowance = 50 ether;
//         uint256 additionalAllowance = 20 ether;

//         // User1 approves user2 for an allowance
//         vm.startPrank(user1);
//         ourToken.approve(user2, initialAllowance);
//         assertEq(ourToken.allowance(user1, user2), initialAllowance);

//         // User1 increases the allowance for user2
//         ourToken.approve(user2, initialAllowance + additionalAllowance);
//         assertEq(
//             ourToken.allowance(user1, user2),
//             initialAllowance + additionalAllowance
//         );
//         vm.stopPrank();
//     }

//     function testApproveSetsAllowance() public {
//         uint256 initialAllowance = 50 ether;
//         uint256 newAllowance = 20 ether;

//         // User1 approves user2 for an initial allowance
//         vm.startPrank(user1);
//         ourToken.approve(user2, initialAllowance);
//         assertEq(ourToken.allowance(user1, user2), initialAllowance);

//         // User1 sets a new allowance for user2 (overwriting the previous one)
//         ourToken.approve(user2, newAllowance);
//         assertEq(ourToken.allowance(user1, user2), newAllowance);
//         vm.stopPrank();
//     }

//     function testBurnTokens() public {
//         uint256 burnAmount = 10 ether;

//         // User1 burns some of their tokens
//         vm.startPrank(user1);
//         ourToken.transfer(address(0), burnAmount); // This simulates burning in standard ERC20
//         assertEq(ourToken.balanceOf(user1), INITIAL_USER1_BALANCE - burnAmount);
//         assertEq(
//             ourToken.totalSupply(),
//             deployer.INITIAL_SUPPLY() - burnAmount
//         );
//         vm.stopPrank();
//     }
// }
