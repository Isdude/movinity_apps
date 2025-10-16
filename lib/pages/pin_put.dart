import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class PinPutPage extends StatefulWidget {
  const PinPutPage({super.key});

  @override
  State<PinPutPage> createState() => _PinPutPageState();
}

class _PinPutPageState extends State<PinPutPage> {
  final String validPin = '1234';
  final formKey = GlobalKey<FormState>();
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00234B),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/movinity.png',
                  width: 120,
                ),

                const SizedBox(height: 50),
                Text(
                  "Masukkan PIN untuk membuka profil ini",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  "Verifikasi Akun Anda",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Pinput(
                        length: 6,
                        controller: pinController,
                        obscureText: true,
                        obscuringCharacter: '•',
                        defaultPinTheme: PinTheme(
                          width: 60,
                          height: 60,
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E1C2C),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 60,
                          height: 60,
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF173B68),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFF004CFF)),
                          ),
                        ),
                        validator: (value) {
                          if (value != validPin) {
                            return 'PIN yang Anda masukkan salah';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 40),

                      // Tombol Validasi
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF004CFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Tautan kirim ulang kode
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Kirim Ulang Kode",
                    style: GoogleFonts.poppins(
                      color: Colors.blueAccent,
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
    );
  }
}
