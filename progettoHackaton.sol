pragma solidity >=0.4.22 <0.7.0;
contract GreenPayment {
    
    struct Person {
        bool seller;
        uint tot; // numero crediti green acquistati
    }
    
    struct Queue {
        address payable[] ad;
        uint front;
        uint back;
    }
    
    /// @dev the number of elements stored in the queue.
    function length(Queue storage q) internal view returns (uint) {
        return q.back - q.front;
    }

    /// @dev the number of elements this queue can hold
    function capacity(Queue storage q) internal view  returns (uint) {
        return q.ad.length - 1;
    }

    /// @dev push a new element to the back of the queue
    function push(Queue storage q,  address payable ad) internal
    {
        if ((q.back + 1) % q.ad.length == q.front)
            return; // throw;
        q.ad[q.back] = ad;
        q.back = (q.back + 1) % q.ad.length;
    }

    /// @dev remove and return the element at the front of the queue
    function pop(Queue storage q) internal returns (address payable ad)
    {
        require(q.back != q.front, "Coda vuota");
        ad = q.ad[q.front];
        delete q.ad[q.front];
        q.front = (q.front + 1) % q.ad.length;
    }
    
    function addMarket(address payable d) private {
        push(market, d);
    }
    
    function popMarket() internal returns (address payable) {
        return pop(market);
    }
    
    function queueLength() private view returns (uint) {
        return length(market);
    }
    
    mapping(address => Person) public people;
    Queue public market;
    uint price = 10**18; // price of a green energy credit WEI

    constructor() public {
        address payable[] memory b=new address payable[](100);
        market=Queue(b,0,0);
    }

    //selling: if ad is a seller, push amount credits in the market
    function selling (uint amount, address payable ad) public payable {
        require(people[ad].seller==true, "non può vendere");
        require(amount+queueLength()<=100, "Non c'è abbastanza spazio sul mercato");
        for(uint i=1;i<=amount;i++) {
            addMarket(ad);
        }
       
    }
    
    //buying: pops the first amount of credits from the market, sets the value tot associated to the buyer to tot:=tot+amount. The buyer pays the seller for the credits he bought.
    function buying (uint amount) public payable{
        require(amount<=queueLength(), "Non ci sono abbastanza crediti nel sistema");
        for(uint i=0;i<amount;i++) {
            address payable venditore = popMarket();
            venditore.transfer(price);
            //pagare l'indirizzo a un tot di ether
        }
        msg.sender.transfer(msg.value - (price*amount));
        people[msg.sender].tot+=amount;
        //emit Sent(ad);
    }
        
    //used to compute powers of big numbers
    function power(int a, int b, int m) internal returns (int){
        int res = 1;
        a = a % m;
        if (a == 0) {return 0;}
        while (b > 0){
            if(b & 1 == 1){
                res = (res * a) % m;
            }
            b = b >> 1;
            a = (a*a) % m;
        }
         return res;
    }
    
    //verify: takes as input a uint and a address (which wants to authenticate as a seller), if the authentication is valid the function sets seller=true.
    function verify (int v, address payable ad) public {
        if (people[ad].seller == false){
            int dec = power (v, 23, 733763);
            require(dec==100, "autenticazione non valida");
            people[ad].seller=true;
        }
    }
    
    
}
