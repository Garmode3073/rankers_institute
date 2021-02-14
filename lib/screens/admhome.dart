import 'package:flutter/material.dart';
import 'package:rankers_institute/Admschedule.dart';
import 'package:rankers_institute/widgets/hpimg.dart';
import 'package:rankers_institute/widgets/loading.dart';
import 'package:rankers_institute/globals.dart' as g;

class AdmHome extends StatefulWidget {
  AdmHome({
    Key key,
  }) : super(key: key);

  @override
  _AdmHomeState createState() => _AdmHomeState();
}

class _AdmHomeState extends State<AdmHome> {
  @override
  Widget build(BuildContext context) {
    bool isload = false;
    return isload
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: const Color(0xffcaf0f8),
            body: Padding(
              padding: EdgeInsets.only(
                  left: g.width * 0.03,
                  right: g.width * 0.03,
                  top: g.height * 0.02),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hpImage('1'),
                      GestureDetector(
                        child: hpImage('2'),
                        onTap: () async {
                          setState(() {
                            isload = true;
                          });
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        AdmSchedule()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: g.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [hpImage('9'), hpImage('7')],
                  ),
                  SizedBox(
                    height: g.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [hpImage('8'), hpImage('10')],
                  ),
                ],
              ),
            ),
          );
  }
}
