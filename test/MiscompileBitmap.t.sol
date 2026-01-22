// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/MiscompileBitmap.sol";

contract MiscompileBitmapTest is Test {
    MiscompileBitmap b;

    function setUp() public {
        b = new MiscompileBitmap();
    }

    function _spec(uint256 x, uint256 idx) internal pure returns (uint256) {
        return x & ~(uint256(1) << (idx << 1));
    }

    // 定向回归：低位全 1，再清一个较高的 borrow 位。
    // 若出现 Certora 文章那类 bug，往往会把更低位一串也清掉，导致断言失败。
    function test_regression_clearOneBorrowDoesNotWipeLowerPairs() public {
        uint256 n = 80; // 2*n=160 < 256，且足够“高”以触发优化路径
        b.setAllPairsUpTo(n);

        uint256 beforeX = b.data();
        b.clearBorrow(n);
        uint256 afterX = b.data();

        assertEq(afterX, _spec(beforeX, n), "miscompile: cleared more than one bit");
    }

    // fuzz：任意输入都必须严格满足数学规格
    function testFuzz_clearBorrowMatchesSpec(uint256 x, uint8 idx) public {
        uint256 reserveIndex = uint256(idx) % 120; // 2*120=240 < 256，避免移位越界
        uint256 got = b.clearBorrowPure(x, reserveIndex);
        uint256 want = _spec(x, reserveIndex);
        assertEq(got, want, "miscompile: spec mismatch");
    }

    // 更“狠”的定向 fuzz：强制高位 + 低位前缀全 1，专抓“清低位连锁”问题
    function testFuzz_hiIndex_doesNotClearLowerPrefix(uint8 i, uint8 prefixLen) public {
        vm.assume(i >= 64 && i < 120);      // 2*i < 240
        vm.assume(prefixLen > 0 && prefixLen < (i << 1));

        uint256 bitPos = uint256(i) << 1;   // borrow 位位置
        uint256 lowPrefix = (uint256(1) << prefixLen) - 1;
        uint256 x = lowPrefix | (uint256(1) << bitPos);

        uint256 got = b.clearBorrowPure(x, uint256(i));
        uint256 want = x & ~(uint256(1) << bitPos);

        assertEq(got, want, "miscompile: lower bits changed");
        assertEq(got & lowPrefix, lowPrefix, "miscompile: lower prefix corrupted");
    }
}
