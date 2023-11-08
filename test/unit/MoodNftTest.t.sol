// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    string public constant HAPPY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9IjgwMCIgdmlld0JveD0iMCAwIDQ3My45MzEgNDczLjkzMSIgd2lkdGg9IjgwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyMzYuOTY2IiBjeT0iMjM2Ljk2NiIgZmlsbD0iI2ZmYzEwZSIgcj0iMjM2Ljk2NiIvPjxwYXRoIGQ9Im04MS4zOTEgMjM3LjEyN2MwIDg1LjkxMSA2OS42NDkgMTU1LjU2IDE1NS41NiAxNTUuNTYgODUuOTE1IDAgMTU1LjU2Ny02OS42NDkgMTU1LjU2Ny0xNTUuNTZ6IiBmaWxsPSIjMzMzIi8+PHBhdGggZD0ibTE1MC40NTIgMjk4LjcwNWMwIDQ3Ljc3MSAzOC43MzEgODYuNDk4IDg2LjQ5OCA4Ni40OTggNDcuNzc1IDAgODYuNTAyLTM4LjczMSA4Ni41MDItODYuNDk4eiIgZmlsbD0iI2NhMjAyNyIvPjxnIGZpbGw9IiMzMzMiPjxjaXJjbGUgY3g9IjE2NC45MzciIGN5PSIxNTUuMjMxIiByPSIzNy4yMTYiLz48Y2lyY2xlIGN4PSIzMDUuNjY0IiBjeT0iMTU1LjIzMSIgcj0iMzcuMjE2Ii8+PC9nPjwvc3ZnPg==";
    string public constant SAD_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9IjgwMCIgdmlld0JveD0iMCAwIDQ3My45MzUgNDczLjkzNSIgd2lkdGg9IjgwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyMzYuOTY3IiBjeT0iMjM2Ljk2NyIgZmlsbD0iI2ZmYzEwZSIgcj0iMjM2Ljk2NyIvPjxnIGZpbGw9IiMzMzMiPjxwYXRoIGQ9Im0zNTYuNjcxIDM1NC4xYy02Ni4yMjYtNjcuNjE4LTE3NC4yNTUtNjcuMzM3LTI0MC4wOTYuNzAzLTguMzg5IDguNjY2IDQuODI3IDIxLjkxMiAxMy4yMjcgMTMuMjI3IDU4Ljg3LTYwLjgzIDE1NC4zODYtNjEuMjA0IDIxMy42NDEtLjcwMyA4LjQ1MyA4LjYzMyAyMS42NzMtNC42MDYgMTMuMjI4LTEzLjIyN3oiLz48Y2lyY2xlIGN4PSIxNjQuOTM4IiBjeT0iMTU1LjIzMiIgcj0iMzcuMjE2Ii8+PGNpcmNsZSBjeD0iMzA1LjY2NyIgY3k9IjE1NS4yMzIiIHI9IjM3LjIxNiIvPjwvZz48L3N2Zz4=";
    address USER = makeAddr("USER");

    function setUp() public {
        moodNft = new MoodNft(HAPPY_SVG_IMAGE_URI, SAD_SVG_IMAGE_URI);
    }

    function testViewTokenURI() public {
        vm.prank(USER);
        moodNft.mintNft();
        assert(moodNft.ownerOf(0) == USER);
    }
}
