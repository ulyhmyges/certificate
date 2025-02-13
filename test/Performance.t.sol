// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {Performance} from "../src/Performance.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract PerformanceTest is Test, IERC721Receiver {
    Performance public performance;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        performance = new Performance();
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function testInitialState() public view {
        assertEq(performance.owner(), owner);
        assertEq(performance.getBaseURI(), "https://ipfs.io/ipfs/");
    }

    function testMint() public {
        string memory tokenURI = "QmTest123";
        uint256 tokenId = performance.mint(tokenURI);
        assertEq(tokenId, 1);
        assertEq(performance.tokenURI(tokenId), "https://ipfs.io/ipfs/QmTest123");
        assertEq(performance.ownerOf(tokenId), owner);
        assertEq(performance.getURIByDayRevert(tokenId, 0), tokenURI);
    }

    function testBurn() public {
        string memory tokenURI = "QmTest123";
        uint256 tokenId = performance.mint(tokenURI);

        performance.burn(tokenId);

        vm.expectRevert();
        performance.ownerOf(tokenId);
    }

    function testFailBurnNotOwner() public {
        string memory tokenURI = "QmTest123";
        uint256 tokenId = performance.mint(tokenURI);

        vm.prank(user1);
        performance.burn(tokenId);
    }

    function testUpdateNFT() public {
        string memory initialURI = "QmInitial";
        string memory updatedURI = "QmUpdated";

        uint256 tokenId = performance.mint(initialURI);
        performance.updateNFT(tokenId, updatedURI);

        assertEq(performance.tokenURI(tokenId), "https://ipfs.io/ipfs/QmUpdated");
        assertEq(performance.getURIByDayRevert(tokenId, 0), updatedURI);
        assertEq(performance.getURIByDayRevert(tokenId, 1), initialURI);
    }

    function testURIHistory() public {
        string memory uri1 = "QmURI1";
        string memory uri2 = "QmURI2";
        string memory uri3 = "QmURI3";

        uint256 tokenId = performance.mint(uri1);
        performance.updateNFT(tokenId, uri2);
        performance.updateNFT(tokenId, uri3);

        assertEq(performance.getURIByDayRevert(tokenId, 0), uri3);
        assertEq(performance.getURIByDayRevert(tokenId, 1), uri2);
        assertEq(performance.getURIByDayRevert(tokenId, 2), uri1);
    }

    function testUpdateHistory() public {
        string memory uri1 = "QmURI1";
        uint256 tokenId = performance.mint(uri1);

        string memory uri2 = "QmURI2";
        performance.updateHistory(tokenId, uri2);
        assertEq(performance.getURIByDayRevert(tokenId, 0), uri2);
        assertEq(performance.getURIByDayRevert(tokenId, 1), uri1);

        string memory uri3 = "QmURI3";
        performance.updateHistory(tokenId, uri3);
        assertEq(performance.getURIByDayRevert(tokenId, 0), uri3);
        assertEq(performance.getURIByDayRevert(tokenId, 1), uri2);
        assertEq(performance.getURIByDayRevert(tokenId, 2), uri1);

        performance.updateHistory(tokenId, uri3);
        assertEq(performance.getURIByDayRevert(tokenId, 0), uri3);
        assertEq(performance.getURIByDayRevert(tokenId, 1), uri3);
        assertEq(performance.getURIByDayRevert(tokenId, 2), uri2);
    }

    function testFailGetURIByDayRevertLimit() public {
        string memory tokenURI = "QmTest123";
        uint256 tokenId = performance.mint(tokenURI);

        performance.getURIByDayRevert(tokenId, 31);
    }

    function testHistoryLimit() public {
        string memory baseURI = "QmTest";
        uint256 tokenId = performance.mint("QmInitial");

        // Fill up history (Performance contract has a limit of 10)
        for (uint8 i = 0; i < 15; i++) {
            string memory newURI = string(abi.encodePacked(baseURI, vm.toString(i)));
            performance.updateHistory(tokenId, newURI);
        }

        // Check that only the last 10 entries are kept
        string memory lastURI = string(abi.encodePacked(baseURI, "14"));
        assertEq(performance.getURIByDayRevert(tokenId, 0), lastURI);

        // Verify that we can't access beyond the 10th entry
        vm.expectRevert();
        performance.getURIByDayRevert(tokenId, 10);
    }
}
