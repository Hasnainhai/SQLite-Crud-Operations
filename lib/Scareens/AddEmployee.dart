import 'package:flutter/material.dart';
import 'package:sqllite/Modals/Employee_model.dart';
import 'package:sqllite/Modals/myDatabase.dart';
import 'package:sqllite/Scareens/HomeScreen.dart';

class AddEmployee extends StatefulWidget {
  final MyDatabase myDatabase;
  const AddEmployee({super.key, required this.myDatabase});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

bool isMale = false;
FocusNode _focusNode = FocusNode();

class _AddEmployeeState extends State<AddEmployee> {
  final TextEditingController _idEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _designationEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: _idEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                  label: Text('Employee Id'),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                  label: Text('Employee Name'),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _designationEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                  label: Text('Employee Designation'),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Male',
                        style: TextStyle(
                          color: isMale ? Colors.grey : Colors.blue,
                          fontSize: 20.0,
                          fontWeight:
                              isMale ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Icon(
                        Icons.male,
                        color: isMale ? Colors.grey : Colors.blue,
                      ),
                    ],
                  ),
                  Switch(
                    value: isMale,
                    onChanged: (value) {
                      setState(() {
                        isMale = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        'Female',
                        style: TextStyle(
                          color: isMale ? Colors.pink : Colors.grey,
                          fontSize: 20.0,
                          fontWeight:
                              isMale ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.female,
                        color: isMale ? Colors.pink : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Employee employee = Employee(
                          epId: int.parse(_idEditingController.text),
                          epName: _nameEditingController.text,
                          epDesignation: _designationEditingController.text,
                          isMale: !isMale,
                        );
                        await widget.myDatabase.insertEmployee(employee);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                  'The Employee ${employee.epName}has been added')));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (route) => false);
                        }
                      },
                      child: const Text('Add')),
                  ElevatedButton(
                      onPressed: () {
                        _idEditingController.text = '';
                        _nameEditingController.text = '';
                        _designationEditingController.text = '';
                        _focusNode.requestFocus();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Reset'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
