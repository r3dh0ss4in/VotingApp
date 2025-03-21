// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Voting {
    /* Types */

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 voteIndex;
    }

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    /* State Variables */

    address public admin;
    bool public votingEnded;
    Candidate[] public candidates;
    mapping(address => Voter) public voters;
    address[] public votersAddresses;

    /* Modifiers */

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin call this function!");
        _;
    }

    modifier votingActive() {
        require(!votingEnded, "Voting has ended");
        _;
    }

    /* Functions */

    constructor(string[] memory _candidateNames) {
        admin = msg.sender;
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({name: _candidateNames[i], voteCount: 0}));
        }
    }

    function addCandidate(string memory _name) public onlyAdmin {
        candidates.push(Candidate({name: _name, voteCount: 0}));
    }

    function registerVoter(address _voterAddress) public onlyAdmin {
        require(!voters[_voterAddress].isRegistered, "Voter is already registered");
        voters[_voterAddress] = Voter({isRegistered: true, hasVoted: false, voteIndex: 0});
        votersAddresses.push(_voterAddress);
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function getTotalCandidates() public view returns (uint256) {
        return candidates.length;
    }

    function getVoters() public view returns (address[] memory) {
        return votersAddresses;
    }

    function getTotalVoters() public view returns (uint256) {
        return votersAddresses.length;
    }

    function vote(uint256 _candidateIndex) public votingActive {
        require(voters[msg.sender].isRegistered, "Voter is not registered");
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate index");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].voteIndex = _candidateIndex;
        candidates[_candidateIndex].voteCount++;
    }

    function endVoting() public onlyAdmin {
        require(!votingEnded, "Voting has already ended");
        votingEnded = true;
    }

    function pickWinner() public view onlyAdmin returns (string memory) {
        require(votingEnded, "Voting has not ended yet!");

        uint256 winningVoteCount = 0;
        uint256 winningCandidateIndex = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateIndex = i;
            }
        }

        return candidates[winningCandidateIndex].name;
    }
}
