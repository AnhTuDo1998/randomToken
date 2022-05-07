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

    uint256 public initCost = 0.000000001 ether;

    uint256 public maxSupply = 10;

    uint256 public maxMintAmount = 3;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    // Mint function
    function mintToken() public payable {
        uint256 supply = totalSupply();

        uint256 costToMint = initCost;

        // Ensure cannot mint more than the limit per minter
        require(maxMintAmount - balanceOf(msg.sender) > 0);
        require(supply.add(1) <= maxSupply);

        // determine price by quadratic equation
        if (msg.sender != owner()) {
            for (uint i = 0; i < balanceOf(msg.sender); i++) {
                costToMint = costToMint ** 2;
            }
            require(msg.value >= costToMint);
        }
        _safeMint(msg.sender, supply.add(1));
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