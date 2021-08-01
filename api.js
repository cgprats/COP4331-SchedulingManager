require('dotenv').config();
const token = require('./createJWT.js');
const nodemailer = require('nodemailer');
var ObjectID = require('mongodb').ObjectID;
var math = require("mathjs");

// Remaining Endpoints To Create Or Significantly Modify
// 1: Get Notes
// 2: Get Individual Notes
// 3: Sign On / Sign Off - MUST 1 function for both sign on and sign off
// 4: Clock In / Clock Out - MUST be 1 function for both clock in and clock out
// 5: Get Individual Timesheet - Same as Individual Notes -> handle time range 
// 6: Finish Search Order (Mostly done)

//This comment is for commit purposes

// Other stuff
// 1: Handle date stuff for add / edit order (I got this)
// 2: Help Front End with JWT

exports.setApp = function(app, client) {
	app.post('/api/login', async (req, res, next) => {
		// TODO: Check if User has verified their email before allowing login
		// incoming: login, password
		// outgoing: id, firstName, lastName, error
		var errorMessage = '';

		var email = req.body.email;
		var password = req.body.password;
		var flag = req.body.flag;

		var fn = '';
		var ln = '';
		var phone = '';
		var compcode = '';
		var compname = '';
		var verified = '';


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
					compname = results[0].companyName;
					flag = results[0].flag;
					verified = results[0].Verified;

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

		var ret = { email:email, firstName:fn, lastName:ln, phone:phone, companyName:compname, companyCode: compcode, verified: verified, flag:flag, error:errorMessage};

		/* 
		// JWT Code
		try {
			ret = token.createToken(email, flag, fn, ln, phone, compcode, verified);
		}

		catch (e) {
			ret = {error:e.message};
		}
		*/

		res.status(200).json(ret);
	});

	app.post('/api/send', async(req, res) => {
		var errorMessage = '';
		var email = req.body.email;

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
				subject: "Verification Code", 
				html: "<h1>Your verification code is: " + req.body.verCode + "</h1>"
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

	function sendVerificationLink(email, verificationCode) {
		var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
		var xhr = new XMLHttpRequest();
		xhr.open("POST", "https://cop4331group2.herokuapp.com/api/send", true);
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.send(JSON.stringify({email: email, verCode: verificationCode}));
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
		
		const db = client.db();


		// Comapres passwords
		if (password.localeCompare(password_confirm)) {
			errorMessage = "Passwords do not match";
		}
		else{
			// Generates Random Company Code
			var cont = 1;
			if (flag == 1) {

				while(cont){

					compCode = getRandomInt().toString();
					const codeChecker = await db.collection('employers').find({companyCode: compCode}).toArray();

					if (codeChecker.length == 0)
						cont = 0;
				}

			}

			// Checks company code entered by user, making sure it's used by an Employer already
			var compcodeVerified = 1;
			if (flag == 0){
				const codeChecker = await db.collection('employers').find({companyCode: compCode}).toArray();

				if (codeChecker.length == 0)
				{
						compcodeVerified = 0;
						errorMessage = "Invalid company code";
				}

			}

			// Check for existing users in both collections
			var unique = 1;
			const emailCheckerE = await db.collection('employers').find({Email: email}).toArray();
			const emailCheckerW = await db.collection('workers').find({Email: email}).toArray();

			if (emailCheckerE.length != 0){
				unique = 0;
				errorMessage = "User already exists with this email ";
			}
			
			else if (emailCheckerW.length != 0){
				unique = 0;
				errorMessage = "User already exists with this email ";
			}

			// 'Unique' is used to denote the email hasn't been used before
			else if (unique == 1 && compcodeVerified == 1){
				var verificationCode = getRandomInt().toString();
				var data = {
					"Email" : email,
					"Password": password,
					"firstName": firstName,
					"lastName": lastName,
					"phone" : phone,
					"companyCode" : compCode,
					"companyName" : compName,
					"flag": flag,
					"Verified": false,
					"VerificationCode": verificationCode
				}

				// Attempt to insert worker / employer
				try {
					
					if (flag == 0)
					{
						
						const results = await db.collection('workers').insertOne(data);
						sendVerificationLink(email, verificationCode);
						errorMessage = "Success: Worker";
					}
					else {
						const results = await db.collection('employers').insertOne(data);
						sendVerificationLink(email, verificationCode);
						errorMessage = "Success: Employer";
					}
				}

				// Catch insert error
				catch(e) {
					errorMessage = e.toString();
				}
			}
		}

		var ret = {
			error: errorMessage,
			Email: email,
			FirstName: firstName,
			LastName: lastName,
			Phone: phone,
			CompanyCode: compCode,
			Flag: flag,
			Verified: false,
			VerificationCode: verificationCode
		};
		res.status(200).json(ret);
	});

	app.post('/api/verify', async(req, res, next) => { 
		// TODO: JWT stuff, check new post URL in line above ^^
		// incoming: login, password
		// outgoing: error
		var email = req.body.email;
		var ver = req.body.verificationCode;
		var errorMessage = '';

		var account = {
			Email: email,
			VerificationCode: ver
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
			var results = await db.collection('workers').updateOne(account, data);
			if (results.matchedCount == 0) results = await db.collection('employers').updateOne(account, data);

			if (!results.matchedCount) {
				errorMessage = "Code Invalid";
			}

			else if (!results.modifiedCount) {
				errorMessage = "No modifications - matched " + results.matchedCount;
			}

			else {
				errorMessage = "";
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
		var email = req.body.email;
		var ver = req.body.ver;
		var new_password = req.body.new_password;
		var new_password_confirm = req.body.new_password_confirm;
		var errorMessage = '';

		if (new_password.localeCompare(new_password_confirm)) {
			errorMessage = "Passwords do not match";
		}

		else {
			var account = {
				Email: email,
				VerificationCode: ver
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
				var results = await db.collection('workers').updateOne(account, data);

				if (!results.matchedCount) {
					results = await db.collection('employers').updateOne(account, data);
				}

				if(!results.matchedCount){
					errorMessage = "Verification code invalid";
				}

				else if (!results.modifiedCount) {
					errorMessage = "No modifications - matched " + results.matchedCount;
				}

				else {
					errorMessage = "Password changed, redirecting to login";
				}
			}

			catch(e) {
				errorMessage = e.toString();
			}
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/sendcode', async(req, res, next) => {
		// incoming: email
		// outgoing: error
		var email = req.body.email;
		var errorMessage = '';
		var flag = 0;
		var code = getRandomInt().toString();

		var account = {
			Email: email
		}

		var data = {
			//$set is needed to make the data atomic
			$set: {
				VerificationCode: code
			}
		}

		//Set new verification code
		try {
			const db = client.db();
			var results = await db.collection('workers').updateOne(account, data);
			flag = 0;

			if (!results.matchedCount) {
				results = await db.collection('employers').updateOne(account, data);
				flag = 1;
			}

			if(!results.matchedCount){
				errorMessage = "Invalid email address";
			}

			else if (!results.modifiedCount) {
				errorMessage = "No modifications - matched " + results.matchedCount;
			}

			else {
				errorMessage = "Success";
				sendVerificationLink(email, code);
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}
		

		var ret = {error: errorMessage, flag: flag};
		res.status(200).json(ret);
	});

	app.post('/api/editaccount', async(req, res, next) => {
		// incoming: login, password
		// outgoing: error
		var email = req.body.email;
		var new_LastName = req.body.ln;
		var new_FirstName = req.body.fn;
		var new_Phone = req.body.phone;
		var errorMessage = '';

		var account = {
			Email: email
		}

		var data = {
			//$set is needed to make the data atomic
			$set: {
				firstName: new_FirstName,
				lastName: new_LastName,
				phone: new_Phone
			}
		}

		//Set verify to true
		try {
			const db = client.db();
			var results = await db.collection('workers').updateOne(account, data);

			if (!results.matchedCount) {
				var results = await db.collection('employers').updateOne(account, data);
			}

			if (!results.matchedCount) {
				errorMessage = "No match";
			}

			else {
				errorMessage = "Edits applied!";
			}
		}

		catch(e) {
			errorMessage = e.toString();
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
		var companyCode = req.body.companyCode;
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
			"workers": [],
			"companyCode" : companyCode,
			"briefing" : briefing,
			"completed" : false
		}

		// Attempt to insert order
		try {
			const db = client.db();
			const results = await db.collection('jobs').insertOne(data);

			errorMessage = "Job added!";
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
			var results = await db.collection('jobs').find({title: Title}).toArray();

			if (results.length > 0)
			{
				/*
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
				*/

				errorMessage = results.length.toString();
			}

			else {
				errorMessage = "No results";
			}
		}
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = { data:results, error:errorMessage};
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

		var mongo = require('mongodb');
		var o_id = new mongo.ObjectID(id);

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
			const results = await db.collection('jobs').updateOne({_id: o_id}, data);

			if (!results.matchedCount) {
				errorMessage = "No match";
			}

			else if (!results.modifiedCount) {
				errorMessage = "No modifications - matched " + results.matchedCount;
			}

			else {
				errorMessage = "Edits applied!";
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

		var mongo = require('mongodb');
		var o_id = new mongo.ObjectID(id);


		try {
			const db = client.db();
			var results = await db.collection('jobs').deleteOne({ _id:o_id });

			if (results.deletedCount == 1) {
				errorMessage = "Job deleted";
			}
			else {
				errorMessage = "No Jobs found";
			}
			
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

		var fooid = req.body.fooid;
		var errorMessage = '';

		var mongo = require('mongodb');
		var o_id = new mongo.ObjectID(fooid);

		var joborder = {
			"_id": o_id
		}

		var data = {
			$set: {
				"completed" : true
			}
		}

		// Attempt to update order
		try {
			const db = client.db();
			const results = await db.collection('jobs').updateOne(joborder, data);

			errorMessage = "Job completed!";
		}

		// Catch update error
		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/signJob', async(req, res, next) => {
		// TODO: Add array of worker names to orders
		// Sign On for an available order unless max workers is reached
		// incoming: order ID
		// outgoing: error

		var email = req.body.email;
		var id = req.body.id;
		var fn = req.body.firstName;
		var ln = req.body.lastName;
		var phone = req.body.phone;
		var current = req.body.current;
		var max = req.body.max;

		var mongo = require('mongodb');
		var o_id = new mongo.ObjectID(id);
		
		var errorMessage = '';

		// Checking for order using the given ID
		try {
			var db = client.db();
			var results = await db.collection('jobs').find({_id:o_id}).toArray();
		}
		catch(e) {
			errorMessage = "Job ID not valid";
			ret = {error: errorMessage};
		}

		var workers = results[0].workers;
		var inArray = false;
		for (let i = 0; i < workers.length; i++)
		{
			if(workers[i].email == email)
				inArray = true;
		}

		if (!inArray && current == max){
			errorMessage = "Job is at worker limit";

		}else{
			if(inArray)
			{
				var data = {
					$pull: { 
						workers: {email: email}
					}
				}

				try {
					var db = client.db();
					var results = await db.collection('jobs').updateOne({_id:o_id}, data);
					errorMessage = "Removed from team";
				}
		
				// Catch update error
				catch(e) {
					errorMessage = e.toString();
				}
			}
			else{

				var data = {
					$push: { 
						workers: {email: email, firstName: fn, lastName: ln, phone: phone}
					}
				}

				try {
					var db = client.db();
					var results = await db.collection('jobs').updateOne({_id:o_id}, data);
					errorMessage = "Added to team";
				}
		
				// Catch update error
				catch(e) {
					errorMessage = e.toString();
				}
			}
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchNotes', async(req, res, next) =>{
		
		var errorMessage = '';

		var fooid = req.body.fooid;

		try {
			const db = client.db();
			var results = await db.collection('notes').find({fooid:fooid}).toArray();

			if (results.length > 0) {
				results.sort((a,b) => (a.date > b.date) ? 1 : ((b.date > a.date) ? -1 : 0));

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {notes:results, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchIndividualNotes', async(req, res, next) =>{
		
		var errorMessage = '';

		var email = req.body.email;

		try {
			const db = client.db();
			var results = await db.collection('notes').find({email:email}).toArray();

			if (results.length > 0) {
				results.sort((a,b) => (a.date > b.date) ? 1 : ((b.date > a.date) ? -1 : 0));

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {notes:results, error:errorMessage};
		res.status(200).json(ret);
	});


	app.post('/api/addnote', async(req, res, next) =>{
		// incoming: fooid, email, time, note
		// outgoing: error
		var errorMessage = '';

		var fooid = req.body.fooid;
		var email = req.body.email;
		var fn = req.body.fn;
		var ln = req.body.ln;
		var date = req.body.date;
		var title = req.body.title;
		var note = req.body.note;


		var data = {
			"fooid" : fooid,
			"email" : email,
			"date" : date,
			"note" : note,
			"firstName" : fn,
			"lastName": ln,
			"title": title
		}

		try {
			const db = client.db();
			const results = await db.collection('notes').insertOne(data);

			errorMessage = "Note added!";
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/clockEvent', async(req, res, next) =>{
		// incoming: fooid, email, time, note
		// outgoing: error
		var errorMessage = '';

		var fooid = req.body.fooid;
		var email = req.body.email;
		var fn = req.body.fn;
		var ln = req.body.ln;
		var date = req.body.date;
		var title = req.body.title;
		var time = req.body.time;


		var data = {
			"fooid" : fooid,
			"email" : email,
			"end": 'XXXXX'
		}

		try {
			var db = client.db();
			var results = await db.collection('timesheet').find(data).toArray();
		}
		catch(e) {
			errorMessage = e.toString();
		}

		if (results.length < 1)
		{
			var data2 = {
				"fooid": fooid,
				"email": email,
				"firstName": fn,
				"lastName": ln,
				"start": time,
				"end": 'XXXXX',
				"date": date,
				"title": title
			}

			try {
				var db = client.db();
				var results = await db.collection('timesheet').insertOne(data2);
				errorMessage = 'Clocked in';
			}
			catch(e) {
				errorMessage = e.toString();
			}

		}else{
			var data2 = {
				$set: 
				{
					"end": time
				}
			}

			try {
				var db = client.db();
				var results = await db.collection('timesheet').updateOne(data, data2);
				errorMessage = 'Clocked out';
			}
			catch(e) {
				errorMessage = e.toString();
			}

		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchTimesheet', async(req, res, next) =>{
		
		var errorMessage = '';

		var fooid = req.body.fooid;

		try {
			const db = client.db();
			var results = await db.collection('timesheet').find({fooid:fooid}).toArray();

			if (results.length > 0) {
				results.sort((a,b) => (a.date > b.date) ? 1 : ((b.date > a.date) ? -1 : 0));

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {times:results, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchIndividualTimesheet', async(req, res, next) =>{
		
		var errorMessage = '';

		var email = req.body.email;

		try {
			const db = client.db();
			var results = await db.collection('timesheet').find({email:email}).toArray();

			if (results.length > 0) {
				results.sort((a,b) => (a.date > b.date) ? 1 : ((b.date > a.date) ? -1 : 0));

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {times:results, error:errorMessage};
		res.status(200).json(ret);
	});
	

	app.post('/api/searchJobs', async(req, res, next) =>{
		// TODO: Do not return jobs the user does not have access too 
		// Outgoing: Any relevant job orders

		var errorMessage = '';
		
		// Incomming
		var input = req.body.input;
		var compCode = req.body.companyCode;
		var email = req.body.email;
		var showMine = req.body.showMine;
		var showCompleted = req.body.showCompleted;
		// showCompleted == TRUE ( Do Nothing )
		// showCompleted == FALSE ( Only return completed == false )
		
		var start = req.body.start;
		var end = req.body.end;

		var startinput = new Date(start);
		var endinput = new Date(end);

		// Indicator if time range search is being done
		var useInRange = false;

		try {
			const db = client.db();
			var jobsAll = await db.collection('jobs').find({companyCode:compCode}).toArray();
		}
		catch(e) {
			errorMessage = e.toString();
		}

		// Copy over all found jobs to new array
		// Then empty all elements so they can be filled if matched
		var jobsMatched = [].concat(jobsAll);
		jobsMatched.splice(0,jobsMatched.length);

		if (jobsAll.length == 0)
			errorMessage = "This company does not have any jobs yet";
		
		for (let i = 0; i < jobsAll.length; i++)
			if (jobsAll[i].title != null)
				if (jobsAll[i].title.indexOf(input) > -1)
					jobsMatched[i] = jobsAll[i];

		for (let i = 0; i < jobsAll.length; i++)
			if (jobsAll[i].email != null)
				if (jobsAll[i].email.indexOf(input) > -1)
					jobsMatched[i] = jobsAll[i];
		
		for (let i = 0; i < jobsAll.length; i++)
			if (jobsAll[i].address != null)
				if (jobsAll[i].address.indexOf(input) > -1) 
					jobsMatched[i] = jobsAll[i];

		for (let i = 0; i < jobsAll.length; i++)
			if (jobsAll[i].clientname != null)
				if (jobsAll[i].clientname.indexOf(input) > -1) 
					jobsMatched[i] = jobsAll[i];

		for (let i = 0; i < jobsAll.length; i++)
			if (jobsAll[i].clientcontact != null)
				if (jobsAll[i].clientcontact.indexOf(input) > -1) 
					jobsMatched[i] = jobsAll[i];

		var jobsMatchedInRange = [].concat(jobsMatched);
		jobsMatchedInRange.splice(0,jobsMatchedInRange.length);

		if (start != "" && end != ""){
			var startfield;
			var endfield;

			useInRange = true;

			for (let i = 0; i < jobsMatched.length; i++){
				if (jobsMatched[i] != null)
				{
					startfield = new Date(jobsMatched[i].start);
					endfield = new Date(jobsMatched[i].end);
	
					if (startfield.getTime() < endinput.getTime() && endfield.getTime() > startinput.getTime())
						jobsMatchedInRange[i] = jobsMatched[i];
				}
			}
		}
		
		// Filter for showing jobs the user is signed on for
		if (showMine == true){
			if (useInRange == true){
				var jobsMatchedPostRange = [].concat(jobsMatchedInRange);
				jobsMatchedPostRange.splice(0,jobsMatchedPostRange.length);

				for (let i = 0; i < jobsMatchedInRange.length; i++)
					if (jobsMatchedInRange[i] != null)
						for (let j = 0; j < jobsMatchedInRange[i].workers.length; j++)
							if (jobsMatchedInRange[i].workers[j].email == email)
								jobsMatchedPostRange[i] = jobsMatchedInRange[i];
			}

			if (useInRange == false){
				var jobsMatchedPostRange = [].concat(jobsMatched);
				jobsMatchedPostRange.splice(0,jobsMatchedPostRange.length);

				for (let i = 0; i < jobsMatched.length; i++)
					if (jobsMatched[i] != null)
						for (let j = 0; j < jobsMatched[i].workers.length; j++)
							if (jobsMatched[i].workers[j].email == email)
								jobsMatchedPostRange[i] = jobsMatched[i];
			}
		}
		else
		{
			if (useInRange == true)
				var jobsMatchedPostRange = [].concat(jobsMatchedInRange);
			else
				var jobsMatchedPostRange = [].concat(jobsMatched);
		}
			

		
		// Filter for completed jobs
		var jobsMatchedFinal = [].concat(jobsMatchedPostRange);
		jobsMatchedFinal.splice(0,jobsMatchedFinal.length);

		for (let i = 0; i < jobsMatchedPostRange.length; i++)
			if(jobsMatchedPostRange[i] != null)
				if (jobsMatchedPostRange[i].completed == false)
					jobsMatchedFinal[i] = jobsMatchedPostRange[i];

		if (showCompleted == false)
			var ret = {jobs:jobsMatchedFinal, error:errorMessage};
		else
			var ret = {jobs:jobsMatchedPostRange, error:errorMessage};
		
		res.status(200).json(ret);
	});

	app.post('/api/searchWorkers', async(req, res, next) =>{
		// TODO: Do not return jobs the user does not have access too 
		// Outgoing: Any relevant job orders

		var errorMessage = '';
		
		// Incomming
		var input = req.body.input;
		var compCode = req.body.companyCode;

		try {
			const db = client.db();
			var workersAll = await db.collection('workers').find({companyCode:compCode}).toArray();
		}
		catch(e) {
			errorMessage = e.toString();
		}

		// Copy over all found jobs to new array
		// Then empty all elements so they can be filled if matched
		workersAll.forEach(u => {delete u.Password; delete u.Verified; delete u.VerificationCode;});
		var workersMatched = [].concat(workersAll);
		workersMatched.splice(0,workersMatched.length);

		if (workersAll.length == 0)
			errorMessage = "This company does not have any workers yet";
		
		for (let i = 0; i < workersAll.length; i++)
			if (workersAll[i].firstName != null)
				if (workersAll[i].firstName.indexOf(input) > -1)
					workersMatched[i] = workersAll[i];

		for (let i = 0; i < workersAll.length; i++)
			if (workersAll[i].lastName != null)
				if (workersAll[i].lastName.indexOf(input) > -1)
					workersMatched[i] = workersAll[i];
		
		for (let i = 0; i < workersAll.length; i++)
			if (workersAll[i].Email != null)
				if (workersAll[i].Email.indexOf(input) > -1)
					workersMatched[i] = workersAll[i];

		for (let i = 0; i < workersAll.length; i++)
			if (workersAll[i].phone != null)
				if (workersAll[i].phone.indexOf(input) > -1)
					workersMatched[i] = workersAll[i];

		
		var ret = {workers: workersMatched, error: errorMessage};
		res.status(200).json(ret);
	});
}
