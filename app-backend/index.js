'use strict';

var express = require('express');
var bodyParser = require('body-parser');

var app = express();

// Using application/json request and response
app.use(bodyParser.json({ type: 'application/json' }));
app.use('/routes', require('./routes'));

// Running on port 3000 for development purposes
var port = 3000;
app.listen(port);

// Api Status
app.get('/', function(req, res) {
res.send('Api is up and running! :)');
console.log('Api Running');
})

module.exports = app;
