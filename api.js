require('dotenv').config();
//const token = require('./createJWT.js');
const nodemailer = require('nodemailer');
var math = require("mathjs");

exports.setApp = function(app, client) {
	app.post('/api/login', async (req, res, next) => {
		// TODO: Check if User has verified their email before allowing login
		// incoming: login, password
		// outgoing: id, firstName, lastName, error
		var errorMessage = '';

		var email = req.body.email;
		var password = req.body.password;

		var fn = '';
		var ln = '';
		var email = '';
		var phone = '';
		var compcode = '';
		var flag = '';

		// Attempt to login user
		try {
			const db = client.db();
			const results = await db.collection('workers').find({Email:email,Password:password}).toArray();

			//Account Exists
			if (results.length > 0)
			{
				email = results[0].Email;
				fn = results[0].firstName;
				ln = results[0].lastName;
				phone = results[0].phone;
				compcode = results[0].companyCode;
				flag = results[0].flag;
				verified = results[0].Verified;

				//TODO: Create JWT
				errorMessage = "Success: Worker";
			}

			else {
				const results = await db.collection('employers').find({Email:email,Password:password}).toArray();

				if (results.length > 0)
				{
					email = results[0].Email;
					fn = results[0].firstName;
					ln = results[0].lastName;
					phone = results[0].phone;
					compcode = results[0].companyCode;
					flag = results[0].flag;
					verified = results[0].Verified;

					//TODO: Create JWT
					errorMessage = "Success: Employer";
				}

				else {
					errorMessage = "Login/Password incorrect";
				}
			}

			
		}

		// Catch login error
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = { email:email, firstName:fn, lastName:ln, phone:phone, companycode:compcode, verified:verified, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/send', async(req, res) => {
		// TODO: Create JWT for verification link
		// Maybe create async email for faster response, requires JWT done first
		var errorMessage = '';
		var email = req.body.email;
		// Note: Must include http
		var verification_link = "https://www.google.com";
		try{

			let transporter = nodemailer.createTransport({
				/*host: "smtp.gmail.com",
				port: 587,*/
				service: 'gmail',
				auth: {
					user: process.env.EMAIL_USER,
					pass: process.env.EMAIL_PASS
				}
			});

			let body = {
				from: '"Group 2" <' + process.env.EMAIL_USER + '>',
				to: email,
				subject: "Verification Link", 
				html: "<h1><a href=" + verification_link + ">Click here to verify your account</a></h1>" +
				      "<p>Copy and Paste the following link into your address bar if the link above does not work: " +
				      "<a href=" + verification_link + ">" + verification_link + "</a></p>"
			};

			transporter.verify(function(error, success) {
				if (error) {
					errorMessage = "Error verifying mail";
				}
			});

			transporter.sendMail(body,(err, result) => {
				if (error) {
					errorMessage = "Error sending mail";
				}
			});

			errorMessage = "Success";
		}
		catch (e){
			errorMessage = e.toString();
		}

		
		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	function sendVerificationLink(email) {
		var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
		var xhr = new XMLHttpRequest();
		xhr.open("POST", "https://cop4331group2.herokuapp.com/api/send", true);
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.send(JSON.stringify({email: email}));
	}

	function getRandomInt() {
		var min = 1000;
		var max = 9999;
		return math.floor(math.random() * (max - min) + min);
	}

	app.post('/api/register', async(req, res, next) => {
		// incoming: email, password
		// outgoing: error

		var email = req.body.email;
		var password = req.body.password;
		var password_confirm = req.body.password_confirm;
		var firstName = req.body.firstName;
		var lastName = req.body.lastName;
		var phone = req.body.phone;
		var compCode = req.body.companyCode;
		var compName = req.body.companyName;
		var flag = req.body.flag;
		var errorMessage = '';
		
		var cont = 1;

		//TODO: Handle duplicate users
		const db = client.db();

		if (flag == 1) {

			while(cont){

				compCode = getRandomInt();
				const codeChecker = await db.collection('employers').find({companyCode: compCode}).toArray();

				if (codeChecker.length == 0)
					cont = 0;
			}

		}


		if (password.localeCompare(password_confirm)) {
			errorMessage = "Passwords do not match";
		}

		else {
			var data = {
				"Email" : email,
				"Password": password,
				"firstName": firstName,
				"lastName": lastName,
				"phone" : phone,
				"compnayCode" : compCode,
				"compnayName" : compName,
				"flag": flag,
				"Verified": false
			}

			// Attempt to insert worker / employer
			try {
				
				if (flag == 0)
				{
					
					const results = await db.collection('workers').insertOne(data);
					sendVerificationLink(email);
					errorMessage = "Success: Worker";
				}
				else {
					const results = await db.collection('employers').insertOne(data);
					sendVerificationLink(email);
					errorMessage = "Success: Employer " + compCode;
				}
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

	app.post('/api/changefirstname', async(req, res, next) => {
		// incoming: login, password
		// outgoing: error
		var login = req.body.login;
		var password = req.body.password;
		var new_FirstName = req.body.new_FirstName;
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
					FirstName: new_FirstName
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

	app.post('/api/changelastname', async(req, res, next) => {
		// incoming: login, password
		// outgoing: error
		var login = req.body.login;
		var password = req.body.password;
		var new_LastName = req.body.new_LastName;
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
					LastName: new_LastName
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

	app.post('/api/changephone', async(req, res, next) => {
		// incoming: login, password
		// outgoing: error
		var login = req.body.login;
		var password = req.body.password;
		var new_phone = req.body.new_phone;
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
					phone: new_phone
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

	app.post('/api/changeemail', async(req, res, next) => {
		// incoming: login, password
		// outgoing: error
		var login = req.body.login;
		var password = req.body.password;
		var new_email = req.body.new_email;
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
					email: new_email
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

	app.post('/api/addorder', async(req, res, next) => {
		//TODO: Handle duplicate orders
		// incoming: title, email, address, client name, client contact, 
			// start date, end date, max workers, briefing, fooid(?)
		// outgoing:error
		var errorMessage = '';
		var title = req.body.title;
		var email = req.body.email;
		var address = req.body.address;
		var clientname = req.body.clientname;
		var clientcontact = req.body.clientcontact;
		var start = req.body.start;
		var end = req.body.end;
		var max = req.body.max;
		var briefing = req.body.briefing;

		var data = {
			"title" : title,
			"email" : email,
			"address" : address,
			"clientname" : clientname,
			"clientcontact" : clientcontact,
			"start" : start,
			"end" : end,
			"maxworkers" : max,
			"briefing" : briefing,
			"completed" : false,
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

	app.post('/api/searchIncomp', async(req, res) => {
		// TODO: Create array of results to return (currently only able to return first result)
		// incoming: 
		// outgoing: All incomplete orders, error
		var errorMessage = '';

		try {
			const db = client.db();
			const results = await db.collection('jobs').find({completed: false}).toArray();

			if (results.length > 0)
			{
				id = results[0]._id;
				ti = results[0].title;
				em = results[0].email;
				add= results[0].address;
				clientn = results[0].clientname;
				clientc = results[0].clientcontact;
				start = results[0].start;
				end = results[0].end;
				maxw = results[0].maxworkers;
				bri = results[0].briefing;
				comp = results[0].completed;

				errorMessage = results.length.toString();
			}

			else {
				errorMessage = "No results";
			}
		}
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = { ID: id, Title:ti, Email:em, error:errorMessage};
		res.status(200).json(ret);

	});

	app.post('/api/searchTitle', async(req, res) => {
		// TODO: Create array of results to return (currently only able to return first result)
		// incoming: 
		// outgoing: All orders with similar title, error
		var errorMessage = '';
		var Title = req.body.title;

		try {
			const db = client.db();
			const results = await db.collection('jobs').find({title: Title}).toArray();

			if (results.length > 0)
			{
				id = results[0]._id;
				ti = results[0].title;
				em = results[0].email;
				add= results[0].address;
				clientn = results[0].clientname;
				clientc = results[0].clientcontact;
				start = results[0].start;
				end = results[0].end;
				maxw = results[0].maxworkers;
				bri = results[0].briefing;
				comp = results[0].completed;

				errorMessage = results.length.toString();
			}

			else {
				errorMessage = "No results";
			}
		}
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = { ID:id, Title:ti, Email:em, error:errorMessage};
		res.status(200).json(ret);

	});


	app.post('/api/editorder', async(req, res, next) => {
		//TODO: This ain't working very well
		// incoming: id, title, email, address, client name, client contact, 
			// start data, end datae, max workers, briefing
		// outgoing: error
		var errorMessage = '';
		var id = req.body.id;
		var title = req.body.title;
		var email = req.body.email;
		var address = req.body.address;
		var clientname = req.body.clientname;
		var clientcontact = req.body.clientcontact;
		var start = req.body.start;
		var end = req.body.end;
		var max = req.body.max;
		var briefing = req.body.briefing;

		var filter = {
			_id: id
		}

		var data = {
			$set: {
			"title" : title,
			"email" : email,
			"address" : address,
			"clientname" : clientname,
			"clientcontact" : clientcontact,
			"start" : start,
			"end" : end,
			"maxworkers" : max,
			"briefing" : briefing
			}
		}

		// Attempt to update order
		try {
			const db = client.db();
			const results = await db.collection('jobs').updateOne({_id: id}, data);

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

		// Catch update error
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/deleteorder', async(req, res, next) => {
		// incoming: id
		// outgoing: error
		var errorMessage = '';

		var id = req.body.id;

		try {
			const db = client.db();
			const results = await db.collection('jobs').deleteOne( { _id: id });

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
		//TODO: What are notes? Past orders?
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

	app.post('/api/addnote', async(req, res, next) =>{
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
