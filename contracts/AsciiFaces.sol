// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AsciiFaces is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => uint256) internal idToSeed;
    mapping(uint256 => uint256) internal seedToId;

    uint256 private constant EYE_COUNT = 46;
    uint256 private constant MOUTH_COUNT = 43;
    uint256 private constant EDGE_COUNT = 41;

    bool public hasSaleStarted = false;

    string public baseURI;

    constructor() ERC721("AsciiFaces", "ASF") {
        setBaseURI("https://api.asciifaces.com/face/");
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

    function getFace(uint256 id) external view returns (string memory) {
        require(_exists(id), "ERC721: Token is not exist");
        uint256 seed = idToSeed[id];

        string memory face = _createFace(seed);

        return face;
    }

    function calculatePrice() public pure returns (uint256) {
        return 50000000000000000;
    }

    function createFace(uint256 _seed) public returns (string memory) {
        uint256 seed =
            uint256(keccak256(abi.encodePacked(_seed, block.timestamp, msg.sender, _tokenIdCounter.current())));

        require(seedToId[seed] == 0, "ERC721: seed already used");

        _tokenIdCounter.increment();

        idToSeed[_tokenIdCounter.current()] = seed;
        seedToId[seed] = _tokenIdCounter.current();

        string memory face = _createFace(idToSeed[_tokenIdCounter.current()]);

        _mint(msg.sender, _tokenIdCounter.current());

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
                ["unicode0", "0"],
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
