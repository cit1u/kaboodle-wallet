// Project Sharing by Alpha Serpentis Developments - https://github.com/Alpha-Serpentis-Developments
// Written by Amethyst C.

pragma solidity ^0.7.4;

contract CaringDeployer {

    address private CaringImplementation;
    address payable creator;

    uint256 private creatorFee;

    modifier onlyCreator() {
        if(msg.sender != creator) {
            revert("Not the creator!");
        }
        _;
    }
    modifier meetCreatorFee() {
        if(msg.value < creatorFee) {
            revert("CaringDeployer: Does not meet the creator fee (service fee)!");
        }
        _;
    }

    constructor(address _caringImplementation) {
        require(_caringImplementation != address(0), "CaringDeployer: Address is a zero address!");

        CaringImplementation = _caringImplementation;
        creator = msg.sender;
    }

    function deployCaringContract(address _manager, string memory _contractName, bool _onlyMembersDeposit, bool _multiSig) public {
        CaringImplementation.call(abi.encode(_manager, _contractName, _onlyMembersDeposit, _multiSig));
    }
    function redeemFee() public onlyCreator() {
        creator.transfer(address(this).balance);
    }

    function setCaringImplementation(address _caringImplementation) public onlyCreator() {
        require(_caringImplementation != address(0), "CaringDeployer: Address is a zero address!");

        CaringImplementation = _caringImplementation;
    }

    function getCaringImplementation() public view returns(address) {
        return CaringImplementation;
    }
    function getCreatorFee() public view returns(uint256) {
        return creatorFee;
    }

}
