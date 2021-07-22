require('dotenv').config();
const token = require('./createJWT.js');
const nodemailer = require('nodemailer');
var ObjectID = require('mongodb').ObjectID;
var math = require("mathjs");

// Remaining Endpoints To Create Or Significantly Modify
// 1: Get Notes - handle "array of emails"
// 2: Get Individual Notes - incomming: start date and end date 
//			    			 outgoing: all notes within time range
// 3: Sign On / Sign Off - MUST 1 function for both sign on and sign off
// 4: Clock In / Clock Out - MUST be 1 function for both clock in and clock out
// 5: Get Individual Timesheet - Same as Individual Notes -> handle time range 


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

		var id = new ObjectID(req.body.id);


		try {
			const db = client.db();
			var results = await db.collection('jobs').deleteOne({ _id:id });

			if (results.deletedCount == 1) {
				errorMessage = "Success";
			}
			else {
				errorMessage = "Nope";
			}
		}

		catch(e) {
			errorMessage = e.toString;
		}
		finally {
			await client.close();
		}

		var ret = {error: errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/markorder', async(req, res, next) => {
		// Mark Order as Completed (1) or Incompleted (0)
		// incoming: 0 or 1
		// outgoing: error

		var status = req.body.status;
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
	app.post('/api/signon', async(req, res, next) => {
		// TODO: Add array of worker names to orders
		// Sign On for an available order unless max workers is reached
		// incoming: order ID
		// outgoing: error

		var sign = req.body.sign;
		var id = req.body.id;
		var maxw = 0; // Max Workers for job
		var currw = 0; // Current amount of Workers signed on
		var errorMessage = '';
		var ret = '';
		var filter_var = "TempFilter";

		const db = client.db();

		// Checking for order using the given ID
		try {
			
			var results = await db.collection('jobs').find({_id:id}).toArray();
		}
		catch(e) {
			errorMessage = e.toString();
			ret = {error: errorMessage};
			res.status(200).json(ret);
		}

		if (results.length > 0){
			maxw = results[0].maxworkers;
			currw = results[0].currentworkers + 1;
		}
		else{
			errorMessage = "Job ID not valid";
			ret = {error: errorMessage};
			res.status(200).json(ret);

		}

		if (currw > maxw){
			errorMessage = "Too many workers";
			ret = {error: errorMessage};
			res.status(200).json(ret);
		}

		var data = {
			$set: {
				"currentworkers" :currw,
			}
		}

		// Attempt to update order
		try {
			const results = await db.collection('jobs').updateOne({id:_id}, data);

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
		// incoming: fooid, "array of emails"
		// outgoing: all notes w/ matching fooid and email from array
		var errorMessage = '';

		var fooid = req.body.fooid;
		var email = req.body.email;

		try {
			const db = client.db();
			const results = await db.collection('notes').find({fooid:fooid,email:email}).toArray();

			var data = -1;

			if (results.length > 0) {
				data = results[0].note;

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {note:data, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchnotesTime', async(req, res, next) =>{
		// incoming: email, start time, end time
		// outgoing: all notes from time range
		var errorMessage = '';

		var time = req.body.time;

		try {
			const db = client.db();
			const results = await db.collection('notes').find({time:time}).toArray();

			var data = -1;

			if (results.length > 0) {
				data = results[0].note;

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {note:data, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/addnote', async(req, res, next) =>{
		// incoming: fooid, email, time, note
		// outgoing: error
		var errorMessage = '';

		var fooid = req.body.fooid;
		var email = req.body.email;
		var time = req.body.time;
		var note = req.body.note;


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

	
	app.post('/api/searchTimesheet', async(req, res, next) =>{
		// incoming: fooid
		// outgoing: All timesheets with matching id (?)
		var errorMessage = '';

		var fooid = req.body.fooid;

		try {
			const db = client.db();
			const results = await db.collection('notes').find({_id:fooid}).toArray();

			var data = -1;

			if (results.length > 0) {
				// data = 

				errorMessage = "Success";
			}
		}

		catch(e) {
			errorMessage = e.toString();
		}

		var ret = {timesheet:data, error:errorMessage};
		res.status(200).json(ret);
	});

	app.post('/api/searchJobs', async(req, res, next) =>{
		// TODO: Do not return jobs the user does not have access too 
		// Outgoing: Any relevant job orders

		var errorMessage = '';

		// Incomming
		var compCode = req.body.companyCode;
		var address = req.body.address;
		var email = req.body.eamil;
		var title = req.body.title;
		var clientname = req.body.clientname;
		var clientcontact = req.body.clientcontact;
		var start = req.body.start;
		var end = req.body.end;

		var jobsTitle = [];

		var data = {
			"companyCode" : compCode,
			"address" : address,
			"email" : email,
			"title" : title,
			"clientname" : clientname,
			"clientcontact" : clientcontact
			//"start"  : start,
			//"end" : end,
			//"completed": false
		}
		try {
			const db = client.db();
			var jobsWithCode = await db.collection('jobs').find({companyCode:compCode}).toArray();
		}
		catch(e) {
			errorMessage = e.toString();
		}

		if (jobsWithCode.length == 0){
			errorMessage = "No Jobs found with given company code"
		}

		for(let i = 0; i < jobsWithCode.length; ++i){
			if (jobsWithCode[i].title.indexOf(title) > -1 ) {
				//data[i].title = jobsWithCode[i].title;
			}
			else{
				jobsWithCode.splice(i,1);
				errorMessage = "Spliced"
			}
		}

		var ret = {jobs:jobsWithCode, error:errorMessage};
		res.status(200).json(ret);
		// Using company code, find all orders with a partial match to the incomming data

		// The given 'start' data must be earlier than the end field of the job
		// The give 'end' data must be later than the start field of the job
		// If no string, ignore

	});
}
