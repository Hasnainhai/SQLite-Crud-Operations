import 'package:flutter/material.dart';
import 'package:sqllite/Modals/Employee_model.dart';
import 'package:sqllite/Modals/myDatabase.dart';
import 'package:sqllite/Scareens/AddEmployee.dart';
import 'package:sqllite/Scareens/Edit_employee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Employee> employee = List.empty(growable: true);
  bool isLoading = false;
  final MyDatabase _myDatabase = MyDatabase();
  int count = 0;

  getDataFromDb() async {
    await _myDatabase.initailizeDatabase();
    List<Map<String, Object?>> map = await _myDatabase.getEmpList();
    for (int i = 0; i < map.length; i++) {
      employee.add(Employee.toEmp(map[i]));
    }
    count = await _myDatabase.countEmp();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getDataFromDb();
    super.initState();
    // employees.add(
    //   Employee(EpId: 12, EpName: "Hasnain", EpDesignation: 'Bsc', isMale: true),
    // );
    // employees.add(
    //   Employee(EpId: 23, EpName: "Aliza", EpDesignation: 'Msc', isMale: false),
    // );
    // employees.add(
    //   Employee(EpId: 15, EpName: "Basit", EpDesignation: 'B.A', isMale: true),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployee(myDatabase: _myDatabase),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('SQL-LIte'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : employee.isEmpty
              ? const Center(
                  child: Text('There is no employee Yet'),
                )
              : ListView.builder(
                  itemCount: employee.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: employee[index].isMale
                                ? Colors.blue
                                : Colors.pink,
                            child: Icon(
                              employee[index].isMale
                                  ? Icons.male
                                  : Icons.female,
                            ),
                          ),
                          title: SizedBox(
                            width: 10,
                            child: Row(
                              children: [
                                Text(
                                  employee[index].epName,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text('(${employee[index].epId.toString()})')
                              ],
                            ),
                          ),
                          subtitle: Text(employee[index].epDesignation),
                          trailing: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Editemployee(
                                          employee: employee[index],
                                          myDatabase: _myDatabase,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final epName = employee[index].epName;
                                    _myDatabase.rowsDeleted(employee[index]);
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'The Employee ${epName}has been deleted')));
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen()),
                                          (route) => false);
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
