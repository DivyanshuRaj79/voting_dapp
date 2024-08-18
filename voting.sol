// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public admin;
    enum ElectionState { NOT_STARTED, ONGOING, ENDED }
    ElectionState public electionState;

    struct Candidate {
        uint id;
        string name;
        string proposal;
        uint votes;
    }

    struct Voter {
        address voterAddress;
        string name;
        bool hasVoted;
        address delegateTo;
        uint votes; 
        uint candidateVoted; // Added attribute to track the candidate voted for
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint public candidateCount;
    uint public voterCount;

    constructor() {
        admin = msg.sender;
        electionState = ElectionState.NOT_STARTED;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier electionOngoing() {
        require(electionState == ElectionState.ONGOING, "Election is not ongoing");
        _;
    }

    modifier electionNotStarted() {
        require(electionState == ElectionState.NOT_STARTED, "Election has already started");
        _;
    }

    /**********************************************************************************************************
    *
    *  Name        : addCandidate
    *  Description : This function is used by the admin to add a new candidate to the election.
    *                This function can only be called when the election has not started.
    *  Parameters  :
    *      param {string} _name : The name of the candidate.
    *      param {string} _proposal : The proposal or agenda of the candidate.
    *
    **********************************************************************************************************/
    function addCandidate(string memory _name, string memory _proposal) public onlyAdmin electionNotStarted {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, _proposal, 0);
    }

    /**********************************************************************************************************
    *
    *  Name        : addVoter
    *  Description : This function is used by the admin to add a new voter to the election.
    *                This function can only be called when the election has not started.
    *  Parameters  :
    *      param {address} _voterAddress : The address of the voter.
    *      param {string} _name : The name of the voter.
    *
    **********************************************************************************************************/
    function addVoter(address _voterAddress, string memory _name) public onlyAdmin electionNotStarted {
        require(voters[_voterAddress].voterAddress != _voterAddress, "Voter already registered");
        voterCount++;
        voters[_voterAddress] = Voter(_voterAddress, _name, false, address(0), 0, 0);
    }

    /**********************************************************************************************************
    *
    *  Name        : startElection
    *  Description : This function is used by the admin to start the election.
    *                This function can only be called when the election has not started.
    *
    **********************************************************************************************************/
    function startElection() public onlyAdmin electionNotStarted {
        electionState = ElectionState.ONGOING;
    }
  
    /**********************************************************************************************************
    *
    *  Name        : endElection
    *  Description : This function is used by the admin to end the election.
    *                This function can only be called during an ongoing election.
    *
    **********************************************************************************************************/
    function endElection() public onlyAdmin electionOngoing {
        electionState = ElectionState.ENDED;
    }

    /**********************************************************************************************************
    *
    *  Name        : displayCandidateDetails
    *  Description : This function is used to display the details of a candidate.
    *  Parameters  :
    *      param {uint} _candidateId : The ID of the candidate to retrieve details for.
    *
    **********************************************************************************************************/
    function displayCandidateDetails(uint _candidateId) public view returns (
        uint candidateId,
        string memory candidateName,
        string memory candidateProposal) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.proposal);
    }

    /**********************************************************************************************************
    *
    *  Name        : delegateVotingRight
    *  Description : This function allows a registered voter to delegate their voting right to another 
    *                registered voter.
    *                This function can only be called during an ongoing election, and the caller must not 
    *                have voted yet. 
    *                Delegation of voting increases the number of votes of the delegated voter by 1.
    *  Parameters  :
    *      param {address} _delegateTo  : The address of the voter to delegate the voting right to.
    *      param {address} voterAddress : The address of the voter delegating the voting right.
    *
    **********************************************************************************************************/
    function delegateVotingRight(address _delegateTo, address voterAddress) public electionOngoing {
        require(voters[_delegateTo].voterAddress != voterAddress, "Delegate address can not be voter address");
        require(voters[_delegateTo].voterAddress == _delegateTo, "Delegate address is not registered");
        require(!voters[voterAddress].hasVoted, "You have already voted");
        voters[voterAddress].delegateTo = _delegateTo;
        voters[voterAddress].hasVoted = true;
        voters[_delegateTo].votes++;
    }

    /**********************************************************************************************************
    *
    *  Name        : castVote
    *  Description : This function allows a voter to cast their vote for a specific candidate.
    *                This function can only be called during an ongoing election, and the caller must not have 
    *                voted yet.
    *  Parameters  :
    *      param {uint} _candidateId : The ID of the candidate to cast the vote for.
    *      param {uint} voterAddress : The address of the voter.
    *
    **********************************************************************************************************/
    function castVote(uint _candidateId, address voterAddress) public electionOngoing {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        require(!voters[voterAddress].hasVoted, "Voter has already voted or has delegated voting!");
        voters[voterAddress].hasVoted = true;
        uint totalVotes = 1 + voters[voterAddress].votes;
        voters[voterAddress].candidateVoted = candidates[_candidateId].id;
        voters[voterAddress].votes = totalVotes;
        candidates[_candidateId].votes += totalVotes;
    }

    /**********************************************************************************************************
    *
    *  Name        : viewVoterProfile
    *  Description : This function is used to view the profile of a voter.
    *  Parameters  :
    *      param {address} _voterAddress : The address of the voter to retrieve the profile for.
    *
    **********************************************************************************************************/
    function viewVoterProfile(address _voterAddress) public view returns (
        string memory voterName, 
        address delegateTo, 
        bool hasVoted, 
        uint candidateVoted ) {
        Voter memory voter = voters[_voterAddress];
        return (voter.name, voter.delegateTo, voter.hasVoted, voter.candidateVoted);
    }

    /**********************************************************************************************************
    *
    *  Name        : checkState
    *  Description : This function is used check the voting process status.
    *
    **********************************************************************************************************/
    function checkState() public view returns (string memory) {
    if (electionState == ElectionState.NOT_STARTED) {
        return "Election not started";
        } 
    else if (electionState == ElectionState.ONGOING) {
        return "Election is ongoing";
        } 
    else {
        return "Election has ended";
        }
    }

    /**********************************************************************************************************
    *
    *  Name        : showElectionResults
    *  Description : This function is used to display the results for a specific candidate in the election.
    *  Parameters  :
    *      param {uint} _candidateId : The ID of the candidate to retrieve results for.
    *
    **********************************************************************************************************/
    function showElectionResults(uint _candidateId) public view returns (
        uint candidateId, 
        string memory candidateName, 
        uint votesReceived) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.votes);
    }
    
    /**********************************************************************************************************
    *
    *  Name        : showElectionWinner
    *  Description : This function is used to determine and display the winner of the election.
    *                This function can only be called after the election has ended.
    *
    **********************************************************************************************************/
    function showElectionWinner() public view returns (
        string memory winnerCandidateName, 
        uint winnerCandidateId, 
        uint winnerVotes) {
        require(electionState == ElectionState.ENDED, "Election is not ended");
        Candidate memory winner = candidates[1];
        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].votes > winner.votes) {
                winner = candidates[i];
            }
        }
        return (winner.name, winner.id, winner.votes);
    }

}