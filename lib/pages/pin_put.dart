import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class PinPutPage extends StatefulWidget {
  const PinPutPage({super.key});

  @override
  State<PinPutPage> createState() => _PinPutPageState();
}

class _PinPutPageState extends State<PinPutPage> {
  String? userPin;
  final formKey = GlobalKey<FormState>();
  final TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserPin();
  }

  Future<void> _getUserPin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            userPin = doc['pin'];
          });
        }
      }
    } catch (e) {
      print("Gagal mengambil PIN: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background image (gaya Netflix)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/blue.jpeg"), // ganti dengan gambar latar kamu
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Overlay hitam transparan
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // 🔹 Konten utama
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔹 Logo Movinity
                      Image.asset(
                        'assets/movinity.png',
                        width: 130,
                        height: 130,
                      ),

                      const SizedBox(height: 40),

                      // 🔹 Judul
                      Text(
                        "Masukkan PIN Profil Anda",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Untuk membuka profil ini, masukkan PIN Anda",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 🔹 Input PIN
                      Pinput(
                        length: 6,
                        controller: pinController,
                        obscureText: true,
                        obscuringCharacter: '•',
                        defaultPinTheme: PinTheme(
                          width: 55,
                          height: 60,
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 55,
                          height: 60,
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blueAccent),
                          ),
                        ),
                        validator: (value) {
                          if (userPin == null) {
                            return 'Sedang memuat data...';
                          }
                          if (value != userPin) {
                            return 'PIN salah, coba lagi.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 40),

                      // 🔹 Tombol Verifikasi
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004CFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("PIN benar! Akses diizinkan."),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Verifikasi",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 🔹 Kirim ulang PIN
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Lupa PIN? Kirim Ulang",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF004CFF),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
