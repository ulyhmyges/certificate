// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {ESGID} from "../src/ESGID.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract ESGIDTest is Test, IERC721Receiver {
    ESGID public esgid;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        esgid = new ESGID();
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function testInitialState() public view {
        assertEq(esgid.owner(), owner);
        assertEq(esgid.getBaseURI(), "https://ipfs.io/ipfs/");
    }

    function testMint() public {
        string memory tokenURI = "QmTest123";
        uint256 tokenId = esgid.mint(tokenURI);
        assertEq(tokenId, 1);
        assertEq(esgid.tokenURI(tokenId), "https://ipfs.io/ipfs/QmTest123");
        assertEq(esgid.ownerOf(tokenId), owner);
        assertEq(esgid.getURIByDayRevert(tokenId, 0), tokenURI);
    }

    function testBurn() public {
        string memory tokenURI = "QmTest123";
        uint256 tokenId = esgid.mint(tokenURI);

        esgid.burn(tokenId);

        vm.expectRevert();
        esgid.ownerOf(tokenId);
    }

    function testFailBurnNotOwner() public {
        string memory tokenURI = "QmTest123";
        uint256 tokenId = esgid.mint(tokenURI);

        vm.prank(user1);
        esgid.burn(tokenId);
    }

    function testUpdateNFT() public {
        string memory initialURI = "QmInitial";
        string memory updatedURI = "QmUpdated";

        uint256 tokenId = esgid.mint(initialURI);
        esgid.updateNFT(tokenId, updatedURI);

        assertEq(esgid.tokenURI(tokenId), "https://ipfs.io/ipfs/QmUpdated");
        assertEq(esgid.getURIByDayRevert(tokenId, 0), updatedURI);
        assertEq(esgid.getURIByDayRevert(tokenId, 1), initialURI);
    }

    function testURIHistory() public {
        string memory uri1 = "QmURI1";
        string memory uri2 = "QmURI2";
        string memory uri3 = "QmURI3";

        uint256 tokenId = esgid.mint(uri1);
        esgid.updateNFT(tokenId, uri2);
        esgid.updateNFT(tokenId, uri3);

        assertEq(esgid.getURIByDayRevert(tokenId, 0), uri3);
        assertEq(esgid.getURIByDayRevert(tokenId, 1), uri2);
        assertEq(esgid.getURIByDayRevert(tokenId, 2), uri1);
    }

    function testUpdateHistory() public {
        string memory uri1 = "QmURI1";
        uint256 tokenId = esgid.mint(uri1);

        string memory uri2 = "QmURI2";
        esgid.updateHistory(tokenId, uri2);
        assertEq(esgid.getURIByDayRevert(tokenId, 0), uri2);
        assertEq(esgid.getURIByDayRevert(tokenId, 1), uri1);

        string memory uri3 = "QmURI3";
        esgid.updateHistory(tokenId, uri3);
        assertEq(esgid.getURIByDayRevert(tokenId, 0), uri3);
        assertEq(esgid.getURIByDayRevert(tokenId, 1), uri2);
        assertEq(esgid.getURIByDayRevert(tokenId, 2), uri1);

        esgid.updateHistory(tokenId, uri3);
        assertEq(esgid.getURIByDayRevert(tokenId, 0), uri3);
        assertEq(esgid.getURIByDayRevert(tokenId, 1), uri3);
        assertEq(esgid.getURIByDayRevert(tokenId, 2), uri2);
    }

    function testFailGetURIByDayRevertLimit() public {
        string memory tokenURI = "QmTest123";
        uint256 tokenId = esgid.mint(tokenURI);

        esgid.getURIByDayRevert(tokenId, 31);
    }

    function testHistoryLimit() public {
        string memory baseURI = "QmTest";
        uint256 tokenId = esgid.mint("QmInitial");

        // Fill up history
        for (uint8 i = 0; i < 35; i++) {
            string memory newURI = string(abi.encodePacked(baseURI, vm.toString(i)));
            esgid.updateHistory(tokenId, newURI);
        }

        // Check that only the last 31 entries are kept
        string memory lastURI = string(abi.encodePacked(baseURI, "34"));
        assertEq(esgid.getURIByDayRevert(tokenId, 0), lastURI);
    }
}
