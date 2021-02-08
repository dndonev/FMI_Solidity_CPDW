// SPDX-License-Identifier: FMI, Introduction to BlockChain 2021
pragma solidity >=0.6.6 <0.8.0;
pragma experimental ABIEncoderV2;

contract CopyPasteDoneWrong {
    struct Picture {
        uint256 usagePrice;
        uint256 ownershipPrice;
        bool forSale;
        bool transferable;
        address ownerId;
        string id;
    }

    address private owner;
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addPicture(
        string memory pictureFile,
        uint256 picturePrice,
        bool forSale,
        string memory id
    ) public {}

    function buyPicture(string memory pictureId) external payable {}

    function getOwnedPictures() public returns (string[] memory) {}

    function getBoughtPictures() public returns (string[] memory) {}

    function getLastNPictures(uint256 count)
        public
        returns (Picture[] memory)
    {}

    function getFirstNPicturesu(int256 count)
        public
        returns (Picture[] memory)
    {}

    function setPrice(string memory pictureId, uint256 newPrice)
        external
        isOwner
    {}

    function setForSale(string memory pictureId, bool status)
        external
        isOwner
    {}

    function transferOwnership(address newOwnerID, string memory pictureId)
        public
    {}

    function deletePicture(string memory pictureId) public isOwner {}
}
