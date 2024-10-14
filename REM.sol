// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@5.0.2/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RelatorioMedico is ERC1155 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct MedicalRecord {
        string nomeDoenca;
        string causa;
        string remedioUsado;
        string dataInicioTratamento;
        string dataFimTratamento;
    }

    mapping(uint256 => address) public tokenOwner;
    mapping(uint256 => bytes) public encryptedData;

    constructor() ERC1155("RelatorioMedico", "REME") {}    

    function createNFT(string memory _nomeDoenca, string memory _causa, string memory _remedioUsado, string memory _dataInicioTratamento, string memory _dataFimTratamento, bytes memory _encryptedData) public {
        uint256 newItemId = Counters.Counter(_tokenIds).current();
        tokenOwner[newItemId] = msg.sender;
        encryptedData[newItemId] = _encryptedData;
    }

    function getEncryptedData(uint256 tokenId) public view returns (bytes memory) {
        require( balanceOf(msg.sender,tokenId)>0,"Token does not exist");
        return encryptedData[tokenId];
    }

    function exists(address owner, uint256 id ) internal override(ERC1155){
        mappingStorageSlot = ERC1155.storage.slotIndex;
    }
}