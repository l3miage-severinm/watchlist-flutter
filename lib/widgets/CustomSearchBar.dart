import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const CustomSearchBar({super.key, required this.onSearch});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final _searchSubject = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    _searchSubject
        .debounceTime(const Duration(milliseconds: 200))
        .distinct()
        .listen((query) {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    _searchSubject.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onChanged: (value) => _searchSubject.add(value),
        decoration: InputDecoration(
          hintText: "Rechercher un film...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
