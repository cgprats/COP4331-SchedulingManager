import 'dart:convert';
import 'package:test/test.dart';
import 'package:mobile/utils/get_api.dart';

void main() {
  group('Unit Testing', () {
    test('Sign up should return user already exists error', () async{
      Map _payload = Map();
      _payload['email'] = 'joeljoy@gmail.com';
      _payload['password'] = 'pass';
      _payload['password_confirm'] = 'pass';
      _payload['firstName'] = 'Name';
      _payload['lastName'] = 'Name';
      _payload['phone'] = '1234567890';
      _payload['companyCode'] = '1234';
      _payload['companyName'] = 'Name';
      _payload['flag'] = 1;
      String dir = '/register';
      String ret = await API.getJson(dir, _payload);
      var jsonObj = json.decode(ret);
      expect(jsonObj['error'].toString().trim(), 'User already exists with this email');
    });

    test("Sign up should return passwords don't match error", () async{
      Map _payload = Map();
      _payload['email'] = 'joeljoy@gmail.com';
      _payload['password'] = 'pass';
      _payload['password_confirm'] = 'pass1';
      _payload['firstName'] = 'Name';
      _payload['lastName'] = 'Name';
      _payload['phone'] = '1234567890';
      _payload['companyCode'] = '1234';
      _payload['companyName'] = 'Name';
      _payload['flag'] = 1;
      String dir = '/register';
      String ret = await API.getJson(dir, _payload);
      var jsonObj = json.decode(ret);
      expect(jsonObj['error'].toString().trim(), 'Passwords do not match');
    });
  });
}