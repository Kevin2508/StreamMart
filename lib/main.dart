import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streammart/features/auth/login_screen.dart'; // Import LoginScreen
import 'package:streammart/features/auth/role_selection.dart'; // Import RoleSelection
import 'package:streammart/features/auth/register_page.dart';
import 'package:streammart/features/home/seller_dashboard.dart'; // Import SellerDashboard
import 'package:streammart/features/home/home_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Shopping App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterPage(),
        '/SellerDashboard': (context) => const SellerDashboard(),
        '/home': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        // Handle dynamic routing for RoleSelection
        if (settings.name == '/roleSelection') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => RoleSelection(userId: userId),
          );
        }
        return null;
      },
    );
  }
}

// 🔁 Check login state and redirect accordingly
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData && snapshot.data != null) {
          // User is logged in
          final userId = snapshot.data!.uid;
          return RoleSelection(userId: userId);
        } else {
          // Not logged in
          return const LoginScreen();
        }
      },
    );
  }
}