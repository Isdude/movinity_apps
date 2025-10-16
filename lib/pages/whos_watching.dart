import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pin_put.dart';

class WhosWatchingPage extends StatefulWidget {
  const WhosWatchingPage({super.key});

  @override
  State<WhosWatchingPage> createState() => _WhosWatchingPageState();
}

class _WhosWatchingPageState extends State<WhosWatchingPage> {
  List<Map<String, String>> profiles = [
    {'name': 'User 1', 'image': 'assets/user1.jpeg'},
  ];

  final int maxProfiles = 6;

  void addProfile() {
    if (profiles.length < maxProfiles) {
      setState(() {
        profiles.add({
          'name': 'User ${profiles.length + 1}',
          'image': 'assets/user${profiles.length + 1}.jpeg',
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00234B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00234B),
        title: Text(
          "Movinity",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Who's Watching?",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Select your profile",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 35),

            // === GRID PROFILE ===
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount:
                    profiles.length + (profiles.length < maxProfiles ? 1 : 0),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  // tombol tambah profil
                  if (index == profiles.length &&
                      profiles.length < maxProfiles) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: addProfile,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E1C2C),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Add Profile",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    );
                  }

                  // profil user biasa
                  final profile = profiles[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          // pindah ke halaman Pinput
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PinPutPage(
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(7),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.asset(
                            profile['image']!,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile['name']!,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 6),
            SizedBox(
              width: 180,
              height: 38,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text(
                  "Manage Profiles",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
