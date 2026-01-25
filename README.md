# FundRaiser

Crowdfunding platform with milestone-based releases on Base and Stacks blockchains.

## Features

- Create fundraising campaigns with goals
- Milestone-based fund release
- Track contributions per user
- Transparent fund management
- Multi-chain crowdfunding

## Smart Contract Functions

### Base (Solidity)
- `create(uint256 goal, uint256 milestones)` - Create campaign
- `contribute(uint256 campaignId)` - Contribute to campaign
- `releaseMilestone(uint256 campaignId)` - Release milestone funds
- `getCampaign(uint256 campaignId)` - Get campaign details
- `getContribution(uint256 campaignId, address contributor)` - Get contribution

### Stacks (Clarity)
- `(create-campaign (goal uint) (milestones uint))` - Create campaign
- `(contribute (campaign-id uint) (amount uint))` - Contribute
- `(get-campaign (campaign-id uint))` - Get campaign info

## Tech Stack

- **Frontend**: Next.js 14, TypeScript, Tailwind CSS
- **Base**: Solidity 0.8.20, Foundry, Reown wallet
- **Stacks**: Clarity v4, Clarinet, @stacks/connect

## Getting Started

```bash
pnpm install
pnpm dev
```

## License

MIT License
