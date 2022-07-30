//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

// contract for creating warrenty nft's for a product
import "./ERC4907.sol";

//ecommerce contract
// which is divided into 5 parts
// 1. regestring the sellers by owner
// 2. add products to the ecommerce platform
// 3. buy the products by the any user
// 4. giving expirable warrenty for NFT's products
// 5. reselling the products

//testing in each module is required
contract WarrentyNFT is ERC4907{

    //structure to get the details of the seller
    struct seller{
        uint noOfProducts;
        mapping(string => uint) sellerProduct;         // product product:token mapping
    }
    mapping(address => seller) allSellers;             //sellers address : structure mapping

    //state variables
    address public immutable owner;                    // the deployer of the contract
    mapping(address => bool) registeredSellers;        // regestered sellers list
    address[] arrOfSellers;                            // array of sellers
    uint public noOfSellers=0;                         // noOfSellers
    mapping(string => uint) public allProducts;        // all product:token mapping
    mapping(string => uint) public productsPrices;     // all products:prices mapping
    mapping(string => uint) public productExpires;     // all products:expires mapping
    string[50]  allProductsNames;                      // all products names
    uint public productsCount=0;                       // number of products count
    mapping(address => string) public buyersHistory;   // buyers history address:product
    address[] arrayOfbuyers;                           // array of buyers history
    mapping(string =>uint) warrentyNFTsHistory;        // warrentyNFT's history product:token 

    //modifiers
    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }

    //only regestered sellers
    modifier onlyRegesteredSellers{
        require(registeredSellers[msg.sender],"ur not the registerd seller");
        _;
    }

    //constructor for ERC contract intialization
    constructor(){
        owner=msg.sender;
    }

    // 1. regestring the sellers by owner
    function resgisterSeller(address _sellerAddress)public onlyOwner{
        registeredSellers[_sellerAddress]=true;
        arrOfSellers.push(_sellerAddress);
        noOfSellers++;
    }
    //unregestering the seller and only owner can call
    function unRegesterSeller(address _sellerAddress)external onlyOwner{
        registeredSellers[_sellerAddress]=false;
        noOfSellers--;
    }

    //reseller register and transfer the NFT for giving complelete ownership
    function regesterAndTransfer(uint _id)external{
        transferFrom(ownerOf(_id),msg.sender,_id); //giving complete ownership to the reseller
    }

    //regestered sellers(comment it)
    function arrayOfSellers()external view returns(address[] memory){
        return arrOfSellers;
    }

    // 2. add products to the ecommerce platform
    //,uint[] memory id,string[] memory _products,uint[] memory prices,uint[] memory _expires
    function addProducts(uint _noOfProducts,string[] memory _products,uint[] memory _tokenId,uint[] memory _prices,uint[] memory _expires)external onlyRegesteredSellers{
          allSellers[msg.sender].noOfProducts = _noOfProducts;
         for(uint i=0;i<_noOfProducts;i++){
            allSellers[msg.sender].sellerProduct[_products[i]] =_tokenId[i];     //each seller products
            allProductsNames[productsCount]=_products[i];
            allProducts[_products[i]] =_tokenId[i];
            productsPrices[_products[i]] =_prices[i];                      //products and prices history
            productExpires[_products[i]]=_expires[i];                      // products and its expires mapping
            productsCount++;
         }
        //minting the nfts to seller,giving the limited time ownership to the buyer
        for(uint i=0;i<_noOfProducts;i++){
           _mint(msg.sender,_tokenId[i]);
        }
    }

    //show products on interface
    function showProducts()external view returns(string[50] memory){
        return allProductsNames;
    }

    //check for the working of the allProducts mapping

    // 3. buy the products by the user
    function buy(string memory _product)public payable{
        require(allProducts[_product]!=0  && productsPrices[_product]!=0,"product not available/sold");
        require(!registeredSellers[msg.sender],"u are the seller");          // sellers cant buy for spaming
        //require(msg.value > 0 && msg.value == productsPrices[_product],"insufficient funds");
        setUser(allProducts[_product],ownerOf(allProducts[_product]),uint64(productExpires[_product]));   //setting up the user for decayed warrenty nft
        buyersHistory[msg.sender] = _product;
        arrayOfbuyers.push(msg.sender);                                     //array of buyers
        warrentyNFTsHistory[_product]=allProducts[_product];
        productsCount--;
        //deleting the bought product from all the products
        for(uint i=0;i<allProductsNames.length;i++){
            if(keccak256(abi.encode(allProductsNames[i])) == keccak256(abi.encode(_product))){ 
                allProductsNames[i] = allProductsNames[productsCount]; 
                delete allProductsNames[productsCount];
                delete allProducts[_product];
                break;           
            }
        }
        //warrentyCard(_product);                                            // for warrenty nft
        delete productsPrices[_product];
        //transfering the funds to registered seller
       //payable(ownerOf(allProducts[_product])).transfer(address(this).balance);
    }
    
    //buyers history
    function historyOfBuyers()external view onlyOwner returns(address[] memory){
          return arrayOfbuyers;
    }

    // show prices
    function showPrice(string memory _product)public view returns(uint ){
        return productsPrices[_product];
    }


     //if buyer want to sell resell the product and required 3 transactions
    //1.he should fist register at the owners end 
    //2.then he get the complete owner ship of the warrenty NFT
    //3.and adding his product to the public 
    function reSell(uint _id,string memory _product,uint price)public{
        require(registeredSellers[msg.sender],"ur not the registered seller");
        require(keccak256(abi.encode(buyersHistory[msg.sender])) == keccak256(abi.encode(_product)),"ur not having product");
        allProducts[_product]=_id;
        allProductsNames[productsCount] = _product;
        productsPrices[_product] = price;                      //products and prices history
        productExpires[_product]=userExpires(_id) - block.timestamp;  // remaining expires time 
        productsCount++;
    }

 }