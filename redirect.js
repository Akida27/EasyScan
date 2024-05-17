// Importing the 'express' package for creating a web application
const express = require('express');
// Importing 'body-parser' for parsing request data (used later)
const port = 8081;
// Creating the Express application
const app = express();

// Define a route to handle the redirection
app.get('/', (req, res) => {
    // Assume the code is sent as a query parameter
    var code = req.query.code;
    console.log(req.query);
    if (code) {
        // Redirect to your app
        res.redirect(`easyscan://redirect?code=${code}`);
    } else {
        // Handle the case when code is not provided
        res.status(400).send('Authorization code is missing');
    }
});

// runs the app and listens to the port
app.listen(port, () => {
    console.log(`Server running and listening on port ${port}...`)
})
