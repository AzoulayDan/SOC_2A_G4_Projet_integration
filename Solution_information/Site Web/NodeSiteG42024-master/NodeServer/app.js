var express = require('express');
var bodyParser = require('body-parser');
var fs = require('fs');
var app = express();
var http = require('http').Server(app);
var LanguageTranslationV2 = require('watson-developer-cloud/language-translation/v2');
var prompt = require('prompt-sync')();
var ConversationV1 = require('watson-developer-cloud/conversation/v1');
var io = require('socket.io')(http);

var langue = "fr";
var trad = "en";
var newMessageFromUser = "";
var newMessageFromServer ="";
var endConversation = false;

// Set up Conversation service.
var conversation = new ConversationV1({
  username: 'ce1502f1-f010-4876-884f-250965daf785', // replace with username from service key
  password: 'sfGzZIHRvG1m', // replace with password from service key
  path: { workspace_id: '4868b21e-7024-4497-9eba-31ac52c76fa7' }, // replace with workspace ID
  version_date: '2016-07-11'
});

var language_translation = new LanguageTranslationV2({
  url: "https://gateway.watsonplatform.net/language-translator/api",
  username: '7ac85371-2117-47d8-a03b-ea0172ff8997',
  password: '7DuDleJ0CJBf'
});

app.use(express.static('public'));
app.use(bodyParser.json()); // for parsing application/json

io.on('connection', function(socket){
  console.log('a user connected');
  socket.on('disconnect', function(){
    console.log('user disconnected');
    endConversation = true;
  });
});

app.get('/', function (req, res) {
	fs.readFile("./index.html", 'utf8', function (errors, contents) {
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
});

app.get('/presentation', function(req, res){
	fs.readFile("./presentation.html", 'utf8', function (errors, contents) {
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
});

app.get('/planning', function(req, res){
	fs.readFile("./planning.html", 'utf8', function (errors, contents) {
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
});

app.get('/social', function(req, res){
	fs.readFile("./social.html", 'utf8', function (errors, contents) {
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
});

app.get('/plan/stades', function(req, res){
	fs.readFile("./stades.html", 'utf8', function (errors, contents) {
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
});

app.get('/plan/transports', function(req, res){
	fs.readFile("./transports.html", 'utf8', function (errors, contents) {
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
});

app.get('/plan/restaurants', function(req, res){
	fs.readFile("./restaurants.html", 'utf8', function (errors, contents) {
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
});

app.get('/plan/hotels', function(req, res){
	fs.readFile("./hotels.html", 'utf8', function (errors, contents) {
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
})

app.get('/dashboard', function(req, res){
	fs.readFile("./dashboard.html", 'utf8', function(errors, contents){
		if(errors){
		  console.log(errors);
		}else{
		  res.end(contents);
		}
	});
})

app.post('/translateToolbarInEnglish', function(req,res){
	language_translation.translate({
      text: [req.body.accueil, req.body.presentation, req.body.plan, req.body.stades, req.body.restaurants, req.body.hotels, req.body.social], source : 'fr', target : 'en'},
      function (err, translation) {
        if (err)
            console.log('error:', err);

        else{
            //console.log(JSON.stringify(translation, null, 2));
            console.log(JSON.stringify(translation['translations']));
            res.send(JSON.stringify(translation['translations']));
        }
  });
})

app.post('/translateElementsInEnglish', function(req, res){
  //console.log(req.body.texth1);
  //console.log(req.body.texth2);
  //console.log(req.body.texth3);
  
  

  language_translation.translate({
      text: [req.body.texth1, req.body.texth2, req.body.texth3], source : 'fr', target: 'en' },
      function (err, translation) {
        if (err)
            console.log('error:', err);

        else{
            //console.log(JSON.stringify(translation, null, 2));
            console.log(JSON.stringify(translation['translations']));
            res.send(JSON.stringify(translation['translations']));
        }
  });
  
  langue = "en";
  trad = "fr";

});

app.get('/initconversation', function(req, res){
	// Start conversation with empty message.
	conversation.message({}, processResponse);
})

// Process the conversation response.
function processResponse(err, response) {

  if (err) {
    console.error(err); // something went wrong
    return;
  }

  
  
  if (response.output.action === 'end_conversation') {
    // User said goodbye, so we're done.
    console.log(response.output.text[0]);
    endConversation = true;
  } else {
    // Display the output from dialog, if any.
    if (response.output.text.length != 0) {
        console.log(response.output.text[0]);
        if(langue == "en"){
	    	language_translation.translate({
	    		text: response.output.text[0], source : trad, target: langue },
	    		function(err, translation){
	    			if(err)
	    				console.log("error:", err);
	    			else{
	    				newMessageFromServer = JSON.stringify(translation.translations[0].translation);
	    				console.log(newMessageFromUser);
	    			}
	    		}
	    	);
	    }
	    console.log(newMessageFromServer);
        io.emit('chat message', newMessageFromServer);

    }
  }

  // If we're not done, prompt for the next round of input.
  if (!endConversation) {

    io.on('chat message', function(socket){
	  socket.on('chat message', function(msg){
	    console.log('message: ' + msg);
	    newMessageFromUser = msg;
	    io.emit('chat message', msg);
	    
	  });
	});
	
  
	conversation.message({
	    	  input: { text: newMessageFromUser }, context : response.context }, processResponse)
    newMessageFromUser = "";	
		
  }

}
 
http.listen(8080)