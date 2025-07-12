import 'package:flutter/material.dart';
import 'image_preview_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    _HomeMainContent(),
    _AboutContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'CropDoc 🌿',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal.shade600),
              child: const Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Capture or Upload Image'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickImageScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('View Diagnosis History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal.shade600,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 10,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeMainContent extends StatelessWidget {
  const _HomeMainContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to CropDoc',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _ActionCard(
            icon: Icons.camera_alt,
            label: 'Capture or Upload Image',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PickImageScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _ActionCard(
            icon: Icons.history,
            label: 'View Diagnosis History',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color textColor = Theme.of(context).colorScheme.onSurface;

    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: double.infinity,
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.teal.shade600),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onBackground;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 80, color: Colors.teal),
            const SizedBox(height: 24),
            Text(
              'CropDoc: Ped ke Saathi\n\nCreated with ❤️ by',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Sandeep',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
