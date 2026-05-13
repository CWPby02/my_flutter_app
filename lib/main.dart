import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ShayariByPiyush());
}

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
    loadTheme();
    ShayariDB.load();
  }

  Future<void> loadTheme() async {
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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.pink),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: HomePage(darkMode: darkMode, onThemeChange: toggleTheme),
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
}

class HomePage extends StatefulWidget {
  final bool darkMode;
  final VoidCallback onThemeChange;

  const HomePage({super.key, required this.darkMode, required this.onThemeChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final categories = const [
    ['Love', Icons.favorite, Colors.pink],
    ['Attitude', Icons.flash_on, Colors.orange],
    ['Sad', Icons.dark_mode, Colors.indigo],
    ['Motivation', Icons.rocket_launch, Colors.green],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.pink, Colors.deepPurple]),
              ),
              child: Center(
                child: Text(
                  'shyari_by_piyush ✨',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Add Shayari'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PasswordPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Advanced Calculator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorPage()));
              },
            ),
            SwitchListTile(
              value: widget.darkMode,
              onChanged: (_) => widget.onThemeChange(),
              title: const Text('Dark Mode'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('shyari_by_piyush'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: widget.onThemeChange, icon: Icon(widget.darkMode ? Icons.light_mode : Icons.dark_mode)),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorPage())),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xff141e30), Color(0xff243b55)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(colors: [Color(0xffff416c), Color(0xffff4b2b)]),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 18)],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Piyush ✍️', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Love, Attitude, Sad aur Motivation Shayari', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15),
              itemBuilder: (context, i) {
                final item = categories[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryPage(category: item[0] as String)));
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(colors: [(item[2] as Color).withOpacity(.75), item[2] as Color]),
                      boxShadow: [BoxShadow(color: (item[2] as Color).withOpacity(.5), blurRadius: 18)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item[1] as IconData, color: Colors.white, size: 45),
                        const SizedBox(height: 12),
                        Text(item[0] as String, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                        Text('${ShayariDB.data[item[0]]?.length ?? 0} Shayari', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
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
  @override
  Widget build(BuildContext context) {
    final list = ShayariDB.data[widget.category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} Shayari')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Admin Add'),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordPage(defaultCategory: widget.category)));
          setState(() {});
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: list.length,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(colors: [Color(0xff8E2DE2), Color(0xff4A00E0)]),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(list[i]['text'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 19, height: 1.5)),
                const SizedBox(height: 12),
                Text('- ${list[i]['author'] ?? 'Unknown'}', style: const TextStyle(color: Colors.white70, fontSize: 15)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PasswordPage extends StatefulWidget {
  final String? defaultCategory;
  const PasswordPage({super.key, this.defaultCategory});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final password = TextEditingController();

  void login() {
    if (password.text == '12345') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AddShayariPage(defaultCategory: widget.defaultCategory)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password ❌')));
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
            const Icon(Icons.lock, size: 80),
            const SizedBox(height: 20),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Enter Admin Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(onPressed: login, icon: const Icon(Icons.login), label: const Text('Login')),
            ),
          ],
        ),
      ),
    );
  }
}

class AddShayariPage extends StatefulWidget {
  final String? defaultCategory;
  const AddShayariPage({super.key, this.defaultCategory});

  @override
  State<AddShayariPage> createState() => _AddShayariPageState();
}

class _AddShayariPageState extends State<AddShayariPage> {
  late String category = widget.defaultCategory ?? 'Love';
  final shayari = TextEditingController();
  final author = TextEditingController();

  Future<void> saveShayari() async {
    if (shayari.text.trim().isEmpty || author.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shayari aur name dono likho')));
      return;
    }

    ShayariDB.data[category]!.add({
      'text': shayari.text.trim(),
      'author': author.text.trim(),
    });

    await ShayariDB.save();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shayari added successfully ✅')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shayari'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: category,
              items: ShayariDB.data.keys.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => category = v!),
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: author,
              decoration: const InputDecoration(labelText: 'Your Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: shayari,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Write Shayari', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(onPressed: saveShayari, icon: const Icon(Icons.save), label: const Text('Save Shayari')),
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
        title: const Text('Advanced Calculator'),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xff0f2027), Color(0xff203a43), Color(0xff2c5364)]),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(input, style: const TextStyle(color: Colors.white70, fontSize: 25)),
                    const SizedBox(height: 10),
                    Text(result, style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (_, i) {
                final b = buttons[i];
                return ElevatedButton(
                  onPressed: () => tap(b),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: b == '=' ? Colors.orange : Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text(b, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ],
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
      double x = parseExpression();
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
    while (pos < s.length && s[pos] == ' ') pos++;
  }
}
