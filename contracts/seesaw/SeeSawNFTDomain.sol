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


contract SeeSawNFTDomain is ERC721 {
    
    /*///////////////////////////////////////////////////////////////
                        STATE
    //////////////////////////////////////////////////////////////*/
    uint256 public constant mintPrice = 1e16; // 0.01 ETH
    uint256 public constant totalSupply = 1000;

    uint32 public counter; // 4 bytes
    uint32 public destinationDomainId; // 4 bytes
    IConnext public connext;  // 20 bytes 
    address public mirror; // 20


    modifier onlySource(address _originSender, uint32 _origin) {
        require(
        _origin == destinationDomainId &&
            _originSender == mirror &&
            msg.sender == address(connext),
        "Expected source contract called by Connext"
        );
        _;
    }

    //////////////////////////////////////////////////////////////*/

    error IncorrectBuyAmount();
    error AllSold();
    error NotAOwner();
    
    constructor(IConnext _connext, address _mirror, uint32 _destinationDomainId) ERC721("EthIndia22_SeeSaw", "ETHIN22_SW") {
        connext = _connext;
        mirror = _mirror;
        destinationDomainId = _destinationDomainId;
    }

    
    /*///////////////////////////////////////////////////////////////
                      EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function buy() external payable {
        if(counter == totalSupply - 1) revert AllSold();
        if (msg.value != mintPrice) revert IncorrectBuyAmount();
        _safeMint(msg.sender, ++counter);
    }


    function lockHereReleaseThere(uint256 tokenId) external payable{
        if (msg.sender != ownerOf(tokenId)) revert NotAOwner();
        connext.xcall{value: msg.value}(
            destinationDomainId, // _destination: Domain ID of the destination chain
            mirror,            // _to: address of the mirror contract
            address(0),        // _asset: use address zero for 0-value transfers
            ownerOf(tokenId),        // _delegate: address that can revert or forceLocal on destination
            0,                 // _amount: 0 because no funds are being transferred
            0,                 // _slippage: can be anything between 0-10000 because no funds are being transferred
            abi.encode(ownerOf(tokenId), tokenId)           // _callData: the encoded calldata to send
        );
        _burn(tokenId);
    }

    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes memory _callData
    ) external onlySource(_originSender, _origin) returns (bytes memory) {
        address to;
        uint256 tokenId;
        
        (to, tokenId) = abi.decode(_callData, (address, uint256));
        _safeMint(to, tokenId);
    }
}
