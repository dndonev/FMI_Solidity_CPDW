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

    address payable private owner;
    mapping(string => Picture) private availablePictures;
    mapping(address => Picture[]) private ownerPictures;
    mapping(address => Picture[]) private buyerPictures;
    mapping(string => Picture) private exists;
    Picture[] private pictures;
    address[] private owners;
    address[] private buyers;

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
     * @param file the hash of the file.
     * @param price the price of the picture.
     * @param forSale is it for sale.
     * @param id picture's id.
     */
    function addPicture(
        string memory file,
        uint256 price,
        bool forSale,
        string memory id
    ) public {
        address pictureOwner = msg.sender;
        uint256 usagePrice = price / 2;
        Picture memory pictureToAdd =
            Picture({
                ownershipPrice: price,
                usagePrice: usagePrice,
                forSale: forSale,
                ownerId: owner,
                id: file,
                transferable: true
            });

        availablePictures[id] = pictureToAdd;

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
    function getOwnedPictures() public view returns (Picture[] memory) {
        return ownerPictures[owner];
    }

    /**
     * @dev Gets bought pictures.
     */
    function getBoughtPictures() public view returns (Picture[] memory) {
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
     * @dev Removes a picture from the database.
     * @param pictureId The id of the picture to be deleted.
     */
    function deletePicture(string memory pictureId) public isOwner {}

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
    }

    /**
     * @dev Helper function to push a picture into a key/value
     * @param pictureToAdd The picture to be added.
     * @param pictureOwner The address of the owner.
     */
    function pushBuyerPicture(Picture memory pictureToAdd, address pictureOwner)
        private
    {
        Picture[] storage ownedPictures = buyerPictures[pictureOwner];
        ownedPictures.push(pictureToAdd);
        ownerPictures[pictureOwner] = ownedPictures;
        pictures.push(pictureToAdd);
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
