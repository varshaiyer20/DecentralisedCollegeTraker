pragma solidity ^0.5.11;
contract CollegeTracker{
    address private admin;
    constructor () public {
        admin = msg.sender;
    }
    modifier onlyAdmin {
        require(msg.sender == admin, "Only admin can access this functionality.");
        _;
    }
    struct Student{
        string sName;
        string phoneNo;
        string courseName;
        uint added;
        uint updated;
    }

    struct College{
        string collegeName;
        uint regNo;
        uint NumberOfstudents;
        bool blocked;
        uint added;
        uint updated;
        mapping(string => Student) Students;
    }
    mapping(address => College) private Colleges;
    function addCollege(address _add, string memory _collegeName, uint _regNo) public onlyAdmin{
        require(Colleges[_add].added == 0 , "College already added.");
        College storage newCollege = Colleges[_add];
        newCollege.collegeName = _collegeName;
        newCollege.blocked = false;
        newCollege.regNo = _regNo;
        newCollege.NumberOfstudents = 0;
        newCollege.added = block.timestamp;
        newCollege.updated = 0;
    }
    function addStudent(address _add, string memory _sName, string memory _phoneNo, string memory _courseName) public {
        require(Colleges[_add].added != 0, "College address not found!.");
        require(!Colleges[_add].blocked, "College is blocked !");
        require(Colleges[_add].Students[_sName].added == 0, "Student already present");
        Student storage newStudent = Colleges[_add].Students[_sName];
        newStudent.sName = _sName;
        newStudent.courseName = _courseName;
        newStudent.phoneNo = _phoneNo;
        newStudent.added = block.timestamp;
        newStudent.updated = 0;
        Colleges[_add].NumberOfstudents += 1;
    }
    function getCollege(address _add) public view returns(string memory _collegeName, uint _regNo, uint _NumberOfstudents){
        require(Colleges[_add].added != 0, "College not found!");
        _collegeName = (Colleges[_add].collegeName);
        _regNo = Colleges[_add].regNo;
        _NumberOfstudents = Colleges[_add].NumberOfstudents;
    }
    function getStudentDetails(address _add, string memory _sName) public view returns(
        string memory _studentName, 
        string memory _course, 
        string memory _phoneNo)
    {
        require(Colleges[_add].added != 0, "College not found!");
        require(Colleges[_add].Students[_sName].added != 0, "Student not found!");
        _studentName = _sName;
        _course = ( Colleges[_add].Students[_sName].courseName);
        _phoneNo = (Colleges[_add].Students[_sName].phoneNo);
    }
    function blockCollege(address _add) public onlyAdmin{
        require(Colleges[_add].added != 0, "College not found!");
        require(!Colleges[_add].blocked, "Adding Student has been blocked.");
        Colleges[_add].blocked = true;
        Colleges[_add].updated = block.timestamp;
    }
    function UnblockCollege(address _add) public onlyAdmin{
        require(Colleges[_add].added != 0, "College not found!");
        require(Colleges[_add].blocked, "Adding Student not blocked.");
        Colleges[_add].blocked = false;
        Colleges[_add].updated = block.timestamp;
    }
    function changeCourse(address _add, string memory _sName, string memory _updateCourse) public onlyAdmin{
        require(Colleges[_add].added != 0, "College not found!");
        require(!Colleges[_add].blocked, "College is blocked.");
        require(Colleges[_add].Students[_sName].added != 0, "Student not found!");
        Colleges[_add].Students[_sName].courseName = _updateCourse;
        Colleges[_add].Students[_sName].updated = block.timestamp;
    }
}
