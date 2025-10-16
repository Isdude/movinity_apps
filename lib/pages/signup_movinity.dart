import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import '../firebase_options.dart';
import 'signin_movinity.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi berhasil! Silakan login."),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = "Email sudah terdaftar!";
      } else {
        message = "Registrasi gagal, coba lagi.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00234B),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                      image: AssetImage('assets/movinity.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Sign up",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white, fontSize: 36),
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          "Already have a account ?",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPage()),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Name',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        filled: true,
                        fillColor: Color(0xFF000C1C),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        filled: true,
                        fillColor: Color(0xFF000C1C),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Password',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        filled: true,
                        fillColor: Color(0xFF000C1C),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Phone Number',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    IntlPhoneField(
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white),
                  dropdownTextStyle: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF000C1C),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  initialCountryCode: 'ID', // kode default Indonesia
                  onChanged: (phone) {
                    // phone.completeNumber = +62xxx
                    print(phone.completeNumber);
                  },
                  dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  flagsButtonMargin: const EdgeInsets.only(left: 12),
                ),
                
                    SizedBox(height: 20),
                    Text(
                      'Date of Birth',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: dobController,
                      readOnly: true, // tidak bisa diketik manual
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Select your date of birth',
                        filled: true,
                        fillColor: const Color(0xFF000C1C),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            FocusScope.of(
                              context,
                            ).requestFocus(FocusNode()); // hilangkan keyboard
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2005, 1, 1),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Color(0xFF004CFF), // warna tombol OK
                                      onPrimary:
                                          Colors.white, // warna teks tombol OK
                                      surface: Color(
                                        0xFF001733,
                                      ), // background dialog
                                      onSurface: Colors.white, // warna teks tanggal
                                    ),
                                    dialogBackgroundColor: const Color(0xFF000C1C),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setState(() {
                                dobController.text =
                                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              });
                            }
                          },
                        ),
                      ),
                    ),
                
                    SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          register();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF004CFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
