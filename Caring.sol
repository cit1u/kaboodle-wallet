// Project Sharing by Alpha Serpentis Developments - https://github.com/Alpha-Serpentis-Developments
// Written by Amethyst C. 

pragma solidity ^0.7.4;

struct Member {
    address adr;
    bool isManager;
    bool allowedToDeposit;
    bool allowedToWithdraw;
}

contract Caring {
    
    mapping(address => Member) private members;
    
    bool onlyMembersDeposit;
    
    event Deposit(address _from, uint256 amount);
    event Withdrawal(address _from, address _to, uint256 amount);
    
    modifier onlyManager() {
        if(!members[msg.sender].isManager) {
            revert("Must be the manager!");
        }
        _;
    }
    modifier onlyMember() {
        if((members[msg.sender].adr == address(0)) && onlyMembersDeposit) {
            revert("Must be a member!");
        }
        _;
    }
    
    constructor(address _manager, bool _onlyMembersDeposit) {
        require(_manager != address(0), "Must have a manager!");
        
        onlyMembersDeposit = _onlyMembersDeposit;
        
        members[_manager].adr = _manager;
        members[_manager].isManager = true;
        members[_manager].allowedToDeposit = true;
        members[_manager].allowedToWithdraw = true;
    }
    
    receive() payable external onlyMember() {
        emit Deposit(msg.sender, msg.value);
    }
    
    function addMember(address _member, bool _allowDeposit, bool _allowWithdrawal) public onlyManager() {
        members[_member].adr = _member;
        members[_member].allowedToDeposit = _allowDeposit;
        members[_member].allowedToWithdraw = _allowWithdrawal;
    }
    function removeMember(address _member) public onlyManager() {
        delete members[_member];
    }
    function addManager(address _newManager) public onlyManager() {
        if(members[_newManager].adr == address(0)) {
            addMember(_newManager, true, true);
        }
        
        members[_newManager].isManager = true;
    }
    function removeManager(address _manager) public onlyManager() {
        require(msg.sender != _manager, "Cannot remove manager from yourself!");
        
        members[_manager].isManager = false;
    }
    
    function setMemberAllowedToWithdraw(address _member, bool _allowed) public onlyManager() {
        members[_member].allowedToWithdraw = _allowed;
    }
    function setOnlyMemberDeposit(bool _allow) public onlyManager() {
        onlyMembersDeposit = _allow;
    }
    
    function isOnlyMemberDeposits() public view returns(bool) {
        return onlyMembersDeposit;
    }
    function isMember(address _address) public view returns(bool) {
        return members[_address].adr != address(0);
    }
    function isMemberAllowedToDeposit(address _address) public view returns(bool) {
        return members[_address].allowedToDeposit;
    }
    function isMemberAllowedToWithdraw(address _address) public view returns(bool) {
        return members[_address].allowedToWithdraw;
    }
    function isManager(address _address) public view returns(bool) {
        return members[_address].isManager;
    }
    
}
