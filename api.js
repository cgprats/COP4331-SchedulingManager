//var token = require('./createJWT.js');

exports.setApp = function(app, client) {
	app.post('/api/login', async (req, res, next) => {
		// incoming: login, password
		// outgoing: id, firstName, lastName, error
		var errorMessage = '';

		const { login, password } = req.body;

		const db = client.db();
		const results = await db.collection('workers').find({Login:login,Password:password}).toArray();

		var id = -1;
		var fn = '';
		var ln = '';

		//Account Exists
		if (results.length > 0)
		{
			id = results[0].UserId;
			fn = results[0].FirstName;
			ln = results[0].LastName;

			//TODO: Create JWT
		}

		else {
			errorMessage = "Login/Password incorrect";
		}

		var ret = { id:id, firstName:fn, lastName:ln, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/register', async(req, res, next) => {
		// incoming: login, password
		// outgoing: id, error
		var email = req.body.email;
		var password = req.body.password;
		var FirstName = req.body.FirstName;
		var LastName = req.body.LastName;

		//TODO: Handle password confirm

		var data = {
			"login": login,
			"password": password,
			"FirstName": FirstName,
			"LastName": LastName
		}

		//TODO: Handle insert error
		const db = client.db();
		const results = await db.collection('workers').insertOne(data, function(err, collection) {
		});

		// Login after successful registration
		return res.redirect('/api/login');
	});

	app.post('/api/addorder', async(req, res, next) => {
		//TODO: Determine necessary data types for orders
		// incoming:
		// outgoing:

		var data = {
		}

		//TODO: Handle insert error
		const db = client.db();
		const results = await db.collection('orders').insertOne(data, function(err, collection) {
		});

		var ret = {};
		res.status(200).json(ret);

	});

	app.post('/api/editorder', async(req, res, next) => {
		//TODO: See addorder
		// incoming:
		// outgoing:
		
		var data = {
		}

		//TODO: Handle update error
		const db = client.db();
		const results = await db.collection('orders').updateOne( { filter:filter_var }, data, {upsert: false});

		var ret = {};
		res.status(200).json(ret);
	});

	app.post('/api/deleteorder', async(req, res, next) => {
		//TODO: See addorder
		// incoming:
		// outgoing:

		//TODO: Handle delete error
		const db = client.db();
		const results = await db.collection('orders').deleteOne( { data:data_var });
		
		var ret = {};
		res.status(200).json(ret);
	});
}