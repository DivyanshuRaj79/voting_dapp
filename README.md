# voting_dapp
Purpose: The "VotingSystem" Smart Contract is designed to manage an election system on the
Ethereum blockchain. It ensures a secure and transparent election process, allowing voters to
cast their votes for candidates. The contract maintains the state of the election, registers
candidates and voters, and tracks votes.

Technology Used: The Smart Contract is developed using Solidity, a programming language
for writing Ethereum Smart Contracts. It can be deployed and executed on the Ethereum
blockchain using technologies such as Remix and Ganache.

Functions:
addCandidate: This function enables the admin to add new candidates to the election. It can
only be called before the election starts and is crucial for initializing the list of candidates.

addVoter: The admin uses this function to add new voters to the election. It is essential to
ensure that only eligible voters can participate, and it must be called before the election starts.

startElection: The admin can initiate the election using this function, setting the state to
"ONGOING." It marks the beginning of the voting process.

endElection: This function allows the admin to conclude the election when the voting process is
over, setting the state to "ENDED."

displayCandidateDetails: Voters and other participants can access this function to view the
details of a specific candidate, including their name and election proposal.

delegateVotingRight: Registered voters can delegate their voting rights to other registered
voters during an ongoing election. When a registered voter delegates his voting right to the
other registered voter, both of whom must not yet voted at the time of such delegation, then the
number of votes to be casted by the delegated voter increases by 1 over his own single vote,
This function helps maintain fairness and transparency in the election.

castVote: Voters use this function to cast their votes for their preferred candidates during an
ongoing election. The function tracks the votes and the candidate selected by the voter.
viewVoterProfile: This function allows participants to view the profile of a voter. It provides
information about the voter's name, whether the voter has cast a vote, and the candidate they
voted for (if any).

checkState: A public function to check the current state of the election, providing information
about whether the election is ongoing, ended, or has not yet started.

showElectionResults: This function displays the results for a specific candidate, showing their
ID, name, and the number of votes they received.

showElectionWinner: After the election has ended, this function determines and displays the
winning candidate's name, ID, and the total number of votes they received.

Each function in the Smart Contract serves a specific role in the election process. Together, they
facilitate the management of candidates, voters, and the election itself. Key functions include
adding candidates and voters, starting and ending the election, casting votes, and viewing
results, ensuring the integrity and transparency of the election.

The "VotingSystem" Smart Contract is a vital tool for conducting fair and secure elections on the
Ethereum blockchain, addressing challenges related to eligibility, reusability, privacy, fairness,
soundness, and completeness. It leverages blockchain technology to provide a reliable and
tamper-resistant election system.
