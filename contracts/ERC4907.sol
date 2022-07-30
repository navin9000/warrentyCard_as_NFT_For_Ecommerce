//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

import "./IERC4907.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//IERC4907 is like extension to the ERC721
//mainly three functions required
//1.setUser() , userOf()  and userExpries() 

contract ERC4907 is ERC721,IERC4907{
    struct userInfo{
        address userAddress;
        uint expires;
    }
    mapping(uint => userInfo) rentUsers;

    constructor()ERC721("naveen","pc"){

    }
    function setUser(uint256 _tokenId, address _user, uint64 _expires) public virtual override{
        userInfo storage info =  rentUsers[_tokenId];
        info.userAddress = _user;
        info.expires = _expires+block.timestamp;
       // emit UpdateUser(_tokenId, _user, _expires);
    }
    
    function userOf(uint256 _tokenId) public view virtual override returns(address ){
        if( block.timestamp <= rentUsers[_tokenId].expires){
            return  rentUsers[_tokenId].userAddress;
        }
        else{
            return address(0);
        }
    }

    function userExpires(uint256 _tokenId) public view virtual override returns(uint256){
        return rentUsers[_tokenId].expires;
    }


}