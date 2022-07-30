require("@nomiclabs/hardhat-waffle");
require("dotenv").config({path: ".env"});

const ALCHEMY_API_KEY_URL =process.env.ALCHEMY_API_KEY_URL;
const GOERLI_PRIVATE_KEY=process.env.GOERLI_PRIVATE_KEY;

//TELLING THE WHICH NETWORK AND WHICH ACCOUNT
module.exports = {
      solidity: "0.8.7",
      networks: {       
        goerli:  {
              url:ALCHEMY_API_KEY_URL,
              accounts:[GOERLI_PRIVATE_KEY],
        },  
      mumbai: {
              url:process.env.ALCHEMY_MUMBAI_TESTNET_API_KEY,
              accounts:[process.env.MUMBAI_TESTNET_PRIVATE_KEY],
        },             
      },  
    };