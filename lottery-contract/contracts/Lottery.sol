pragma solidity ^0.4.23;
contract lottery {
    address public manager;
    address[] public players;

    constructor() public {
        manager = msg.sender;
    }
    function enter() public payable {
        //同じ人がなんども参加できないようにする
        for(uint i=0; i< players.length; i++) {
            require(msg.sender !=players[i]);
        }
        // 0.1TETH以上の参加費を指定しよう
        require(msg.value > 0.01 ether);
        players.push(msg.sender);
    }
    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
    }
    //コントラクト作成者しか呼び出せないようにする
    function pickWinner() public {
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        //抽選の後再度抽選が出来るようにメンバーを削除
        players = new address[](0);
    }
    //コントラクト作成者にしか呼び出せない修飾子を作ろう
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    function getPlayers() public view returns (address[]) {
        return players;
    }
    //抽選で溜まっている金額を返す関数を書こう
    function getLotteryBalance() public view returns(uint) {
        return address(this).balance;
    }
}
