import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankers_institute/models/students.dart';
import 'package:rankers_institute/models/teachers.dart';
import 'package:rankers_institute/models/user.dart';
import 'package:rankers_institute/globals.dart' as g;

class DatabaseServices {
  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference classColl =
      FirebaseFirestore.instance.collection('classes');
  final CollectionReference subColl =
      FirebaseFirestore.instance.collection('usertype');

  DatabaseServices({this.uid});

  Future updateUserInfo(User user, bool isCreating) async {
    if (isCreating) {
      return await userCollection.doc(user.uid).set({
        'email': user.email,
        'password': user.password,
        'usertype': user.usertype,
      });
    }
    return await userCollection.doc(user.uid).update({
      'email': user.email,
      'password': user.password,
      'usertype': user.usertype,
    });
  }

  //update student info
  Future updateStuInfo(Student student, bool isCreating) async {
    if (isCreating) {
      return await FirebaseFirestore.instance
          .collection('student')
          .doc(student.stuId)
          .set({
        'classID': student.classId,
        'contact': student.contact,
        'email': student.email,
        'name': student.name,
        'rollno': student.rollNo,
      });
    }
    return await FirebaseFirestore.instance
        .collection('student')
        .doc(student.stuId)
        .update({
      'classID': student.classId,
      'contact': student.contact,
      'email': student.email,
      'name': student.name,
      'rollno': student.rollNo,
    });
  }

  //update teacher info
  Future updateTeaInfo(Teacher tea, bool isCreating) async {
    if (isCreating) {
      return await FirebaseFirestore.instance
          .collection('teacher')
          .doc(tea.tId)
          .set({
        'subject': tea.subject,
        'teachername': tea.teacherName,
      });
    }
    return await FirebaseFirestore.instance
        .collection('teacher')
        .doc(tea.tId)
        .update({
      'subject': tea.subject,
      'teachername': tea.teacherName,
    });
  }

  //add material
  Future updateMaterial(String clss, String link, String subject) async {
    return await FirebaseFirestore.instance
        .collection('material')
        .doc()
        .set({'subjectID': subject, 'classID': clss, 'materialLink': link});
  }

  //addlec
  Future updateLecture(String name, String rollno) async {}

  //add fees details
  Future addFees(String email, String clss) async {
    var v = await FirebaseFirestore.instance
        .collection('student')
        .where('email', isEqualTo: email)
        .get();
    return await FirebaseFirestore.instance
        .collection('fees')
        .doc(v.docs[0].id)
        .set({'amtpaid': 0, 'amttotal': g.fees[clss], 'username': email});
  }

  //get fees
  Future<DocumentSnapshot> getFees() async {
    return await FirebaseFirestore.instance.collection('fees').doc(uid).get();
  }

  //update fees details
  Future updateFees(String email, int amtpaid) async {
    var v = await FirebaseFirestore.instance
        .collection('student')
        .where('email', isEqualTo: email)
        .get();
    return await FirebaseFirestore.instance
        .collection('fees')
        .doc(v.docs[0].id)
        .update({'amtpaid': amtpaid});
  }

  //get current user
  Future<DocumentSnapshot> currentUser() async {
    return await userCollection.doc(uid).get();
  }

  //get student if current
  Future<DocumentSnapshot> currentStu() async {
    return await FirebaseFirestore.instance
        .collection('student')
        .doc(uid)
        .get();
  }

  //get teacher if current
  Future<DocumentSnapshot> currentTea() async {
    return await FirebaseFirestore.instance
        .collection('teacher')
        .doc(uid)
        .get();
  }

  //get admin if current
  Future<DocumentSnapshot> currentAdm() async {
    return await FirebaseFirestore.instance.collection('admin').doc(uid).get();
  }

  Future<List> allClasses() async {
    return await FirebaseFirestore.instance
        .collection('classes')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<List> allSubs(String cls) async {
    return await FirebaseFirestore.instance
        .collection('subjects')
        .where("class", isEqualTo: cls)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<List> allSch(String cls) async {
    return await FirebaseFirestore.instance
        .collection("schedule ")
        .where("class", isEqualTo: cls)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  //all Tests
  Future<List> allTests(String cls) async {
    List s = await FirebaseFirestore.instance
        .collection("test")
        .where("classID", isEqualTo: cls)
        .get()
        .then((value) => value.docs
            .map((e) => e.get("subjectID"))
            .toList()
            .toSet()
            .toList());
    s.sort();
    return s;
  }

  //all test tests
  Future<List> allTeststes(String cls) async {
    List s = await FirebaseFirestore.instance
        .collection("test")
        .where("classID", isEqualTo: cls)
        .get()
        .then((value) =>
            value.docs.map((e) => e.get("testType")).toList().toSet().toList());
    s.sort();
    return s;
  }

  //update schedule
  Future updateSch(classs, time, subject, day) async {
    var v = await FirebaseFirestore.instance
        .collection('schedule ')
        .where('class', isEqualTo: classs)
        .where('day', isEqualTo: day)
        .get();
    return await FirebaseFirestore.instance
        .collection('schedule ')
        .doc(v.docs[0].id)
        .update({
      time: subject,
    });
  }

  //add marks
  Future addMarks(email, marks, sub, test, cls) async {
    var v = await FirebaseFirestore.instance
        .collection('student')
        .where('classID', isEqualTo: cls)
        .where('email', isEqualTo: email)
        .get();
    var t = await FirebaseFirestore.instance
        .collection('test')
        .where('classID', isEqualTo: cls)
        .where('subjectID', isEqualTo: sub)
        .where('testType', isEqualTo: test)
        .get();
    await FirebaseFirestore.instance
        .collection('marks')
        .doc(v.docs[0].id)
        .set({'marks': marks, 'studentID': email, 'testID': t.docs[0].id});
  }
}

//for only 5th standard

// classColl
//         .where('class', isEqualTo: '5th')
//         .get()
//         .then((value) => value.docs.map((e) => e.data()).toList());
