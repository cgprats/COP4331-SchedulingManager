const jwt = require("jsonwebtoken");
require("dotenv").config();

exports.createToken = function(email, flag, fn, ln, phone, compcode, verified) {
	try {
		const expiration = new Date();
		const user = {Email:email, flag:flag, firstName:fn, lastName:ln, phone:phone, companyCode:compcode, Verified:verified};

		// Use default expiration
		const accessToken = jwt.sign(user, process.env.ACCESS_TOKEN_SECRET);

		var ret = {accessToken:accessToken};
	}

	catch(e) {
		var ret = {error:e.message};
	}

	return ret;
}

exports.isExpired = function(token) {
	var isError = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, verifiedJWT) => {
		if (err) {
			return true;
		}
		else {
			return false;
		}
	});

	return isError;
}

exports.refresh = function(token) {
	var ud = jwt.decode(token,{complete:true});

	var email = ud.payload.email;
	var flag = ud.payload.flag;
	var fn = ud.payload.fn;
	var ln = ud.payload.ln;
	var phone = ud.payload.phone;
	var compcode = ud.payload.compcode;
	var verified = ud.payload.verified;

	return createToken(email, flag, fn, ln, phone, compcode, verified);
}
