// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FavoriteRecords {
    // --- Custom Error ---
    error NotApproved(string album);

    // --- State Variables ---
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) private userFavorites;

    // To keep track of keys for approved records and user favorites
    string[] private approvedList;
    mapping(address => string[]) private userFavoriteList;

    // --- Constructor: Load Approved Records ---
    constructor() {
        _addApprovedRecord("Thriller");
        _addApprovedRecord("Back in Black");
        _addApprovedRecord("The Bodyguard");
        _addApprovedRecord("The Dark Side of the Moon");
        _addApprovedRecord("Their Greatest Hits (1971-1975)");
        _addApprovedRecord("Hotel California");
        _addApprovedRecord("Come On Over");
        _addApprovedRecord("Rumours");
        _addApprovedRecord("Saturday Night Fever");
    }

    // Internal function to add approved records
    function _addApprovedRecord(string memory album) internal {
        approvedRecords[album] = true;
        approvedList.push(album);
    }

    // --- Get Approved Records ---
    function getApprovedRecords() external view returns (string[] memory) {
        return approvedList;
    }

    // --- Add Record to Favorites ---
    function addRecord(string memory album) external {
        if (!approvedRecords[album]) {
            revert NotApproved(album);
        }

        // Add to mapping and list if not already added
        if (!userFavorites[msg.sender][album]) {
            userFavorites[msg.sender][album] = true;
            userFavoriteList[msg.sender].push(album);
        }
    }

    // --- Get User Favorites ---
    function getUserFavorites(address user) external view returns (string[] memory) {
        return userFavoriteList[user];
    }

    // --- Reset My Favorites ---
    function resetUserFavorites() external {
        string[] storage favorites = userFavoriteList[msg.sender];
        for (uint i = 0; i < favorites.length; i++) {
            userFavorites[msg.sender][favorites[i]] = false;
        }
        delete userFavoriteList[msg.sender];
    }
}
