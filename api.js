//var token = require('./createJWT.js');
const nodemailer = require('nodemailer');

exports.setApp = function(app, client) {
	app.post('/api/login', async (req, res, next) => {
		// TODO: Check if User has verified their email before allowing login
		// incoming: login, password
		// outgoing: id, firstName, lastName, error
		var errorMessage = '';

		var login = req.body.login;
		var password = req.body.password;

		// Attempt to login user
		try {
			const db = client.db();
			const results = await db.collection('workers').find({Login:login,Password:password}).toArray();

			var id = -1;
			var fn = '';
			var ln = '';
			var type = '';

			//Account Exists
			if (results.length > 0)
			{
				id = results[0].Login;
				fn = results[0].firstName;
				ln = results[0].lastName;
				type = results[0].Type;
				verified = results[0].Verified;

				//TODO: Create JWT

				errorMessage = "Success";
			}

			else {
				errorMessage = "Login/Password incorrect";
			}
		}

		// Catch login error
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = { id:id, firstName:fn, lastName:ln, type:type, verified:verified, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/send', async(req, res) => {
		// TODO: Create JWT for verification link
		// Maybe create async email for faster response, requires JWT done first
		var errorMessage = "Yeet";
		try{

			let sender = nodemailer.createTransport({
				host: "smtp.gmail.com",
				port: 25,
				auth: {
				user: "cop4331group2verifier@gmail.com",
				pass: "plsletM3in",
				},
				tls:{
					rejectUnauthorized:false
				}
			});

			let info = await sender.sendMail({
				from: '"Group 2" <cop4331group2verifier@gmail.com>',
				to: "lepola6791@eyeremind.com", //Temp email from random site
				subject: "Verification Link", 
				text: "WIP",
			});
		}	catch (e){
			errorMessage = e.toString();
		}

		
		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/registerworker', async(req, res, next) => {
		// incoming: login, password
		// outgoing: error
		var login = req.body.login;
		var password = req.body.password;
		var password_confirm = req.body.password_confirm;
		var firstName = req.body.firstName;
		var lastName = req.body.lastName;
		var email = req.body.email;
		var phone = req.body.phone;
		var employercode = req.body.employercode;
		var flag = 0;
		var errorMessage = '';

		//TODO: Email verification (via smtp?)
		//TODO: Handle duplicate users

		if (password.localeCompare(password_confirm)) {
			errorMessage = "Passwords do not match";
		}

		else {
			var data = {
				"Login": login,
				"Password": password,
				"firstName": firstName,
				"lastName": lastName,
				"email" : email,
				"phone" : phone,
				"employercode" : employercode,
				"flag": flag,
				"Verified": false
			}

			// Attempt to insert worker
			try {
				const db = client.db();
				const results = await db.collection('workers').insertOne(data);
				errorMessage = "Success";
			}

			// Catch insert error
			catch(e) {
				errorMessage = e.toString();
			}
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);

		/*TODO: Login after successful registration
		return res.redirect('/api/login');*/
	});
	
	app.post('/api/registeremployer', async(req, res, next) => {
		// incoming: login, password
		// outgoing: error
		var login = req.body.login;
		var password = req.body.password;
		var password_confirm = req.body.password_confirm;
		var FirstName = req.body.FirstName;
		var LastName = req.body.LastName;
		var email = req.body.email;
		var phone = req.body.phone;
		var employercode = req.body.employercode;
		var flag = 1;
		var errorMessage = '';

		//TODO: Email verification (via smtp?)
		//TODO: Handle duplicate users

		if (password.localeCompare(password_confirm)) {
			errorMessage = "Passwords do not match";
		}

		else {
			var data = {
				"Login": login,
				"Password": password,
				"firstName": FirstName,
				"lastName": LastName,
				"email" : email,
				"phone" : phone,
				"employercode" : employercode,
				"flag": flag,
				"Verified": false
			}

			// Attempt to insert worker
			try {
				const db = client.db();
				const results = await db.collection('employers').insertOne(data);
				errorMessage = "Success";
			}

			// Catch insert error
			catch(e) {
				errorMessage = e.toString();
			}
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);

		/*TODO: Login after successful registration
		return res.redirect('/api/login');*/
	});

	app.post('/api/verify/:token', async(req, res, next) => { 
		// TODO: JWT stuff, check new post URL in line above ^^
		// incoming: login, password
		// outgoing: error
		var login = req.body.login;
		var password = req.body.password;
		var errorMessage = '';

		var account = {
			Login: login,
			Password: password
		}

		var data = {
			//$set is needed to make the data atomic
			$set: {
				Verified: true
			}
		}

		//Set verify to true
		try {
			const db = client.db();
			const results = await db.collection('workers').updateOne(account, data);

			if (!results.matchedCount) {
				errorMessage = "No match";
			}

			else if (!results.modifiedCount) {
				errorMessage = "No modifications - matched " + results.matchedCount;
			}

			else {
				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/changepassword', async(req, res, next) => {
		// incoming: login, password
		// outgoing: error
		var login = req.body.login;
		var password = req.body.password;
		var new_password = req.body.new_password;
		var new_password_confirm = req.body.new_password_confirm;
		var errorMessage = '';

		if (new_password.localeCompare(new_password_confirm)) {
			errorMessage = "Passwords do not match";
		}

		else {
			var account = {
				Login: login,
				Password: password
			}

			var data = {
				//$set is needed to make the data atomic
				$set: {
					Password: new_password
				}
			}

			//Set verify to true
			try {
				const db = client.db();
				const results = await db.collection('workers').updateOne(account, data);

				if (!results.matchedCount) {
					errorMessage = "No match";
				}

				else if (!results.modifiedCount) {
					errorMessage = "No modifications - matched " + results.matchedCount;
				}

				else {
					errorMessage = "Success";
				}
			}

			catch(e) {
				errorMessage = e.toString();
			}
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchorder', async(req, res, next) =>{
		//TODO: Determine necessary data types for orders
		// incoming:
		// outgoing:
		var errorMessage = '';

		var temp = req.body.temp;

		try {
			const db = client.db();
			const results = await db.collection('jobs').find({temp:temp}).toArray();

			var data = -1;

			if (results.length > 0) {
				data = results[0].data;

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {data:data, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/addorder', async(req, res, next) => {
		//TODO: Handle duplicate orders
		// incoming: title, email, address, client name, client contact, 
			// start data, end datae, max workers, briefing, fooid(?)
		// outgoing:error
		var errorMessage = '';
		var temp = req.body.temp;

		var data = {
			"TempData": temp
		}

		// Attempt to insert order
		try {
			const db = client.db();
			const results = await db.collection('jobs').insertOne(data);

			errorMessage = "Success";
		}

		// Catch insert error
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);

	});

	app.post('/api/editorder', async(req, res, next) => {
		//TODO: See addorder
		// incoming: fooid, title, email, address, client name, client contact, 
			// start data, end datae, max workers, briefing
		// outgoing: error
		var errorMessage = '';
		var filter_var = "TempFilter";

		var filter = {
		}

		var data = {
			$set: {
			}
		}

		// Attempt to update order
		try {
			const db = client.db();
			const results = await db.collection('jobs').updateOne(filter, data);

			errorMessage = "Success";
		}

		// Catch update error
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/deleteorder', async(req, res, next) => {
		//TODO: See addorder
		// incoming:
		// outgoing:
		var errorMessage = '';

		try {
			const db = client.db();
			const results = await db.collection('jobs').deleteOne( { data:data_var });

			errorMessage = "Success";
		}

		catch(e) {
			errorMessage = e.toString;
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/markorder', async(req, res, next) => {
		// Mark Order as Completed (1) or Incompleted (0)
		// incoming: 0 or 1
		// outgoing: error

		var status = reg.body.status;
		var errorMessage = '';
		var filter_var = "TempFilter";

		var joborder = {
		}

		var data = {
			$set: {
				"status" : status
			}
		}

		// Attempt to update order
		try {
			const db = client.db();
			const results = await db.collection('jobs').updateOne(joborder, data);

			errorMessage = "Success";
		}

		// Catch update error
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchnotesEmail', async(req, res, next) =>{
		//TODO: What the Hell are notes? Past orders?
		// incoming: fooid, "array of emails"
		// outgoing: all notes w/ matching fooid and email from array
		var errorMessage = '';

		var fooid = req.body.fooid;
		var emails = req.body.emails; // Arrays tho

		var emailarr = new Array();

		try {
			const db = client.db();
			const results = await db.collection('notes').find({fooid:emails}).toArray();

			var data = -1;

			if (results.length > 0) {
				data = results[0].data;

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {data:data, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchnotesTime', async(req, res, next) =>{
		//TODO: See above
		// incoming: email, start time, end time
		// outgoing: all notes from time range
		var errorMessage = '';

		var email = req.body.email;
		var start = req.body.start;
		var end = req.body.end;

		try {
			const db = client.db();
			const results = await db.collection('notes').find({email}).toArray();

			var data = -1;

			if (results.length > 0) {
				data = results[0].data;

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {data:data, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/addnode', async(req, res, next) =>{
		//TODO: See above
		// incoming: fooid, email, time, note
		// outgoing: error
		var errorMessage = '';

		var fooid = req.body.fooid;
		var email = req.body.email;
		var time = req.body.time;
		var note = req.body.note;

		var errorMessage = '';

		var data = {
			"fooid" : fooid,
			"email" : email,
			"time" : time,
			"note" : note
		}

		try {
			const db = client.db();
			const results = await db.collection('notes').insertOne(data);

			errorMessage = "Success";
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});
}
