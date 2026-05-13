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
class ExpressionParser {
  final String s;
  int pos = 0;

  ExpressionParser(this.s);

  double parse() => parseExpression();

  double parseExpression() {
    double x = parseTerm();

    while (pos < s.length) {
      if (s[pos] == '+') {
        pos++;
        x += parseTerm();
      } else if (s[pos] == '-') {
        pos++;
        x -= parseTerm();
      } else {
        break;
      }
    }

    return x;
  }

  double parseTerm() {
    double x = parsePower();

    while (pos < s.length) {
      if (s[pos] == '*') {
        pos++;
        x *= parsePower();
      } else if (s[pos] == '/') {
        pos++;
        x /= parsePower();
      } else {
        break;
      }
    }

    return x;
  }

  double parsePower() {
    double x = parseFactor();

    while (pos < s.length && s[pos] == '^') {
      pos++;
      x = pow(x, parseFactor()).toDouble();
    }

    return x;
  }

  double parseFactor() {
    skipSpaces();

    if (pos < s.length && s[pos] == '+') {
      pos++;
      return parseFactor();
    }

    if (pos < s.length && s[pos] == '-') {
      pos++;
      return -parseFactor();
    }

    if (match('pi')) return pi;
    if (match('sqrt')) return sqrt(readBracket());
    if (match('sin')) return sin(readBracket() * pi / 180);
    if (match('cos')) return cos(readBracket() * pi / 180);
    if (match('tan')) return tan(readBracket() * pi / 180);
    if (match('log')) return log(readBracket()) / ln10;

    if (pos < s.length && s[pos] == '(') {
      pos++;
      final x = parseExpression();
      if (pos < s.length && s[pos] == ')') pos++;
      return x;
    }

    return readNumber();
  }

  double readBracket() {
    skipSpaces();

    if (pos < s.length && s[pos] == '(') pos++;

    final x = parseExpression();

    if (pos < s.length && s[pos] == ')') pos++;

    return x;
  }

  double readNumber() {
    int start = pos;

    while (pos < s.length && RegExp(r'[0-9.]').hasMatch(s[pos])) {
      pos++;
    }

    return double.parse(s.substring(start, pos));
  }

  bool match(String word) {
    if (s.substring(pos).startsWith(word)) {
      pos += word.length;
      return true;
    }

    return false;
  }

  void skipSpaces() {
    while (pos < s.length && s[pos] == ' ') {
      pos++;
    }
  }
}

class PremiumBg extends StatelessWidget {
  final Widget child;

  const PremiumBg({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final dark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: dark
            ? const RadialGradient(
                center: Alignment.topLeft,
                radius: 1.2,
                colors: [
                  Color(0xff45103d),
                  Color(0xff160014),
                  Color(0xff050006),
                ],
              )
            : const LinearGradient(
                colors: [
                  Color(0xfffff1f7),
                  Color(0xfff7e7ff),
                  Color(0xfffff7fb),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: child,
    );
  }
}

class GlowLogo extends StatelessWidget {
  final double size;

  const GlowLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 4),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(.65),
            blurRadius: 28,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(.25),
            blurRadius: 45,
            spreadRadius: 6,
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 850),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xffff2f7a),
              Color(0xff7b2ff7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(.45),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Row(
          children: [
            GlowLogo(size: 86),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shyari Hub 🔥',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Love, Sad, Attitude & Motivation Shayari',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShayariCard extends StatelessWidget {
  final String text;
  final String author;
  final String category;
  final VoidCallback onCopy;

  const ShayariCard({
    super.key,
    required this.text,
    required this.author,
    required this.category,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: .85, end: 1),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(.13),
              Colors.pinkAccent.withOpacity(.15),
            ],
          ),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(.20),
              blurRadius: 18,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(category),
              backgroundColor: Colors.pinkAccent,
              labelStyle: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '- $author',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copy'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(.12),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Share.share(
                        '$text\n\n- $author\n\n$appName\nShyari_by_Piyush',
                      );
                    },
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PremiumTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PremiumTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.pinkAccent,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white60),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white54,
          size: 17,
        ),
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          GlowLogo(size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration premiumInput(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.white.withOpacity(.10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.white24),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
    ),
  );
}
