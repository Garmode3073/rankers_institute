import 'package:flutter/material.dart';
import 'package:rankers_institute/models/admin.dart';
import 'package:rankers_institute/models/feesm.dart';
import 'package:rankers_institute/models/students.dart';
import 'package:rankers_institute/models/teachers.dart';
import 'package:rankers_institute/models/user.dart';

//current user
User userGlob = User(email: "", password: "", uid: "", usertype: "");
FeesM feesM = FeesM(amtpaid: 0, amttotal: 0, username: "");
Student stuGlob =
    Student(classId: "", contact: "", name: "", rollNo: "", stuId: "");
Teacher teaGlob = Teacher(subject: "", tId: "", teacherName: "");
Admin admGlob = Admin(admId: '', contact: '', email: '', name: '');
String uid = '';
String name = '';

//text controllers for login
TextEditingController uName = TextEditingController(text: "");
TextEditingController uPass = TextEditingController(text: "");

//text controller for adding student
TextEditingController stuName = TextEditingController(text: "");
TextEditingController stuPass = TextEditingController(text: "");
TextEditingController stuEmail = TextEditingController(text: "");
TextEditingController stuContact = TextEditingController(text: "");
TextEditingController stuID = TextEditingController(text: "");
TextEditingController stuAmtPaid = TextEditingController(text: "");
TextEditingController stuMarks = TextEditingController(text: "");

//text controller for adding teacher
TextEditingController teaName = TextEditingController(text: "");
TextEditingController teaPass = TextEditingController(text: "");
TextEditingController teaEmail = TextEditingController(text: "");
TextEditingController teaContact = TextEditingController(text: "");
TextEditingController teaSubject = TextEditingController(text: "");

//text controller for lecture adding
TextEditingController leclink = TextEditingController(text: "");

//text controller for add doubt and notice
TextEditingController title = TextEditingController(text: "");
TextEditingController details = TextEditingController(text: "");

//screen width and height
double width;
double height;
String contact;
String email;

//fees of students
Map fees = {
  '5th': 10000,
  '6th': 10000,
  '7th': 10000,
  '8th': 10000,
  '9th': 10000,
  '10th': 10000,
  '11th sci': 10000,
  '11th com': 10000,
  '12th sci': 10000,
  '12th com': 10000,
};

//login page textfield's textstyles common with color varient
TextStyle loginpgstyles(color) => TextStyle(
      fontFamily: 'Lucida Fax',
      fontSize: 22,
      color: color,
    );

TextStyle adduserstyles(color) => TextStyle(
      fontFamily: 'Lucida Fax',
      fontSize: 16,
      color: color,
    );

List allss;

var model;
