// SPDX-License-Identifier: MIT
// Project Sharing by Alpha Serpentis Developments - https://github.com/Alpha-Serpentis-Developments
// Written by Amethyst C. 

pragma solidity ^0.7.4;

import "../math/SafeMath.sol";

struct TransferRequest {
    address member; // Address of the member requesting
    address payable to; // Address of the receiving party
    address token; // If applicable
    uint256 amount; // Amount of tokens withdrawing
    address[] approved; // Current approvals
    address[] rejected; // Current rejected
    bytes32 ident; // The identifier of the TransferRequest
}

struct Member {
    address adr; // Address of the member
    bool isManager; // Is a manager of the wallet
    bool allowedToDeposit; // Is allowed to deposit
    bool allowedToWithdraw; // Is allowed to withdraw
}

contract Caring {
    
    using SafeMath for uint256;

    mapping(address => Member) private members;
    mapping(bytes32 => TransferRequest) private pendingOutbound;
    mapping(address => uint256) private userNonce;

    uint256 immutable MAX_ALLOWED_MANAGERS;

    string private identifier;
    
    bool private onlyMembersDeposit;
    uint256 private totalMembers;
    
    bool private multiSig;
    uint256 private minimumSig;
    uint256 private pendingTransfers;
    
    // Events
    
    event Deposit(address _from, uint256 amount);
    event PendingTransfer(address _from, address _to, address _token, uint256 _amount, uint256 _nonce, bytes32 _transferId);
    event TransferCancelled(address _from, bytes32 _transferId);
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
    
    constructor(address _manager, uint256 _maxManagers, string memory _contractName, bool _onlyMembersDeposit, bool _multiSig) {
        require(_manager != address(0), "Caring: Must have a manager!");
        require(_maxManagers > 0 && _maxManagers < (2**256) - 1, "Caring: Must have at least one manager (this includes yourself)!");
        require(bytes(_contractName).length != 0, "Caring: Must have a contract identifier!");
        
        MAX_ALLOWED_MANAGERS = _maxManagers;
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
    
    receive() payable external onlyMember() { // This does not reject mined Ether or from a selfdestruct
        emit Deposit(msg.sender, msg.value);
    }
    
    // INTERNAL FUNCTIONS
    function verifyMultiSig(TransferRequest memory _tx) internal {
        if(_tx.approved.length >= minimumSig) {// If passes definitely, execute transfer
            executeSomeTx(_tx);
        } else if(totalMembers.sub(_tx.rejected.length) < minimumSig) { // If fails definitely, cancel the transfer
            removePendingTx(_tx.ident);

            emit TransferCancelled(pendingOutbound[_tx.ident].member, _tx.ident);
        }
    }
    function addPendingTx(TransferRequest memory _tx) internal {
        pendingOutbound[_tx.ident] = _tx;
    }
    function removePendingTx(bytes32 _ident) internal {
        delete pendingOutbound[_ident];
    }
    function executeSomeTx(TransferRequest memory _tx) internal {
        if(_tx.token == address(0))
            executeEtherTx(_tx.ident);
        else
            executeTokenTx(_tx.ident);
    }
    function executeEtherTx(bytes32 _ident) internal {
        require(pendingOutbound[_ident].amount <= address(this).balance, "Caring (executeEtherTx): Cannot withdraw more than there actually is!");
        pendingOutbound[_ident].to.transfer(pendingOutbound[_ident].amount);

        emit TransferExecute(pendingOutbound[_ident].member, pendingOutbound[_ident].to, address(0), true);
        removePendingTx(_ident);
    }
    function executeTokenTx(bytes32 _ident) internal {

    }
    
    // TRANSFER FUNCTIONS
    
    function requestTransfer(address payable _to, address _token, uint256 _amount) public onlyMember returns(bytes32) {
        if(_token == address(0))
            require(address(this).balance > _amount, "Caring: Insufficient funds to withdraw!");
        
        bytes32 transferId = keccak256(abi.encode(
            msg.sender, 
            _to, 
            _token, 
            _amount,
            userNonce[msg.sender]++
            ));
        TransferRequest memory transferReq;
        
        transferReq.member = msg.sender;
        transferReq.to = _to;
        transferReq.token = _token;
        transferReq.amount = _amount;
        
        addPendingTx(transferReq);
        emit PendingTransfer(msg.sender, _to, _token, _amount, userNonce[msg.sender] - 1, transferId);
        
        return transferId;
    }
    function approveTransfer(bytes32 _index, bool _approve) public onlyMember {
        TransferRequest storage transferReq;
        transferReq = pendingOutbound[_index];
        
        // Approve or deny the transaction
        if(_approve) {
            transferReq.approved.push(msg.sender);
        } else {
            transferReq.rejected.push(msg.sender);
        }
        // Check if able to execute or has failed the 51%+ requirement
        if(multiSig)
            verifyMultiSig(transferReq);

    }
    function attemptTransfer(bytes32 _index) public onlyMember {
        verifyMultiSig(pendingOutbound[_index]);
    }
    function manualCancelTransfer(bytes32 _index) public onlyMember {
        require(pendingOutbound[_index].member == msg.sender, "Caring (manualCancelTransfer): Must be the member initiating the transfer request to cancel!");
        removePendingTx(_index);
        emit TransferCancelled(pendingOutbound[_index].member, _index);
    }
    
    // MEMBER MANAGEMENT FUNCTIONS
    
    function addMember(address _member, bool _allowDeposit, bool _allowWithdrawal) public onlyManager {
        members[_member].adr = _member;
        members[_member].allowedToDeposit = _allowDeposit;
        members[_member].allowedToWithdraw = _allowWithdrawal;
        
        totalMembers++;
    }
    function removeMember(address _member) public onlyManager {
        delete members[_member];
        
        totalMembers--;
    }
    function addManager(address _newManager) public onlyManager {
        // require(MAX_ALLOWED_MANAGERS);
        if(members[_newManager].adr == address(0)) {
            addMember(_newManager, true, true);
        }
        
        members[_newManager].isManager = true;
    }
    function removeManager(address _manager) public onlyManager {
        require(msg.sender != _manager, "Caring: Cannot remove manager from yourself!");
        
        members[_manager].isManager = false;
    }
    
    // SIMPLE SETTER FUNCTIONS
    
    function setMemberAllowedToDeposit(address _member, bool _allowed) public onlyManager {
        members[_member].allowedToDeposit = _allowed;
    }
    function setMemberAllowedToWithdraw(address _member, bool _allowed) public onlyManager {
        members[_member].allowedToWithdraw = _allowed;
    }
    function setOnlyMemberDeposit(bool _allow) public onlyManager {
        onlyMembersDeposit = _allow;
    }
    function setMultiSig(bool _enable) public onlyManager {
        multiSig = _enable;
    }
    function setMinimumMultiSig(uint256 _amount, bool _useSuggested) public onlyManager {
        require(_amount <= totalMembers && _amount > 0, "Caring: Invalid minimum multi-signature");

        if(_useSuggested)
            minimumSig = suggestedSigners(totalMembers);
        else
            minimumSig = _amount; // This does NOT check if it passes a 50%...
    }

    // MISC FUNCTIONS

    function suggestedSigners(uint256 _count) public pure returns(uint256) {
        require(_count > 0 && _count < (2**256) - 1, "Caring (suggestedSigners): Invalid '_count' value!");

        
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
