## Overview

This smart contract implements a staking pool where users can deposit tokens, earn block-based rewards, and withdraw both their original deposit and accrued rewards. The contract ensures fair distribution of rewards based on each participant's share of the pool.

## Features

- **Deposits**: Users can deposit tokens into the pool.
- **Reward Compounding**: The pool owner can compound rewards periodically, adding new rewards based on elapsed blocks.
- **Withdrawals**: Users can withdraw their initial deposit along with their earned rewards.
- **Ownership Controls**: Only the pool owner can trigger reward compounding.
- **Secure & Transparent**: The contract prevents unauthorized actions and ensures fair reward distribution.

## Functions

- `initialize(owner)`: Initializes the contract with the designated owner.
- `deposit(amount)`: Allows users to deposit tokens into the pool.
- `compound-rewards()`: Allows the pool owner to add rewards based on elapsed blocks.
- `withdraw()`: Allows users to withdraw their deposit along with their earned rewards.

## Setup & Usage

1. Deploy the contract.
2. Call `initialize(owner)` to set the pool owner.
3. Users can deposit using `deposit(amount)`.
4. The pool owner can compound rewards periodically using `compound-rewards()`.
5. Users can withdraw their funds at any time with `withdraw()`.
