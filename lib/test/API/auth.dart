// Lper Max
const testId= '5fa2c83cbd3915ec925b2fe8';
const testToken = '414x2ntokslku3ztpgab7smb1';

// Leo
const leoId = '5fa2acde10f740ca2bc1265f';
const leoToken= '079f9zqnodyq2iw43r2nl8x82';

// Jan
const janId = '5f997e32b5b10b72f88f33a1';
const janToken = '97nz4l9kq83rz907tyff6ara8';

enum User {Jan , Leo , Test}

const Map<User, String> authQueries = {
  User.Jan: '?auth=$janToken&userId=$janId',
  User.Leo: '?auth=$janToken&userId=$janId',
  User.Test: '?auth=$janToken&userId=$janId',
};

class Auth {

  static String getAuth(User user){
    return authQueries[user];
  }

}