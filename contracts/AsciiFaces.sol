// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AsciiFaces is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using SafeERC20 for IERC20;

    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => uint256) internal idToSeed;
    mapping(uint256 => uint256) internal seedToId;

    uint256 private constant EYE_COUNT = 46;
    uint256 private constant MOUTH_COUNT = 43;
    uint256 private constant EDGE_COUNT = 41;

    IERC20 internal wETH;

    uint256 public constant MAX_SUPPLY = 10000;

    bool public hasSaleStarted = false;

    string public baseURI;

    constructor(address weth) ERC721("AsciiFaces", "ASF") {
        wETH = IERC20(weth);

        setBaseURI("https://api.asciifaces.com/face/");

        // mint 10 genesis faces
        _registerToken(60, owner()); // ~|◕o◕|~
        _registerToken(27, owner()); // ꒰✜益✜꒱
        _registerToken(88, owner()); // (ʘ̆___ʘ̆)⌐
        _registerToken(116, owner()); // :ʘ̆⌂ʘ̆:
        _registerToken(156, owner()); // ヽ༼©ェ©༽ﾉ
        _registerToken(242, owner()); // ◕ᴥ◕
        _registerToken(332, owner()); // ⊂(ⱺ..ⱺ)つ
        _registerToken(351, owner()); // ╚(°<>°)╝
        _registerToken(424, owner()); // ⊂(ㆆ___ㆆ)つ
        _registerToken(438, owner()); // |(◕︹◕)|
    }

    function getFace(uint256 id) external view returns (string memory) {
        require(_exists(id), "ERC721: Token is not exist");
        uint256 seed = idToSeed[id];

        string memory face = _createFace(seed);

        return face;
    }

    function calculatePrice() public view returns (uint256) {
        uint256 price;
        uint256 totalSupply = _tokenIdCounter.current();

        if (totalSupply <= 1000) {
            price = 25000000000000000; // 0.025
        } else if (totalSupply <= 2000 && totalSupply > 1000) {
            price = 50000000000000000; // 0.05
        } else if (totalSupply <= 3000 && totalSupply > 2000) {
            price = 100000000000000000; // 0.1
        } else if (totalSupply <= 4000 && totalSupply > 3000) {
            price = 200000000000000000; // 0.2
        } else if (totalSupply > 4000) {
            price = 400000000000000000; // 0.4
        }

        return price;
    }

    function createFace(uint256 _seed) public returns (string memory) {
        require(hasSaleStarted == true, "Sale hasn't started");
        require(_tokenIdCounter.current() <= MAX_SUPPLY, "Sale has ended, you can still buy on secondary market");

        wETH.safeTransferFrom(msg.sender, address(this), calculatePrice());

        uint256 seed =
            uint256(keccak256(abi.encodePacked(_seed, block.timestamp, msg.sender, _tokenIdCounter.current())));

        require(seedToId[seed] == 0, "ERC721: seed already used");

        return _registerToken(seed, msg.sender);
    }

    function _registerToken(uint256 _seed, address to) internal returns (string memory) {
        _tokenIdCounter.increment();

        idToSeed[_tokenIdCounter.current()] = _seed;
        seedToId[_seed] = _tokenIdCounter.current();

        string memory face = _createFace(idToSeed[_tokenIdCounter.current()]);

        _mint(to, _tokenIdCounter.current());

        return face;
    }

    function _createFace(uint256 _seed) internal pure returns (string memory) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_seed)));

        string[2] memory edge = _getEdge(rand);
        string[2] memory eye = _getEye(rand);
        string memory mouth = _getMouth(rand);

        return string(abi.encodePacked(edge[0], eye[0], mouth, eye[1], edge[1]));
    }

    function _getEdge(uint256 _rand) internal pure returns (string[2] memory) {
        string[2][EDGE_COUNT] memory edges =
            [
                ["", ""],
                [unicode"=", unicode"="],
                [unicode"(", unicode")"],
                [unicode"⊂(", unicode")つ"],
                [unicode"☜(", unicode")☞"],
                [unicode"ʕノ", unicode"ʔノ"],
                [unicode"(˵", unicode"˵)"],
                [unicode"<{", unicode"}>"],
                [unicode"}>", unicode"}>"],
                [unicode"{", unicode"}"],
                [unicode"|", unicode"|"],
                [unicode"ԅ(", unicode"ԅ)"],
                [unicode")ᕗ", unicode")ᕗ"],
                [unicode"ヽ(", unicode")ﾉ"],
                [unicode"<(", unicode")>"],
                [unicode"(╯", unicode")╯"],
                [unicode"|(", unicode")|"],
                [unicode"(", unicode")/"],
                [unicode"╚(", unicode")╝"],
                [unicode"(๑", unicode"๑)"],
                [unicode"[¬", unicode"]¬"],
                [unicode"ε(", unicode")з"],
                [unicode"*(", unicode")*"],
                [unicode"~=[", unicode"]=~"],
                [unicode"d[", unicode"]b"],
                [unicode"ヽ༼", unicode"༽ﾉ"],
                [unicode"ψ(", unicode")ψ"],
                [unicode"(ღ", unicode"ღ)"],
                [unicode"(", unicode")⌐"],
                [unicode"(づ｡", unicode"｡)づ"],
                [unicode"(੭*", unicode")੭* ̀"],
                [unicode"／人", unicode"人＼"],
                [unicode")ง", unicode")ง"],
                [unicode")/¯", unicode")/¯"],
                [unicode"꒰", unicode"꒱"],
                [unicode"!!", unicode"!!"],
                [unicode"<", unicode">"],
                [unicode"<|", unicode"|>"],
                [unicode"~|", unicode"|~"],
                [unicode":(", unicode"):"],
                [unicode":", unicode":"]
            ];

        uint256 edgeId = _rand % EDGE_COUNT;

        return edges[edgeId];
    }

    function _getEye(uint256 _rand) internal pure returns (string[2] memory) {
        string[2][EYE_COUNT] memory eyes =
            [
                ["0", "0"],
                [unicode"◉", unicode"◉"],
                [unicode"ㆆ", unicode"ㆆ"],
                [unicode"⌒", unicode"⌒"],
                [unicode"•`", unicode"´•"],
                [unicode"ⱺ", unicode"ⱺ"],
                [unicode"•͡", unicode"•͡"],
                [unicode"^.", unicode".^"],
                [unicode"■", unicode"■"],
                [unicode"°", unicode"°"],
                [unicode"-", unicode"-"],
                [unicode"Ф", unicode"Ф"],
                [unicode"ຈ", unicode"ຈ"],
                [unicode"✜", unicode"✜"],
                [unicode"◕", unicode"◕"],
                [unicode"•́", unicode"•̀"],
                [unicode"ಥ", unicode"ಥ"],
                [unicode"⊙", unicode"⊙"],
                [unicode"Ó", unicode"Ó"],
                [unicode"•͡˘", unicode"•͡˘"],
                [unicode"┻", unicode"┻"],
                [unicode"ʘ̆", unicode"ʘ̆"],
                [unicode"Ɵ͆", unicode"Ɵ͆"],
                [unicode"≖", unicode"≖"],
                [unicode"╥", unicode"╥"],
                [unicode"°", unicode"°"],
                [unicode"︶", unicode"︶"],
                [unicode"°", unicode"o"],
                [unicode"⌐■", unicode"■"],
                [unicode"╹", unicode"╹"],
                [unicode"ˊ", unicode"ˋ"],
                [unicode"❍", unicode"❍"],
                [unicode"¬", unicode"¬"],
                [unicode"ಡ", unicode"ಡ"],
                [unicode"♥", unicode"♥"],
                [unicode"@", unicode"@"],
                [unicode"눈", unicode"눈"],
                [unicode"*", unicode"*"],
                [unicode"�", unicode"�"],
                [unicode"X", unicode"X"],
                [unicode"^", unicode"^"],
                [unicode"™", unicode"™"],
                [unicode"©", unicode"©"],
                [unicode"(©)", unicode"(©)"],
                [unicode"+", unicode"+"],
                [unicode"#", unicode"#"]
            ];

        uint256 eyeId = _rand % EYE_COUNT;

        return eyes[eyeId];
    }

    function _getMouth(uint256 _rand) internal pure returns (string memory) {
        string[MOUTH_COUNT] memory mouths =
            [
                "",
                unicode"‿",
                unicode"_",
                unicode"▽",
                unicode"ʖ̯",
                unicode"㇁",
                unicode"ᴥ",
                unicode"Y",
                unicode"³",
                unicode"ェ",
                unicode"o",
                unicode"౪",
                unicode"ل͜",
                unicode"‿‿",
                unicode"︹",
                unicode"Д",
                unicode"⌂",
                unicode"ヮ",
                unicode"ʟ",
                unicode",,,,",
                unicode"ω",
                unicode"◞౪◟",
                unicode"⌓",
                unicode"____",
                unicode"Ӝ",
                unicode"﹏",
                unicode"ਊ",
                unicode"3",
                unicode"⺫",
                unicode"卌",
                unicode"益",
                unicode"Ω",
                unicode"ᵕ",
                unicode"﹃",
                unicode".",
                unicode"෴",
                unicode"__",
                unicode"___",
                unicode"..",
                unicode"...",
                unicode"O",
                unicode">",
                unicode"<>"
            ];

        uint256 mouthId = _rand % MOUTH_COUNT;

        return mouths[mouthId];
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function startSale() public onlyOwner {
        hasSaleStarted = true;
    }

    function pauseSale() public onlyOwner {
        hasSaleStarted = false;
    }

    function setBaseURI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
