// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Whitelist
 * @dev Highly gas-efficient access control using Merkle Proofs.
 */
contract Whitelist {
    bytes32 public merkleRoot;
    mapping(address => bool) public hasClaimed;

    event Claimed(address indexed account);
    event RootUpdated(bytes32 newRoot);

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(bytes32 _merkleRoot) {
        merkleRoot = _merkleRoot;
        owner = msg.sender;
    }

    /**
     * @dev Updates the merkle root to refresh the whitelist.
     */
    function updateRoot(bytes32 _newRoot) external onlyOwner {
        merkleRoot = _newRoot;
        emit RootUpdated(_newRoot);
    }

    /**
     * @dev Verifies a user's address against the Merkle Root.
     */
    function checkWhitelist(bytes32[] calldata _proof, address _claimer) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(_claimer));
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < _proof.length; i++) {
            bytes32 proofElement = _proof[i];

            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        return computedHash == merkleRoot;
    }

    /**
     * @dev Allows whitelisted users to perform an action (e.g., mint or claim).
     */
    function claim(bytes32[] calldata _proof) external {
        require(!hasClaimed[msg.sender], "Already claimed");
        require(checkWhitelist(_proof, msg.sender), "Invalid Merkle Proof: Not on whitelist");

        hasClaimed[msg.sender] = true;
        emit Claimed(msg.sender);
    }
}
