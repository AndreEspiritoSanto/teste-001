// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract UserDatav2 {

  // Define a struct to store user data
  struct User {
    string name;
    uint256 dateOfBirth; // Store date of birth as unix timestamp
    string knownAddress;
    string nationality;
  }

  // Mapping to store user data by address
  mapping(address => User) public users;

  // Function to add a new user
  function addUser(string memory _name, uint256 _dateOfBirth, string memory _knownAddress, string memory _nationality) public {
    users[msg.sender] = User(_name, _dateOfBirth, _knownAddress, _nationality);
  }

  // Function to update user data (requires current user to call)
  function updateUser(string memory _name, uint256 _dateOfBirth, string memory _knownAddress, string memory _nationality) public {
    users[msg.sender] = User(_name, _dateOfBirth, _knownAddress, _nationality);
  }

  // Function to get user data by address (view function - doesn't modify state)
  function getUser(address _userAddress) public view returns (string memory name, uint256 dateOfBirth, string memory knownAddress, string memory nationality) {
    User storage user = users[_userAddress];
    return (user.name, user.dateOfBirth, user.knownAddress, user.nationality);
  }

  // Function to list all users (not recommended for large datasets due to gas cost)
function getAllUsers() public view returns (User[] memory) {
    User[] memory allUsers = new User[](addressCount()); // Dynamically allocate memory based on user count
    for (uint i = 0; i < addressCount(); i++) {
      address userAddress = address(uint160(i)); // Convert index to address
      (string memory name, uint256 dateOfBirth, string memory knownAddress, string memory nationality) = getUser(userAddress);
      allUsers[i] = User(name, dateOfBirth, knownAddress, nationality);
    }
    return allUsers;
}

  // Internal function to get the number of users (used by getAllUsers)
  function addressCount() internal view returns (uint) {
      return uint256(block.number) - uint256(blockhash(block.number - 1)); // Convert both values to uint256
  }
}
