const express = require('express');
const algolia = require('algoliasearch');

const app = express()
const client = algolia('8S7QPI6PAJ', '95c388163cfc1b25db5ba76069716fea');
const index = client.initIndex('users');

app.use(express.json())    // <==== parse request body as JSON


app.post('/', async (req, res) => {


    try{
     await index
    .saveObjects([{ objectID: req.body.id, username: req.body.username, userAvatar: req.body.user_avatar}]);
    res.status(200).json({msg: req.body});
  
    }catch(e){
       res.status(400).json({e: e.message});
    }

   

});


const PORT = process.env.PORT || 500;
app.listen(PORT, () => {
    console.log("The app has started");
});
