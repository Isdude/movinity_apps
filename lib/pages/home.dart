import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'movie_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = "5630e501";

  Future<List<dynamic>> getMovies(String keyword) async {
    final response = await http.get(
      Uri.parse("http://www.omdbapi.com/?s=$keyword&apikey=$apiKey"),
    );

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);

    if (data["Response"] != "True") return [];

    final List movies = data["Search"];
    final List<Map<String, dynamic>> detailedMovies = await Future.wait(
      movies.map((movie) async {
        final id = movie['imdbID'];
        final detailFilm = await http.get(
          Uri.parse("http://www.omdbapi.com/?i=$id&apikey=$apiKey"),
        );

        if (detailFilm.statusCode == 200) {
          final detail = jsonDecode(detailFilm.body);

          return {
            'title': movie['Title'] ?? 'No Title',
            'year': movie['Year'] ?? 'Unknown',
            'poster': movie['Poster'] != "N/A"
                ? movie['Poster']
                : 'https://via.placeholder.com/150',
            'genre': detail['Genre'] ?? 'Unknown',
            'rating': detail['imdbRating'] ?? 'N/A',
            'type': movie['Type'] ?? '',
            'plot_overview': detail['Plot'] ?? 'No overview available.',
            'imdbID': movie['imdbID'],
          };
        } else {
          return {
            'title': movie['Title'] ?? 'No Title',
            'year': movie['Year'] ?? 'Unknown',
            'poster': movie['Poster'] != "N/A"
                ? movie['Poster']
                : 'https://via.placeholder.com/150',
            'genre': 'Unknown',
            'rating': 'N/A',
            'type': movie['Type'] ?? '',
            'plot_overview': 'No overview available.',
          };
        }
      }),
    );

    return detailedMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00234B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00234B),
        centerTitle: true,
        title: Image.asset('assets/movinity.png', height: 60),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Banner
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1640127249305-793865c2efe1?q=80&w=1103&auto=format&fit=crop",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Watch Now",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(offset: const Offset(2, 2), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  "Popular Movies",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: getMovies("avengers"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No data found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final movies = snapshot.data!;
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return buildMovieCard(movie);
                        },
                      ),
                    );
                  }
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  "Anime",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: getMovies("anime"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No data found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final movies = snapshot.data!;
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return buildMovieCard(movie);
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  "Horror Movies",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: getMovies("insidious"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No data found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final movies = snapshot.data!;
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return buildMovieCard(movie);
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildMovieCard(Map<String, dynamic> movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(imdbID: movie['imdbID']),
          ),
        );
      },

      child: Container(
        width: 200,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                movie['poster'],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 160,
                    color: Colors.grey,
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'],
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${movie['year']} • ${movie['genre']}",
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        movie['rating'],
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
