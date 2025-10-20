import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends StatefulWidget {
  final String imdbID;

  const MovieDetailPage({super.key, required this.imdbID});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final String apiKey = "5630e501";
  Map<String, dynamic>? movieDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovieDetail();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tidak bisa membuka link')));
    }
  }

  Future<void> fetchMovieDetail() async {
    final response = await http.get(
      Uri.parse("http://www.omdbapi.com/?i=${widget.imdbID}&apikey=$apiKey"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        movieDetail = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120), // Navy gelap modern
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    movieDetail!['Poster'] ?? '',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.4),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),

                // Gradasi gelap bawah
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xFF0B1120),
                          Color(0xFF0B1120),
                        ],
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tombol back
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                        // Poster besar dengan efek
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              movieDetail!['Poster'] ?? '',
                              height: 280,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 280,
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            movieDetail!['Title'] ?? '',
                            style: GoogleFonts.bebasNeue(
                              color: Colors.white,
                              fontSize: 38,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "${movieDetail!['Year']} • ${movieDetail!['Genre']}",
                            style: GoogleFonts.roboto(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: _buildStarRating(
                              movieDetail!['imdbRating'],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Tombol nonton dan simpan
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text("Putar"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF004CFF),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Deskripsi film
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            movieDetail!['Plot'] ??
                                'Deskripsi tidak tersedia untuk film ini.',
                            style: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Info tambahan
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                "Direktur",
                                movieDetail!['Director'],
                              ),
                              _buildInfoRow("Aktor", movieDetail!['Actors']),
                              _buildInfoRow("Rilis", movieDetail!['Released']),
                              _buildInfoRow("Durasi", movieDetail!['Runtime']),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: GoogleFonts.roboto(color: Colors.white.withOpacity(0.85)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStarRating(String? ratingStr) {
    double rating = double.tryParse(ratingStr ?? "0") ?? 0;
    int fullStars = (rating / 2).floor();
    bool halfStar = (rating / 2) - fullStars >= 0.5;

    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 22));
      } else if (i == fullStars && halfStar) {
        stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 22));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 22));
      }
    }

    stars.add(
      Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Text(
          ratingStr ?? "N/A",
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),
        ),
      ),
    );

    return stars;
  }
}
