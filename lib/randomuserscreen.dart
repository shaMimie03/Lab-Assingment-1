import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomUserScreen extends StatefulWidget {
  const RandomUserScreen({super.key});

  @override
  State<RandomUserScreen> createState() => _RandomUserScreenState();
}

class _RandomUserScreenState extends State<RandomUserScreen> {
  String? _imageUrl;
  bool isLoading = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    onPressed(); // Auto-fetch on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 185, 214),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 81, 0, 56),
        title: const Text(
          'Random User Info Viewer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageUrl != null)
                CircleAvatar(
                  radius: 90,
                  backgroundImage: NetworkImage(_imageUrl!),
                ),
              const SizedBox(height: 20),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(),
                ),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 168, 6, 133),
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: Colors.black,
                ),
                child: const Text("Load Another User"),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                child: TextField(
                  maxLines: 6,
                  controller: controller,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Data',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onPressed() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse('httpshhhh://omuhsgzhnse.me/api/'),
      );

      if (response.statusCode == 200) {
        var resparr = json.decode(response.body);
        var user = resparr['results'][0];

        String name = "${user['name']['first']} ${user['name']['last']}";
        String email = user['email'];
        String phone = user['phone'];
        String location =
            "${user['location']['city']}, ${user['location']['country']}";
        String imageUrl = user['picture']['large'];

        print("NAME: $name");
        print("EMAIL: $email");
        print("PHONE: $phone");
        print("LOCATION: $location");
        print("IMAGE: $imageUrl");

        setState(() {
          controller.text =
              "NAME : $name\nEMAIL : $email\nPHONE : $phone\nLOCATION : $location";
          _imageUrl = imageUrl;
          isLoading = false;
        });
      } else {
        showError("Error loading user data.");
      }
    } catch (e) {
      showError("An error occurred: $e");
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
      controller.text = "";
      _imageUrl = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
