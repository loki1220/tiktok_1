import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/providers/user_providers.dart';
import 'package:tiktok/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiktok/screens/welcome_page.dart';
import 'package:tiktok/utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TikTok',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: HomePage(),
      ),
    );
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  FirebaseAuth? _auth;
  User? users;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    users = _auth!.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : users == null
            ? HomePage()
            : WelcomePage();
  }
}
