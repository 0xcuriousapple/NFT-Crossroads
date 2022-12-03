// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IConnext {
  function xcall(
    uint32 _destination,
    address _to,
    address _asset,
    address _delegate,
    uint256 _amount,
    uint256 _slippage,
    bytes calldata _callData
  ) external payable returns (bytes32);
}


contract NFTPlayDomain is ERC721 {
    
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


    /*///////////////////////////////////////////////////////////////
                      INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId, 
        uint256 batchSize
    ) internal override {
        connext.xcall(
            domainId,             // _destination: Domain ID of the destination chain
            target,               // _to: address of the target contract
            address(0),           // _asset: use address zero for 0-value transfers
            ownerOf(tokenId),     // _delegate: address that can revert or forceLocal on destination
            0,                    // _amount: 0 because no funds are being transferred
            0,                    // _slippage: can be anything between 0-10000 because no funds are being transferred
            abi.encode(from, to, tokenId)   //_callData: the encoded calldata to send
        );
    }
}
