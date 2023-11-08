// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testConvertSvgToUri() public view {
        string memory expectedUri =
            "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9IjgwMCIgdmlld0JveD0iMCAwIDQ3My45MzUgNDczLjkzNSIgd2lkdGg9IjgwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyMzYuOTY3IiBjeT0iMjM2Ljk2NyIgZmlsbD0iI2ZmYzEwZSIgcj0iMjM2Ljk2NyIvPjxnIGZpbGw9IiMzMzMiPjxwYXRoIGQ9Im0zNTYuNjcxIDM1NC4xYy02Ni4yMjYtNjcuNjE4LTE3NC4yNTUtNjcuMzM3LTI0MC4wOTYuNzAzLTguMzg5IDguNjY2IDQuODI3IDIxLjkxMiAxMy4yMjcgMTMuMjI3IDU4Ljg3LTYwLjgzIDE1NC4zODYtNjEuMjA0IDIxMy42NDEtLjcwMyA4LjQ1MyA4LjYzMyAyMS42NzMtNC42MDYgMTMuMjI4LTEzLjIyN3oiLz48Y2lyY2xlIGN4PSIxNjQuOTM4IiBjeT0iMTU1LjIzMiIgcj0iMzcuMjE2Ii8+PGNpcmNsZSBjeD0iMzA1LjY2NyIgY3k9IjE1NS4yMzIiIHI9IjM3LjIxNiIvPjwvZz48L3N2Zz4=";
        string memory svg =
            '<svg height="800" viewBox="0 0 473.935 473.935" width="800" xmlns="http://www.w3.org/2000/svg"><circle cx="236.967" cy="236.967" fill="#ffc10e" r="236.967"/><g fill="#333"><path d="m356.671 354.1c-66.226-67.618-174.255-67.337-240.096.703-8.389 8.666 4.827 21.912 13.227 13.227 58.87-60.83 154.386-61.204 213.641-.703 8.453 8.633 21.673-4.606 13.228-13.227z"/><circle cx="164.938" cy="155.232" r="37.216"/><circle cx="305.667" cy="155.232" r="37.216"/></g></svg>';
        string memory actualUri = deployer.svgToImageURI(svg);
        assert(keccak256(abi.encodePacked(expectedUri)) == keccak256(abi.encodePacked(actualUri)));
    }
}
