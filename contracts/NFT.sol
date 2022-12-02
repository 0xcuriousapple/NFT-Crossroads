// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IConnext} from "@connext/nxtp-contracts/contracts/core/connext/interfaces/IConnext.sol";
import {IXReceiver} from "@connext/nxtp-contracts/contracts/core/connext/interfaces/IXReceiver.sol";

contract ETHIndia22NFT is ERC721 {


    uint32 public originDomain;
    address public source;
    IConnext public connext;
    
    
    error IncorrectBuyAmount();
    error TransfersNotPossible();
    error NotAOwner();

    constructor(
        uint32 _originDomain,
        address _source,
        IConnext _connext
    ) ERC721("EthIndia22", "ETHIN22"){
        originDomain = _originDomain;
        source = _source;
        connext = _connext;
    }

    
    modifier onlySource(address _originSender, uint32 _origin) {
        require(
        _origin == originDomain &&
            _originSender == source &&
            msg.sender == address(connext),
        "Expected source contract on origin domain called by Connext"
        );
        _;
    }

    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes memory _callData
    ) external onlySource(_originSender, _origin) returns (bytes memory) {

        address receiver;
        uint256 tokenId;
        (receiver, tokenId) = abi.decode(_callData, (address, uint256));
        _safeMint(receiver, tokenId);
    }

}
