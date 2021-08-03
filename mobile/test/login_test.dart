import 'dart:convert';
import 'package:test/test.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/utils/get_api.dart';

void main() {
  group('Unit Testing', () {
    test('Login should return First Name', () async{
      Map _payload = Map();
      _payload['email'] = 'joeljoy@gmail.com';
      _payload['password'] = 'pass';
      String dir = '/login';
      String ret = await API.getJson(dir, _payload);
      var jsonObj = json.decode(ret);
      expect(jsonObj['firstName'], 'James');
    });

    test('Login should return Employer', () async{
      Map _payload = Map();
      _payload['email'] = 'joeljoy@gmail.com';
      _payload['password'] = 'pass';
      String dir = '/login';
      String ret = await API.getJson(dir, _payload);
      var jsonObj = json.decode(ret);
      expect(jsonObj['flag'], 1);
    });

    test('Login should return Company Code', () async{
      Map _payload = Map();
      _payload['email'] = 'joeljoy@gmail.com';
      _payload['password'] = 'pass1';
      String dir = '/login';
      String ret = await API.getJson(dir, _payload);
      var jsonObj = json.decode(ret);
      expect(jsonObj['companyCode'], '8830');
    });
  });
}