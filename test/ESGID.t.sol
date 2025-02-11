// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ESGID.sol";

contract ESGIDTest is Test {
    ESGID private esgid;
    address private owner = address(0xbc0993f0a5C6Cd8c56897305D0666A1C5A2B416a);
    address private user = address(0x123);

    function setUp() public {
        vm.startBroadcast(owner);
        esgid = new ESGID();
        vm.stopBroadcast();
    }

    function testMint() public {
        vm.startBroadcast(owner);
        string memory ipfsId = "QmTokenURI";
        string memory tokenURI = "https://ipfs.io/ipfs/QmTokenURI";
        uint256 tokenId = esgid.mint(ipfsId);


        assertEq(esgid.ownerOf(tokenId), address(0xbc0993f0a5C6Cd8c56897305D0666A1C5A2B416a));
        assertEq(esgid.tokenURI(tokenId), tokenURI);
        vm.stopBroadcast();
    }

    function testBurn() public {
        vm.startBroadcast(owner);
        string memory ipfsId = "QmTokenURI";

        uint256 tokenId = esgid.mint(ipfsId);
        esgid.burn(tokenId);
        
        vm.expectRevert();
        esgid.ownerOf(tokenId);
        vm.stopBroadcast();
    }

    function testUpdateNFT() public {
        vm.startBroadcast(owner);
        string memory initialipfs = "QmTokenURI1";
        string memory updatedipfs = "QmTokenURI2";
        uint256 tokenId = esgid.mint(initialipfs);

        esgid.updateNFT(tokenId, updatedipfs);
        string memory uri = "https://ipfs.io/ipfs/QmTokenURI2";
        assertEq(esgid.tokenURI(tokenId), uri);
        vm.stopBroadcast();
    }

    function testGetURIByDayRevert() public {
        vm.startBroadcast(owner);
        string memory initialipfs = "QmTokenURI1";
        string memory updatedipfs = "QmTokenURI2";
        uint256 tokenId = esgid.mint(initialipfs);
        esgid.updateNFT(tokenId, updatedipfs);

        assertEq(esgid.getURIByDayRevert(tokenId, 0), updatedipfs);
        assertEq(esgid.getURIByDayRevert(tokenId, 1), initialipfs);
        vm.stopBroadcast();
    }

    function testOnlyOwnerCanBurn() public {
        vm.prank(user);
        uint256 tokenId = esgid.mint("QmTokenURI");

        vm.prank(user);
        vm.expectRevert();
        esgid.burn(tokenId);
    }
}
