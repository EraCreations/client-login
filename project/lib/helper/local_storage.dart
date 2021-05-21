import 'package:project/modal/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* 

This class is saving data locally in the phone for futher using in app
you can data from account class directly and have small state for it can also used for saving pdfs links and 
images links as save document folder

*/
class LocalStorage {
  SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

// Initialization of Local Storage => mean shared preferences
  LocalStorage() {
    this.init();
  }

//setting data of account class into the local Storage
  Future<void> setAccount(Account account) async {
    //Checking here instace of Shared Preferences
    if (prefs == null) {
      await this.init();
    }

    prefs.setString('email', account.email);
    prefs.setString('uid', account.uid);
    prefs.setString('std', account.std);
    prefs.setString('name', account.name);
  }

  //getting data from json form out of the local storage to use in app
  Future<Account> getAccount() async {
    if (prefs == null) {
      await this.init();
    }
    Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = prefs.getString('email');
    data['uid'] = prefs.getString('uid');
    data['std'] = prefs.getString('std');
    data['name'] = prefs.getString('name');
    return Account.fromJson(data);
  }
}
