// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract REM {
    struct Doenca {
        string nomeComum;
        string causa;
        string remedioUsado;
        string dataDeInicio; //digite dd/mm/aaaa
        string dataDeFim; //digite dd/mm/aaaa
    }

    mapping(address => Doenca[]) public doencas;
    mapping(address => mapping(address => bool)) public allowedReaders;

    // Construtor do contrato
    constructor() public {
        // O deployer é automaticamente o paciente e tem permissão para ler seus próprios dados
        allowedReaders[msg.sender][msg.sender] = true;
    }

    function adicionarDoenca(string memory _nomeComum, string memory _causa, string memory _remedioUsado, string memory _dataDeInicio, string memory _dataDeFim) public {
        require(allowedReaders[msg.sender][msg.sender], "Acesso negado");
        doencas[msg.sender].push(Doenca(_nomeComum, _causa, _remedioUsado, _dataDeInicio, _dataDeFim));
    }

    // Função para consultar o histórico médico (somente o paciente ou contratos autorizados)
    function consultarHistoricoMedico() public view returns (Doenca[] memory) {
        require(allowedReaders[msg.sender][msg.sender], "Acesso negado");
        return doencas[msg.sender];
    }

    // Função para permitir que outros contratos leiam o histórico médico
    function autorizarLeitura(address reader) public {
        require(allowedReaders[msg.sender][msg.sender], "Acesso negado");
        allowedReaders[msg.sender][reader] = true;
    }

    // Função para revogar a permissão de leitura de outro contrato
    function revogarLeitura(address reader) public {
        require(allowedReaders[msg.sender][msg.sender], "Acesso negado");
        allowedReaders[msg.sender][reader] = false;
    }
}