import 'package:flutter/material.dart';
import '../models/Movie.dart';
import '../services/AuthService.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isAuthenticated = false;
  List<String> _userLists = ["Ma liste 1", "Ma liste 2", "Mes favoris"];

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final authStatus = await AuthService.isAuthenticated();
    setState(() {
      isAuthenticated = authStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.movie.posterPath.isNotEmpty
                  ? Image.network(
                "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}",
                height: 300,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.movie, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              "Titre: ${widget.movie.title}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Sortie: ${widget.movie.releaseDate}"),
            const SizedBox(height: 8),
            Text("Note: ${widget.movie.voteAverage}/10"),
            const SizedBox(height: 16),
            const Text(
              "Synopsis:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.movie.overview, textAlign: TextAlign.justify),
            const SizedBox(height: 20),
            DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: null,
                  hint: const Text("Ajouter à une liste"),
                  disabledHint: const Text("Ajouter à une liste"),
                  items: isAuthenticated
                      ? _userLists.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                      : null,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      print("Ajouter à $newValue");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}