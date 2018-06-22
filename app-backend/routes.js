'use strict';

// Node Packages
const express = require('express');
const SquareConnect = require('square-connect');
const bodyParser = require('body-parser');

const defaultClient = SquareConnect.ApiClient.instance;

var oauth2 = defaultClient.authentications['oauth2'];
oauth2.accessToken = 'YOUR_SANDBOX_ACCESS_TOKEN';

var router = express.Router();

////////////////////////////////////////////////////////
////////// MARK: - Customers API //////////////////////
//////////////////////////////////////////////////////

// MARK: - Creates Customer Object
//         body params: 
//         given_name, email_address, phone_number
router.post('/createCustomer', function(req, res) {

  var custApi = new SquareConnect.CustomersApi();

  var givenName = req.body.givenName;
  var emailAddress = req.body.emailAddress;
  var phoneNumber = req.body.phoneNumber;

const body = {
  given_name: givenName,
  email_address: emailAddress,
  phone_number: phoneNumber
};

  custApi.createCustomer(body).then(function(data) {
    res.json(data);
  }, function(error) {
    res.json(error);
  });

});

// MARK: - Retrieves Customer Object 
//         body params:
//         customer_id
router.post('/retrieveCustomer', function(req, res) {

  var custApi = new SquareConnect.CustomersApi();

  var customerId = req.body.customerId;

  custApi.retrieveCustomer(customerId).then((response) => {
      if (response)
      {
        res.json(response);
      } else {
        res.json(response.error);
      }
    });

});

// MARK: - Retrieves Customer Object and returns cards on file
//         body params:
//         customer_id
router.post('/retrieveCustomerCards', function(req, res) {

  var custApi = new SquareConnect.CustomersApi();

  var customerId = req.body.customerId;

  custApi.retrieveCustomer(customerId).then((response) => {
      if (response)
      {
        var cards = response.customer.cards;
        res.json(cards);
      } else {
        res.json(response.error.field);
      }
    });

});

// MARK: - Creates Customer Card Object
//         body params: 
//         customer_id, card_nonce
router.post('/createCustomerCard', function(req, res) {

  var custApi = new SquareConnect.CustomersApi();

  var customerId = req.body.customerId;
  var cardNonce = req.body.cardNonce;

  const customerid = customerId;
  const body = {
    card_nonce: cardNonce
  };

  custApi.createCustomerCard(customerid, body).then((response) => {
      if (response)
      {
        res.json(response);
      }
    });

});

// MARK: - Deletes Customer Card Object
//         body params:
//         customer_id, customer_card_id
router.post('/deleteCustomerCard', function(req, res) {

  var custApi = new SquareConnect.CustomersApi();

  var customerId = req.body.customerId;
  var cardId = req.body.cardId;

  custApi.deleteCustomerCard(customerId, cardId).then((response) => {
      if (response)
      {
        res.json(response);
      } else {
        res.json(response.error);
      }
    });

});

////////////////////////////////////////////////////////
///////////// MARK: - Orders API //////////////////////
//////////////////////////////////////////////////////

// MARK: - Creates an Order Object
//         body params: 
//         location_id, line_items
router.post('/createOrder', function(req, res) {

  const ordersApi = new SquareConnect.OrdersApi();
  const idempotencyKey = require('crypto').randomBytes(32).toString('hex');

  var locationId = req.body.locationId;

  var lineItems = req.body.lineItems;
  var name = lineItems.name;
  var quantity = lineItems.quantity;
  var amount = lineItems.amount;

  var items = [];

  for (var i in lineItems) {
    var item = lineItems[i];

     items.push({
      "name": item.name,
      "quantity": item.quantity.toString(),
      "base_price_money": {
        "amount": item.amount,
        "currency": "USD"
      }
    });
  };

  const body = {
    idempotency_key: idempotencyKey,
    line_items: items
  };

  ordersApi.createOrder(locationId, body).then((response) => {

    if (response)
    {
      res.json(response);
    } else {
      res.json(response.error);
    }

  });

});

////////////////////////////////////////////////////////
////////// MARK: - Transactions API ///////////////////
//////////////////////////////////////////////////////

// MARK: - Charges a Customer
//         body params: 
//         location_id, amount, customer_card_id, customer_id
router.post('/charge', function(req, res) {

  const tranApi = new SquareConnect.TransactionsApi();

  const idempotencyKey = require('crypto').randomBytes(32).toString('hex');
  var locationId = req.body.locationId;
  var amount = req.body.amount;
  var customerCardId = req.body.customerCardId;
  var customerId = req.body.customerId;

  const body = {
    idempotency_key: idempotencyKey,
    amount_money: {
      amount: amount, currency: "USD"
    },
    customer_card_id: customerCardId,
    customer_id: customerId
  };

  tranApi.charge(locationId, body).then((response) => {

    if (response)
    {
      res.json(response);
    } else {
      res.json(response.error);
    }

  });

});

// route to api endpoint
module.exports = router;