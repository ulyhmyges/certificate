// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/Performance.sol";

contract PerformanceTest is Test {
    Performance private performance;
    address private owner = address(0xbc0993f0a5C6Cd8c56897305D0666A1C5A2B416a);
    address private user = address(0x123);

    function setUp() public {
        vm.startBroadcast(owner);
        performance = new Performance();
        vm.stopBroadcast();
    }

    function test_Mint() public {
        vm.startBroadcast(owner);
        string memory ipfsId = "QmTokenURI";
        string memory tokenURI = "https://ipfs.io/ipfs/QmTokenURI";
        uint256 tokenId = performance.mint(ipfsId);

        assertEq(performance.ownerOf(tokenId), address(0xbc0993f0a5C6Cd8c56897305D0666A1C5A2B416a));
        assertEq(performance.tokenURI(tokenId), tokenURI);
        vm.stopBroadcast();
    }

    function test_Burn() public {
        vm.startBroadcast(owner);
        string memory ipfsId = "QmTokenURI";

        uint256 tokenId = performance.mint(ipfsId);
        performance.burn(tokenId);

        vm.expectRevert();
        performance.ownerOf(tokenId);
        vm.stopBroadcast();
    }

    function test_UpdateNFT() public {
        vm.startBroadcast(owner);
        string memory initialipfs = "QmTokenURI1";
        string memory updatedipfs = "QmTokenURI2";
        uint256 tokenId = performance.mint(initialipfs);

        performance.updateNFT(tokenId, updatedipfs);
        string memory uri = "https://ipfs.io/ipfs/QmTokenURI2";
        assertEq(performance.tokenURI(tokenId), uri);
        vm.stopBroadcast();
    }

    function test_GetURIByDayRevert() public {
        vm.startBroadcast(owner);
        string memory initialipfs = "QmTokenURI1";
        string memory updatedipfs = "QmTokenURI2";
        uint256 tokenId = performance.mint(initialipfs);
        performance.updateNFT(tokenId, updatedipfs);

        assertEq(performance.getURIByDayRevert(tokenId, 0), updatedipfs);
        assertEq(performance.getURIByDayRevert(tokenId, 1), initialipfs);
        vm.stopBroadcast();
    }

    function test_OnlyOwnerCanBurn() public {
        vm.prank(user);
        uint256 tokenId = performance.mint("QmTokenURI");

        vm.prank(user);
        vm.expectRevert();
        performance.burn(tokenId);
    }
}
