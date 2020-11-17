// SPDX-License-Identifier: MIT
// Project Sharing by Alpha Serpentis Developments - https://github.com/Alpha-Serpentis-Developments
// Written by Amethyst C. 

pragma solidity =0.7.4;

struct TransferRequest {
    address member; // Address of the member requesting
    address token; // If applicable
    address payable to;
    uint256 amount; // Amount of tokens withdrawing
    address[] approved; // Current approvals
    address[] rejected; // Current rejected
}

struct Member {
    address adr; // Address of the member
    bool isManager; // Is a manager of the wallet
    bool allowedToDeposit; // Is allowed to deposit
    bool allowedToWithdraw; // Is allowed to withdraw
}

contract Caring {
    
    mapping(address => Member) private members;
    TransferRequest[] private pendingOutbound;
    
    string identifier;
    
    bool onlyMembersDeposit;
    uint256 totalMembers;
    
    bool multiSig;
    uint256 minimumSig;
    uint256 pendingTransfers;
    
    event Deposit(address _from, uint256 amount);
    event PendingTransfer(address _from, address _to, address _token, uint256 _amount);
    event TransferExecute(address _from, address _to, address _token, bool _success);
    event Withdrawal(address _from, address _to, uint256 _amount);
    
    modifier onlyManager {
        if(!members[msg.sender].isManager) {
            revert("Caring: Must be the manager!");
        }
        _;
    }
    modifier onlyMember {
        if((members[msg.sender].adr == address(0)) && onlyMembersDeposit) {
            revert("Caring: Must be a member!");
        }
        _;
    }
    modifier needMultiSig() {
        if(multiSig) {
            // Check if it passes multi-sig
            
            
            
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
    
    // INTERNAL FUNCTIONS
    
    function removePendingTx(uint256 _index) internal {
        
    }
    
    // TRANSFER FUNCTIONS
    
    function requestTransfer(address _to, address _token, uint256 _amount) external onlyMember {
        
    }
    function approveTransfer(uint256 _index, bool _approve) external onlyMember {
        
    }
    function attemptTransfer(uint256 _index) external onlyMember needMultiSig {
        
        if(pendingOutbound[_index].token == address(0)) {
            require(pendingOutbound[_index].amount <= address(this).balance, "Caring: Insufficient Ether balance!");
            
            pendingOutbound[_index].to.transfer(pendingOutbound[_index].amount);
        } else {
            
        }
        
    }
    function cancelTransfer(uint256 _index) external onlyMember {
        
    }
    
    // MEMBER MANAGEMENT FUNCTIONS
    
    function addMember(address _member, bool _allowDeposit, bool _allowWithdrawal) public onlyManager {
        members[_member].adr = _member;
        members[_member].allowedToDeposit = _allowDeposit;
        members[_member].allowedToWithdraw = _allowWithdrawal;
        
        totalMembers++;
    }
    function removeMember(address _member) public onlyManager {
        totalMembers--;
        delete members[_member];
    }
    function addManager(address _newManager) external onlyManager {
        if(members[_newManager].adr == address(0)) {
            addMember(_newManager, true, true);
        }
        
        members[_newManager].isManager = true;
    }
    function removeManager(address _manager) external onlyManager {
        require(msg.sender != _manager, "Caring: Cannot remove manager from yourself!");
        
        members[_manager].isManager = false;
    }
    
    // SIMPLE SETTER FUNCTIONS
    
    function setMemberAllowedToDeposit(address _member, bool _allowed) external onlyManager {
        members[_member].allowedToDeposit = _allowed;
    }
    function setMemberAllowedToWithdraw(address _member, bool _allowed) external onlyManager {
        members[_member].allowedToWithdraw = _allowed;
    }
    function setOnlyMemberDeposit(bool _allow) external onlyManager {
        onlyMembersDeposit = _allow;
    }
    function setMultiSig(bool _enable) external onlyManager {
        multiSig = _enable;
    }
    function setMinimumMultiSig(uint256 _amount) external onlyManager {
        require(_amount <= totalMembers, "Caring: Invalid minimum multi-signature");
        minimumSig = _amount;
    }
    
    // VIEW FUNCTIONS
    
    function getIdentifier() public view returns(string memory) {
        return identifier;
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
    function getPendingTransferCount() public view returns(uint256) {
        return pendingTransfers;
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
