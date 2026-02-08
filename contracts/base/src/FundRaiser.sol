// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FundRaiser
 * @notice Crowdfunding with milestone-based releases
 */
contract FundRaiser {
    error CampaignNotFound();
    error GoalNotReached();
    error MilestoneNotReached();

    event CampaignCreated(uint256 indexed campaignId, address indexed creator, uint256 goal);
    event Contributed(uint256 indexed campaignId, address indexed contributor, uint256 amount);
    event MilestoneReleased(uint256 indexed campaignId, uint256 milestone, uint256 amount);

    struct Campaign {
        address creator;
        uint256 goal;
        uint256 raised;
        uint256 milestones;
        uint256 released;
        bool active;
    }

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public contributions;
    uint256 public campaignCounter;

    function create(uint256 goal, uint256 milestones) external returns (uint256) {
        uint256 id = campaignCounter++;
        campaigns[id] = Campaign({
            creator: msg.sender,
            goal: goal,
            raised: 0,
            milestones: milestones,
            released: 0,
            active: true
        });
        emit CampaignCreated(id, msg.sender, goal);
        return id;
    }

    function contribute(uint256 campaignId) external payable {
        Campaign storage c = campaigns[campaignId];
        if (!c.active) revert CampaignNotFound();
        c.raised += msg.value;
        contributions[campaignId][msg.sender] += msg.value;
        emit Contributed(campaignId, msg.sender, msg.value);
    }

    function releaseMilestone(uint256 campaignId) external {
        Campaign storage c = campaigns[campaignId];
        require(msg.sender == c.creator);
        if (c.raised < c.goal) revert GoalNotReached();
        if (c.released >= c.milestones) revert MilestoneNotReached();
        
        uint256 amount = c.goal / c.milestones;
        c.released++;
        payable(c.creator).transfer(amount);
        emit MilestoneReleased(campaignId, c.released, amount);
    }

    function getCampaign(uint256 campaignId) external view returns (address, uint256, uint256, uint256, uint256, bool) {
        Campaign memory c = campaigns[campaignId];
        return (c.creator, c.goal, c.raised, c.milestones, c.released, c.active);
    }

    function getContribution(uint256 campaignId, address contributor) external view returns (uint256) {
        return contributions[campaignId][contributor];
    }
}
