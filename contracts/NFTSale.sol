// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IConnext} from "@connext/nxtp-contracts/contracts/core/connext/interfaces/IConnext.sol";

/// @title ETHIndia22NFTSale
/// @author curiousapple (abhishek vispute)
/// @notice contract to do NFT Sale on sep chain and then migrate the claim to the mainnet.

contract ETHIndia22NFTSale is ERC721 {
    
    /*///////////////////////////////////////////////////////////////
                        STATE
    //////////////////////////////////////////////////////////////*/
    uint256 public constant mintPrice = 1e16; // 0.01 ETH
    uint256 public constant totalSupply = 1000;

    //slot 0
    uint32 public counter; // 4 bytes
    uint32 public domainId; // 4 bytes
    IConnext public connext;  // 20 bytes 
    // slot 1 
    address public target; // 20


    //////////////////////////////////////////////////////////////*/

    error IncorrectBuyAmount();
    error TransfersNotPossible();
    error NotAOwner();
    error AllSold();
    constructor(IConnext _connext, address _target, uint32 _domainId) ERC721("EthIndia22_Claim", "ETHIN22_C") {
        connext = _connext;
        target = _target;
        domainId = _domainId;
    }

    /*///////////////////////////////////////////////////////////////
                      EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function buy() external payable {
        if(counter == totalSupply - 1) revert AllSold();
        if (msg.value != mintPrice) revert IncorrectBuyAmount();
        _safeMint(msg.sender, ++counter);
    }

    function propogateToMainnet (
        uint256 tokenId,
        uint256 relayerFee
    ) external payable {
        connext.xcall{value: relayerFee}(
            domainId, // _destination: Domain ID of the destination chain
            target,            // _to: address of the target contract
            address(0),        // _asset: use address zero for 0-value transfers
            ownerOf(tokenId),        // _delegate: address that can revert or forceLocal on destination
            0,                 // _amount: 0 because no funds are being transferred
            0,                 // _slippage: can be anything between 0-10000 because no funds are being transferred
            abi.encode(tokenId)           // _callData: the encoded calldata to send
        );
        _burn(tokenId);
    }


    /*///////////////////////////////////////////////////////////////
                      INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256, 
        uint256 batchSize
    ) internal override {
        // from 0 allow
        // to 0 allow
        // for all others dont allow
        if(from != address(0) && to != address(0)) revert TransfersNotPossible();
    }

    

}
