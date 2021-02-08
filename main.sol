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
    mapping(string => Picture) private database;
    mapping(address => string[]) private ownerPicture;
    mapping(address => string[]) private buyers;
    mapping(string => Picture) private exists;

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Add a picture to the mapping.
     * @param pictureFile the hash of the file.
     * @param picturePrice the price of the picture.
     * @param forSale is it for sale.
     * @param id picture's id.
     */
    function addPicture(
        string memory pictureFile,
        uint256 picturePrice,
        bool forSale,
        string memory id
    ) public {}

    /**
     * @dev Buyer gets ownership.
     * @param pictureId the id of the demanded picture.
     */
    function buyPicture(string memory pictureId) external payable {}

    /**
     * @dev Gets owned pictures.
     */
    function getOwnedPictures() public returns (string[] memory) {}

    /**
     * @dev Gets bought pictures.
     */
    function getBoughtPictures() public returns (string[] memory) {}

    /**
     * @dev Gets last N pictures.
     */
    function getLastNPictures(uint256 count)
        public
        returns (Picture[] memory)
    {}

    /**
     * @dev Gets first N pictures.
     */
    function getFirstNPicturesu(int256 count)
        public
        returns (Picture[] memory)
    {}

    /**
     * @dev Sets pictures price. Owner only.
     * @param pictureId The id of the picture.
     * @param newPrice The new price;
     */
    function setPrice(string memory pictureId, uint256 newPrice)
        external
        isOwner
    {}

    /**
     * @dev Change selling status.
     * @param pictureId The id of the picture.
     * @param newStatus The new status;
     */
    function setForSale(string memory pictureId, bool newStatus)
        external
        isOwner
    {}

    /**
     * @dev Transfers the ownership to the buyer.
     * @param newOwnerID The address of the buyer.
     * @param pictureId The id of the picture.
     */
    function transferOwnership(address newOwnerID, string memory pictureId)
        public
    {}

    /**
     * @dev Removes a picture from the database.
     * @param pictureId The id of the picture to be deleted.
     */
    function deletePicture(string memory pictureId) public isOwner {}
}
