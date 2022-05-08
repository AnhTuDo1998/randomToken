// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RandomToken is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter private _tokenIdCounter;

    uint256 public cost = 2;

    uint256 public maxSupply = 10;

    uint256 public maxMintAmount = 3;

    constructor() ERC721("Random Token", "RTK") {}

    // Mint function
    function mintToken(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        uint256 _totalMintCost = getTotalMintCost(_mintAmount);

        // Ensure cannot mint more than the limit per minter
        require(_mintAmount > 0);
        require(_mintAmount + balanceOf(msg.sender) <= maxMintAmount);
        require(supply.add(_mintAmount) <= maxSupply);

        // owner mint for free
        if (msg.sender != owner()) {
          require(msg.value >= _totalMintCost);
        }

        // mint and increase price point
        for (uint256 i = 1; i <= _mintAmount; i++) {
          _safeMint(msg.sender, supply.add(i));
          cost = cost ** 2;
        }
    }

    // Get amount of token a user can mint left
    function mintableTokenLeft() public view returns (uint256) {
        return maxMintAmount - balanceOf(msg.sender);
    }

    // Get total cost needed to mint x amount of token at once
    function getTotalMintCost(uint256 _mintAmount) public view returns (uint256) {
        uint256 _total = 0;
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _total = _total + (cost ** (2 ** (i -1)));
        }
        return _total;
    }

    // Query the list of tokens under a minter wallet
    function walletOfOwner(address _wallet)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_wallet);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_wallet, i);
        }
        return tokenIds;
    }

}