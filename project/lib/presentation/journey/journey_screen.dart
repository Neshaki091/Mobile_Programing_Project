import 'package:flutter/material.dart';
import 'package:project/data/repositories/auth_repository.dart';
import 'package:project/data/models/user_model.dart';
import 'package:project/presentation/profile/EditProfileScreen.dart';
import '../../widgets/appBar_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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
                Text("Chỉnh sửa", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 16),
            _buildBodyMeasurementTile("1. Số đo cơ thể của tôi", "01/01/2023"),
            _buildBodyMeasurementTile("2. Số đo cơ thể của tôi", "01/02/2023"),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyMeasurementTile(String title, String date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        title: Text(title),
        subtitle: Text(date),
        trailing: Icon(Icons.open_in_new, color: Colors.blue),
        onTap: () {},
      ),
    );
  }
}
