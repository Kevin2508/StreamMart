import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoleSelection extends StatelessWidget {
  final String userId;

  const RoleSelection({super.key, required this.userId});

  void _selectRole(BuildContext context, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'role': role,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));

    // Navigate to the respective page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Role set as $role")),
    );

    // Example navigation
    if (role == 'seller') {
      Navigator.pushReplacementNamed(context, '/SellerDashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectRole(context, 'buyer'),
              child: const Text("I'm a Buyer"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectRole(context, 'seller'),
              child: const Text("I'm a Seller"),
            ),
          ],
        ),
      ),
    );
  }
}
