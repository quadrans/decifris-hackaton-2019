pragma solidity >=0.4.22 <0.7.0;
contract GreenPayment {
    
    struct Person {
        bool seller;
        uint tot;
    }
    
    struct Queue {
        address[] ad ;
        uint front;
        uint back;
    }

    mapping(address => Person) people;
    Queue market;

    constructor() public {
        addMarket(msg.sender);
    }
    
    event Sent(address ad);

    /// @dev the number of elements stored in the queue.
    function length(Queue storage q) internal view returns (uint) {
        return q.back - q.front;
    }
    /// @dev the number of elements this queue can hold
    function capacity(Queue storage q) internal view  returns (uint) {
        return q.ad.length - 1;
    }
    /// @dev push a new element to the back of the queue
    function push(Queue storage q, address ad) internal
    {
        if ((q.back + 1) % q.ad.length == q.front)
            return; // throw;
        q.ad[q.back] = ad;
        q.back = (q.back + 1) % q.ad.length;
    }
    /// @dev remove and return the element at the front of the queue
    function pop(Queue storage q) internal returns (address ad)
    {
        require(q.back != q.front, "Coda vuota");
        ad = q.ad[q.front];
        delete q.ad[q.front];
        q.front = (q.front + 1) % q.ad.length;
    }
   
    function QueueUserMayBeDeliveryDroneControl() private {
        market.ad.length = 200;
    }
    
    function addMarket(address d) private {
        push(market, d);
    }
    
    function popMarket() private returns (address) {
        return pop(market);
    }
    
    function queueLength() private view returns (uint) {
        return length(market);
    }
    
    ///////////////////
    
    function insertion (address ad) public payable {
        require(people[ad].seller==true, "non può vendere");
        require(people[ad].tot>=msg.value, "non ha abbastanza crediti");
        for(uint i=1;i<=msg.value;i++) {
            addMarket(ad);
        }
    }
    
    function buying (address ad) public payable{
        require(msg.value<=queueLength(), "Non ci sono abbastanza crediti nel sistema");
        for(uint i=1;i<msg.value;i++) {
            address a=popMarket();
            people[a].tot-=1;
        }
        people[ad].tot+=msg.value;
        emit Sent(ad);
    }
    
    //  @dev suppose that the seller knows a secret previously shared with
    //  the smart contract manager and sends an encrypted message with RSA
    //  the secret is the number 100 the sellers know the rsa key (733763, 541079)
    //  so they can authenticate themselves by encrypting the message 100 with the key
    function verify (uint value, address ad) public payable {
        uint dec=(value^23)%733763;
        require(dec==100, "autenticazione non valida");
        people[ad].seller=true;
        people[ad].tot=100;
    }
    
}
