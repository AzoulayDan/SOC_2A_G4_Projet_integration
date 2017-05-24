var prompt = require('prompt-sync')();
var ConversationV1 = require('watson-developer-cloud/conversation/v1');

// Set up Conversation service.
var conversation = new ConversationV1({
  username: 'ce1502f1-f010-4876-884f-250965daf785', // replace with username from service key
  password: 'sfGzZIHRvG1m', // replace with password from service key
  path: { workspace_id: '4868b21e-7024-4497-9eba-31ac52c76fa7' }, // replace with workspace ID
  version_date: '2016-07-11'
});

// Start conversation with empty message.
conversation.message({}, processResponse);

// Process the conversation response.
function processResponse(err, response) {
  if (err) {
    console.error(err); // something went wrong
    return;
  }

  var endConversation = false;
  
  // Check for action flags.
  if (response.output.action === 'display_time') {
    // User asked what time it is, so we output the local system time.
    console.log('The current time is ' + new Date().toLocaleTimeString());
  } else if (response.output.action === 'end_conversation') {
    // User said goodbye, so we're done.
    console.log(response.output.text[0]);
    endConversation = true;
  } else {
    // Display the output from dialog, if any.
    if (response.output.text.length != 0) {
        console.log(response.output.text[0]);
    }
  }

  // If we're not done, prompt for the next round of input.
  if (!endConversation) {
    var newMessageFromUser = prompt('>> ');
    conversation.message({
      input: { text: newMessageFromUser },
      // Send back the context to maintain state.
      context : response.context,
    }, processResponse)
  }
}