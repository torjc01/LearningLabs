// Requires
const express = require('express'); 
const bodyParser = require('body-parser'); 

// Initializations
const app = express(); 
const PORT = 3000; 

// Use body-parser for json parsing 
app.use(bodyParser.json()); 

app.post("/hook", (req, res) => {
    console.log("===================== HOOK ANSWER ==========================");
    console.log(req.body); 
    res.status(200).end();
}); 
// Start express server at the defined port
app.listen(PORT, () => console.log(`Server running on port ${PORT}`)); 