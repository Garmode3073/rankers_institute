import 'package:flutter/material.dart';
import 'package:rankers_institute/screens/addstudy.dart';
import 'package:rankers_institute/screens/schedule.dart';
import 'package:rankers_institute/screens/teaanalysis.dart';
import 'package:rankers_institute/screens/teadbt.dart';
import 'package:rankers_institute/services/dbser.dart';
import 'package:rankers_institute/widgets/hpimg.dart';
import 'package:rankers_institute/widgets/loading.dart';
import 'package:rankers_institute/globals.dart' as g;
import 'package:rankers_institute/widgets/loginfield.dart';

class TeaHome extends StatefulWidget {
  TeaHome({
    Key key,
  }) : super(key: key);

  @override
  _TeaHomeState createState() => _TeaHomeState();
}

class _TeaHomeState extends State<TeaHome> {
  bool isload = false;
  @override
  Widget build(BuildContext context) {
    return isload
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: const Color(0xffcaf0f8),
            body: Padding(
              padding: EdgeInsets.only(
                  left: g.width * 0.03,
                  right: g.width * 0.03,
                  top: g.height * 0.080),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              isload = true;
                            });
                            final Map testdata = {};
                            List allT =
                                await DatabaseServices(uid: g.uid).getcls();
                            for (int i = 0; i < allT.length; i++) {
                              var v = await DatabaseServices(uid: g.uid)
                                  .getTestt('classID', allT[i]);
                              if (v.isNotEmpty) {
                                testdata[allT[i]] = v;
                              }
                            }
                            isload = false;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      TeaAnalysis(
                                        testd: testdata,
                                      )),
                            );
                          },
                          child: hpImage('1')),
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              isload = true;
                            });
                            List allS =
                                await DatabaseServices(uid: g.uid).allClasses();
                            isload = false;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      TeaSchedule(
                                        list: allS,
                                      )),
                            );
                          },
                          child: hpImage('2'))
                    ],
                  ),
                  SizedBox(
                    height: g.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              isload = true;
                            });
                            List allC;
                            allC =
                                await DatabaseServices(uid: g.uid).allClasses();
                            isload = false;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        AdmSmCls(list: allC),
                              ),
                            );
                          },
                          child: hpImage('3')),
                      GestureDetector(
                        onTap: () async {
                          List allDbt;
                          allDbt =
                              await DatabaseServices(uid: g.uid).getDoubtTe();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        TeaDoubt(
                                          doubts: allDbt,
                                        )),
                          );
                        },
                        child: hpImage('4'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: g.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            List allC;
                            allC =
                                await DatabaseServices(uid: g.uid).allClasses();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String classid;
                                String error = '';
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return GestureDetector(
                                    onTap: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                    },
                                    child: AlertDialog(
                                      title: Text('Add Lecture'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            TxtField(
                                              ctrl: g.leclink,
                                              hint: "Lecture Link",
                                            ),
                                            DropdownButton<String>(
                                              isExpanded: true,
                                              value: classid,
                                              elevation: 16,
                                              hint: Text('Class'),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  classid = newValue;
                                                });
                                              },
                                              items: allC.map<
                                                      DropdownMenuItem<String>>(
                                                  (value) {
                                                return DropdownMenuItem<String>(
                                                  value: value['class'],
                                                  child: Text(
                                                    value['class'],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            Center(
                                              child: Text(
                                                error,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Add'),
                                          onPressed: () {
                                            if (classid == null ||
                                                g.leclink.text.isEmpty) {
                                              setState(() {
                                                error =
                                                    'Please enter all the data';
                                              });
                                            } else {
                                              DatabaseServices(uid: g.uid)
                                                  .updateLecture(
                                                      g.leclink.text, classid);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          child: hpImage('5')),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
