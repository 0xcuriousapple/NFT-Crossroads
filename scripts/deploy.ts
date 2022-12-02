import { ethers } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners();

  hre.changeNetwork("goerli");
  const nonce = await ethers.provider.getTransactionCount(owner.address);
  const TARGET_ADDRESS = await ethers.utils.getContractAddress({
    from: owner.address,
    nonce: nonce + 1,
  });
  console.log("calculated target address", TARGET_ADDRESS);

  hre.changeNetwork("opgoerli");
  const OP_G_CONNEXT_ADDRESS = "0x0C70d6E9760DEE639aC761f3564a190220DF5E44";
  const DESTINATION_DOMAIN_ID = 1735353714;
  const NFTSale = await ethers.getContractFactory("ETHIndia22NFTSale");
  const nftSale = await NFTSale.deploy(OP_G_CONNEXT_ADDRESS, TARGET_ADDRESS, DESTINATION_DOMAIN_ID);
  await nftSale.deployed();
  console.log(`Deployed to ${nftSale.address}`);

  hre.changeNetwork("goerli");

  const ORIGIN_DOMAIN_ID =  1735356532;
  const SOURCE =  nftSale.address;
  const G_CONNEXT_ADDRESS = "0xb35937ce4fFB5f72E90eAD83c10D33097a4F18D2";

  const NFT = await ethers.getContractFactory("ETHIndia22NFT");
  const nft = await NFT.deploy(ORIGIN_DOMAIN_ID, SOURCE, G_CONNEXT_ADDRESS);
  await nft.deployed();
  console.log(`Deployed to ${nft.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
