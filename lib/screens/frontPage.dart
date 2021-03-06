import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:provider/provider.dart';
import 'package:rankers_institute/globals.dart' as g;
import 'package:rankers_institute/models/user.dart';
import 'package:rankers_institute/screens/wrapper.dart';
import 'package:rankers_institute/services/auth.dart';
import 'package:rankers_institute/widgets/loading.dart';
import 'loginPage.dart';

class FrontPage extends StatefulWidget {
  FrontPage({
    Key key,
  }) : super(key: key);

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  bool isload = false;
  @override
  Widget build(BuildContext context) {
    double width = g.width;
    double height = g.height;
    return isload
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: const Color(0xff0077b6),
            body: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: width / 14,
                      right: width / 14,
                      top: height / 20,
                      bottom: height / 20),
                  decoration: BoxDecoration(
                    color: Color(0xff90e0ef).withOpacity(0.5),
                  ),
                ),
                //Login button box
                Transform.translate(
                  offset: Offset(width * 1.2 / 5, height * 5.3 / 7),
                  child: Container(
                    width: width / 2,
                    height: height / 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color(0xe3ffffff),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x24000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                //Login button text
                Transform.translate(
                  offset: Offset(width * 1 / 3, height * 5.37 / 7),
                  child: RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        isload = true;
                      });
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  StreamProvider<User>.value(
                                      value: AuthServices().userIsIn,
                                      child: WrapScreens()),
                        ),
                      );
                    },
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontFamily: 'Lucida Bright',
                        fontSize: 40,
                        color: const Color(0xff0e0d0d),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                // background image
                Transform.translate(
                  offset: Offset(0.0, height * 0.8 / 5),
                  child:
                      // Adobe XD layer: 'kisspng-student-lea…' (shape)
                      Container(
                    width: 418.0,
                    height: 418.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('lib/assets/frontpageimg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                //Logo
                Transform.translate(
                  offset: Offset(width * 1.5 / 5, height * 0.6 / 5),
                  child:
                      // Adobe XD layer: 'r-removebg-preview …' (shape)
                      Container(
                    width: g.width * 0.4,
                    height: g.height * 0.15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('lib/assets/rlogo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
