import 'package:flutter/material.dart';

class SignUpDateOfBirthScreen extends StatefulWidget {
  const SignUpDateOfBirthScreen({Key? key}) : super(key: key);

  @override
  State<SignUpDateOfBirthScreen> createState() =>
      _SignUpDateOfBirthScreenState();
}

class _SignUpDateOfBirthScreenState extends State<SignUpDateOfBirthScreen> {
  int _selectedDay = 1;
  String _selectedMonth = 'Jan';
  int _selectedYear = 2000;

  final List<int> _days = List.generate(31, (index) => index + 1);
  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final List<int> _years = List.generate(100, (index) => 2022 - index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
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
                    items:
                        _months.map<DropdownMenuItem<String>>((String value) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
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
