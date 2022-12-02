import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers, network } from "hardhat";

describe("L2SoulBoundNFT", function () {
    it("Test", async function () {
      await network.provider.request({
        method: "hardhat_reset",
        params: [
          {
            forking: {
              jsonRpcUrl: "https://opt-goerli.g.alchemy.com/v2/FJ6Tl38nVaxBbkKR6lErMQw28wKmCg6F",
              blockNumber: 3147800,
            },
          },
        ],
      });
      const [owner, otherAccount] = await ethers.getSigners();

      const OP_G_ConnextAddress = "0x0C70d6E9760DEE639aC761f3564a190220DF5E44";
      const DOMAIN_ID = 1735353714;
      const TARGET_ADDRESS = owner.address;
      
      const L2SoulBoundNFT = await ethers.getContractFactory("ETHIndia22");
      const l2SoulBoundNFT = await L2SoulBoundNFT.deploy(OP_G_ConnextAddress, TARGET_ADDRESS, DOMAIN_ID);
      await l2SoulBoundNFT.buy({value: ethers.BigNumber.from("10000000000000000")}); 
      expect(await l2SoulBoundNFT.ownerOf(1)).equals(await owner.getAddress()); 
      expect(l2SoulBoundNFT.transferFrom(owner.address, otherAccount.address, 1)).revertedWith("TransfersNotPossible()");
      
      const relayerFee = ethers.BigNumber.from("0");
      await l2SoulBoundNFT.propogateToMainnet(1, relayerFee, {value: relayerFee});

      await network.provider.request({
        method: "hardhat_reset",
        params: [],
      });
    });
    
});
  

