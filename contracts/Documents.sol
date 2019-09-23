pragma solidity ^0.5.0;

import "@openzeppelin/contracts/cryptography/ECDSA.sol";

contract Documents {

    using ECDSA for bytes32;

    // Modifiers

    modifier onlyBy(address _account) {
        require(
            msg.sender == _account,
            "Sender not authorized"
        );
        // Do not forget the "_;"! It will
        // be replaced by the actual function
        // body when the modifier is used.
        _;
    }

    // Structs

    struct Document {
        address issuer;
        string fileDigest;
        string contentDigest;
        uint validFrom;
        uint expirationDate;
        uint createdAt;
        bool valid;
    }

    // Events

    event DocumentIssued(
        uint id,
        address issuer,
        string fileDigest,
        string contentDigest,
        uint validFrom,
        uint expirationDate,
        uint createdAt
    );

    event DocumentInvalidated(
        uint id
    );

    event DocumentValidated(
        uint id
    );

    // Properties

    address private owner;

    uint numDocuments;
    mapping (uint => Document) documents;

    mapping(string => uint) contentDigests;
    mapping(string => uint) fileDigests;

    constructor() public {
      owner = msg.sender;
    }

    function issue(
        string calldata fileDigest,
        string calldata contentDigest,
        uint validFrom,
        uint expirationDate,
        address issuer,
        bytes calldata signature
    ) external onlyBy(owner) {

        // avoid duplicates
        require(
            contentDigests[contentDigest] == 0,
            "Content digest exists"
        );

        require(
            fileDigests[fileDigest] == 0,
            "File digest exists"
        );

        address signer = keccak256(
          abi.encodePacked(fileDigest, contentDigest, validFrom, expirationDate)
        ).toEthSignedMessageHash().recover(signature);

        require(
            signer == issuer,
            "Issuer address does not match signer address"
        );

        require(
            expirationDate > now,
            "Invalid expiration date"
        );

        require(
            expirationDate > validFrom,
            "expirationDate should be greater than validFrom"
        );

        uint id = ++numDocuments;
        uint createdAt = now;

        documents[id] = Document(
          signer,
          fileDigest,
          contentDigest,
          validFrom,
          expirationDate,
          createdAt,
          validFrom <= createdAt
        );

        contentDigests[contentDigest] = id;
        fileDigests[fileDigest] = id;

        emit DocumentIssued(id, signer, fileDigest, contentDigest, validFrom, expirationDate, createdAt);
    }

    function remove(uint id) external onlyBy(owner) {
        delete contentDigests[documents[id].contentDigest];
        delete fileDigests[documents[id].fileDigest];
        delete documents[id];
    }

    function invalidate(uint id) external onlyBy(owner) {
        documents[id].valid = false;
        emit DocumentInvalidated(id);
    }

    function validate(uint id) external onlyBy(owner) {
        documents[id].valid = true;
        emit DocumentValidated(id);
    }

    function isExpired(uint id) public view returns (bool) {
        return documents[id].expirationDate < now;
    }

    function isValid(uint id) external view returns (bool) {
        return !isExpired(id) && documents[id].validFrom > now && documents[id].valid;
    }

    function getDocument(uint id) public view returns (
        address issuer,
        string memory fileDigest,
        string memory contentDigest,
        uint validFrom,
        uint expirationDate,
        uint createdAt,
        bool valid
    ) {
        Document memory document = documents[id];
        return (
            document.issuer,
            document.fileDigest,
            document.contentDigest,
            document.validFrom,
            document.expirationDate,
            document.createdAt,
            document.valid
        );
    }

    function getDocumentByFileDigest(string calldata digest) external view returns (
        address issuer,
        string memory fileDigest,
        string memory contentDigest,
        uint validFrom,
        uint expirationDate,
        uint createdAt,
        bool valid
    ) {
        uint id = fileDigests[digest];
        return getDocument(id);
    }

    function getDocumentByContentDigest(string calldata digest) external view returns (
        address issuer,
        string memory fileDigest,
        string memory contentDigest,
        uint validFrom,
        uint expirationDate,
        uint createdAt,
        bool valid
    ) {
        uint id = contentDigests[digest];
        return getDocument(id);
    }

    function getNumDocuments() external view returns (uint) {
        return numDocuments;
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}