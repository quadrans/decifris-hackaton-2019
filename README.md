# decifris-hackaton-2019
## "Food, Health & Sustainability"

This Smart Contract handles the exchange of green energy credits.

Users are characterised by:
-"seller":  a boolean value which is true if the user can sell new credits, otherwise the user can only buy credits;
-"tot": an integer value representing the number of credits he has bought.

Users can buy and sell credits in a market which is a queue of credits with 100 slots.

When a credit is bought by some user, the credit is popped from the front of the market; when a seller want to sell some credits his credits are pushed in the back of the market.

Everybody is authorised to buy new credits, only users whose boolean variable "seller" is true are authorised to push credits in the market.
The credit placed in the market are represented with the address of the seller who pushed it inside. The buyer will pay the the address associated to the credit he has bought. 
In order to authenticate as a seller, we assume that the seller knows a cryptographic secret (in this case an RSA key) which allows him switch the varibale "seller" from false to true.


The operations a user can perform are:
1)buying new credits using function BUYING
2)prove to the smart contract he knows the secret that authorizes him to sell credits using function VERIFY
3)sell some credits using function SELLING


## Prossible upgrades:

-Expand the market with a flexible number of slots. 
-The secret is the encryption of 100 using an RSA key only known by the sellers (in this case sk=(733763, 541079)) . 
This means that the ciphertext (100^ 541079 mod 733763)  can be known by everyone in the network. Hence everyone in the network can authenticate as a seller being the transaction requests public. 

A fix which can be performed is the following: instead of setting the secret RSAEncryption(100,sk) we can set RSAEncryption(address,sk). 
In this way the ciphertext is different for every user and only the sellers can produce a valid ciphertext for their address.
When the smart contract decrypts the ciphertext it verifies that the plaintext obtained is the address of the user who wanted to authenticate using the function Verify. 

## De Componendis Cifris

organizes a Smart Contract Hackathon 2019. The aim of this event is to help those
looking to kickstart effort into programming smart contracts using Solidity. Focused on building smart contract
applications, the event is a one day 4-person (max) team competition and it has a prize pool of € 6000,
provided by Quadrans Foundation and Athilab srl. Two projects will be rewarded (€ 3000 each).
The hackathon will be open to all who have an interest in Blockchain and Smart Contracts, students but not
only, though on a first-come first-served basis (places are limited).
The event will be hosted by Department of Computer Science @UniMi (Aula Magna A.Bertoni, Via Celoria
18, Milano), Department of Mathematics @UniTn and FBK (Sala Consiglio, Via Sommarive 18, Povo, Trento).

Participants in the hackathon have to register through the following link: https://www.decifris.it/
Contact person: Andrea Visconti (andrea.visconti@unimi.it)
