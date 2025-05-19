import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/AuthViewModel.dart';
import 'MovieListScreen.dart';
import 'FavoriteMoviesScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    MovieListScreen(),
    FavoriteMoviesScreen(),
  ];

  void _onItemTapped(int index, bool isAuthenticated) {
    if (index == 1 && !isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez vous connecter pour accéder aux favoris.')),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des films'),
        actions: [
          StreamBuilder<bool>(
            stream: authViewModel.isAuthenticatedStream,
            builder: (context, snapshot) {
              final auth = snapshot.data ?? false;
              return IconButton(
                icon: Icon(auth ? Icons.logout : Icons.login),
                tooltip: auth ? 'Se déconnecter' : 'Se connecter',
                onPressed: authViewModel.handleAuth,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          StreamBuilder<bool>(
            stream: authViewModel.isAuthenticatingStream,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomNavigationBar: StreamBuilder<bool>(
        stream: authViewModel.isAuthenticatedStream,
        builder: (context, snapshot) {
          final isAuthenticated = snapshot.data ?? false;
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => _onItemTapped(index, isAuthenticated),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Recherche',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favoris',
              ),
            ],
          );
        },
      ),
    );
  }
}
