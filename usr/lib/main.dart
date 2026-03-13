import 'package:flutter/material.dart';

void main() {
  runApp(const KinoApp());
}

class KinoApp extends StatelessWidget {
  const KinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filmovi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        // Svijetlo siva pozadina kako bi se bijele kartice filmova jasno isticale
        scaffoldBackgroundColor: Colors.grey[100], 
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FilmoviPage(),
      },
    );
  }
}

// Status filma koji određuje boju pozadine
enum MovieStatus { nowShowing, comingSoon, notAvailable }

class Movie {
  final String title;
  final String duration;
  final MovieStatus status;

  Movie(this.title, this.duration, this.status);
}

class FilmoviPage extends StatelessWidget {
  const FilmoviPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fiksni meni na vrhu (uvijek vidljiv)
          const TopMenu(),
          
          // Skrolajući sadržaj ispod menija
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategorySection(
                    id: 'akcija',
                    title: 'Akcija',
                    movies: [
                      Movie('John Wick 4', '169 min', MovieStatus.nowShowing),
                      Movie('Gladiator 2', '150 min', MovieStatus.comingSoon),
                      Movie('Mad Max: Fury Road', '120 min', MovieStatus.notAvailable),
                      Movie('The Batman', '175 min', MovieStatus.nowShowing),
                      Movie('Fast X', '141 min', MovieStatus.nowShowing),
                      Movie('Die Hard', '132 min', MovieStatus.notAvailable),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CategorySection(
                    id: 'drama',
                    title: 'Drama',
                    movies: [
                      Movie('Oppenheimer', '180 min', MovieStatus.nowShowing),
                      Movie('Dune: Part Two', '166 min', MovieStatus.comingSoon),
                      Movie('The Godfather', '175 min', MovieStatus.notAvailable),
                      Movie('Joker', '122 min', MovieStatus.notAvailable),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CategorySection(
                    id: 'komedija',
                    title: 'Komedija',
                    movies: [
                      Movie('Barbie', '114 min', MovieStatus.nowShowing),
                      Movie('Deadpool 3', '120 min', MovieStatus.comingSoon),
                      Movie('Superbad', '113 min', MovieStatus.notAvailable),
                      Movie('The Hangover', '100 min', MovieStatus.notAvailable),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CategorySection(
                    id: 'animirani',
                    title: 'Animirani',
                    movies: [
                      Movie('Spider-Man: Across the Spider-Verse', '140 min', MovieStatus.nowShowing),
                      Movie('Kung Fu Panda 4', '94 min', MovieStatus.comingSoon),
                      Movie('Toy Story', '81 min', MovieStatus.notAvailable),
                      Movie('Shrek', '90 min', MovieStatus.notAvailable),
                      Movie('Inside Out 2', '100 min', MovieStatus.comingSoon),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopMenu extends StatelessWidget {
  const TopMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey[900],
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final links = [
            _MenuLink('Filmovi'),
            _MenuLink('Raspored'),
            _MenuLink('Sala'),
          ];

          // Ako širina ekrana ne dozvoljava prikaz svih linkova u jednom redu (npr. < 400px)
          // meni se prikazuje jedan ispod drugog
          if (constraints.maxWidth < 400) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: links.map((link) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: link,
              )).toList(),
            );
          } else {
            // Prikaz u jednom redu za šire ekrane
            return Row(
              children: links.map((link) => Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: link,
              )).toList(),
            );
          }
        },
      ),
    );
  }
}

class _MenuLink extends StatelessWidget {
  final String text;
  const _MenuLink(this.text);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Ovdje bi išla navigacija
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String id;
  final String title;
  final List<Movie> movies;

  const CategorySection({
    super.key, 
    required this.id, 
    required this.title, 
    required this.movies
  });

  @override
  Widget build(BuildContext context) {
    // Ekvivalent <div id="akcija"> u HTML-u
    return Container(
      key: ValueKey(id),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Naslov sekcije
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          // Grid filmova koristeći Wrap za responzivnost
          Wrap(
            spacing: 10.0, // Minimalno 10px razmaka horizontalno
            runSpacing: 10.0, // Minimalno 10px razmaka vertikalno
            children: movies.map((movie) => MovieCard(movie: movie)).toList(),
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  Color _getBackgroundColor() {
    switch (movie.status) {
      case MovieStatus.nowShowing:
        return Colors.white; // trenutno u kinima
      case MovieStatus.comingSoon:
        return const Color(0xFFB0E0E6); // powderblue - uskoro u kinima
      case MovieStatus.notAvailable:
        return Colors.grey; // siva - više nije u ponudi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fiksna širina od 200px prema zadatku
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slika postera (Placeholder)
          Container(
            height: 280,
            width: 200,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_movies,
                  size: 60,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  'POSTER',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          // Informacije o filmu
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      movie.duration,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
