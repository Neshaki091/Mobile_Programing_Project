import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng ký người dùng mới
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng nhập người dùng
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng nhập với Google
  Future<User?> signInWithGoogle() async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(),
      );
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Lấy thông tin người dùng hiện tại
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Lấy danh sách sản phẩm từ Firestore
  Future<List<Map<String, String>>> getProducts() async {
    try {
      // Truy vấn vào collection 'DietarySupplementID' -> document 'DSID' -> collection con 'DSID'
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('DietarySupplementID') // Collection chính
              .doc('DSID') // Document chứa collection con DSID
              .collection('DSID') // Collection con DSID
              .get();

      // Kiểm tra xem có dữ liệu không
      print('Number of documents: ${querySnapshot.docs.length}');

      List<Map<String, String>> products = [];

      querySnapshot.docs.forEach((doc) {
        print('Document data: ${doc.data()}'); // In dữ liệu của mỗi document

        // Thêm sản phẩm vào danh sách
        products.add({
          'name': doc['name'], // Lấy tên sản phẩm
          'description': doc['descriptions'], // Lấy mô tả sản phẩm
          'imageUrl': doc['imageURL'], // Lấy URL hình ảnh
        });
      });

      return products;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
