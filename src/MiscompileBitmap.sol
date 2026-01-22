// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MiscompileBitmap {
    uint256 public data;

    // 初始化：把 [0..n] 的 borrow/collateral 两位都置 1（每个 index 占 2 bit）
    function setAllPairsUpTo(uint256 n) external {
        uint256 x = 0;
        for (uint256 i = 0; i <= n; i++) {
            // 按位或操作设置 0b11 到 (2*i) 位置
            x |= (uint256(3) << (i << 1)); // 0b11 at (2*i)
        }
        data = x;
    }

    // 清 borrow 位：与 Aave 的典型写法一致
    function clearBorrow(uint256 reserveIndex) external {
        uint256 bit = uint256(1) << (reserveIndex << 1);
        data &= ~bit;
    }

    // 纯函数版：便于 property 检查
    function clearBorrowPure(uint256 x, uint256 reserveIndex) external pure returns (uint256) {
        uint256 bit = uint256(1) << (reserveIndex << 1);
        return x & ~bit;
    }
}