// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClassLeaderElection {
    struct Candidate {
        uint256 voteCount;
        bool exists;
    }

    mapping(address => Candidate) public candidates;
    address[] public candidateAddresses;
    bool public electionEnded;
    address public classLeader;

    event Vote(address indexed candidate, address indexed voter);

    constructor(address[] memory _candidates) {
        require(_candidates.length > 0, "At least one candidate required");

        for (uint256 i = 0; i < _candidates.length; i++) {
            candidates[_candidates[i]].exists = true;
            candidateAddresses.push(_candidates[i]);
        }
    }

    function vote(address candidate) external {
        require(!electionEnded, "Election has ended");
        require(candidates[candidate].exists, "Invalid candidate");

        candidates[candidate].voteCount++;
        emit Vote(candidate, msg.sender);
    }

    function endElection() external {
        require(!electionEnded, "Election has already ended");
        electionEnded = true;

        uint256 maxVotes = 0;
        address winningCandidate;

        for (uint256 i = 0; i < candidateAddresses.length; i++) {
            address candidate = candidateAddresses[i];
            uint256 votes = candidates[candidate].voteCount;

            if (votes > maxVotes) {
                maxVotes = votes;
                winningCandidate = candidate;
            }
        }

        classLeader = winningCandidate;
    }
}
