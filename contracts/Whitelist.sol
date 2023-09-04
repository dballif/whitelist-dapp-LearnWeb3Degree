// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.18;

contract Whitelist {

    //Max number of whitlisted address for our NFT whitelist
    uint8 public maxWhitelistedAddresses;

    //Mapping between address and bool if they are whitelisted or not
    mapping(address => bool) public whitelistedAddresses;

    //Store how many addresses are in our list
    uint8 public numAddressesWhitelisted;

    //max whitelisted is set in constructor on deployment
    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    /**
     * addAddressToWhitelist - Function to add the address of sender to the whitelist
     */
    function addAddressToWhitelist() public {
        //Are they already on the whitelist
        require(!whitelistedAddresses[msg.sender], "Sender has already been whitelisted");
        //Is the whitelist full
        require(numAddressesWhitelisted < maxWhitelistedAddresses, "More addresses can't be addded, limit reached");
        //If those all pass, add the address to the whitelist (msg.sender)
        whitelistedAddresses[msg.sender] = true;
        //Increase our total whitelisted
        numAddressesWhitelisted += 1;
    }
}