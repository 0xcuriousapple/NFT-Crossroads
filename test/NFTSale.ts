import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers, network } from "hardhat";
import { config } from "dotenv";
config();

describe("NFTSale", function () {
    it("Test", async function () {
      await network.provider.request({
        method: "hardhat_reset",
        params: [
          {
            forking: {
              jsonRpcUrl: "https://opt-goerli.g.alchemy.com/v2/" + process.env.OP_GOERLI_API_KEY,
              blockNumber: 3147800,
            },
          },
        ],
      });
      const [owner, otherAccount] = await ethers.getSigners();
      const OP_G_ConnextAddress = "0x0C70d6E9760DEE639aC761f3564a190220DF5E44";
      const DOMAIN_ID = 1735353714;
      const TARGET_ADDRESS = owner.address;
      
      const NFTSale = await ethers.getContractFactory("NFTSale");
      const nftSale = await NFTSale.deploy(OP_G_ConnextAddress, TARGET_ADDRESS, DOMAIN_ID);
      await nftSale.buy({value: ethers.BigNumber.from("10000000000000000")}); 
      expect(await nftSale.ownerOf(1)).equals(await owner.getAddress()); 
      expect(nftSale.transferFrom(owner.address, otherAccount.address, 1)).revertedWith("TransfersNotPossible()");
      
      const relayerFee = ethers.BigNumber.from("0");
      await nftSale.propogateToMainnet(1, {value: relayerFee});
      expect(nftSale.propogateToMainnet(1, {value: relayerFee})).revertedWith("ERC721: invalid token ID");

      await network.provider.request({
        method: "hardhat_reset",
        params: [],
      });
    });
    
});
  

