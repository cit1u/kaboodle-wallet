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
    
    string identifier;
    bool onlyMembersDeposit;
    uint256 totalMembers;
    
    bool multiSig;
    uint256 minimumSig;
    
    event Deposit(address _from, uint256 amount);
    event Withdrawal(address _from, address _to, uint256 amount);
    
    modifier onlyManager() {
        if(!members[msg.sender].isManager) {
            revert("Caring: Must be the manager!");
        }
        _;
    }
    modifier onlyMember() {
        if((members[msg.sender].adr == address(0)) && onlyMembersDeposit) {
            revert("Caring: Must be a member!");
        }
        _;
    }
    
    constructor(address _manager, string memory _contractName, bool _onlyMembersDeposit, bool _multiSig) {
        require(_manager != address(0), "Caring: Must have a manager!");
        require(bytes(_contractName).length != 0, "Caring: Must have a contract identifier!");
        
        identifier = _contractName;
        onlyMembersDeposit = _onlyMembersDeposit;
        totalMembers = 1;
        
        multiSig = _multiSig;
        minimumSig = 1;
        
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
        
        totalMembers++;
    }
    function removeMember(address _member) public onlyManager() {
        delete members[_member];
    }
    function addManager(address _newManager) external onlyManager() {
        if(members[_newManager].adr == address(0)) {
            addMember(_newManager, true, true);
        }
        
        members[_newManager].isManager = true;
    }
    function removeManager(address _manager) external onlyManager() {
        require(msg.sender != _manager, "Caring: Cannot remove manager from yourself!");
        
        members[_manager].isManager = false;
    }
    
    function setMemberAllowedToDeposit(address _member, bool _allowed) external onlyManager() {
        members[_member].allowedToDeposit = _allowed;
    }
    function setMemberAllowedToWithdraw(address _member, bool _allowed) external onlyManager() {
        members[_member].allowedToWithdraw = _allowed;
    }
    function setOnlyMemberDeposit(bool _allow) external onlyManager() {
        onlyMembersDeposit = _allow;
    }
    function setMultiSig(bool _enable) external onlyManager() {
        multiSig = _enable;
    }
    function setMinimumMultiSig(uint256 _amount) external onlyManager() {
        require(_amount <= totalMembers, "Caring: Invalid minimum multi-signature");
        minimumSig = _amount;
    }
    
    function isOnlyMemberDeposits() public view returns(bool) {
        return onlyMembersDeposit;
    }
    function getTotalMembers() public view returns(uint256) {
        return totalMembers;
    }
    function isMultiSig() public view returns(bool) {
        return multiSig;
    }
    function getMinimumSig() public view returns(uint256) {
        return minimumSig;
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
