import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ShayariByPiyush());

class ShayariByPiyush extends StatefulWidget {
  const ShayariByPiyush({super.key});

  @override
  State<ShayariByPiyush> createState() => _ShayariByPiyushState();
}

class _ShayariByPiyushState extends State<ShayariByPiyush> {
  bool darkMode = true;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
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
    final mainScreen = MainScreen(
      darkMode: darkMode,
      onThemeChange: toggleTheme,
    );

    return MaterialApp(
      title: 'shyari_by_piyush',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
        scaffoldBackgroundColor: const Color(0xfff7f3ff),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: SplashPage(nextPage: mainScreen),
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffff512f), Color(0xffdd2476), Color(0xff6a11cb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 58,
              backgroundColor: Colors.white,
              child: Text(
                'SP',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(height: 22),
            Text(
              'shyari_by_piyush',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Feelings ko words do...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 35),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class ShayariDB {
  static Map<String, List<Map<String, String>>> data = {
    'Love': [
      {
        'text':
            'Mohabbat bhi udhaar ki tarah nikli,\nLog le toh lete hain… par lautate nahi 💔',
        'author': 'Piyush'
      },
      {
        'text':
            'Tere bina zindagi adhuri si lagti hai,\nJaise raat bina chand ke 🥀',
        'author': 'Piyush'
      },
    ],
    'Attitude': [
      {
        'text':
            'Humse jalne wale bhi kamaal karte hain,\nMehfil khud ki aur charche hamare 😎',
        'author': 'Piyush'
      },
      {
        'text': 'Naam chhota hai par pehchan badi hai 🔥',
        'author': 'Piyush'
      },
    ],
    'Sad': [
      {
        'text':
            'Usne kaha bhool jao mujhe,\nHumne muskura kar kaha — kaun ho tum? 🥀',
        'author': 'Piyush'
      },
      {
        'text': 'Dard wahi dete hain,\nJinse umeed sabse zyada hoti hai 💔',
        'author': 'Piyush'
      },
    ],
    'Motivation': [
      {
        'text':
            'Sapne woh nahi jo neend me aaye,\nSapne woh hain jo neend uda dein 🔥',
        'author': 'Piyush'
      },
      {
        'text': 'Har haar ke baad jeet ka chance hota hai 🚀',
        'author': 'Piyush'
      },
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (v) => setState(() => page = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.add_circle_rounded), label: 'Add'),
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'More'),
        ],
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
      appBar: AppBar(title: const Text('shyari_by_piyush'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 700),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xffff512f), Color(0xffdd2476)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feelings ko words do ✍️',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Love, Sad, Attitude aur Motivation Shayari',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Categories',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              childAspectRatio: 1,
            ),
            itemBuilder: (context, i) {
              final item = categories[i];

              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 350 + i * 100),
                tween: Tween<double>(begin: .8, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryPage(
                          category: item[0] as String,
                        ),
                      ),
                    );
                    refresh();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        colors: [
                          (item[2] as Color).withOpacity(.75),
                          item[2] as Color,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (item[2] as Color).withOpacity(.35),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item[1] as IconData, color: Colors.white, size: 44),
                        const SizedBox(height: 10),
                        Text(
                          item[0] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${ShayariDB.data[item[0]]?.length ?? 0} Shayari',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = ShayariDB.data[widget.category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: list.isEmpty
          ? const Center(child: Text('Abhi is category me shayari nahi hai'))
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
      duration: const Duration(milliseconds: 450),
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(category), backgroundColor: Colors.white),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text('- $author', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Share.share('$text\n\n- $author\n\nshyari_by_piyush');
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            )
          ],
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
      appBar: AppBar(title: const Text('Search Shayari')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: 'Search love, sad, author...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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
                    Clipboard.setData(
                      ClipboardData(text: all[i]['text'] ?? ''),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied ✅')),
                    );
                  },
                );
              },
            ),
          )
        ],
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
  String category = 'User Shayari';
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
      const SnackBar(content: Text('Shayari added ✅')),
    );

    name.clear();
    text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cats = widget.isAdmin ? ShayariDB.data.keys.toList() : ['User Shayari'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdmin ? 'Admin Add Shayari' : 'User Add Shayari'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xff43cea2), Color(0xff185a9d)],
              ),
            ),
            child: Text(
              widget.isAdmin
                  ? 'Admin mode: kisi bhi category me add karo'
                  : 'User mode: aapki shayari User Shayari me add hogi',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            value: category,
            items: cats.map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
            onChanged: (v) => setState(() => category = v!),
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: name,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: text,
            maxLines: 7,
            decoration: const InputDecoration(
              labelText: 'Write Shayari',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Text('Save Shayari'),
          ),
        ],
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
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Admin Add Shayari'),
            subtitle: const Text('Password required'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PasswordPage(refresh: refresh)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Calculator'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalculatorPage()),
              );
            },
          ),
          SwitchListTile(
            value: darkMode,
            onChanged: (_) => onThemeChange(),
            title: const Text('Dark / Light Mode'),
            secondary: const Icon(Icons.dark_mode),
          ),
        ],
      ),
    );
  }
}

class PasswordPage extends StatefulWidget {
  final VoidCallback refresh;
  const PasswordPage({super.key, required this.refresh});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final pass = TextEditingController();

  void login() {
    if (pass.text == 'ABCD@12345') {
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
        const SnackBar(content: Text('Wrong password ❌')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.lock_rounded, size: 80),
            const SizedBox(height: 18),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: login,
              icon: const Icon(Icons.login),
              label: const Text('Login'),
            ),
          ],
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
    'C', 'DEL', '(', ')',
    'sin', 'cos', 'tan', '√',
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    '0', '.', '^', '+',
    'π', 'log', '='
  ];

  void tap(String v) {
    setState(() {
      if (v == 'C') {
        input = '';
        result = '0';
      } else if (v == 'DEL') {
        if (input.isNotEmpty) input = input.substring(0, input.length - 1);
      } else if (v == '=') {
        result = solve(input);
      } else if (v == '√') {
        input += 'sqrt(';
      } else if (v == 'sin' || v == 'cos' || v == 'tan' || v == 'log') {
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
      exp = exp.replaceAll('×', '*').replaceAll('÷', '/');
      final ans = ExpressionParser(exp).parse();
      if (ans % 1 == 0) return ans.toInt().toString();
      return ans.toStringAsFixed(4);
    } catch (_) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 10),
                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 42,
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (_, i) {
              final b = buttons[i];

              return ElevatedButton(
                onPressed: () => tap(b),
                style: ElevatedButton.styleFrom(
                  backgroundColor: b == '=' ? Colors.pink : Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  b,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
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
