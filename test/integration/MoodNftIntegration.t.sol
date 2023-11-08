// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    enum Mood {
        HAPPY,
        SAD
    }

    error MoodNft__OnlyOwnerCanFlipMood();

    MoodNft moodNft;
    string public constant HAPPY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9IjgwMCIgdmlld0JveD0iMCAwIDQ3My45MzEgNDczLjkzMSIgd2lkdGg9IjgwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyMzYuOTY2IiBjeT0iMjM2Ljk2NiIgZmlsbD0iI2ZmYzEwZSIgcj0iMjM2Ljk2NiIvPjxwYXRoIGQ9Im04MS4zOTEgMjM3LjEyN2MwIDg1LjkxMSA2OS42NDkgMTU1LjU2IDE1NS41NiAxNTUuNTYgODUuOTE1IDAgMTU1LjU2Ny02OS42NDkgMTU1LjU2Ny0xNTUuNTZ6IiBmaWxsPSIjMzMzIi8+PHBhdGggZD0ibTE1MC40NTIgMjk4LjcwNWMwIDQ3Ljc3MSAzOC43MzEgODYuNDk4IDg2LjQ5OCA4Ni40OTggNDcuNzc1IDAgODYuNTAyLTM4LjczMSA4Ni41MDItODYuNDk4eiIgZmlsbD0iI2NhMjAyNyIvPjxnIGZpbGw9IiMzMzMiPjxjaXJjbGUgY3g9IjE2NC45MzciIGN5PSIxNTUuMjMxIiByPSIzNy4yMTYiLz48Y2lyY2xlIGN4PSIzMDUuNjY0IiBjeT0iMTU1LjIzMSIgcj0iMzcuMjE2Ii8+PC9nPjwvc3ZnPg==";
    string public constant SAD_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyBoZWlnaHQ9IjgwMCIgdmlld0JveD0iMCAwIDQ3My45MzUgNDczLjkzNSIgd2lkdGg9IjgwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyMzYuOTY3IiBjeT0iMjM2Ljk2NyIgZmlsbD0iI2ZmYzEwZSIgcj0iMjM2Ljk2NyIvPjxnIGZpbGw9IiMzMzMiPjxwYXRoIGQ9Im0zNTYuNjcxIDM1NC4xYy02Ni4yMjYtNjcuNjE4LTE3NC4yNTUtNjcuMzM3LTI0MC4wOTYuNzAzLTguMzg5IDguNjY2IDQuODI3IDIxLjkxMiAxMy4yMjcgMTMuMjI3IDU4Ljg3LTYwLjgzIDE1NC4zODYtNjEuMjA0IDIxMy42NDEtLjcwMyA4LjQ1MyA4LjYzMyAyMS42NzMtNC42MDYgMTMuMjI4LTEzLjIyN3oiLz48Y2lyY2xlIGN4PSIxNjQuOTM4IiBjeT0iMTU1LjIzMiIgcj0iMzcuMjE2Ii8+PGNpcmNsZSBjeD0iMzA1LjY2NyIgY3k9IjE1NS4yMzIiIHI9IjM3LjIxNiIvPjwvZz48L3N2Zz4=";
    string public constant HAPPY_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QiLCAiZGVzY3JpcHRpb24iOiAiQW4gTkZUIHRoYXQgcmVmbGVjdHMgdGhlIG93bmVycyBtb29kLiIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJtb29kaW5lc3MiLCAidmFsdWUiOiAxMDB9XSwgImltYWdlIjogImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5Qm9aV2xuYUhROUlqZ3dNQ0lnZG1sbGQwSnZlRDBpTUNBd0lEUTNNeTQ1TXpFZ05EY3pMamt6TVNJZ2QybGtkR2c5SWpnd01DSWdlRzFzYm5NOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklqNDhZMmx5WTJ4bElHTjRQU0l5TXpZdU9UWTJJaUJqZVQwaU1qTTJMamsyTmlJZ1ptbHNiRDBpSTJabVl6RXdaU0lnY2owaU1qTTJMamsyTmlJdlBqeHdZWFJvSUdROUltMDRNUzR6T1RFZ01qTTNMakV5TjJNd0lEZzFMamt4TVNBMk9TNDJORGtnTVRVMUxqVTJJREUxTlM0MU5pQXhOVFV1TlRZZ09EVXVPVEUxSURBZ01UVTFMalUyTnkwMk9TNDJORGtnTVRVMUxqVTJOeTB4TlRVdU5UWjZJaUJtYVd4c1BTSWpNek16SWk4K1BIQmhkR2dnWkQwaWJURTFNQzQwTlRJZ01qazRMamN3TldNd0lEUTNMamMzTVNBek9DNDNNekVnT0RZdU5EazRJRGcyTGpRNU9DQTROaTQwT1RnZ05EY3VOemMxSURBZ09EWXVOVEF5TFRNNExqY3pNU0E0Tmk0MU1ESXRPRFl1TkRrNGVpSWdabWxzYkQwaUkyTmhNakF5TnlJdlBqeG5JR1pwYkd3OUlpTXpNek1pUGp4amFYSmpiR1VnWTNnOUlqRTJOQzQ1TXpjaUlHTjVQU0l4TlRVdU1qTXhJaUJ5UFNJek55NHlNVFlpTHo0OFkybHlZMnhsSUdONFBTSXpNRFV1TmpZMElpQmplVDBpTVRVMUxqSXpNU0lnY2owaU16Y3VNakUySWk4K1BDOW5Qand2YzNablBnPT0ifSk=";
    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QiLCAiZGVzY3JpcHRpb24iOiAiQW4gTkZUIHRoYXQgcmVmbGVjdHMgdGhlIG93bmVycyBtb29kLiIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJtb29kaW5lc3MiLCAidmFsdWUiOiAxMDB9XSwgImltYWdlIjogImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5Qm9aV2xuYUhROUlqZ3dNQ0lnZG1sbGQwSnZlRDBpTUNBd0lEUTNNeTQ1TXpVZ05EY3pMamt6TlNJZ2QybGtkR2c5SWpnd01DSWdlRzFzYm5NOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklqNDhZMmx5WTJ4bElHTjRQU0l5TXpZdU9UWTNJaUJqZVQwaU1qTTJMamsyTnlJZ1ptbHNiRDBpSTJabVl6RXdaU0lnY2owaU1qTTJMamsyTnlJdlBqeG5JR1pwYkd3OUlpTXpNek1pUGp4d1lYUm9JR1E5SW0wek5UWXVOamN4SURNMU5DNHhZeTAyTmk0eU1qWXROamN1TmpFNExURTNOQzR5TlRVdE5qY3VNek0zTFRJME1DNHdPVFl1TnpBekxUZ3VNemc1SURndU5qWTJJRFF1T0RJM0lESXhMamt4TWlBeE15NHlNamNnTVRNdU1qSTNJRFU0TGpnM0xUWXdMamd6SURFMU5DNHpPRFl0TmpFdU1qQTBJREl4TXk0Mk5ERXRMamN3TXlBNExqUTFNeUE0TGpZek15QXlNUzQyTnpNdE5DNDJNRFlnTVRNdU1qSTRMVEV6TGpJeU4zb2lMejQ4WTJseVkyeGxJR040UFNJeE5qUXVPVE00SWlCamVUMGlNVFUxTGpJek1pSWdjajBpTXpjdU1qRTJJaTgrUEdOcGNtTnNaU0JqZUQwaU16QTFMalkyTnlJZ1kzazlJakUxTlM0eU16SWlJSEk5SWpNM0xqSXhOaUl2UGp3dlp6NDhMM04yWno0PSJ9KQ==";
    DeployMoodNft public deployer;
    address USER = makeAddr("USER");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        assert(moodNft.ownerOf(0) == USER);
    }

    function testInitialStateIntegration() public {
        assert(moodNft.getTokenCounter() == 0);
        assertEq(
            keccak256(abi.encodePacked(moodNft.getHappySvgImageUri())), keccak256(abi.encodePacked(HAPPY_SVG_IMAGE_URI))
        );
        assertEq(
            keccak256(abi.encodePacked(moodNft.getSadSvgImageUri())), keccak256(abi.encodePacked(SAD_SVG_IMAGE_URI))
        );
    }

    function testMintNftIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        assert(moodNft.ownerOf(0) == USER);
        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(HAPPY_SVG_URI)));
        assert(uint256(moodNft.getTokenToMood(0)) == uint256(Mood.HAPPY));
    }

    function testFlipMoodIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        vm.prank(USER);
        moodNft.flipMood(0);
        assert(uint256(moodNft.getTokenToMood(0)) == uint256(Mood.SAD));
        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(SAD_SVG_URI)));
        vm.prank(USER);
        moodNft.flipMood(0);
        assert(uint256(moodNft.getTokenToMood(0)) == uint256(Mood.HAPPY));
        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(HAPPY_SVG_URI)));
    }

    function testOnlyOwnerCanFlipMoodIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        vm.prank(makeAddr("NOT_OWNER"));
        vm.expectRevert(abi.encodeWithSelector(MoodNft__OnlyOwnerCanFlipMood.selector));
        moodNft.flipMood(0);
    }
}
