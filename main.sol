// SPDX-License-Identifier: FMI, Introduction to BlockChain 2021
pragma solidity ^0.7.4;
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

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    address payable private owner;
    mapping(string => Picture) private availablePictures;
    mapping(address => Picture[]) private ownerPictures;
    mapping(address => Picture[]) private buyerPictures;
    mapping(string => Picture) private exists;
    Picture[] private pictures;
    address[] private owners;
    address[] private buyers;

    constructor() {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Add a picture to the mapping.
     * @param fileHash the hash of the file.
     * @param price the price of the picture.
     * @param forSale is it for sale.
     */
    function addPicture(
        string memory fileHash,
        uint256 price,
        bool forSale
    ) public {
        address pictureOwner = msg.sender;
        uint256 usagePrice = price / 2;

        Picture memory pictureToAdd =
            Picture({
                ownershipPrice: price,
                usagePrice: usagePrice,
                forSale: forSale,
                ownerId: owner,
                id: fileHash,
                transferable: true
            });

        availablePictures[fileHash] = pictureToAdd;

        pushOwnerPicture(pictureToAdd, pictureOwner);
    }

    /**
     * @dev Buyer gets ownership.
     * @param pictureId the id of the demanded picture.
     */
    function buyPicture(string memory pictureId) external payable {
        require(pictures.length > 0, "No pictures available");

        address buyer = msg.sender;
        uint256 value = msg.value;
        Picture memory wantedPicture = getPictureById(pictureId);

        if (availablePictures[pictureId].ownershipPrice == value) {
            transferOwnership(payable(buyer), wantedPicture, value);
        }
    }

    /**
     * @dev Buyer rents ownership.
     * @param pictureId the id of the demanded picture.
     */
    function rentPicture(string memory pictureId) external payable {
        require(pictures.length > 0, "No pictures available");

        address buyer = msg.sender;
        uint256 value = msg.value;
        Picture memory wantedPicture = getPictureById(pictureId);

        if (availablePictures[pictureId].usagePrice == value) {
            pushBuyerPicture(wantedPicture, buyer);
            owner.transfer(value);
        }
    }

    /**
     * @dev Transfers the ownership to the buyer.
     * @param newOwnerID The address of the buyer.
     * @param picture The picture to be bought.
     * @param price The price of the picture.
     */
    function transferOwnership(
        address payable newOwnerID,
        Picture memory picture,
        uint256 price
    ) public {
        owner.transfer(price);
        emit OwnerSet(owner, newOwnerID);
        owner = newOwnerID;

        pushBuyerPicture(picture, owner);
    }

    /**
     * @dev Gets owned pictures.
     */
    function getOwnedPictures() external view returns (Picture[] memory) {
        require(pictures.length > 0, "No pictures available");

        return ownerPictures[owner];
    }

    /**
     * @dev Gets bought pictures.
     */
    function getBoughtPictures() external view returns (Picture[] memory) {
        require(pictures.length > 0, "No pictures available");

        address caller = msg.sender;
        return buyerPictures[caller];
    }

    /**
     * @dev Gets last N pictures.
     */
    function getLastNPictures(uint256 count)
        public
        view
        returns (Picture[] memory)
    {
        Picture[] memory lastPictures;

        for (
            uint256 index = pictures.length - count - 1;
            index < pictures.length;
            index++
        ) {
            // lastPictures.push(pictures[index]); -> .push is not found ???
        }

        return lastPictures;
    }

    /**
     * @dev Gets first N pictures.
     */
    function getFirstNPictures(uint256 count)
        public
        view
        returns (Picture[] memory)
    {
        Picture[] memory firstPictures;

        for (uint256 index = 0; index < pictures.length - count; index++) {
            // firstPictures.push(pictures[index]); -> .push is not found ???
        }

        return firstPictures;
    }

    /**
     * @dev Sets picture's ownership price. Owner only.
     * @param pictureId The id of the picture.
     * @param newPrice The new price;
     */
    function setOwnershipPrice(string memory pictureId, uint256 newPrice)
        external
        view
        isOwner
    {
        require(pictures.length > 0, "No pictures available");

        Picture memory picture = getPictureById(pictureId);
        picture.ownershipPrice = newPrice;
    }

    /**
     * @dev Sets picture's usage price. Owner only.
     * @param pictureId The id of the picture.
     * @param newPrice The new price;
     */
    function setUsagePrice(string memory pictureId, uint256 newPrice)
        external
        view
        isOwner
    {
        require(pictures.length > 0, "No pictures available");

        Picture memory picture = getPictureById(pictureId);
        picture.usagePrice = newPrice;
    }

    /**
     * @dev Change selling status.
     * @param pictureId The id of the picture.
     * @param newStatus The new status;
     */
    function setForSale(string memory pictureId, bool newStatus)
        external
        view
        isOwner
    {
        require(pictures.length > 0, "No pictures available");

        Picture memory picture = getPictureById(pictureId);
        picture.forSale = newStatus;
    }

    /**
     * @dev Removes a picture from the database.
     * @param pictureId The id of the picture to be deleted.
     */
    function deletePicture(string memory pictureId) public isOwner {
        require(pictures.length > 0, "No pictures available");

        Picture memory picture = getPictureById(pictureId);
        delete ownerPictures[picture.ownerId];
    }

    /**
     * @dev Helper function to push a picture into a key/value
     * @param pictureToAdd The picture to be added.
     * @param pictureOwner The address of the owner.
     */
    function pushOwnerPicture(Picture memory pictureToAdd, address pictureOwner)
        private
    {
        Picture[] storage ownedPictures = ownerPictures[pictureOwner];
        ownedPictures.push(pictureToAdd);
        ownerPictures[pictureOwner] = ownedPictures;
        pictures.push(pictureToAdd);
        owners.push(pictureOwner);
    }

    /**
     * @dev Helper function to push a picture into a key/value
     * @param pictureToAdd The picture to be added.
     * @param pictureBuyer The address of the buyer.
     */
    function pushBuyerPicture(Picture memory pictureToAdd, address pictureBuyer)
        private
    {
        Picture[] storage ownedPictures = buyerPictures[pictureBuyer];
        ownedPictures.push(pictureToAdd);
        ownerPictures[pictureBuyer] = ownedPictures;
        pictures.push(pictureToAdd);
        buyers.push(pictureBuyer);
    }

    /**
     * @dev Gets a picture by id.
     * @param pictureId The picture's id.
     */
    function getPictureById(string memory pictureId)
        private
        view
        returns (Picture memory)
    {
        Picture memory wantedPicture;

        for (uint256 index = 0; index < pictures.length; index++) {
            if (
                keccak256(abi.encodePacked(pictures[index].id)) ==
                keccak256(abi.encodePacked(pictureId))
            ) {
                wantedPicture = pictures[index];
            }
        }

        return wantedPicture;
    }
}
