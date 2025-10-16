import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
      backgroundColor: const Color(0xFF001B3A),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            movieDetail!['Poster'] ?? '',
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 220,
                              color: Colors.grey,
                              child: const Icon(Icons.broken_image,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.white, size: 40),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Judul
                    Text(
                      movieDetail!['Title'] ?? '',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Text(
                      "${movieDetail!['Year']} • ${movieDetail!['Genre']}",
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: _buildStarRating(movieDetail!['imdbRating']),
                    ),

                    const SizedBox(height: 16),

                    // Plot
                    Text(
                      movieDetail!['Plot'] ?? 'No description available.',
                      style: GoogleFonts.roboto(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildInfoRow("Director", movieDetail!['Director']),
                    _buildInfoRow("Actors", movieDetail!['Actors']),
                    _buildInfoRow("Released", movieDetail!['Released']),
                    _buildInfoRow("Runtime", movieDetail!['Runtime']),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
              style: GoogleFonts.roboto(
                color: Colors.white.withOpacity(0.9),
              ),
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
