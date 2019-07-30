pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum,msg.sender);
		
		deployedCampaigns.push(newCampaign);
		}

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
	
    struct Inf {
        string descrip;
		uint date;
    }
	
    Request[] public requests;
    Inf[] public camp; 
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
	
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Campaign(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
        
    }
    
    function addDet(string descrip,uint date) public restricted{
	Inf memory newInf = Inf({
           descrip: descrip,
		   date:date
        });
        camp.push(newInf);
    }
	
	 function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });

        requests.push(newRequest);
    }
	
    // function getd() public view returns(uint,string,address,uint,uint,uint)
    //     {
    //         Inf  storage campp=camp[0];
    //         return (
       
    //         campp.description,
            
    //         this.balance,
    //       requests.length,
    //       approversCount
    //         );
     //   }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

   

    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }
    // function getSummary() public view returns(uint,string,address,uint,uint,uint)
    //     {
    //         Inf  storage campp=camp[0];
    //         return (
    //         campp.minimum,
    //         campp.description,
    //         campp.sender,
    //         this.balance,
    //       requests.length,
    //       approversCount
    //         );
    //     }


    function getSummary() public view returns (
      uint, uint, uint, uint, address,string
      ) {
          Inf  storage campp=camp[0];
        return (
          minimumContribution,
          this.balance,
          requests.length,
          approversCount,
          manager,
          campp.descrip
        );
    }
   

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}
