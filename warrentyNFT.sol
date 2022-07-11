//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

// contract for creating warrenty nft's for a product
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract WarrentyNFT is ERC721{
    address public immutable owner;             // the deployer of the contract
    mapping(address => bool) registeredSellers; // regestered sellers list
    mapping(address => string) buyersHistory;   //buyers history
    mapping(string => uint) allProducts;        // all products history 
    string[] public allProductsNames;                  // all products names
    uint public productsCount=0;                      //number of products count
    uint public noOfSellers=0;                  // noOfSellers

    //structure to get the details of the seller
    struct seller{
        uint noOfProducts;
        mapping(string => uint) sellerProduct;   // product id and nameid
    }
    mapping(address => seller) allSellers;       // object of seller

    //constructor for ERC contract intialization
    constructor()ERC721("warrenty","WT"){
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

    //regestering the sellers and only the owner can call 
    function resgisterSeller(address _sellerAddress)external onlyOwner{
        registeredSellers[_sellerAddress]=true;
        noOfSellers++;
    }

    //unregestering the seller and only owner can call
    function unRegesterSeller(address _sellerAddress)external onlyOwner{
        registeredSellers[_sellerAddress]=false;
    }

    //to get the details of seller and products
    function getDetails(uint _noOfProducts,uint[] memory id,string[] memory _products)external onlyRegesteredSellers{
        allSellers[msg.sender].noOfProducts=_noOfProducts;
        for(uint i=0;i<_noOfProducts;i++){
            allSellers[msg.sender].sellerProduct[_products[i]]=id[i];  //each seller products
            allProducts[_products[i]]=id[i];
            allProductsNames.push(_products[i]);
            productsCount++;
        }
    }
    //show products on front 
    function products()external view returns(string[] memory){
        return allProductsNames;
    }
    
    //minting the warrenty card
    function warrentyCard(string memory productNameId)external{
        _mint(msg.sender,allSellers[msg.sender].sellerProduct[productNameId]);
    }

     //buy the product 
    function buy(string memory _product)external{
        _mint(msg.sender,allProducts[_product]);
    }

    //sell has to disable the warrenty completion time
    function disableWarrenty()

}