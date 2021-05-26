pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol"; 
import "openzeppelin-solidity/contracts/math/Math.sol"; 

/**
* @title LicenseToken 
* @author Alberto Cuesta Canada 
* @notice Implements an ERC721 license token with validity by top up.
 */
 contract LicenseToken is ERC721, Ownable {

     event TopUp(uint256 licenseId, uint256 expire); 

     /**
     * @notice mappint from token id to expire date (in unix time)
     */
     mapping(uint256 => uint256) internal expire; 

     /**
     * @notice Delay the expiration of a license by a sencond per wei. 
     * @param _licenseId The license id.
      */
      function topUp(uint256 _licenseId)
        external
        payable
    {
        uint256 timeToAdd = msg.value; 
        expire[_licenseId] = Math.max(now, expire[_licenseId]) + timeToAdd; 
        emit TopUp(_licenseId, expire[_licenseId]); 
    }

    /**
    * @notice Mint new licenses, only owner. 
    * @param _to The address to receive the license 
    * @param _licenseId The unique license id.  
     */
     function mint(address _to, uint256 _licenseId)
        public 
        onlyOwner
    {
        _mint(_to, _licenseId); 
    }

    /**
    * @notice Retrieve an expire date for a license. 
    * @param _licenseId The license id. 
     */
     function getExpire(uint256 _licenseId)
        public 
        view
        returns (uint256)
    {
        return expire[_licenseId]
    }
 }

 /**
 
    CASOS DE TESTE 
    ===============

    - contrato deploy corretamente 
    - topUp reverte se a licença nao existe 
  */