import 'package:flutter/material.dart';
import 'package:project/data/repositories/auth_repository.dart';
import 'package:project/data/models/user_model.dart';
import 'package:project/data/models/body_measurement.dart'; // Thêm import này
import 'package:project/presentation/profile/EditProfileScreen.dart';
import 'package:project/presentation/journey/body_screen.dart';
import '../../widgets/appBar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JourneyScreen extends StatefulWidget {
  final AuthRepository authRepo;
  
  const JourneyScreen({Key? key, required this.authRepo}) : super(key: key);

  @override
  _JourneyScreenState createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  double bmi = 0;
  bool _isLoading = true;
  UserProfile? _profile;

  // Thêm biến để lưu danh sách số đo cơ thể
  List<BodyMeasurement> bodyMeasurements = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadBodyMeasurements();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final uid = widget.authRepo.currentUser?.uid;
      if (uid == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final profile = await widget.authRepo.getUserProfile(uid);

      setState(() {
        _profile = profile;
        if (profile != null) {
          bmi = _calculateBMI(profile.weight.toInt(), profile.height.toInt());
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBodyMeasurements() async {
    if (widget.authRepo.currentUser == null) return;
    
    final uid = widget.authRepo.currentUser!.uid;
    print('Đang tìm số đo cho uid: $uid');
    
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bodyMeasurements')
          .get();
      
      print('Tổng số bản ghi: ${snapshot.docs.length}');
      
      final filteredDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['userId'] == uid || data['uid'] == uid;
      }).toList();
      
      print('Số bản ghi sau khi lọc: ${filteredDocs.length}');
      
      if (filteredDocs.isNotEmpty) {
        filteredDocs.sort((a, b) {
          final aTime = a.data()['createdAt'];
          final bTime = b.data()['createdAt'];
          if (aTime is Timestamp && bTime is Timestamp) {
            return bTime.compareTo(aTime);
          }
          return 0;
        });
        
        setState(() {
          // Thay đổi chỗ này để sử dụng model BodyMeasurement
          bodyMeasurements = filteredDocs.map((doc) => 
            BodyMeasurement.fromMap(doc.data(), id: doc.id)
          ).toList();
        });
      }
    } catch (e) {
      print('Lỗi khi tải danh sách số đo cơ thể: $e');
    }
  }

  double _calculateBMI(int weight, int height) {
    if (height == 0) return 0;
    double heightM = height / 100;
    return weight / (heightM * heightM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Training journey', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _profile == null
              ? Center(child: Text('Không có dữ liệu!'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildBMICard(context),
                      SizedBox(height: 20),
                      _buildBodyMeasurementsCard(context),
                    ],
                  ),
                ),
                
    );
  }

  Widget _buildBMICard(BuildContext context) {
    final weight = _profile?.weight.toInt() ?? 0;
    final height = _profile?.height.toInt() ?? 0;
    final age = _profile?.age ?? 0;
    final gender = _profile?.isMale == true ? "Nam" : "Nữ";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
                children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 8),
                Text("Chỉ số BMI của bạn: ", style: TextStyle(fontSize: 16)),
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        authRepo: widget.authRepo,
                      ),
                    ));
                    _loadUserProfile();
                  },
                  child: Text(
                  "Chỉnh sửa", 
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildBMIIndicatorBar(),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _bmiColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(_bmiStatus(), style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoColumn("$weight kg", "Cân Nặng"),
                _infoColumn("$height cm", "Chiều Cao"),
                _infoColumn("$age", "Tuổi"),
                _infoColumn(gender, "Giới Tính"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIIndicatorBar() {
    double minBMI = 10;
    double maxBMI = 40;
    double percent = ((bmi - minBMI) / (maxBMI - minBMI)).clamp(0.0, 1.0);

    return Stack(
      children: [
        Container(
          height: 8,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
              ],
            ),
          ),
        ),
        Positioned(
          left: percent * 220,
          child: Container(
            width: 12,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  Color _bmiColor() {
    if (bmi < 18.5) return Colors.yellow[200]!;
    if (bmi < 25) return Colors.green[100]!;
    if (bmi < 30) return Colors.orange[100]!;
    return Colors.red[100]!;
  }

  String _bmiStatus() {
    if (bmi < 18.5) return "Thiếu cân";
    if (bmi < 25) return "Bình thường";
    if (bmi < 30) return "Thừa cân";
    if (bmi < 35) return "Béo phì độ 1";
    return "Béo phì độ 2";
  }

  Widget _infoColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildBodyMeasurementsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.straighten_outlined),
                SizedBox(width: 8),
                Text("Số đo cơ thể", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    // Chuyển sang trang BodyMeasurementScreen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BodyMeasurementScreen(
                          authRepo: widget.authRepo,
                          profile: _profile,
                        ),
                      ),
                    );
                    
                    // Nếu có kết quả trả về (đã lưu thành công), tải lại dữ liệu
                    if (result == true) {
                      print('Nhận tín hiệu đã lưu thành công, đang tải lại dữ liệu...');
                      await _loadBodyMeasurements();
                      // Đợi để đảm bảo đã tải xong dữ liệu
                      setState(() {}); // Cập nhật UI
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        "Chỉnh sửa", 
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.edit, color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            bodyMeasurements.isEmpty
                ? Text("Chưa có số đo cơ thể nào", 
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                : Column(
                    children: bodyMeasurements.asMap().entries.map((entry) {
                      final index = entry.key;
                      final measurement = entry.value;
                      return _buildBodyMeasurementTile(
                        "${index + 1}. Số đo cơ thể của tôi",
                        measurement.date,
                        measurement,
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyMeasurementTile(String title, String date, BodyMeasurement measurement) {
    print('Hiển thị số đo: ${measurement.toMap()}');
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    date,
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMeasurementColumn('Ngực', '${measurement.bust} cm'),
                _buildMeasurementColumn('Eo', '${measurement.waist} cm'),
                _buildMeasurementColumn('Mông', '${measurement.hip} cm'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
