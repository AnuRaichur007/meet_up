import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_up/Models/user.dart';

class AuthMethods{
  
final FirebaseAuth _auth = FirebaseAuth.instance;
AppUsers? _userFromFirebaseUser(User user){
  return user!=null ? AppUsers(userID: user.uid) : null;
}

Future signInWithEmailAndPassword(String email, String password) async{
  try{
     UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
     User? firebaseuser = result.user;
     return _userFromFirebaseUser(firebaseuser!);
  }catch(e){
    print(e.toString());
    return null;
  }
}

Future signUpWithEmailAndPassword(String email, String password) async{
  try{
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? firebaseuser = result.user;
    return _userFromFirebaseUser(firebaseuser!);
  }catch(e){
    print(e.toString());
  }
}

Future resetPassword(String email) async {
  try{
    return await _auth.sendPasswordResetEmail(email: email);
  }catch(e){
    print(e.toString());
  }
}

Future signOut() async {
  try{
  return  await _auth.signOut();
  }catch(e){
    print(e.toString());
  }
}
  
}