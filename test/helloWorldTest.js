// const { except } = require("chai");
// const { ethers } = require("hardhat");
// const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

//         //step 1 is to get the signers to deploy the contract
//         //step 2 is pass contract name to getContractFactory 
//         //note : like to deploy a contract additional information is required that is 
//         //not available on a contract object.like bytecode of contract
//         //so,contractFactory sends a special trasaction which is inticode transaction
//         //the result becomes the new code to be deployed as a new contract.
//         //step3 is like calling the deploy function using the factoryObject

// describe("regestering the sellers and unregestring the sellers",function(){    
//     async function deployTokenFixture(){

//         const [owner,addr1,addr2,addr3,addr4,addr5] = await ethers.getSigners();
//         const factoryObject = await ethers.getContractFactory("HelloWorld");
//         const contractObject = await factoryObject.deploy();

//         return {owner,addr1,addr2,addr3,addr4,addr5,factoryObject,contractObject};
//     }

//     // it("here checking the accounts balances",async function(){
//     //     const {owner,addr1,addr2,addr3,addr4,addr5,factoryObject,contractObject} = await loadFixture(deployTokenFixture);
//     //     console.log("owner address :",owner.address);
//     //     console.log("owner balance :",await owner.getBalance());
//     //     console.log("user1 address :",addr1.address);
//     //     console.log("user1 balance :",await addr1.getBalance());
//     //     console.log("user2 address :",addr2.address);
//     //     console.log("user2 balance :",await addr2.getBalance());
//     // });
//     it("Adding sellers by the owner and adding the products by registered sellers",async function(){
//         const {owner,addr1,addr2,addr3,addr4,addr5,addr6,addr7,factoryObject,contractObject}= await loadFixture(deployTokenFixture);
//         // console.log("regestering the sellers :");
//         // //calling the contract external functions using the contract object in javascript
//         await contractObject.resgisterSeller(addr1.address);
//         await contractObject.resgisterSeller(addr2.address);
//         await contractObject.resgisterSeller(addr3.address);
//         //console.log("owner balance after 3 transactions :",await owner.getBalance());
//         // we can access the public state variables using the getter funtions of it
        
//         //printing array of sellers
//         console.log("Registered sellers :");
//         const arr = await contractObject.arrayOfSellers();
//         arr.forEach(item => console.log(item));
//         console.log();
//         console.log("Number of registered sellers :",await contractObject.noOfSellers());

//         // the registered addresses are addr1,addr2,addr3
//         console.log();
//         console.log("Products are :");
//         console.log();
//         await contractObject.connect(addr1).add(5,["a","b","c","d","e"],[1,2,3,4,5],[112,123,234,111,123],[300,230,110,123,234]);
//         await contractObject.connect(addr2).add(5,["f","g","h","i","j"],[6,7,8,9,10],[112,123,234,111,123],[300,230,110,123,234]);
//         await contractObject.connect(addr3).add(5,["k","l","m","n","o"],[11,12,13,14,15],[112,123,234,111,123],[300,230,110,123,234]);
//         //down below line is call getDetails function by unregestered member 
//         //await contractObject.getDetails(5,[1,2,3,4,5],["a","b","c","d","e"],[112,123,234,111,123],[300,230,110,123,234]);
//         const totalProducts = await contractObject.showProducts();
//         var string="";
//         totalProducts.forEach(function(element){
//             string+=element;
//         });
//         console.log(string.split(""));
//         console.log("total no of products :",await contractObject.productsCount());
//         console.log();
//         //checking the count of nfts with sellers
//         const seller1 =await contractObject.balanceOf(addr1.address);
//         console.log("seller1 nft's count =",seller1);
//         console.log("owner of token id 1 :",await contractObject.ownerOf(1));
//         const seller2 =await contractObject.balanceOf(addr2.address);
//         console.log("seller1 nft's count =",seller1);
//         const seller3 =await  contractObject.balanceOf(addr3.address);
//         console.log("seller1 nft's count =",seller1);
//     });

//     it("adding items to things array",async function(){
//         const {owner,addr1,addr2,addr3,addr4,addr5,factoryObject,contractObject} = await loadFixture(deployTokenFixture);
//         let token = await contractObject.allProducts("b");
//         console.log("product token is :",token);
//         let token2 = await contractObject.productsPrices("c");
//         console.log("product price : ",token2);
//     });
// });