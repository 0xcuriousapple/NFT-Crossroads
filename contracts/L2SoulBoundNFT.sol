// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ETHIndia22 is ERC721 {

    uint256 public constant mintPrice = 1e16; // 0.01 ETH
    uint256 counter = 0;
    error IncorrectBuyAmount();
    error TransfersNotPossible();
    constructor() ERC721("EthIndia22", "ETHIN22") {
    }

    function buy() external payable {
        if (msg.value != mintPrice) revert IncorrectBuyAmount();
        _safeMint(msg.sender, ++counter);
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256, /* firstTokenId */
        uint256 batchSize
    ) 
    internal override {
        if(from != address(0)) revert TransfersNotPossible();
    }
}
