#  Square Integration for Taking 'Online Payments' with Swift
Square is a great company for small businesses to grow their business using Square's beautiful POS Mobile application as a register for in-store payments. They have a number of client side SDKs available for e-commerce over the web. However they currently do not have a mobile client for 'online-payments' unlike their competitors Braintree and Stripe which have great client SDKs. I tried to solve this with this project. Square has alot of server side SDK's but in order to store customer cards and handle transactions you need to generate a card nonce. This encrypted card data is generated using Square's 'SqPaymentForm', which is only available for Javascript. I used a webview in Swift to let users enter their card data and send the nonce back to my client so that I can then make the next call to my backend to store the card on file or use it for a purchase. Below is an outline of how to integrate Square into your Swift application for your own needs.

## Frontend:
1. Uses Swift's URLSession that can call back-end functions to Square's apis
2. A Webview to display Square's SqPaymentForm to get nonces for payment methods that you may or may not want to store on file for customers
            
## Backend:
1. Nodejs functions using Square's 'square-connect' package from npm
2. Api endpoints for Squares Api
```
CustomersApi:
    Create Customer
    Retrieve Customer
    Retrieve Customer Cards
    Create Customer Card
    Delete Customer Card
                            
OrdersApi:
    Create Order
                            
TransactionsApi:
    Charge
```
## Static-web-page
Host the index.html file on a website or you can host a static web page using Amazon Web Services S3 buckets. I would recommend using AWS because it is an easy way to interact with the file without having to worry about servers. Just make sure to secure the endpoint if using for production.

