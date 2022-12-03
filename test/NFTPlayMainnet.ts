import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers, network } from "hardhat";
import { config } from "dotenv";
config();

describe("NFTPlayMainnet", function () {
    it("Test", async function () {
    
      const [owner, otherAccount] = await ethers.getSigners();

      const ORIGIN_DOMAIN_ID = 0;
      const SOURCE = owner.address;
      const CONNEXT = owner.address;

      const NFTPlayMainnet = await ethers.getContractFactory("NFTPlayMainnet");
      const nftPlayMainnet = await NFTPlayMainnet.deploy(ORIGIN_DOMAIN_ID, CONNEXT, owner.address);

      await nftPlayMainnet.xReceive(
        ethers.constants.HashZero,
        0, 
        ethers.constants.AddressZero, 
        SOURCE, 
        ORIGIN_DOMAIN_ID, 
        "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc40000000000000000000000000000000000000000000000000000000000000001"
       );

      expect(await nftPlayMainnet.ownerOf(1)).equals("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4");
      const impersonatedSigner = await ethers.getImpersonatedSigner("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4");
      expect(nftPlayMainnet.connect(impersonatedSigner).transferFrom(impersonatedSigner.address, otherAccount.address, 1)).revertedWith("TransfersNotPossible()")
    });
    
});
  

