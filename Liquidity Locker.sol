/**

SPDX-License-Identifier: MIT
LiquidityLocker smart contract that allows users to lock liquidity for a specified duration
and charge a fee for doing so. Users can unlock their liquidity once the specified duration has elapsed.
@author Sean Pepper
@version 1.0.0
*/
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LiquidityLocker is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct LockBox {
        uint256 amount;
        uint256 unlockTime;
    }

    mapping(address => LockBox[]) public lockBoxes;
    mapping(address => mapping(address => bool)) public lockBoxExists;

    IERC20 public token;
    uint256 public feePercentage;

    event LiquidityLocked(address indexed account, uint256 amount, uint256 unlockTime);
    event LiquidityUnlocked(address indexed account, uint256 amount);

    constructor(IERC20 _token, uint256 _feePercentage) {
        token = _token;
        feePercentage = _feePercentage;
    }

    function lockLiquidity(uint256 _amount, uint256 _unlockTime) external {
        require(_amount > 0, "Amount should be greater than zero");
        require(_unlockTime > block.timestamp, "Unlock time should be in the future");

        uint256 fee = _amount.mul(feePercentage).div(10000);
        uint256 amountAfterFee = _amount.sub(fee);

        token.safeTransferFrom(msg.sender, address(this), amountAfterFee);

        lockBoxes[msg.sender].push(LockBox({
            amount: amountAfterFee,
            unlockTime: _unlockTime
        }));

        emit LiquidityLocked(msg.sender, amountAfterFee, _unlockTime);
    }

    function unlockLiquidity(uint256 index) external {
        require(index < lockBoxes[msg.sender].length, "Index out of range");

        LockBox storage box = lockBoxes[msg.sender][index];
        require(box.unlockTime <= block.timestamp, "Tokens are still locked");

        uint256 amount = box.amount;
        delete lockBoxes[msg.sender][index];

        token.safeTransfer(msg.sender, amount);

        emit LiquidityUnlocked(msg.sender, amount);
    }

    function setFeePercentage(uint256 _feePercentage) external onlyOwner {
        require(_feePercentage <= 10000, "Fee should not exceed 100%");
        feePercentage = _feePercentage;
    }

    function getLockBox(address account, uint256 index) external view returns(uint256 amount, uint256 unlockTime) {
        require(lockBoxExists[account][msg.sender], "Invalid caller");
        require(index < lockBoxes[account].length, "Index out of range");

        LockBox storage box = lockBoxes[account][index];
        amount = box.amount;
        unlockTime = box.unlockTime;
    }

    function lockBoxCount(address account) external view returns(uint256 count) {
        count = lockBoxes[account].length;
    }
}
