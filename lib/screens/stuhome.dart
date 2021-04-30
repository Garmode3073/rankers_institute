import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:rankers_institute/screens/analysis.dart';
import 'package:rankers_institute/screens/schedule.dart';
import 'package:rankers_institute/screens/smsubs.dart';
import 'package:rankers_institute/screens/studbt.dart';
import 'package:rankers_institute/services/dbser.dart';
import 'package:rankers_institute/screens/smclasses.dart';
import 'package:rankers_institute/services/mlhelper.dart';
import 'package:rankers_institute/widgets/hpimg.dart';
import 'package:rankers_institute/globals.dart' as g;
import 'package:rankers_institute/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class StuHome extends StatefulWidget {
  @override
  _StuHomeState createState() => _StuHomeState();
}

class _StuHomeState extends State<StuHome> {
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
                  top: g.height * 0.070),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            isload = true;
                            setState(() {});
                            final Map testdata = {};
                            List allTest = [];
                            List allS = await DatabaseServices(uid: g.uid)
                                .allSubs(g.stuGlob.classId);
                            for (int i = 0; i < allS.length; i++) {
                              var v = await DatabaseServices(uid: g.uid)
                                  .getTest('subjectID', allS[i]['subject']);
                              if (v.isNotEmpty) {
                                testdata[allS[i]['subject']] = v;
                                allTest += v;
                              }
                            }
                            int mar = 0;
                            for (int i = 0; i < allTest.length; i++) {
                              mar = mar + allTest[i].marks;
                            }
                            int c = await DatabaseServices(uid: g.uid)
                                .getDoubtCount(g.uid);
                            var mlh = MLHelper()
                                .studentSide([c, mar / allTest.length]);
                            print(mlh);
                            isload = false;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      StuAnalysis(
                                        testd: testdata,
                                        doubtCount: c,
                                        allM: mlh,
                                      )),
                            );
                          },
                          child: hpImage('1')),
                      GestureDetector(
                        child: hpImage('2'),
                        onTap: () async {
                          setState(() {
                            isload = true;
                          });
                          List allC;
                          allC = await DatabaseServices(uid: g.uid)
                              .getSched(g.stuGlob.classId);
                          isload = false;
                          print(allC);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ScheduleStu(
                                          sch: allC,
                                        )),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: g.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: hpImage('3'),
                        onTap: () async {
                          setState(() {
                            isload = true;
                          });
                          List allC;
                          allC = await DatabaseServices(uid: g.uid)
                              .allSubs(g.stuGlob.classId);
                          isload = false;
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        SMSub(
                                          list: allC,
                                        )),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          List allDbt;
                          allDbt =
                              await DatabaseServices(uid: g.uid).getDoubtSt();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        StuDoubt(
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
                          List link;
                          link = await DatabaseServices(uid: g.uid)
                              .getLink(g.stuGlob.classId);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Current Lecture'),
                                  content: SingleChildScrollView(
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        link[0]['link'] != ''
                                            ? launch(link[0]['link'])
                                            : setState(() {});
                                      },
                                      child: Text(
                                        link[0]['link'],
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                            },
                          );
                        },
                        child: hpImage('5'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
