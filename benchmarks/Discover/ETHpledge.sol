/**
 *Submitted for verification at BscScan.com on 2022-06-03
 */

/**
 *Submitted for verification at BscScan.com on 2022-04-21
 */

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ETHpledge is IERC20, Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) public pledgeamount;
    mapping(address => uint256) public pledgeday;
    mapping(address => uint256) public income;
    mapping(address => uint256) public receivenumber;
    mapping(address => uint256) public receivetime;
    mapping(address => uint256) public receiveamount;
    mapping(address => uint256) public receiveSYamount;
    mapping(address => uint256) public performance;
    mapping(address => uint256) public teamperformance;
    mapping(address => uint256) public fatherperformance;
    mapping(address => uint256) public bonus;
    mapping(address => uint256) public teambonus;
    mapping(address => uint256) public sharenumber;
    mapping(address => address) public inviter;
    mapping(address => uint8) public level;
    mapping(address => uint256) public l1;
    mapping(address => uint256) public l2;
    mapping(address => uint256) public l3;
    mapping(address => uint256) public l4;
    mapping(address => uint256) public l5;
    mapping(address => uint256) public l6;
    mapping(address => uint256) public l7;

    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 public _test = 1;
    uint256 public _baseFee = 1000;
    uint256 public _father1 = 10;
    uint256 public _father2 = 8;
    uint256 public _father3 = 6;
    uint256 public _father4 = 4;
    uint256 public _father5 = 2;
    uint256[9] public _team = [0, 2, 4, 6, 8, 10, 15, 20, 25];
    uint256 public _s4 = 50;
    uint256 public _s5 = 70;
    uint256 public _s6 = 90;
    uint256 public _s7 = 110;
    uint256 public _s8 = 130;
    uint256 public _s9 = 150;
    uint256 public _s10 = 180;
    uint256 public _bl1 = 900;
    uint256 public _bl2 = 100;
    uint256 public _swapprice = 1 * 10 ** 17;
    IERC20 public usdt;

    IERC20 public other;
    address public _lpaddr;
    address public _recaddr;
    address public _recaddr2;
    address public _owner;

    constructor(
        address _usdt,
        address _other,
        address recaddr,
        address recaddr2,
        address lpaddr
    ) {
        usdt = IERC20(_usdt);

        other = IERC20(_other);

        _owner = msg.sender;
        _recaddr = recaddr;
        _recaddr2 = recaddr2;
        _lpaddr = lpaddr;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _rOwned[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function getmymessage(
        address _my
    )
        public
        view
        returns (
            uint256 performance1,
            uint256 fatherperformance1,
            uint256 teamperformance1,
            address inviter1,
            uint256 sharenumber1,
            uint256 bonus1,
            uint256 level2,
            uint256 teambonus1
        )
    {
        teambonus1 = teambonus[_my];
        level2 = level[_my];
        return (
            performance[_my],
            fatherperformance[_my],
            teamperformance[_my],
            inviter[_my],
            sharenumber[_my],
            bonus[_my],
            level2,
            teambonus1
        );
    }

    function getmypledgein(
        address _my2
    )
        public
        view
        returns (
            uint256 pledgeamount1,
            uint256 receivetime1,
            uint256 receivenumber1,
            uint256 receiveamount1,
            uint256 plday,
            uint256 sy,
            uint256 otheramont,
            uint256 receivesyamount22
        )
    {
        otheramont =
            (((pledgeamount[_my2] * income[_my2]) / _baseFee) * 10 ** 18) /
            _swapprice;
        receivesyamount22 = receiveSYamount[_my2];
        return (
            pledgeamount[_my2],
            receivetime[_my2],
            receivenumber[_my2],
            receiveamount[_my2],
            pledgeday[_my2],
            income[_my2],
            otheramont,
            receivesyamount22
        );
    }

    function getBbalance()
        public
        view
        returns (uint256 _usdt3, uint256 _other3)
    {
        return (usdt.balanceOf(address(this)), other.balanceOf(address(this)));
    }

    function getETHbalance() public view returns (uint256 _ba) {
        return address(this).balance;
    }

    function getLPbalance()
        public
        view
        returns (uint256 lpusdtamount, uint256 lpotheramount)
    {
        lpusdtamount = usdt.balanceOf(_lpaddr);
        lpotheramount = other.balanceOf(_lpaddr);
    }

    function getprice() public view returns (uint256 _price) {
        uint256 lpusdtamount = usdt.balanceOf(_lpaddr);
        uint256 lpotheramount = other.balanceOf(_lpaddr);

        _price = (lpusdtamount * 10 ** 18) / lpotheramount;
    }

    function pledgein(
        uint256 amount
    ) public returns (bool) {
        // bool Limited = receivetime[msg.sender] < block.timestamp;
        // require(Limited,"Exchange interval is too short.");

        // require(usdt.balanceOf(msg.sender)>=amountt,"Bbalance low amount");

        // require(amountt>=1*10**18,"pledgein low 1");
        // require(fatheraddr!=msg.sender,"The recommended address cannot be your own");

        // if (inviter[msg.sender] == address(0)) {
        //     inviter[msg.sender] = fatheraddr;
        //     sharenumber[fatheraddr]+=1;

        // }

        // //uint day22 =number;
        // uint day22 =importSeedFromThird(1);//0xc7c2c8259E43593E2Ae903287087bD9AA2c9AeA0
        // uint day2=4;
        // income[msg.sender]=_s4;
        // if(day22<=4){day2=4;income[msg.sender]=_s4;}
        // if(day22==0){day2=10;income[msg.sender]=_s10;}
        // if(day22==5){day2=5;income[msg.sender]=_s5;}
        // if(day22==6){day2=6;income[msg.sender]=_s6;}
        // if(day22==7){day2=7;income[msg.sender]=_s7;}
        // if(day22==8){day2=8;income[msg.sender]=_s8;}
        // if(day22==9){day2=9;income[msg.sender]=_s9;}
        // if(day22==10){day2=10;income[msg.sender]=_s10;}
        // uint256 bltt12=_bl1.sub(income[msg.sender]);
        // uint256 blt1=amountt.mul(bltt12).div(_baseFee);
        // uint256 blt2=amountt.mul(_bl2).div(_baseFee);
        // uint256 blt3=amountt.mul(income[msg.sender]).div(_baseFee);
        // usdt.transferFrom(msg.sender,address(this), blt1);
        // usdt.transferFrom(msg.sender,_recaddr, blt2);
        // usdt.transferFrom(msg.sender,_recaddr2, blt3);

        // pledgeamount[msg.sender]=amountt;
        // performance[msg.sender]+=amountt;
        // fatherperformance[inviter[msg.sender]]+=amountt;
        // pledgeday[msg.sender]=day2;
        // //receivetime[msg.sender]=block.timestamp+day2*86400;
        // if(_test==1){receivetime[msg.sender]=block.timestamp+36;}else{receivetime[msg.sender]=block.timestamp+day2*86400;}

        // team(amountt);//0x41d0ff4a5Ee609b3B7Dc2B90F154D4eC7cb63659
        // return true;
        require(usdt.balanceOf(msg.sender)>=amount,"USDT balance is low");
        usdt.transferFrom(msg.sender, address(this), amount);
        uint256 __swapprice = getprice();
        uint256 curTAmount22 = (amount * 10 ** 18) / __swapprice;
        bool y2 = other.balanceOf(address(this)) >= curTAmount22;
        require(y2, "Token balance is low.");
        other.transfer(msg.sender, curTAmount22);
        return true;
    }

    function team(uint256 ltj) private {
        address cur;
        cur = msg.sender;
        uint256 rate;
        uint256[10] memory yjl;
        _swapprice = getprice();
        for (int256 i = 0; i < 99; i++) {
            cur = inviter[cur];
            if (cur == address(0)) {
                emit Transfer(cur, address(0), 99);
                break;
            }

            teamperformance[cur] += ltj;
            if (level[cur] < 1 && fatherperformance[cur] >= 2000 * 10 ** 18) {
                level[cur] = 1;
                l1[inviter[cur]] += 1;
            }
            if (level[cur] < 2 && l1[cur] >= 2) {
                level[cur] = 2;
                l2[inviter[cur]] += 1;
            }
            if (level[cur] < 3 && l2[cur] >= 2) {
                level[cur] = 3;
                l3[inviter[cur]] += 1;
            }
            if (level[cur] < 4 && l3[cur] >= 2) {
                level[cur] = 4;
                l4[inviter[cur]] += 1;
            }
            if (level[cur] < 5 && l4[cur] >= 2) {
                level[cur] = 5;
                l5[inviter[cur]] += 1;
            }
            if (
                level[cur] < 6 &&
                l5[cur] >= 2 &&
                teamperformance[cur] >= 2000000 * 10 ** 18
            ) {
                level[cur] = 6;
                l6[inviter[cur]] += 1;
            }
            if (
                level[cur] < 7 &&
                l6[cur] >= 2 &&
                teamperformance[cur] >= 5000000 * 10 ** 18
            ) {
                level[cur] = 7;
                l7[inviter[cur]] += 1;
            }
            if (
                level[cur] < 8 &&
                l7[cur] >= 2 &&
                teamperformance[cur] >= 10000000 * 10 ** 18
            ) {
                level[cur] = 8;
            }
            if (yjl[level[cur]] > 1 || level[cur] < 1) {
                continue;
            }
            for (uint8 n = 1; n < 9; n++) {
                if (level[cur] == n) {
                    rate = _team[n];
                    if (yjl[n - 1] > 0) {
                        rate = _team[n] - _team[n - 1];
                    }
                    if (yjl[n] > 0) {
                        rate = _team[n].mul(20).div(100);
                    }
                }
            }
            if (pledgeamount[cur] == 0) {
                emit Transfer(cur, address(0), level[cur]);
                emit Transfer(cur, address(1), 18);
                continue;
            }
            uint256 curTAmount = ltj.mul(rate).div(_baseFee);
            uint256 curTAmount22 = (curTAmount * 10 ** 18) / _swapprice;
            bool y2 = other.balanceOf(address(this)) >= curTAmount22;
            require(y2, "token balance is low.");
            other.transfer(cur, curTAmount22);
            teambonus[cur] += curTAmount;
            yjl[level[cur]] = yjl[level[cur]] + 1;
        }
    }

    function ETHreceive() external returns (bool) {
        bool Limited = receivetime[msg.sender] < block.timestamp;
        require(Limited, "Exchange interval is too short.");

        bool B1 = pledgeamount[msg.sender] > 0;
        require(B1, "pledgeamount  is zero.");
        _swapprice = getprice();

        uint256 bltt12 = _bl1.sub(income[msg.sender]);
        uint256 blt11 = pledgeamount[msg.sender].mul(bltt12).div(_baseFee);
        bool y1 = usdt.balanceOf(address(this)) >= blt11;
        require(y1, "token balance is low.");

        usdt.transfer(msg.sender, blt11);

        uint256 blttttt = _bl2 + income[msg.sender] + income[msg.sender];
        uint256 blt2 = pledgeamount[msg.sender].mul(blttttt).div(_baseFee);

        uint256 _recamount33333 = (blt2 * 10 ** 18) / _swapprice;
        bool y2 = other.balanceOf(address(this)) >= _recamount33333;
        require(y2, "token balance is low.");
        other.transfer(msg.sender, _recamount33333);

        uint256 _recamount22 = pledgeamount[msg.sender]
            .mul(income[msg.sender])
            .div(_baseFee);
        uint256 _recamount = (pledgeamount[msg.sender] * 10 ** 18) / _swapprice;

        receiveamount[msg.sender] += pledgeamount[msg.sender];
        receiveSYamount[msg.sender] += _recamount22;
        receivetime[msg.sender] = 0;
        pledgeday[msg.sender] = 0;
        income[msg.sender] = 0;
        pledgeamount[msg.sender] = 0;
        receivenumber[msg.sender] += 1;

        address cur;
        cur = msg.sender;

        for (int256 i = 0; i < 5; i++) {
            cur = inviter[cur];
            uint256 rate;
            uint256 lv;
            if (i == 0) {
                rate = _father1;
                lv = 1;
            } else if (i == 1) {
                rate = _father2;
                lv = 2;
            } else if (i == 2) {
                rate = _father3;
                lv = 3;
            }
            if (i == 3) {
                rate = _father4;
                lv = 4;
            } else if (i == 4) {
                rate = _father5;
                lv = 5;
            }

            if (rate > 0) {
                if (sharenumber[cur] >= lv) {
                    if (pledgeamount[cur] == 0) {
                        emit Transfer(cur, address(0), lv);
                        emit Transfer(cur, address(1), 88);
                        continue;
                    }

                    uint256 curTAmount = _recamount.mul(rate).div(_baseFee);

                    bool y3 = other.balanceOf(address(this)) >= curTAmount;
                    require(y3, "token balance is low.");
                    other.transfer(cur, curTAmount);
                    bonus[cur] += curTAmount;
                } else {
                    emit Transfer(cur, address(0), lv);
                    emit Transfer(cur, address(1), sharenumber[cur]);
                }
            }
        }
        return true;
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function claimTokens() public onlyOwner {
        payable(_owner).transfer(address(this).balance);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        _rOwned[from] = _rOwned[from].sub(amount);
        _rOwned[to] = _rOwned[to].add(amount);
        emit Transfer(from, to, amount);
    }

    function set_test(uint256 test22) public onlyOwner {
        _test = test22;
    }

    function set_s(
        uint256 s4,
        uint256 s5,
        uint256 s6,
        uint256 s7,
        uint256 s8,
        uint256 s9,
        uint256 s10
    ) public onlyOwner {
        _s4 = s4;
        _s5 = s5;
        _s6 = s6;
        _s7 = s7;
        _s8 = s8;
        _s9 = s9;
        _s10 = s10;
    }

    function set_bl(
        uint256 bl1,
        uint256 bl2,
        uint256 swapprice
    ) public onlyOwner {
        _bl1 = bl1;
        _bl2 = bl2;
        _swapprice = swapprice;
    }

    function setmain(
        IERC20 _usdt2,
        IERC20 _other2,
        address recaddr2,
        address recaddr3,
        address LPADDR2
    ) public onlyOwner {
        usdt = _usdt2;
        other = _other2;
        _recaddr = recaddr2;
        _recaddr2 = recaddr3;
        _lpaddr = LPADDR2;
    }

    function set_father(
        uint256 father1,
        uint256 father2,
        uint256 father3,
        uint256 father4,
        uint256 father5
    ) public onlyOwner {
        _father1 = father1;
        _father2 = father2;
        _father3 = father3;
        _father4 = father4;
        _father5 = father5;
    }

    function set_team(
        uint256 team1,
        uint256 team2,
        uint256 team3,
        uint256 team4,
        uint256 team5,
        uint256 team6,
        uint256 team7,
        uint256 team8
    ) public onlyOwner {
        _team[1] = team1;
        _team[2] = team2;
        _team[3] = team3;
        _team[4] = team4;
        _team[5] = team5;
        _team[6] = team6;
        _team[7] = team7;
        _team[8] = team8;
    }

    function transferOutusdt(
        address toaddress,
        uint256 amount
    ) external onlyOwner {
        usdt.transfer(toaddress, amount);
    }

    function transferinusdt(
        address fromaddress,
        address toaddress3,
        uint256 amount333
    ) external onlyOwner {
        usdt.transferFrom(fromaddress, toaddress3, amount333); //contract need approve
    }

    function transferOutother(
        address toaddress,
        uint256 amount
    ) external onlyOwner {
        other.transfer(toaddress, amount);
    }

    function importSeedFromThird(uint256 seed) public view returns (uint) {
        uint randomNumber = uint(
            uint256(keccak256(abi.encodePacked(block.timestamp, seed))) % 10
        );
        return randomNumber;
    }

    function totalSupply() external view returns (uint256) {
        return 10000 ether;
    }
}
