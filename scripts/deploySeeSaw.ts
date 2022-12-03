import { ethers } from "hardhat";

async function main() {
  const address = "0x421f0897f2e07462b5a7b994abf8ae758dd0dd70";

  hre.changeNetwork("goerli");
  const nonce = await ethers.provider.getTransactionCount(address);
  const MIRROR_ADDRESS = await ethers.utils.getContractAddress({
    from: address,
    nonce: nonce,
  });
  console.log("calculated target address", MIRROR_ADDRESS);

  hre.changeNetwork("polygonMumbai");
  const POLYGON_CONNEXT_ADDRESS = "0xa2F2ed226d4569C8eC09c175DDEeF4d41Bab4627";
  const DESTINATION_DOMAIN_ID = 1735353714;
  const SeeSawNFTDomain = await ethers.getContractFactory("SeeSawNFTDomain");
  const seeSawNFTDomain = await SeeSawNFTDomain.deploy(POLYGON_CONNEXT_ADDRESS, MIRROR_ADDRESS, DESTINATION_DOMAIN_ID);
  await seeSawNFTDomain.deployed();
  console.log(`Domain Deployed to ${seeSawNFTDomain.address} at Polygon Mumbai`);

  hre.changeNetwork("goerli");
  const G_CONNEXT_ADDRESS = "0xb35937ce4fFB5f72E90eAD83c10D33097a4F18D2";
  const ORIGIN_DOMAIN_ID = 9991;

  const SeeSawNFTMainnet = await ethers.getContractFactory("SeeSawNFTMainnet");
  const seeSawNFTMainnet = await SeeSawNFTMainnet.deploy(G_CONNEXT_ADDRESS, seeSawNFTDomain.address, ORIGIN_DOMAIN_ID);
  await seeSawNFTMainnet.deployed();
  console.log(`Mainnet deployed to ${seeSawNFTMainnet.address} at Goerli`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
