import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-change-network";
import "@nomiclabs/hardhat-etherscan";

import {config as read} from "dotenv"
read();

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/" + process.env.GOERLI_API_KEY,
      accounts: {
        mnemonic: process.env.MNEMONIC,
      }
    },
    opgoerli: {
      url: "https://opt-goerli.g.alchemy.com/v2/" + process.env.OP_GOERLI_API_KEY,
      accounts: {
        mnemonic: process.env.MNEMONIC,
      }, 
    },
    polygonMumbai: { 
      url : "https://polygon-mumbai.g.alchemy.com/v2/" + process.env.POLYGON_MUMBAI_API_KEY, 
      accounts: {
        mnemonic: process.env.MNEMONIC,
      }, 
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};

export default config;