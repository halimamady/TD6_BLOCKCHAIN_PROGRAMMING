pragma solidity ^0.4.25;

import "./ERC721.sol";
import "../math/SafeMath.sol";

contract Place is ERC721 {
    using SafeMath for uint256;
    address private _moderator;

    struct Animal 
    {
        address creator;
        string name;
        bool gender; 
        bool alive;
        int age;
    }

    Animal[] public Animals;

    event BreederAdded(address indexed breeder);
    event declareAnimal(uint objectNumber);

    mapping (address => bool) private _registerBreeder;
    mapping (uint256 => address) private _tokenOwner;

    modifier onlyOwner() {
        require(msg.sender == _moderator, "Owner 0x0");
        _;
    }

    function owner() public view returns (address) {
        return _moderator;
    }

    modifier isRegister(address _address) {
        require(_registerBreeder[_address], "not in registerBreeder");
        _;
    }

    function registerBreeder(address _address) public onlyOwner() {
        require(!_registerBreeder[_address], "aldready in registerBreeder");
        _registerBreeder[_address] = true;
        emit RegisterBreederedAdded(_address);
    }

    function isInRegister(address _address) public view returns (bool) {
        return _registerBreeder[_address];
    }

    function declareAnimal(string _name, int _age, bool _gender) public  // true = female,  false= male
    {
        Animal memory _Animal;
        require(isInRegister(msg.sender));

        _Animal.creator = msg.sender;
        _Animal.name = _name;
        _Animal.gender = _gender;
        _Animal.age = _age;
        _Animal.alive = true;

        Animals.push(_Animal) - 1;
        uint objectNumber = Animals.length - 1;
        _tokenOwner[objectNumber] = msg.sender;
        emit declareAnimal(objectNumber);
    }

    function deadAnimal(uint _animalNumber) public {
        require(_tokenOwner[_animalNumber] == msg.sender);
        Animals[_animalNumber].alive = false;
    }


    function breedAnimal(uint _femaleNumber, uint _maleNumber, string _name,bool _gender ) public 
    {
        require((Animals[_femaleNumber].sort == true) && (Animals[_maleNumber].gender== false));
        require((_tokenOwner[_femaleNumber] == msg.sender) || (_tokenOwner[_maleNumber] == msg.sender));
        declareAnimal (_name, Animals[_femaleNumber].kind, 0, Animals[_maleNumber].strength,_sort);
    }


}
