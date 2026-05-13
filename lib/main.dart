import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ShyariHubApp());

const String adminPassword = 'ABCD@12345';
const String appName = 'Shyari Hub';

class ShyariHubApp extends StatefulWidget {
  const ShyariHubApp({super.key});

  @override
  State<ShyariHubApp> createState() => _ShyariHubAppState();
}

class _ShyariHubAppState extends State<ShyariHubApp> {
  bool darkMode = true;

  @override
  void initState() {
    super.initState();
    loadApp();
  }

  Future<void> loadApp() async {
    await ShayariDB.load();
    final prefs = await SharedPreferences.getInstance();
    setState(() => darkMode = prefs.getBool('darkMode') ?? true);
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => darkMode = !darkMode);
    await prefs.setBool('darkMode', darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shyari_by_piyush',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
        scaffoldBackgroundColor: const Color(0xfffff7fb),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff09040b),
        colorSchemeSeed: Colors.pink,
      ),
      home: SplashPage(
        nextPage: MainScreen(
          darkMode: darkMode,
          onThemeChange: toggleTheme,
        ),
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  final Widget nextPage;
  const SplashPage({super.key, required this.nextPage});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBg(
        child: Center(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 900),
            tween: Tween<double>(begin: .6, end: 1),
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlowLogo(size: 150),
                const SizedBox(height: 24),
                const Text(
                  appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'All Shayari by Piyush',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 34),
                const CircularProgressIndicator(color: Colors.pinkAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShayariDB {
  static Map<String, List<Map<String, String>>> data = {
    'Love': [
      {'text': 'Mohabbat bhi udhaar ki tarah nikli,\nLog le toh lete hain… par lautate nahi 💔', 'author': 'Piyush'},
      {'text': 'Tere bina zindagi adhuri si lagti hai,\nJaise raat bina chand ke 🥀', 'author': 'Piyush'},
    ],
    'Attitude': [
      {'text': 'Humse jalne wale bhi kamaal karte hain,\nMehfil khud ki aur charche hamare 😎', 'author': 'Piyush'},
      {'text': 'Naam chhota hai par pehchan badi hai 🔥', 'author': 'Piyush'},
    ],
    'Sad': [
      {'text': 'Usne kaha bhool jao mujhe,\nHumne muskura kar kaha — kaun ho tum? 🥀', 'author': 'Piyush'},
      {'text': 'Dard wahi dete hain,\nJinse umeed sabse zyada hoti hai 💔', 'author': 'Piyush'},
    ],
    'Motivation': [
      {'text': 'Sapne woh nahi jo neend me aaye,\nSapne woh hain jo neend uda dein 🔥', 'author': 'Piyush'},
      {'text': 'Har haar ke baad jeet ka chance hota hai 🚀', 'author': 'Piyush'},
    ],
    'User Shayari': [],
  };

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('shayariData');
    if (saved != null) {
      final decoded = jsonDecode(saved) as Map<String, dynamic>;
      data = decoded.map((key, value) {
        return MapEntry(
          key,
          (value as List).map((e) => Map<String, String>.from(e)).toList(),
        );
      });
    }
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shayariData', jsonEncode(data));
  }

  static List<Map<String, String>> all() {
    final list = <Map<String, String>>[];
    data.forEach((cat, items) {
      for (final item in items) {
        list.add({
          'category': cat,
          'text': item['text'] ?? '',
          'author': item['author'] ?? '',
        });
      }
    });
    return list;
  }
}

class MainScreen extends StatefulWidget {
  final bool darkMode;
  final VoidCallback onThemeChange;

  const MainScreen({
    super.key,
    required this.darkMode,
    required this.onThemeChange,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(refresh: () => setState(() {})),
      SearchPage(refresh: () => setState(() {})),
      AddShayariPage(isAdmin: false, afterSave: () => setState(() {})),
      MorePage(
        darkMode: widget.darkMode,
        onThemeChange: widget.onThemeChange,
        refresh: () => setState(() {}),
      ),
    ];

    return Scaffold(
      body: pages[page],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.90),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(.35),
              blurRadius: 25,
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.pinkAccent.withOpacity(.35),
          selectedIndex: page,
          onDestinationSelected: (v) => setState(() => page = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
            NavigationDestination(icon: Icon(Icons.add_circle_rounded), label: 'Add'),
            NavigationDestination(icon: Icon(Icons.more_horiz_rounded), label: 'More'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback refresh;
  const HomePage({super.key, required this.refresh});

  final categories = const [
    ['Love', Icons.favorite_rounded, Colors.pink],
    ['Attitude', Icons.flash_on_rounded, Colors.orange],
    ['Sad', Icons.nightlight_round, Colors.indigo],
    ['Motivation', Icons.rocket_launch_rounded, Colors.green],
    ['User Shayari', Icons.person_rounded, Colors.blue],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBg(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  GlowLogo(size: 48),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      appName,
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              HeroCard(),
              const SizedBox(height: 22),
              const Text(
                'Categories',
                style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemBuilder: (context, i) {
                  final item = categories[i];
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 350 + i * 90),
                    tween: Tween<double>(begin: .7, end: 1),
                    builder: (context, value, child) => Transform.scale(scale: value, child: child),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(26),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CategoryPage(category: item[0] as String)),
                        );
                        refresh();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: LinearGradient(colors: [
                            (item[2] as Color).withOpacity(.85),
                            const Color(0xff210016),
                          ]),
                          border: Border.all(color: Colors.white24),
                          boxShadow: [
                            BoxShadow(color: (item[2] as Color).withOpacity(.35), blurRadius: 18),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item[1] as IconData, color: Colors.white, size: 45),
                            const SizedBox(height: 10),
                            Text(item[0] as String,
                                style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                            Text('${ShayariDB.data[item[0]]?.length ?? 0} Shayari',
                                style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryPage extends StatefulWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied ✅')));
  }

  @override
  Widget build(BuildContext context) {
    final list = ShayariDB.data[widget.category] ?? [];
    return Scaffold(
      body: PremiumBg(
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(title: widget.category),
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('Abhi is category me shayari nahi hai', style: TextStyle(color: Colors.white)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          return ShayariCard(
                            text: list[i]['text'] ?? '',
                            author: list[i]['author'] ?? '',
                            category: widget.category,
                            onCopy: () => copyText(list[i]['text'] ?? ''),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  final VoidCallback refresh;
  const SearchPage({super.key, required this.refresh});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final all = ShayariDB.all().where((e) {
      return e['text']!.toLowerCase().contains(query.toLowerCase()) ||
          e['author']!.toLowerCase().contains(query.toLowerCase()) ||
          e['category']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      body: PremiumBg(
        child: SafeArea(
          child: Column(
            children: [
              const AppHeader(title: 'Search Shayari'),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (v) => setState(() => query = v),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search love, sad, author...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.pinkAccent),
                    filled: true,
                    fillColor: Colors.white.withOpacity(.10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: all.length,
                  itemBuilder: (context, i) {
                    return ShayariCard(
                      text: all[i]['text'] ?? '',
                      author: all[i]['author'] ?? '',
                      category: all[i]['category'] ?? '',
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: all[i]['text'] ?? ''));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied ✅')));
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
