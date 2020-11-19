// SPDX-License-Identifier: MIT
// Project Sharing by Alpha Serpentis Developments - https://github.com/Alpha-Serpentis-Developments
// Written by Amethyst C.

pragma solidity =0.7.4;

import "./Caring.sol";

contract CaringDeployer {

    address private CaringImplementation;
    address payable creator;

    uint256 private creatorFee; // Aka the deploying fee, in wei units
    bool private sendDirect;

    modifier onlyCreator {
        if(msg.sender != creator) {
            revert("CaringDeployer: Not the creator!");
        }
        _;
    }
    modifier meetCreatorFee {
        if(msg.value < creatorFee) {
            revert("CaringDeployer: Does not meet the creator fee (service fee)! Call getCreatorFee to check minimum required in Ether.");
        }
        _;
    }

    event CaringIssued(address _caller, address _deployed);

    constructor(address _caringImplementation, uint256 _creatorFee) {
        require(_caringImplementation != address(0), "CaringDeployer: Address is a zero address!");

        CaringImplementation = _caringImplementation;
        creator = msg.sender;
        creatorFee = _creatorFee;
    }

    function deployCaringContract(address _manager, string memory _contractName, bool _onlyMembersDeposit, bool _multiSig) external payable meetCreatorFee returns(address) {

        address deployed = address(new Caring(_manager, _contractName, _onlyMembersDeposit, _multiSig));
        require(deployed != address(0), "CaringDeployer: Contract creation failed!");
        emit CaringIssued(msg.sender, deployed);

        if(sendDirect)
            creator.transfer(msg.value);

        return deployed;
    }
    function redeemFee() public onlyCreator {
        creator.transfer(address(this).balance);
    }

    function setCaringImplementation(address _caringImplementation) external onlyCreator {
        require(_caringImplementation != address(0), "CaringDeployer: Address is a zero address!");

        CaringImplementation = _caringImplementation;
    }
    function setCreatorFee(uint256 _fee) external onlyCreator {
        creatorFee = _fee;
    }

    function getCaringImplementation() public view returns(address) {
        return CaringImplementation;
    }
    function getCreatorFee() public view returns(uint256) {
        return creatorFee;
    }

}
