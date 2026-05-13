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
class AddShayariPage extends StatefulWidget {
  final bool isAdmin;
  final VoidCallback afterSave;

  const AddShayariPage({
    super.key,
    required this.isAdmin,
    required this.afterSave,
  });

  @override
  State<AddShayariPage> createState() => _AddShayariPageState();
}

class _AddShayariPageState extends State<AddShayariPage> {
  String category = 'Love';

  final name = TextEditingController();
  final text = TextEditingController();

  Future<void> save() async {
    if (name.text.trim().isEmpty || text.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name aur Shayari dono likho')),
      );
      return;
    }

    ShayariDB.data[category]!.add({
      'text': text.text.trim(),
      'author': name.text.trim(),
    });

    await ShayariDB.save();

    widget.afterSave();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shayari Added ✅')),
    );

    name.clear();
    text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cats = [
      'Love',
      'Attitude',
      'Sad',
      'Motivation',
      'User Shayari',
    ];

    return Scaffold(
      body: PremiumBg(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              AppHeader(
                title: widget.isAdmin
                    ? 'Admin Add Shayari'
                    : 'User Add Shayari',
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xfffc466b),
                      Color(0xff3f5efb),
                    ],
                  ),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  widget.isAdmin
                      ? 'Admin Mode 🔥\nAap kisi bhi category me shayari add kar sakte ho.'
                      : 'User Mode ✨\nAap bhi apni shayari share kar sakte ho.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                value: category,
                dropdownColor: const Color(0xff141414),
                style: const TextStyle(color: Colors.white),
                items: cats.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (v) => setState(() => category = v!),
                decoration: premiumInput('Select Category'),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: name,
                style: const TextStyle(color: Colors.white),
                decoration: premiumInput('Your Name'),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: text,
                maxLines: 7,
                style: const TextStyle(color: Colors.white),
                decoration: premiumInput('Write Shayari'),
              ),

              const SizedBox(height: 22),

              ElevatedButton.icon(
                onPressed: save,
                icon: const Icon(Icons.save),
                label: const Text('Save Shayari'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  final bool darkMode;
  final VoidCallback onThemeChange;
  final VoidCallback refresh;

  const MorePage({
    super.key,
    required this.darkMode,
    required this.onThemeChange,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBg(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const AppHeader(title: 'More Options'),

              PremiumTile(
                icon: Icons.admin_panel_settings_rounded,
                title: 'Admin Add Shayari',
                subtitle: 'Password Required',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PasswordPage(refresh: refresh),
                    ),
                  );
                },
              ),

              PremiumTile(
                icon: Icons.calculate_rounded,
                title: 'Advanced Calculator',
                subtitle: 'Scientific calculator',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CalculatorPage(),
                    ),
                  );
                },
              ),

              PremiumTile(
                icon: Icons.share_rounded,
                title: 'Share App',
                subtitle: 'Share APK with friends',
                onTap: () {
                  Share.share(
                    '🔥 Download Shyari Hub App 🔥',
                  );
                },
              ),

              Container(
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white24),
                ),
                child: SwitchListTile(
                  value: darkMode,
                  onChanged: (_) => onThemeChange(),
                  title: const Text(
                    'Dark / Light Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  secondary: const Icon(
                    Icons.dark_mode_rounded,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordPage extends StatefulWidget {
  final VoidCallback refresh;

  const PasswordPage({
    super.key,
    required this.refresh,
  });

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final pass = TextEditingController();

  void login() {
    if (pass.text == adminPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AddShayariPage(
            isAdmin: true,
            afterSave: widget.refresh,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong Password ❌')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const AppHeader(title: 'Admin Login'),

                const SizedBox(height: 30),

                GlowLogo(size: 120),

                const SizedBox(height: 30),

                TextField(
                  controller: pass,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: premiumInput('Enter Password'),
                ),

                const SizedBox(height: 22),

                ElevatedButton.icon(
                  onPressed: login,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '0';

  final buttons = [
    'C', 'DEL', '(',' )',
    'sin','cos','tan','√',
    '7','8','9','÷',
    '4','5','6','×',
    '1','2','3','-',
    '0','.','^','+',
    'π','log','=',
  ];

  void tap(String v) {
    setState(() {
      if (v == 'C') {
        input = '';
        result = '0';
      } else if (v == 'DEL') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (v == '=') {
        result = solve(input);
      } else if (v == '√') {
        input += 'sqrt(';
      } else if (v == 'sin' ||
          v == 'cos' ||
          v == 'tan' ||
          v == 'log') {
        input += '$v(';
      } else if (v == 'π') {
        input += 'pi';
      } else {
        input += v;
      }
    });
  }

  String solve(String exp) {
    try {
      exp = exp.replaceAll('×', '*');
      exp = exp.replaceAll('÷', '/');

      final ans = ExpressionParser(exp).parse();

      if (ans % 1 == 0) {
        return ans.toInt().toString();
      }

      return ans.toStringAsFixed(4);
    } catch (_) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBg(
        child: SafeArea(
          child: Column(
            children: [
              const AppHeader(title: 'Calculator'),

              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        input,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        result,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(12),
                itemCount: buttons.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (_, i) {
                  final b = buttons[i];

                  return ElevatedButton(
                    onPressed: () => tap(b),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: b == '='
                          ? Colors.pinkAccent
                          : Colors.white.withOpacity(.10),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      b,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
