// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CleanToken
 * @dev Simplified ERC‑20 token with no constructor parameters—deploys with a fixed supply
 */
contract CleanToken {
    // ───── Metadata & Supply ─────
    string  public name       = "Clean Token";
    string  public symbol     = "CLN";
    uint8   public constant decimals   = 18;
    uint256 public totalSupply;

    // ───── Balances & Allowance ─────
    mapping(address => uint256)                      public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // ───── Events ─────
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner,  address indexed spender, uint256 value);

    /**
     * @dev Mints a fixed 1 000 000 tokens (with decimals) to deployer.
     */
    constructor() {
        uint256 initial = 1_000_000 * 10**uint256(decimals);
        totalSupply = initial;
        balanceOf[msg.sender] = initial;
        emit Transfer(address(0), msg.sender, initial);
    }

    /**
     * @dev Transfer `value` tokens from caller to `to`.
     */
    function transfer(address to, uint256 value) external returns (bool) {
        require(balanceOf[msg.sender] >= value, "CleanToken: balance too low");
        _move(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve `spender` to spend `value` tokens on caller's behalf.
     */
    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer `value` tokens from `from` to `to`, if allowed.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= value, "CleanToken: allowance too low");
        allowance[from][msg.sender] = allowed - value;
        _move(from, to, value);
        return true;
    }

    /// @dev Internal move helper
    function _move(address from, address to, uint256 amount) internal {
        require(to != address(0), "CleanToken: zero address");
        balanceOf[from] -= amount;
        balanceOf[to]   += amount;
        emit Transfer(from, to, amount);
    }
}
