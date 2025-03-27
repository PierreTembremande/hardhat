pragma solidity 0.8.29;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }

    struct Proposal {
        uint256 propsalId;
        string description;
        uint256 voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotesTallied
    }

    uint256 incrementId;
    uint256 winningProposalId;
    Voter[] private votersList;
    Proposal[] private proposalsList;
    WorkflowStatus sessionStatus;

    constructor() Ownable(msg.sender) {}

    mapping(address => bool) private whitelists;
    mapping(address => bool) private voters;

    event ProposalRegistered(uint256 proposalId);
    event Voted(address voter, uint256 proposalId);
    event VoterRegistered(address voterAddress);
    event Whitelisted(address _address);
    event WorkflowStatusChange(
        WorkflowStatus previousStatus,
        WorkflowStatus newStatus
    );

    function whitelist(address[] memory _addresses) public onlyOwner {
        sessionStatus = WorkflowStatus.RegisteringVoters;
        for (uint256 i = 0; i < _addresses.length; i++) {
            address _address = _addresses[i];
            require(!whitelists[_address], "L'adresse est deja whiteliste");
            whitelists[_address] = true;
            emit Whitelisted(_address);
        }
    }

    function regiseteringVoter() public {
        require(
            sessionStatus == WorkflowStatus.RegisteringVoters,
            "Cette etape n'est pas disponible"
        );
        require(whitelists[msg.sender], "Vous n etes pas whitelist");
        require(!voters[msg.sender], "Vous etes deja enregistre");
        emit VoterRegistered(msg.sender);
        voters[msg.sender] = true;
        addNewVoter();
    }

    function addNewVoter() private {
        Voter memory newVoter = Voter({
            isRegistered: true,
            hasVoted: false,
            votedProposalId: 0
        });
        votersList.push(newVoter);
    }

    function addNewProposal(string memory ProposalDescription) public {
        require(
            sessionStatus == WorkflowStatus.ProposalsRegistrationStarted,
            "Cette etape n'est pas disponible"
        );
        require(voters[msg.sender], "Vous n etes pas enregistre");
        incrementId++;
        Proposal memory newProposal = Proposal({
            propsalId: incrementId,
            description: ProposalDescription,
            voteCount: 0
        });
        proposalsList.push(newProposal);
        emit ProposalRegistered(incrementId);
    }

    function getProposals() public view returns(Proposal[] memory){
        sessionStatus;
        require(
            sessionStatus == WorkflowStatus.ProposalsRegistrationEnded,
            "Cette etape n'est pas disponible"
        );
        return proposalsList;
    }

    function voteOnProposals(uint256 ProposalId) public {
        require(
            sessionStatus == WorkflowStatus.VotingSessionStarted,
            "Cette etape n'est pas disponible"
        );
        require(voters[msg.sender], "Vous n etes pas enregistre]");
        for (uint256 i = 0; i < votersList.length; i++) {
            Voter memory voter = votersList[i];
            if (voter.hasVoted == false) {
                for (uint256 j = 0; j < proposalsList.length; j++) {
                    Proposal memory proposal = proposalsList[j];
                    if (proposal.propsalId == ProposalId) {
                        voter.hasVoted = true;
                        voter.votedProposalId = ProposalId;
                        proposal.voteCount++;
                        emit Voted(msg.sender, ProposalId);
                        voters[msg.sender] = false;
                        return;
                    }
                }
            }
        }
    }

    function countVote() private{
        require(
            sessionStatus == WorkflowStatus.VotesTallied,
            "Cette etape n'est pas disponible"
        );
        uint score = 0;
        for (uint256 i = 0; i<proposalsList.length; i++) 
        {
            if(proposalsList[i].voteCount > score){
                winningProposalId = proposalsList[i].propsalId;
                score = proposalsList[i].voteCount;
            }
        }
    }
    
    function getWinningProposal() public returns (uint256) {
        require(sessionStatus == WorkflowStatus.VotesTallied, "Cette etape n'est pas disponible");
        countVote();
        return winningProposalId;
    }

    function ChangeSessionStatus() public onlyOwner {
        if (sessionStatus == WorkflowStatus.RegisteringVoters) {
            votersList.length;
            require(votersList.length > 0, "Il n y a pas de votant");
            emit WorkflowStatusChange(
                sessionStatus,
                WorkflowStatus.ProposalsRegistrationStarted
            );
            sessionStatus = WorkflowStatus.ProposalsRegistrationStarted;
        } else if ( sessionStatus == WorkflowStatus.ProposalsRegistrationStarted) {
            require (proposalsList.length > 0, "Il n y a pas de proposition");
            emit WorkflowStatusChange(
                sessionStatus,
                WorkflowStatus.ProposalsRegistrationEnded
            );
            sessionStatus = WorkflowStatus.ProposalsRegistrationEnded;
        } else if (sessionStatus == WorkflowStatus.ProposalsRegistrationEnded) {
            emit WorkflowStatusChange(
                sessionStatus,
                WorkflowStatus.VotingSessionStarted
            );
            sessionStatus = WorkflowStatus.VotingSessionStarted;
        } else {
            emit WorkflowStatusChange(
                sessionStatus,
                WorkflowStatus.VotesTallied
            );
            sessionStatus = WorkflowStatus.VotesTallied;
        }
    }
}
