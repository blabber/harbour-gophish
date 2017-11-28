WorkerScript.onMessage = function(message) {
	WorkerScript.sendMessage({'current': 0, 'max': message.items.length});

	for (var i = 0; i < message.items.length; i++) {
		message.model.append(message.items[i]);

		if (i%10==0) {
			message.model.sync();
			WorkerScript.sendMessage({'current': i, 'max': message.items.length});
		}
	}

	message.model.sync();
	WorkerScript.sendMessage({'current': message.items.length, 'max': message.items.length});
}
