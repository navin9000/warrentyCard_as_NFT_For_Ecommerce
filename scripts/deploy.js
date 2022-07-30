//importing ethers 
const { ethers } = require("hardhat");


async function main(){
    //getting the contract facotory object to access deploy method
    const factoryObject = await ethers.getContractFactory("WarrentyNFT");     
    const contractObject = await factoryObject.deploy();
    await contractObject.deployed();
    //printing the contract address
    console.log("contract address :",contractObject.address);
}

main()
     .then(() => process.exit(0))
     .catch((error) => {
        console.error(error);
        process.exit(1);
     });