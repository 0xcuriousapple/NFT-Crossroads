import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("L2SoulBoundNFT", function () {
    it("Test", async function () {
      const [owner, otherAccount] = await ethers.getSigners();
      const L2SoulBoundNFT = await ethers.getContractFactory("ETHIndia22");
      const l2SoulBoundNFT = await L2SoulBoundNFT.deploy();
      await l2SoulBoundNFT.buy({value: ethers.BigNumber.from("10000000000000000")}); 
      expect(await l2SoulBoundNFT.ownerOf(1)).equals(await owner.getAddress()); 
      expect(l2SoulBoundNFT.transferFrom(owner.address, otherAccount.address, 1)).revertedWith("TransfersNotPossible()");
    });
    
});
  

