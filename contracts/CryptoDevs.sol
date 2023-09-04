// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    //Set the price of one Crypto Dev NFT
    uint256 constant public _price = 0.01 ether;

    //Max number of tokens
    uint256 constant public maxTokenIds = 20;

    //Whitelist instance
    Whitelist whitelist;

    //Reserved tokens for whitelisted members
    uint256 public reservedTokens;
    uint256 public reservedTokensClaimed = 0; //Starts at 0

    /**
      * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
      * name in our case is `Crypto Devs` and symbol is `CD`.
      * Constructor for Crypto Devs takes in the baseURI to set _baseTokenURI for the collection.
      * It also initializes an instance of whitelist interface.
      */
     constructor(address whitelistContract) ERC721("CryptoDevs","CD") {
        whitelist = Whitelist(whitelistContract);
        reservedTokens = whitelist.maxWhitelistedAddresses();
     }

    //Actual minting function for NFTs
     function mint() public payable {
        //Check supply
        require(totalSupply() + reservedTokens - reservedTokensClaimed < maxTokenIds, "EXCEEDED_MAX_SUPPLY");

        //Case = whitelisted user
        if (whitelist.whitelistedAddresses(msg.sender) && msg.value < _price){
            //Check if they already own
            require(balanceOf(msg.sender) == 0,"ALREADY OWNED");
            reservedTokensClaimed += 1;
        } else {
            //Not part of whitelist
            require(msg.value >= _price, "Not Enough Ether");
        }
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
     }

    /**
    * @dev withdraw sends all the ether in the contract
    * to the owner of the contract
    */
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}