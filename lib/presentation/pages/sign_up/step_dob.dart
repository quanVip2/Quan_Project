import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/sign_up_provider.dart';

class SignUpDateOfBirthScreen extends StatefulWidget {
  const SignUpDateOfBirthScreen({super.key});

  @override
  State<SignUpDateOfBirthScreen> createState() => _SignUpDateOfBirthScreenState();
}

class _SignUpDateOfBirthScreenState extends State<SignUpDateOfBirthScreen> {
  int _selectedDay = 1;
  String _selectedMonth = 'Jan';
  int _selectedYear = 2000;

  final List<int> _days = List.generate(31, (index) => index + 1);
  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final List<int> _years = List.generate(100, (index) => 2024 - index);

  // Chuyển đổi tháng từ chữ sang số
  String _convertMonthToNumber(String month) {
    final Map<String, String> monthMap = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
    };
    return monthMap[month] ?? '01';
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Create account",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "What's your date of birth?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Picker cho ngày
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedDay,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedDay = newValue!;
                      });
                    },
                    items: _days.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                // Picker cho tháng
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedMonth,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonth = newValue!;
                      });
                    },
                    items: _months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                // Picker cho năm
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedYear,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedYear = newValue!;
                      });
                    },
                    items: _years.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Định dạng ngày: YYYY-MM-DD (thêm padLeft cho ngày nếu cần)
                  String formattedDate =
                      '$_selectedYear-${_convertMonthToNumber(_selectedMonth)}-${_selectedDay.toString().padLeft(2, '0')}';
                  
                  // Lưu birthday vào provider (trong registerUser, key sẽ là "birthday")
                  signUpProvider.setDateOfBirth(formattedDate);
                  
                  Navigator.pushNamed(context, '/signup_gender');
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
