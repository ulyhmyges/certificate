// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ESGID} from "../src/ESGID.sol";

contract ESGIDScript is Script {
    ESGID public diploma;
    address public wallet;
    function setUp() public {
        wallet = address(vm.envAddress("WALLET"));
    }

    function run() public {
       
        vm.startBroadcast();
        diploma = new ESGID();
        
        uint256 tokenId = diploma.mint("QmVXxHUWE2fdNjMxerzgWNJNeR8tu1F61KYY6BjDo2LRMA");
        console.log("tokenId: ", tokenId);
        console.log("sender: ", msg.sender);

        console.log("url: ", diploma.tokenURI(tokenId)); // => https://ipfs.io/ipfs/QmVXxHUWE2fdNjMxerzgWNJNeR8tu1F61KYY6BjDo2LRMA

        // update URI
        diploma.updateNFT(1, "QmcFhGCkaeb3w9L9Mr7USF7ZD3pn2VRGNsbjYf3Xz5SAtB");
        console.log(diploma.tokenURI(1));               // https://ipfs.io/ipfs/QmcFhGCkaeb3w9L9Mr7USF7ZD3pn2VRGNsbjYf3Xz5SAtB
        console.log(diploma.getURIByDayRevert(1, 0));   // QmcFhGCkaeb3w9L9Mr7USF7ZD3pn2VRGNsbjYf3Xz5SAtB
        console.log(diploma.getURIByDayRevert(1, 1));   // QmVXxHUWE2fdNjMxerzgWNJNeR8tu1F61KYY6BjDo2LRMA
    
        vm.stopBroadcast();
    }
}
