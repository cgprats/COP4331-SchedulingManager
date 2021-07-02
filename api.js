//var token = require('./createJWT.js');

exports.setApp = function(app, client) {
	// Login Endpoint
	app.post('/api/login', async(req, res, next) => {
		//incoming: login, password
		//outgoing: id, firstName, lastName, error
		var error = "";

		const {login, password} = req.body;

		const db = client.db();
		const results = await db.collection('workers').find({Login:login,Password:password}).toArray();

		var id = -1;
		var fn = '';
		var ln = '';

		//var ret;

		//Account Exists
		if (results.length > 0) {
			id = results[0].UserId;
			fn = results[0].FirstName;
			ln = results[0].LastName;

			/*//Attempt to Create JWT
			try {
				const token = require("./createJWT.js");
				ret = token.createToken(fn, ln, id);
			}

			//Return Error on Failure
			catch(e) {
				ret = {error:e.message};
			}*/
		}

		//Account Does Not Exist
		else {
			ret = {error:"Login/Password incorrect"};
		}
		
		var ret = { id:id, firstName:fn, lastName:ln, error:''};
      		res.status(200).json(ret);
	});

	// Register Endpoint
	app.post('/api/register', async(req, res, next) => {
		//incoming: login, password, first name, last name
		//outgoing: id, error
		
		var login = req.body.login; // Should we use e-mail instead?
		var password = req.body.password;
		var email = req.body.email;
		var FirstName = req.body.FirstName;
    		var LastName = req.body.LastName;
		
		var data = {
			"login" : login,
        		"password" : password,
			"email" : email,
			"FirstName" : FirstName,
			"LastName" : LastName
		}
		
		const db = client.db();
		const results = await db.collection('workers').insertOne(data,function(err, collection){ 
			// Check for conflict
		}
    		
    		return res.redirect( ... );
	});
	
	app.post('/api/addorder', async(req, res, next) => {
	});
	
	app.post('/api/editorder', async(req, res, next) => {
	});
	
	app.post('/api/deleteorder', async(req, res, next) => {
	});
}
