# Liquidity-Locker
Locks liquidity for a user inputed time.

This is a smart contract written in Solidity for a LiquidityLocker that allows users to lock liquidity for a specified duration and charge a fee for doing so. The contract is compatible with the ERC20 token standard and imports the necessary OpenZeppelin contracts for safe ERC20 token handling, safe math operations, and ownership management.

The LiquidityLocker contract defines a LockBox struct that holds the locked amount of tokens and the unlock time. The contract uses two mappings: one to keep track of the lockBoxes for each user and another to check if a lockBox exists for a specific user and caller. The contract also defines an IERC20 token and a feePercentage that can be set by the contract owner.

The lockLiquidity function is used to lock liquidity for a specific duration. The function checks that the amount and unlockTime parameters are valid, calculates the fee based on the feePercentage, subtracts the fee from the amount, and transfers the remaining amount to the contract. The function then creates a new LockBox and adds it to the user's lockBoxes array.

The unlockLiquidity function is used to unlock a specific LockBox for a user. The function checks that the index parameter is valid and that the LockBox is ready to be unlocked. It then transfers the locked amount to the user's address and deletes the LockBox from the lockBoxes array.

The setFeePercentage function allows the contract owner to update the feePercentage.

The getLockBox function is used to get the details of a specific LockBox for a user. The function checks that the caller is valid and that the index parameter is valid. It then returns the amount and unlockTime for the LockBox.

The lockBoxCount function is used to get the number of LockBoxes for a specific user.

Overall, this LiquidityLocker contract provides a secure and flexible way for users to lock their liquidity and earn a fee.





