
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0; // State to manage the selected index of the bottom navigation bar

//   // List of widgets to display in the body based on the selected bottom navigation item.
//   // For now, we'll just have a placeholder for the home content.
//   // You would replace these with your actual screen widgets (e.g., HomeContentWidget, SearchWidget, ProfileWidget).
//   static const List<Widget> _widgetOptions = <Widget>[
//     _HomeMainContent(), // This will be the content shown when 'Home' tab is selected
//     Center(child: Text('Search Content', style: TextStyle(fontSize: 20))), // Placeholder for Search tab
//     Center(child: Text('Profile Content', style: TextStyle(fontSize: 20))), // Placeholder for Profile tab
//   ];

//   // Function to handle taps on the bottom navigation bar items
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index; // Update the selected index
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // App bar at the top, showing 'Home Screen' title
//       appBar: AppBar(
//         title: const Text('Home Screen'),
//         // The leading hamburger icon for the drawer is automatically provided by Scaffold
//         // when a Drawer widget is present.
//       ),
//       // Drawer for the side menu (accessed via the hamburger icon)
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero, // Remove default padding
//           children: <Widget>[
//             // Header for the drawer
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue, // Background color for the header
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             // List tile for 'Capture or Upload Image'
//             ListTile(
//               leading: const Icon(Icons.image), // Icon for the list item
//               title: const Text('Capture or Upload Image'), // Text for the list item
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer first
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => const CaptureUploadScreen()), // Uncomment and replace with your screen
//                 // );
//                 debugPrint('Navigate to Capture or Upload Image Screen'); // Debug print for now
//               },
//             ),
//             // List tile for 'Open AI Chatbot'
//             ListTile(
//               leading: const Icon(Icons.chat), // Icon for the list item
//               title: const Text('Open AI Chatbot'), // Text for the list item
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer first
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => const AIChatbotScreen()), // Uncomment and replace with your screen
//                 // );
//                 debugPrint('Navigate to Open AI Chatbot Screen'); // Debug print for now
//               },
//             ),
//             // List tile for 'View Nomby Help Centers'
//             ListTile(
//               leading: const Icon(Icons.help), // Icon for the list item
//               title: const Text('View Nomby Help Centers'), // Text for the list item
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer first
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => const HelpCentersScreen()), // Uncomment and replace with your screen
//                 // );
//                 debugPrint('Navigate to View Nomby Help Centers Screen'); // Debug print for now
//               },
//             ),
//             // You can add more ListTile widgets here for additional menu items
//           ],
//         ),
//       ),
//       // Body of the Scaffold, displaying content based on bottom navigation selection
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex), // Display the selected content
//       ),
//       // Bottom navigation bar
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           // Home tab item
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home), // House icon
//             label: 'Home',
//           ),
//           // Search tab item (using Icons.search as a placeholder for the square icon)
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search), // Square icon in image, using search as common alternative
//             label: 'Search',
//           ),
//           // Profile tab item
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person), // Person icon
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex, // Currently selected item
//         selectedItemColor: Colors.blueAccent, // Color for the selected item
//         onTap: _onItemTapped, // Callback when an item is tapped
//       ),
//     );
//   }
// }

// // A separate widget for the main content of the Home tab,
// // including the buttons shown in the image.
// class _HomeMainContent extends StatelessWidget {
//   const _HomeMainContent();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
//       children: [
//         const Text(
//           'Welcome to the Home Screen!',
//           style: TextStyle(fontSize: 20),
//         ),
//         const SizedBox(height: 40), // Spacer between text and buttons

//         // Button for 'Capture or Upload Image'
//         SizedBox(
//           width: 250, // Fixed width for the button as per image
//           child: ElevatedButton(
//             onPressed: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => const CaptureUploadScreen()), // Uncomment and replace with your screen
//               // );
//               debugPrint('Navigate to Capture or Upload Image Screen'); // Debug print for now
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 15), // Padding inside the button
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10), // Rounded corners
//               ),
//             ),
//             child: const Text('Capture or Upload Image', style: TextStyle(fontSize: 16)),
//           ),
//         ),
//         const SizedBox(height: 20), // Spacer between buttons

//         // Button for 'Open AI Chatbot'
//         SizedBox(
//           width: 250,
//           child: ElevatedButton(
//             onPressed: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => const AIChatbotScreen()), // Uncomment and replace with your screen
//               // );
//               debugPrint('Navigate to Open AI Chatbot Screen'); // Debug print for now
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text('Open AI Chatbot', style: TextStyle(fontSize: 16)),
//           ),
//         ),
//         const SizedBox(height: 20), // Spacer between buttons

//         // Button for 'View Nomby Help Centers'
//         SizedBox(
//           width: 250,
//           child: ElevatedButton(
//             onPressed: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => const HelpCentersScreen()), // Uncomment and replace with your screen
//               // );
//               debugPrint('Navigate to View Nomby Help Centers Screen'); // Debug print for now
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text('View Nomby Help Centers', style: TextStyle(fontSize: 16)),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
// Import your PickImageScreen
import 'image_preview_screen.dart'; // Make sure this path is correct for your project

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // State to manage the selected index of the bottom navigation bar

  // List of widgets to display in the body based on the selected bottom navigation item.
  static const List<Widget> _widgetOptions = <Widget>[
    _HomeMainContent(), // This will be the content shown when 'Home' tab is selected
    Center(child: Text('Search Content', style: TextStyle(fontSize: 20))), // Placeholder for Search tab
    Center(child: Text('Profile Content', style: TextStyle(fontSize: 20))), // Placeholder for Profile tab
  ];

  // Function to handle taps on the bottom navigation bar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top, showing 'Home Screen' title
      appBar: AppBar(
        title: const Text('Home Screen'),
        // The leading hamburger icon for the drawer is automatically provided by Scaffold
        // when a Drawer widget is present.
      ),
      // Drawer for the side menu (accessed via the hamburger icon)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Remove default padding
          children: <Widget>[
            // Header for the drawer
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Background color for the header
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // List tile for 'Capture or Upload Image'
            ListTile(
              leading: const Icon(Icons.image), // Icon for the list item
              title: const Text('Capture or Upload Image'), // Text for the list item
              onTap: () {
                Navigator.pop(context); // Close the drawer first
                // Navigate to the PickImageScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickImageScreen()),
                );
              },
            ),
            // List tile for 'Open AI Chatbot'
            ListTile(
              leading: const Icon(Icons.chat), // Icon for the list item
              title: const Text('Open AI Chatbot'), // Text for the list item
              onTap: () {
                Navigator.pop(context); // Close the drawer first
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const AIChatbotScreen()), // Uncomment and replace with your screen
                // );
                debugPrint('Navigate to Open AI Chatbot Screen'); // Debug print for now
              },
            ),
            // List tile for 'View Nomby Help Centers'
            ListTile(
              leading: const Icon(Icons.help), // Icon for the list item
              title: const Text('View Nomby Help Centers'), // Text for the list item
              onTap: () {
                Navigator.pop(context); // Close the drawer first
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const HelpCentersScreen()), // Uncomment and replace with your screen
                // );
                debugPrint('Navigate to View Nomby Help Centers Screen'); // Debug print for now
              },
            ),
            // You can add more ListTile widgets here for additional menu items
          ],
        ),
      ),
      // Body of the Scaffold, displaying content based on bottom navigation selection
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Display the selected content
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Home tab item
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // House icon
            label: 'Home',
          ),
          // Search tab item (using Icons.search as a placeholder for the square icon)
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Square icon in image, using search as common alternative
            label: 'Search',
          ),
          // Profile tab item
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Person icon
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Currently selected item
        selectedItemColor: Colors.blueAccent, // Color for the selected item
        onTap: _onItemTapped, // Callback when an item is tapped
      ),
    );
  }
}

// A separate widget for the main content of the Home tab,
// including the buttons shown in the image.
class _HomeMainContent extends StatelessWidget {
  const _HomeMainContent(); // Added super.key for best practice

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
      children: [
        const Text(
          'Welcome to the Home Screen!',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 40), // Spacer between text and buttons

        // Button for 'Capture or Upload Image'
        SizedBox(
          width: 250, // Fixed width for the button as per image
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the PickImageScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PickImageScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15), // Padding inside the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
            child: const Text('Capture or Upload Image', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20), // Spacer between buttons

        // Button for 'Open AI Chatbot'
        SizedBox(
          width: 250,
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const AIChatbotScreen()), // Uncomment and replace with your screen
              // );
              debugPrint('Navigate to Open AI Chatbot Screen'); // Debug print for now
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Open AI Chatbot', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20), // Spacer between buttons

        // Button for 'View Nomby Help Centers'
        SizedBox(
          width: 250,
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const HelpCentersScreen()), // Uncomment and replace with your screen
              // );
              debugPrint('Navigate to View Nomby Help Centers Screen'); // Debug print for now
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('View Nomby Help Centers', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
