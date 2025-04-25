import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/data/repositories/auth_repository.dart';
import 'package:project/data/models/user_model.dart';
import 'package:project/data/models/body_measurement.dart';

class BodyMeasurementScreen extends StatefulWidget {
  final AuthRepository authRepo;
  final UserProfile? profile;

  const BodyMeasurementScreen({
    Key? key, 
    required this.authRepo,
    this.profile,
  }) : super(key: key);

  @override
  _BodyMeasurementScreenState createState() => _BodyMeasurementScreenState();
}

class _BodyMeasurementScreenState extends State<BodyMeasurementScreen> {
  final TextEditingController bustController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> bodyMeasurements = [];

  @override
  void initState() {
    super.initState();
    _loadExistingMeasurements();
  }

  Future<void> _loadExistingMeasurements() async {
    if (widget.profile == null || widget.authRepo.currentUser == null) return;
    
    final uid = widget.authRepo.currentUser!.uid;
    
    try {
      // Tìm bản ghi đo gần nhất
      final snapshot = await FirebaseFirestore.instance
          .collection('bodyMeasurements')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          bustController.text = data['bust']?.toString() ?? '';
          waistController.text = data['waist']?.toString() ?? '';
          hipController.text = data['hip']?.toString() ?? '';
          bodyMeasurements = snapshot.docs.map((doc) => doc.data()).toList();
        });
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
    }
  }

  Future<void> _saveMeasurements() async {
    final bust = double.parse(bustController.text.trim());
    final waist = double.parse(waistController.text.trim());
    final hip = double.parse(hipController.text.trim());

    if (bustController.text.trim().isEmpty || waistController.text.trim().isEmpty || hipController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ số đo')),
      );
      return;
    }

    if (widget.authRepo.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn cần đăng nhập để lưu số đo')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = widget.authRepo.currentUser!.uid;
      print('Lưu số đo cho userId: $userId');
      final now = DateTime.now();
      
      // Tạo đối tượng BodyMeasurement
      final measurement = BodyMeasurement(
        userId: userId,
        bust: bust,
        waist: waist,
        hip: hip,
        createdAt: Timestamp.now(),
        date: '${now.day}/${now.month}/${now.year}',
      );

      // Lưu xuống Firestore
      await FirebaseFirestore.instance.collection('bodyMeasurements').add(measurement.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lưu thành công!')),
      );
      
      // Trả về true để JourneyScreen biết đã lưu thành công
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print debug
    print('bodyMeasurements.length: ${bodyMeasurements.length}');
    if (bodyMeasurements.isNotEmpty) {
      print('First measurement: ${bodyMeasurements.first}');
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Số đo cơ thể'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nhập số đo cơ thể của bạn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildInputField(label: 'Ngực (cm)', controller: bustController),
              _buildInputField(label: 'Eo (cm)', controller: waistController),
              _buildInputField(label: 'Mông (cm)', controller: hipController),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveMeasurements,
                child: Text('Lưu số đo'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
