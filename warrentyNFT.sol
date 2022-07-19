//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

// contract for creating warrenty nft's for a product
import "./ERC4907.sol";

//ecommerce contract
// which is divided into 5 parts
// 1. regestring the sellers by owner
// 2. add products to the ecommerce platform
// 3. buy the products by the user
// 4. giving warrenty NFT's for products
// 5. expirable warrenty NFT's 
//6.reselling the products

//testing in each module is required
contract WarrentyNFT is ERC4907{
    address public immutable owner;                    // the deployer of the contract
    mapping(address => bool) registeredSellers;        // regestered sellers list
    uint public noOfSellers=0;                         // noOfSellers
    mapping(string => uint) allProducts;               // all products history 
    mapping(string => uint) productsPrices;            // all products prices
    mapping(string => uint) productExpires;            // all products and its warrenty expires
    string[20] public allProductsNames;                // all products names
    uint public productsCount=0;                       //number of products count
    mapping(address => string) buyersHistory;          //buyers history
    mapping(string =>uint) warrentyNFTsHistory;        // warrentyNFT's history
    

    //structure to get the details of the seller
    struct seller{
        uint noOfProducts;
        mapping(string => uint) sellerProduct;         // product id and nameid
    }
    mapping(address => seller) allSellers;             // object of seller

    //constructor for ERC contract intialization
    constructor(){
        owner=msg.sender;
    }

    //modifiers
    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }

    //only regestered sellers
    modifier onlyRegesteredSellers{
        require(registeredSellers[msg.sender],"ur not the regesterd seller");
        _;
    }

    // 1. regestring the sellers by owner
    function resgisterSeller(address _sellerAddress)public onlyOwner{
        registeredSellers[_sellerAddress]=true;
        noOfSellers++;
    }
    //unregestering the seller and only owner can call
    function unRegesterSeller(address _sellerAddress)external onlyOwner{
        registeredSellers[_sellerAddress]=false;
        noOfSellers--;
    }



    // 2. add products to the ecommerce platform
    function getDetails(uint _noOfProducts,uint[] memory id,string[] memory _products,uint[] memory prices,uint[] memory _expires)public onlyRegesteredSellers{
        allSellers[msg.sender].noOfProducts = _noOfProducts;
        for(uint i=0;i<_noOfProducts;i++){
            allSellers[msg.sender].sellerProduct[_products[i]] = id[i];     //each seller products
            allProducts[_products[i]] = id[i];
            allProductsNames[productsCount] = _products[i];
            productsPrices[_products[i]] = prices[i];                      //products and prices history
            productExpires[_products[i]]=_expires[i];                      // products and its expires mapping
            productsCount++;
        }
        //minting the nfts to seller,giving the limited time ownership to the buyer
        for(uint i=0;i<_noOfProducts;i++){
            _mint(msg.sender,id[i]);
        }
    }
    //show products on interface
    function products()external view returns(string[20] memory){
        return allProductsNames;
    }



    // 3. buy the products by the user
    function buy(string memory _product)external payable{
        require(allProducts[_product]!=0  || productsPrices[_product]==0,"product not available/sold");
        require(!registeredSellers[msg.sender],"u are the seller");          // sellers cant buy for spaming
        require(msg.value > 0 && msg.value == productsPrices[_product],"insufficient funds");
        // _mint(msg.sender,allProducts[_product]);
        setUser(allProducts[_product],ownerOf(allProducts[_product]),uint64(productExpires[_product]));   //setting up the user for decayed warrenty nft
        buyersHistory[msg.sender] = _product;
       // warrentyNFTsHistory[_product]=allProducts[_product];
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
       // warrentyCard(_product);                                            // for warrenty nft
        productsPrices[_product] = 0;
    }
    
    // show prices
    function showPrice(string memory _product)external view returns(uint ){
        return productsPrices[_product];
    }

    
    // 4. giving warrenty NFT's for products
    function warrentyCard(string memory _product)internal{
        _mint(msg.sender,allSellers[msg.sender].sellerProduct[_product]);
    }
    

    //if buyer want to sell resell the product 
    //1.he should fist register at the owners end
    //2.then he get the complete owner ship of the warrenty NFT
    //3.and repeating the same steps in getDetails function
    function reSell(uint _noOfProducts,uint[] memory id,string[] memory _products,uint[] memory prices,uint[] memory _expires)external{
        // checking that reseller having that product
        for(uint i=0;i<_noOfProducts;i++){
             require(keccak256(abi.encode(buyersHistory[msg.sender]))==keccak256(abi.encode(_products[i])),"ur not having product");
            transferFrom(ownerOf(id[i]),msg.sender,id[i]); //giving complete ownership to the reseller
        }
        resgisterSeller(msg.sender);
        getDetails(_noOfProducts,id,_products,prices,_expires);
    }


}