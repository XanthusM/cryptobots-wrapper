pragma solidity 0.8.6;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';


interface IGetBot {
    function transfer(
        address _to,
        uint256 _tokenId
    ) external;

    function getBot(uint256 _id)
        external
        view
        returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}


interface IBotCore is IERC721, IGetBot {}


contract BotCoreWrapper is IGetBot, ReentrancyGuard, Ownable, ERC721 {
    using Strings for uint256;

    IBotCore public botCore;
    string public baseURI;
    string public contractURI;

    event BaseURISet(string value);
    event ContractURISet(string value);

    constructor (address botCoreAddress, string memory baseURIValue, string memory contractURIValue) ERC721("WrappedCryptoBots", "WrappedCryptoBots") {
        require(botCoreAddress != address(0), "zero address");
        botCore = IBotCore(botCoreAddress);
        baseURI = baseURIValue;
        emit BaseURISet(baseURIValue);
        contractURI = contractURIValue;
        emit ContractURISet(contractURIValue);
    }

    function transfer(
        address _to,
        uint256 _tokenId
    ) external override {
        transferFrom(msg.sender, _to, _tokenId);
    }

    function setBaseURI(string calldata baseURIValue) external onlyOwner {
        baseURI = baseURIValue;
        emit BaseURISet(baseURIValue);
    }

    function setContractURI(string calldata contractURIValue) external onlyOwner {
        contractURI = contractURIValue;
        emit ContractURISet(contractURIValue);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }

    function wrap(uint256 tokenId) external nonReentrant {
        botCore.transferFrom(msg.sender, address(this), tokenId);
        _mint(msg.sender, tokenId);
    }

    function unwrap(uint256 tokenId) external nonReentrant {
        require(ownerOf(tokenId) == msg.sender, "NFTWrapper: unwrap from incorrect owner");
        _burn(tokenId);
        botCore.transfer(msg.sender, tokenId);
    }

    function wrapMany(uint256[] calldata tokenIds) external nonReentrant {
        for (uint256 i; i < tokenIds.length; i++) {
            botCore.transferFrom(msg.sender, address(this), tokenIds[i]);
            _mint(msg.sender, tokenIds[i]);
        }
    }

    function unwrapMany(uint256[] calldata tokenIds) external nonReentrant {
        for (uint256 i; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            require(ownerOf(tokenId) == msg.sender, "NFTWrapper: unwrap from incorrect owner");
            _burn(tokenId);
            botCore.transfer(msg.sender, tokenId);
        }
    }

    function getBot(uint256 _id)
        external
        view
        override
        returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    ) {
        return botCore.getBot(_id);
    }
}
