// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LSDToken is ERC20, Ownable {
    modifier onlyIssuer {
        require(isIssuer[_msgSender()] || _msgSender() == owner(), "You do not have issuer right.");
        _;
    }

    mapping(address => bool) public isIssuer;
    event IssuerRights(address indexed issuer, bool value);

    constructor() ERC20 ("Lost Soul District Token", "LSD") {
        _mint(address(0x5b76C87134f3E1FBe9B88e5Fa5E9531CA7139bE8), 1000000 * (10 ** decimals()));
    }

    function mint(address to, uint256 amount) public onlyIssuer returns (bool success) {
        _mint(to, amount);

        return true;
    }

    function burn(uint256 amount) public onlyIssuer returns (bool success) {
       _burn(_msgSender(), amount);

        return true;
    }

    function burnFrom(address from, uint256 amount) public onlyIssuer returns (bool success) {
        _burn(from, amount);

        uint256 currentAllowance = allowance(from, _msgSender());
        require(currentAllowance >= amount, "LSD: burn amount exceeds allowance");
        unchecked {
            _approve(from, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function setIssuerRights(address issuer, bool value) public onlyOwner {
        isIssuer[issuer] = value;
        emit IssuerRights(issuer, value);
    }
}