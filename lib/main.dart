import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rankers_institute/globals.dart' as g;
import 'package:rankers_institute/screens/errorscr.dart';
import 'package:rankers_institute/screens/frontPage.dart';
import 'package:rankers_institute/services/mlhelper.dart';
import 'package:rankers_institute/widgets/loading.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => SafeArea(
        child: ErrorScr(
          error: details.toString(),
        ),
      );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              disabledColor: Colors.black,
              unselectedWidgetColor: Colors.black,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(title: 'Ranker\'s Institute'),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    MLHelper().train();
  }

  @override
  Widget build(BuildContext context) {
    //for once giving the screen width and height to global variables
    g.width = MediaQuery.of(context).size.width;
    g.height = MediaQuery.of(context).size.height;
    return SafeArea(
        //not allowing screen behind status bar
        child: GestureDetector(
      //helping in detection of common gestures on screen
      //to take focus out of textfield when clicked outside
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: FrontPage(),
    ));
  }
}
