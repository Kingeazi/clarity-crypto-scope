# CryptoScope

A blockchain tool for monitoring on-chain activity built on Stacks.

## Features
- Track transactions for specific addresses
- Monitor smart contract events and state changes 
- Set up customizable alerts for specific events
- Get historical activity data with detailed descriptions
- Log activities with optional descriptive information

## Usage
The contract provides the following main functions:
- `register-monitor`: Register an address/contract to be monitored
- `add-alert`: Add alert criteria for monitored addresses
- `log-activity`: Log on-chain activity with optional description
- `get-activity`: Get historical activity for an address
- `get-alerts`: Get triggered alerts

### Activity Logging
The new activity logging system includes:
- Transaction type
- Amount
- Counter-party address (optional)
- Description field for additional context (optional)

## Development
1. Install clarinet
2. Run tests: `clarinet test`
3. Deploy contract: `clarinet deploy`
