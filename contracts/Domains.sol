// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import { Base64 } from "./libraries/Base64.sol";
import { StringUtils } from "./libraries/StringUtils.sol";

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";




contract Domains is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    error Unauthorized();
    error AlreadyRegistered();
    error InvalidName(string name);

    string public tld;
    string svgPartOne ='<svg width="315" height="315" viewBox="0 0 315 315" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="url(#a)" d="M0 0h315v315H0z"/><path fill-rule="evenodd" clip-rule="evenodd" d="m0 206 5.775 15.75c5.775 15.75 17.587 47.25 29.138 49 11.812 1.75 23.362-26.25 35.175-35C81.638 227 93.45 237.5 105 251.5s23.362 31.5 34.912 35c11.813 3.5 23.363-7 35.175-19.25C186.637 255 198.45 241 210 237.5c11.55-3.5 23.362 3.5 34.912 17.5 11.813 14 23.363 35 35.175 28 11.55-7 23.363-42 29.138-59.5L315 206v105H0V206Z" fill="url(#b)"/><path d="M52.5 89.5c22.06 0 40-17.653 40-39.5s-17.94-39.5-40-39.5-40 17.653-40 39.5 17.94 39.5 40 39.5Z" fill="url(#c)" stroke="#D8D5FF" stroke-width="5"/><path d="M61.97 43.243c-.7-.4-1.6-.4-2.401 0l-5.602 3.295-3.802 2.096-5.502 3.295c-.7.4-1.6.4-2.401 0l-4.302-2.596a2.432 2.432 0 0 1-1.2-2.096v-4.993c0-.799.4-1.597 1.2-2.097l4.302-2.496c.7-.4 1.6-.4 2.401 0l4.302 2.596c.7.4 1.2 1.198 1.2 2.097v3.295l3.802-2.197v-3.395c0-.798-.4-1.597-1.2-2.096l-8.004-4.693c-.7-.4-1.6-.4-2.4 0l-8.204 4.793c-.8.399-1.2 1.198-1.2 1.996v9.386c0 .799.4 1.598 1.2 2.097l8.103 4.693c.7.4 1.6.4 2.401 0l5.502-3.195 3.802-2.197 5.502-3.195c.7-.4 1.6-.4 2.4 0l4.302 2.496c.7.4 1.201 1.198 1.201 2.097v4.992c0 .8-.4 1.598-1.2 2.097l-4.202 2.496c-.7.4-1.6.4-2.401 0l-4.302-2.496c-.7-.4-1.2-1.198-1.2-2.097v-3.195l-3.802 2.197v3.295c0 .799.4 1.597 1.2 2.097l8.104 4.693c.7.399 1.6.399 2.4 0l8.104-4.693c.7-.4 1.2-1.199 1.2-2.097v-9.486c0-.798-.4-1.597-1.2-2.096l-8.103-4.693Z" fill="#fff"/><path d="M109.033 77.2c.04-3.204 2.762-5.782 6.094-5.782h.04V53.84h-.04c-13.447 0-24.335 10.45-24.375 23.36h18.281Z" fill="#F44336"/><path d="M109.033 77.2c.04-3.204 2.762-5.782 6.094-5.782h.04V56.769h-.244c-11.76 0-21.287 9.141-21.328 20.43h15.438Z" fill="#FF9800"/><path d="M109.033 77.2c.04-3.204 2.762-5.782 6.094-5.782h.04V59.699h-.04c-10.075 0-18.241 7.832-18.282 17.5h12.188Z" fill="#FFEB3B"/><path d="M109.033 77.2c.04-3.204 2.762-5.782 6.094-5.782h.04v-8.79h-.04c-8.389 0-15.194 6.524-15.235 14.571h9.141Z" fill="#8BC34A"/><path d="M109.033 77.2c.04-3.204 2.762-5.782 6.094-5.782h.04v-5.86h-.04c-6.704 0-12.147 5.196-12.188 11.641h6.094Z" fill="#2196F3"/><path d="M109.033 77.2c.04-3.204 2.762-5.782 6.094-5.782h.04v-2.93h-.04c-5.018 0-9.1 3.887-9.141 8.711h3.047Z" fill="#673AB7"/><path opacity=".2" d="M91.564 77.2c.02-6.016 2.478-11.68 6.906-15.938 4.449-4.278 10.36-6.64 16.657-6.64h.04v-.782h-.04c-13.447 0-24.335 10.45-24.375 23.36h.812Zm17.672 0c.041-3.087 2.661-5.587 5.87-5.587h.041v-.781h-.041c-3.676 0-6.642 2.832-6.703 6.367h.833Z" fill="#424242"/><defs><linearGradient id="a" x1="0" y1="0" x2="315" y2="310.771" gradientUnits="userSpaceOnUse"><stop stop-color="#2E52CE"/><stop offset=".615" stop-color="#637DDA"/><stop offset="1" stop-color="#6D8DFC"/></linearGradient><linearGradient id="b" x1="157.5" y1="206" x2="157.5" y2="311" gradientUnits="userSpaceOnUse"><stop stop-color="#637DDA"/><stop offset="1" stop-color="#2E52CE" stop-opacity="0"/></linearGradient><linearGradient id="c" x1="52.5" y1="13" x2="52.5" y2="87" gradientUnits="userSpaceOnUse"><stop stop-color="#2E52CE"/><stop offset="1" stop-color="#637DDA"/></linearGradient></defs><text x="10%" y="75%" font-size="32" fill="#fff" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = '</text></svg>';

    address payable public owner;

    mapping(string => address) public domains;
    mapping(string => string) public records;
    mapping(uint => string) public names;

    function getAllNames() public view returns (string[] memory) {
      console.log("Getting all names from contract");
      string[] memory allNames = new string[](_tokenIds.current());
      for (uint i = 1; i<_tokenIds.current(); i++){
        allNames[i] = names[i];
        console.log("Name for token %d is %s", i, allNames[i]);
      } 
    return allNames;
    }

    constructor(string memory _tld) payable ERC721("King Name Service", "KNS") {
    owner = payable(msg.sender);
    tld = _tld;
    console.log("%s name service deployed", _tld);
  }


    function price (string calldata name) public pure returns(uint){
        uint len= StringUtils.strlen(name);
        require(len > 0);
        if (len == 0){
            return 3* 10**17; //means 5 matic with 18 decimals
        }else if(len ==4) {
            return 3 * 10**17;
        } else{
            return 1 * 10**17;
        }
    }
    // a register function tht adds their names to our mapping
    function register(string calldata name) public payable {
    if (domains[name] != address(0)) revert AlreadyRegistered();
  if (!valid(name)) revert InvalidName(name);

    uint256 _price = price(name);
    require(msg.value >= _price, "Not enough Matic paid");
		
		// Combine the name passed into the function  with the TLD
    string memory _name = string(abi.encodePacked(name, ".", tld));
		// Create the SVG (image) for the NFT with the name
    string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
    uint256 newRecordId = _tokenIds.current();
  	uint256 length = StringUtils.strlen(name);
		string memory strLen = Strings.toString(length);

    console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

		// Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            _name,
            '", "description": "A domain on the royalty name service", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(finalSvg)),
            '","length":"',
            strLen,
            '"}'
          )
        )
      )
    );

    string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

		console.log("\n--------------------------------------------------------");
	  console.log("Final tokenURI", finalTokenUri);
	  console.log("--------------------------------------------------------\n");

    _safeMint(msg.sender, newRecordId);
    _setTokenURI(newRecordId, finalTokenUri);
    domains[name] = msg.sender;

    _tokenIds.increment();
    names[newRecordId] = name;
  }
    // this will give us the domain owners address
    function getAddress(string calldata name) public view returns (address){
        return domains[name];
    }
    function setRecord(string calldata name, string calldata record) public{
        //check if the owner == txn sender
        if (msg.sender != domains[name]) revert Unauthorized();
        records[name] = record;
    }

    function getRecord(string calldata name) public view returns(string memory){
        return records[name];
    }

    function valid(string calldata name) public pure returns(bool){
      return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <=10;
    }

    modifier onlyOwner() {
  require(isOwner());
  _;
}

    function isOwner() public view returns (bool){
      return msg.sender == owner;
    }

    function withdraw() public onlyOwner {
      uint amount = address(this).balance;

      (bool success, ) = msg.sender.call{value: amount}("");
      require(success, "Failed to withdraw Matic");
    }

}

