$(document).ready(function(){
	App.message = App.cable.subscriptions.create("MessageChannel", {
	  connected: function() {
	    // Called when the subscription is ready for use on the server
	    console.log("Connected");
	  },

	  disconnected: function() {
	    // Called when the subscription has been terminated by the server
	    console.log("Disconnected");
	  },

	  received: function(data) {
	  	debugger;
	    // Called when there's incoming data on the websocket for this channel
	    $('#chat').prepend(data.content);
	    $('#new_message')[0].reset();
	  }
	});
});
