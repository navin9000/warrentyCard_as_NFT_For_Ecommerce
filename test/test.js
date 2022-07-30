const { except } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { ContractType } = require("hardhat/internal/hardhat-network/stack-traces/model");

// writing the first test

describe("Testing the warrentyNFT",function(){
    async function deployTokenFixture(){
       const [owner,addr1,addr2,addr3,addr4,addr5,addr6,addr7] = await ethers.getSigners();
        const factoryObject = await ethers.getContractFactory("WarrentyNFT");
        const contractObject = await factoryObject.deploy();
        return {owner,addr1,addr2,addr3,addr4,addr5,addr6,addr7,factoryObject,contractObject};
    }
    // it("checking the users addresses and balances :",async function(){
    //     const {owner,addr1,addr2,addr3,addr4,addr5,factoryObject,contractObject}= await loadFixture(deployTokenFixture);
    //     console.log("owner address :",owner.address);
    //     console.log("owner balance :",await owner.getBalance());

    //     console.log("user1 address :",addr1.address);
    //     console.log("user1 balance :",await addr1.getBalance());

    //     console.log("user2 address :",addr2.address);
    //     console.log("user1 balance :",await addr2.getBalance());

    //     console.log("user2 address :",addr3.address);
    //     console.log("user1 balance :",await addr3.getBalance());

    //     console.log("user2 address :",addr4.address);
    //     console.log("user1 balance :",await addr4.getBalance());

    //     console.log("user2 address :",addr5.address);
    //     console.log("user1 balance :",await addr5.getBalance());

    //     console.log("contract address :",contractObject.address);
    // });

    //adding the sellers
    it("Adding sellers by the owner and adding the products by registered sellers",async function(){
        const {owner,addr1,addr2,addr3,addr4,addr5,addr6,addr7,factoryObject,contractObject}= await loadFixture(deployTokenFixture);
        // console.log("regestering the sellers :");
        // //calling the contract external functions using the contract object in javascript
        await contractObject.resgisterSeller(addr1.address);
        await contractObject.resgisterSeller(addr2.address);
        await contractObject.resgisterSeller(addr3.address);
        //console.log("owner balance after 3 transactions :",await owner.getBalance());
        // we can access the public state variables using the getter funtions of it
        
        //printing array of sellers
        console.log("Registered sellers :");
        const arr = await contractObject.arrayOfSellers();
        arr.forEach(item => console.log(item));
        console.log();
        console.log("Number of registered sellers :",await contractObject.noOfSellers());

        // the registered addresses are addr1,addr2,addr3
        console.log();
        console.log("Products are :");
        console.log();
        await contractObject.connect(addr1).addProducts(5,["a","b","c","z","e"],[1,2,3,4,5],[112,123,234,111,123],[312,323,112,123,154]);
        await contractObject.connect(addr2).addProducts(5,["f","g","h","i","j"],[6,7,8,9,10],[112,123,234,111,123],[345,376,167,36,445]);
        await contractObject.connect(addr3).addProducts(5,["k","l","m","n","o"],[11,12,13,14,15],[112,123,234,111,123],[553,653,324,233,714]);
        //down below line is call getDetails function by unregestered member 
        //await contractObject.getDetails(5,[1,2,3,4,5],["a","b","c","d","e"],[112,123,234,111,123],[300,230,110,123,234]);
        const totalProducts = await contractObject.showProducts();
        var string="";
        totalProducts.forEach(function(element){
            string+=element;
        });
        console.log(string.split(""));
        console.log("total no of products :",await contractObject.productsCount());
        console.log();
        //checking the count of nfts with sellers
        const seller1 =await contractObject.balanceOf(addr1.address);
        console.log("seller1 nft's count =",seller1);
        console.log("owner of token id 1 :",await contractObject.ownerOf(1));
        const seller2 =await contractObject.balanceOf(addr2.address);
        console.log("seller1 nft's count =",seller1);
        const seller3 =await  contractObject.balanceOf(addr3.address);
        console.log("seller1 nft's count =",seller1);
        console.log();
        console.log("product details to buy :");
        //product details to buy it 
        console.log(" product with token : ",await contractObject.allProducts("e"));
        //show price of a product
        console.log("products price : ",await contractObject.productsPrices("e"));
        //to show product expires
        console.log("product expires :",await contractObject.productExpires("e"));

        await contractObject.connect(addr4).buy("e");
        await contractObject.connect(addr5).buy("g");
        //await contractObject.connect(addr2).buy("e");   actually he is the owner so he cant buy

        const totalProducts1 = await contractObject.showProducts();
        var string1="";
        totalProducts1.forEach(function(element){
            string1+=element;
        });
        console.log(string1.split(""));


        //nft gola
        const ownerAddress = await contractObject.ownerOf(1);
        console.log("token 1 minted address  :",ownerAddress);
        await contractObject.setUser(1,addr4.address,120);
        
        //here checking the rental owner of the product nft
        console.log("product buyer NFT :",await contractObject.userOf(1));

        //testing the resell function

        console.log();
        console.log("reselling the product :");
        //console.log("reselling the products : ");
        //note : 3 transactions required to resell the product
        //1.registering at owners end
        //2.getting complete ownership form the seller
        //3.adding ur product to public
        await contractObject.resgisterSeller(addr4.address);  // regestering the seller
        await contractObject.connect(addr1).regesterAndTransfer(5);    //getting complete ownership
        console.log();
        console.log("compelete ownership of product NFT :",await contractObject.ownerOf(5));
        console.log("After new seller added , no of sellers :",await contractObject.noOfSellers());
        await contractObject.connect(addr4).reSell(5,"e",123);

        //checking the new product added or not
        console.log();
        console.log("All product : ");
        const totalProducts3 = await contractObject.showProducts();
        var string3="";
        totalProducts3.forEach(function(element){
            string3+=element;
        });
        console.log(string3.split(""));
        console.log("total no of products :",await contractObject.productsCount());
        console.log();

        
          // buyers history 
          const buyersAddresses = await contractObject.historyOfBuyers();
          console.log();
          console.log("buyers History :");
          console.log("address  :  product");
          await buyersAddresses.forEach(async function(address){
              console.log(address," : ",await contractObject.buyersHistory(address));
          }) ;
    });

});