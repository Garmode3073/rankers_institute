import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rankers_institute/globals.dart' as g;
import 'package:rankers_institute/models/admin.dart';
import 'package:rankers_institute/models/students.dart';
import 'package:rankers_institute/models/teachers.dart';
import 'package:rankers_institute/models/user.dart';
import 'package:rankers_institute/screens/admhome.dart';
import 'package:rankers_institute/services/auth.dart';
import 'package:rankers_institute/services/dbser.dart';
import 'package:rankers_institute/widgets/loading.dart';
import 'package:rankers_institute/widgets/loginfield.dart';

class AddUser extends StatefulWidget {
  AddUser({
    Key key,
  }) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  bool isload = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffcaf0f8),
      body: Center(
        child: Container(
          height: g.height * 0.8,
          width: g.width * 0.85,
          decoration: BoxDecoration(
            color: const Color(0x9684d9eb),
            border: Border.all(width: 1.0, color: const Color(0x96707070)),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              RawMaterialButton(
                onPressed: () async {
                  setState(() {
                    isload = true;
                  });
                  List allC;
                  allC = await DatabaseServices(uid: g.uid).allClasses();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          AddStudents(
                        subs: allC,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Container(
                    height: g.height * 0.07,
                    width: g.width * 0.70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 3.0, color: const Color(0x96707070)),
                    ),
                    child: Center(
                      child: Text(
                        'Add Student',
                        style: g.loginpgstyles(Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: g.height * 0.1,
              ),
              RawMaterialButton(
                onPressed: () async {
                  var allC;
                  allC = await DatabaseServices(uid: g.uid).getAllUsers();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String error = '';
                      final AuthServices _auth = AuthServices();
                      bool isload = false;
                      return StatefulBuilder(builder: (context, setState) {
                        return WillPopScope(
                          onWillPop: () {
                            g.teaEmail.clear();
                            g.teaName.clear();
                            g.teaPass.clear();
                            g.teaContact.clear();
                            Navigator.pop(context);
                            return Future.value(false);
                          },
                          child: GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: isload
                                ? LoadingScreen()
                                : AlertDialog(
                                    title: Text('Add an admin'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          SizedBox(
                                            height: g.height * 0.01,
                                          ),
                                          Text('Email'),
                                          SizedBox(
                                            height: g.height * 0.01,
                                          ),
                                          ATSInpField(edit: g.teaEmail),
                                          SizedBox(
                                            height: g.height * 0.03,
                                          ),
                                          Text('Password'),
                                          SizedBox(
                                            height: g.height * 0.01,
                                          ),
                                          ATSInpField(edit: g.teaPass),
                                          SizedBox(
                                            height: g.height * 0.03,
                                          ),
                                          Text('Name'),
                                          SizedBox(
                                            height: g.height * 0.01,
                                          ),
                                          ATSInpField(edit: g.teaName),
                                          SizedBox(
                                            height: g.height * 0.03,
                                          ),
                                          Text('Contact no'),
                                          SizedBox(
                                            height: g.height * 0.01,
                                          ),
                                          ATSInpField(edit: g.teaContact),
                                          Center(
                                            child: Text(
                                              error,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text('Add'),
                                          onPressed: () async {
                                            if (g.teaEmail.text.isEmpty ||
                                                g.teaPass.text.isEmpty ||
                                                g.teaName.text.isEmpty ||
                                                g.teaContact.text.isEmpty ||
                                                g.teaContact.text
                                                        .trim()
                                                        .length !=
                                                    10 ||
                                                !g.teaEmail.text
                                                    .trim()
                                                    .endsWith('.com') ||
                                                num.tryParse(
                                                        g.teaContact.text) ==
                                                    null) {
                                              setState(() {
                                                error = 'Invalid Entries';
                                              });
                                            } else {
                                              setState(() {
                                                isload = true;
                                              });
                                              try {} catch (e) {
                                                setState(() {
                                                  isload = false;
                                                  error =
                                                      'Something went wrong try again';
                                                });
                                              }
                                              var c = await _auth
                                                  .registerWithEmailAndPassword(
                                                      g.teaEmail.text,
                                                      g.teaPass.text,
                                                      'Admin');
                                              if (c == null) {
                                                setState(() {
                                                  isload = false;
                                                  error =
                                                      'Error while registering!! Try again';
                                                });
                                              } else {
                                                var h = await DatabaseServices(
                                                        uid: g.uid)
                                                    .addAdmin(
                                                        Admin(
                                                            admId: c.uid,
                                                            contact: g
                                                                .teaContact
                                                                .text,
                                                            email:
                                                                g.teaEmail.text,
                                                            name:
                                                                g.teaName.text),
                                                        c.uid);
                                                if (h != '') {
                                                  setState(() {
                                                    isload = false;
                                                    error = h;
                                                  });
                                                }
                                                g.teaContact.clear();
                                                g.teaEmail.clear();
                                                g.teaName.clear();
                                                g.teaPass.clear();
                                                Navigator.pop(context);
                                              }
                                            }
                                          }),
                                    ],
                                  ),
                          ),
                        );
                      });
                    },
                  );
                },
                child: Center(
                  child: Container(
                    height: g.height * 0.07,
                    width: g.width * 0.70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 3.0, color: const Color(0x96707070)),
                    ),
                    child: Center(
                      child: Text(
                        'Add Admin',
                        style: g.loginpgstyles(Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: g.height * 0.1,
              ),
              RawMaterialButton(
                onPressed: () async {
                  setState(() {
                    isload = true;
                  });
                  List allS = await DatabaseServices(uid: g.uid).allSubClass();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          AddTeachers(
                        subs: allS,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Container(
                    height: g.height * 0.07,
                    width: g.width * 0.70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 3.0, color: const Color(0x96707070)),
                    ),
                    child: Center(
                      child: Text(
                        'Add Teacher',
                        style: g.loginpgstyles(Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: g.height * 0.1,
              ),
              RawMaterialButton(
                onPressed: () async {
                  var allC;
                  allC = await DatabaseServices(uid: g.uid).getAllUsers();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String classid;
                      String error = '';
                      var user;
                      bool isload = false;
                      return StatefulBuilder(builder: (context, setState) {
                        return WillPopScope(
                          onWillPop: () {
                            g.leclink.clear();
                            Navigator.pop(context);
                            return Future.value(false);
                          },
                          child: GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: isload
                                ? LoadingScreen()
                                : AlertDialog(
                                    title: Text('Delete a user'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          SizedBox(
                                            height: g.height * 0.01,
                                          ),
                                          DropdownButton<String>(
                                            isExpanded: true,
                                            value: classid,
                                            elevation: 16,
                                            hint: Text('User Email'),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                classid = newValue;
                                              });
                                            },
                                            items: allC.docs
                                                .map<DropdownMenuItem<String>>(
                                                    (value) {
                                              return DropdownMenuItem<String>(
                                                onTap: () {
                                                  setState(() {
                                                    user = value;
                                                    classid =
                                                        value.data()['email'];
                                                  });
                                                },
                                                value: value.data()['email'],
                                                child: Text(
                                                  value.data()['email'],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          Center(
                                            child: Text(
                                              error,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          if (classid == null || user == null) {
                                            setState(() {
                                              error = 'some fields are empty';
                                            });
                                          } else {
                                            setState(() {
                                              isload = true;
                                            });
                                            if (user.data()['usertype'] ==
                                                'Admin') {
                                              DatabaseServices(uid: g.uid)
                                                  .delAdmin(user.id);
                                              DatabaseServices(uid: g.uid)
                                                  .delUser(user.id);
                                              AuthServices().delete(
                                                  user.data()['email'],
                                                  user.data()['password']);
                                            } else if (user
                                                    .data()['usertype'] ==
                                                'Teacher') {
                                              DatabaseServices(uid: g.uid)
                                                  .delTeacher(user.id);
                                              DatabaseServices(uid: g.uid)
                                                  .delUser(user.id);
                                              AuthServices().delete(
                                                  user.data()['email'],
                                                  user.data()['password']);
                                            } else if (user
                                                    .data()['usertype'] ==
                                                'Student') {
                                              DatabaseServices(uid: g.uid)
                                                  .delMarks(user.id);
                                              DatabaseServices(uid: g.uid)
                                                  .delFees(user.id);
                                              DatabaseServices(uid: g.uid)
                                                  .delDoubt(user.id);
                                              DatabaseServices(uid: g.uid)
                                                  .delStudent(user.id);
                                              DatabaseServices(uid: g.uid)
                                                  .delUser(user.id);
                                              AuthServices().delete(
                                                  user.data()['email'],
                                                  user.data()['password']);
                                            }
                                            isload = false;
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      });
                    },
                  );
                },
                child: Center(
                  child: Container(
                    height: g.height * 0.07,
                    width: g.width * 0.70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 3.0, color: const Color(0x96707070)),
                    ),
                    child: Center(
                      child: Text(
                        'Delete User',
                        style: g.loginpgstyles(Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTeachers extends StatefulWidget {
  final List subs;

  const AddTeachers({Key key, this.subs}) : super(key: key);
  @override
  _AddTeachersState createState() => _AddTeachersState();
}

class _AddTeachersState extends State<AddTeachers> {
  final AuthServices _auth = AuthServices();
  bool isload = false;
  String subs;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return isload
        ? LoadingScreen()
        : WillPopScope(
            onWillPop: () {
              setState(() {
                isload = true;
              });
              g.teaContact.clear();
              g.teaEmail.clear();
              g.teaName.clear();
              g.teaPass.clear();
              Navigator.pop(context, false);
              return Future.value(false);
            },
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: const Color(0xffcaf0f8),
                body: Center(
                  child: Container(
                    height: g.height * 0.8,
                    width: g.width * 0.85,
                    color: Color(0xffffffff).withOpacity(0.55),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: g.height * 0,
                        left: g.width * 0.075,
                        right: g.width * 0.075,
                      ),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.home,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () {
                                  g.teaContact.clear();
                                  g.teaEmail.clear();
                                  g.teaName.clear();
                                  g.teaPass.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(child: Container()),
                              Center(
                                child: Text(
                                  'Add Teacher',
                                  style: g.loginpgstyles(
                                    Color(0xff000000),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                          SizedBox(
                            height: g.height * 0.05,
                          ),
                          Text('Email'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(edit: g.teaEmail),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          Text('Password'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(edit: g.teaPass),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          Text('Name'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(edit: g.teaName),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: subs,
                            elevation: 16,
                            hint: Text('Subject'),
                            onChanged: (String newValue) {
                              setState(() {
                                subs = newValue;
                              });
                            },
                            items: widget.subs
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          Text('Contact no'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(edit: g.teaContact),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          SizedBox(
                            height: g.height * 0.075,
                          ),
                          Center(
                            child: Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Center(
                            child: RawMaterialButton(
                              onPressed: () async {
                                if (g.teaEmail.text.isEmpty ||
                                    g.teaPass.text.isEmpty ||
                                    g.teaName.text.isEmpty ||
                                    subs == null ||
                                    g.teaContact.text.isEmpty ||
                                    g.teaContact.text.trim().length != 10 ||
                                    !g.teaEmail.text.trim().endsWith('.com') ||
                                    num.tryParse(g.teaContact.text) == null) {
                                  setState(() {
                                    error = 'Invalid Entries';
                                  });
                                } else {
                                  setState(() {
                                    isload = true;
                                  });
                                  try {} catch (e) {
                                    setState(() {
                                      isload = false;
                                      error = 'Something went wrong try again';
                                    });
                                  }
                                  var c =
                                      await _auth.registerWithEmailAndPassword(
                                          g.teaEmail.text,
                                          g.teaPass.text,
                                          'Teacher');
                                  if (c == null) {
                                    setState(() {
                                      isload = false;
                                      error = 'Error!! Try again later';
                                    });
                                  } else {
                                    await DatabaseServices(uid: g.uid)
                                        .updateTeaInfo(
                                            Teacher(
                                                teacherName: g.teaName.text,
                                                subject: subs,
                                                tId: c.uid),
                                            true);
                                    g.teaContact.clear();
                                    g.teaEmail.clear();
                                    g.teaName.clear();
                                    g.teaPass.clear();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Container(
                                width: g.width * 0.5,
                                height: g.height * 0.055,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xff90e0ef),
                                ),
                                child: Center(child: Text('Add Teacher')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class AddStudents extends StatefulWidget {
  final List subs;

  AddStudents({Key key, this.subs}) : super(key: key);
  @override
  _AddStudentsState createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  final AuthServices _auth = AuthServices();
  bool isload = false;
  String dropdownValue3;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return isload
        ? LoadingScreen()
        : WillPopScope(
            onWillPop: () {
              g.stuContact.clear();
              g.stuEmail.clear();
              g.stuID.clear();
              g.stuName.clear();
              g.stuPass.clear();
              Navigator.pop(context);
              return Future.value(false);
            },
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: const Color(0xffcaf0f8),
                body: Center(
                  child: Container(
                    height: g.height * 0.8,
                    width: g.width * 0.85,
                    color: Color(0xffffffff).withOpacity(0.55),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: g.height * 0,
                        left: g.width * 0.075,
                        right: g.width * 0.075,
                      ),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.home,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () {
                                  g.stuContact.clear();
                                  g.stuEmail.clear();
                                  g.stuID.clear();
                                  g.stuName.clear();
                                  g.stuPass.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(child: Container()),
                              Center(
                                child: Text(
                                  'Add Student',
                                  style: g.loginpgstyles(
                                    Color(0xff000000),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                          SizedBox(
                            height: g.height * 0.05,
                          ),
                          Text('Email'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(
                            edit: g.stuEmail,
                          ),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          Text('Password'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(edit: g.stuPass),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          Text('Name'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(
                            edit: g.stuName,
                          ),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue3,
                            elevation: 16,
                            hint: Text('Class'),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue3 = newValue;
                              });
                            },
                            items: widget.subs
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value['class'],
                                child: Text(
                                  value['class'],
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          Text('Contact no'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(
                            edit: g.stuContact,
                          ),
                          SizedBox(
                            height: g.height * 0.03,
                          ),
                          Text('Roll no'),
                          SizedBox(
                            height: g.height * 0.01,
                          ),
                          ATSInpField(
                            edit: g.stuID,
                          ),
                          SizedBox(
                            height: g.height * 0.05,
                          ),
                          Center(
                            child: Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Center(
                            child: RawMaterialButton(
                              onPressed: () async {
                                if (dropdownValue3 == null ||
                                    g.stuEmail.text.isEmpty ||
                                    !g.stuEmail.text.trim().endsWith('.com') ||
                                    g.stuContact.text.isEmpty ||
                                    num.tryParse(g.stuContact.text) == null ||
                                    g.stuContact.text.trim().length != 10 ||
                                    g.stuName.text.isEmpty ||
                                    g.stuPass.text.isEmpty ||
                                    g.stuID.text.isEmpty) {
                                  setState(() {
                                    error = 'Invalid entries';
                                  });
                                } else {
                                  setState(() {
                                    isload = true;
                                  });
                                  var c =
                                      await _auth.registerWithEmailAndPassword(
                                          g.stuEmail.text,
                                          g.stuPass.text,
                                          'Student');
                                  await DatabaseServices(uid: g.uid)
                                      .updateStuInfo(
                                          Student(
                                              classId: dropdownValue3,
                                              contact: g.stuContact.text,
                                              name: g.stuName.text,
                                              rollNo: g.stuID.text,
                                              stuId: c.uid),
                                          true);
                                  await DatabaseServices(uid: g.uid)
                                      .addFees(g.stuEmail.text, dropdownValue3);
                                  g.stuContact.clear();
                                  g.stuEmail.clear();
                                  g.stuID.clear();
                                  g.stuName.clear();
                                  g.stuPass.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                width: g.width * 0.5,
                                height: g.height * 0.055,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xff90e0ef),
                                ),
                                child: Center(child: Text('Add Student')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
