pragma solidity 0.8.6;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';


interface IGetBot {
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


contract NFTWrapper is IGetBot, ReentrancyGuard, Ownable, ERC721 {
    using Strings for uint256;

    IBotCore immutable public botCore;
    string internal _baseURIValue;
    string internal _contractURIValue;

    event BaseURISet(string value);
    event ContractURISet(string value);

    constructor (address botCoreAddress, string memory baseURI, string memory contractURI) ERC721("WrappedCryptoBots", "WrappedCryptoBots") {
        require(botCoreAddress != address(0), "zero address");
        botCore = IBotCore(botCoreAddress);
        _baseURIValue = baseURI;
        emit BaseURISet(_baseURIValue);
        _contractURIValue = contractURI;
        emit ContractURISet(_baseURIValue);
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseURIValue = baseURI;
        emit BaseURISet(_baseURIValue);
    }

    function setContractURI(string calldata contractURI) external onlyOwner {
        _contractURIValue = contractURI;
        emit ContractURISet(_baseURIValue);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(_baseURIValue, tokenId.toString()));
    }

    function wrap(uint256 tokenId) external nonReentrant {
        botCore.transferFrom(msg.sender, address(this), tokenId);
        _mint(msg.sender, tokenId);
    }

    function unwrap(uint256 tokenId) external nonReentrant {
        require(ownerOf(tokenId) == msg.sender, "NFTWrapper: unwrap from incorrect owner");
        _burn(tokenId);
        botCore.transferFrom(address(this), msg.sender, tokenId);
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
            botCore.transferFrom(address(this), msg.sender, tokenId);
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
