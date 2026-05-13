import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const ShayariProApp());

class ShayariProApp extends StatelessWidget {
  const ShayariProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shayari Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class ShayariStore {
  static Map<String, List<String>> data = {
    'Love': [
      'Mohabbat bhi udhaar ki tarah nikli,\nLog le toh lete hain… par lautate nahi 💔',
      'Tere bina zindagi adhuri si lagti hai,\nJaise raat bina chand ke 🥀',
    ],
    'Attitude': [
      'Humse jalne wale bhi kamaal karte hain,\nMehfil khud ki… aur charche hamare 😎',
      'Naam chhota hai par pehchan badi hai 🔥',
    ],
    'Sad': [
      'Usne kaha bhool jao mujhe,\nHumne muskura kar kaha — kaun ho tum? 🥀',
      'Dard wahi dete hain,\nJinse umeed sabse zyada hoti hai 💔',
    ],
    'Motivation': [
      'Sapne woh nahi jo neend me aaye,\nSapne woh hain jo neend uda dein 🔥',
      'Har haar ke baad jeet ka chance hota hai 🚀',
    ],
  };
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                gradient: LinearGradient(colors: [Colors.deepPurple, Colors.pink]),
              ),
              child: Text('Shayari Pro ✨',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Advanced Calculator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Shayari'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AddShayariPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Shayari Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorPage())),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddShayariPage())),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff141e30), Color(0xff243b55)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(colors: [Color(0xffff416c), Color(0xffff4b2b)]),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 18)],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apni Feelings Likho ✍️',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Love, sad, attitude aur motivation shayari ek stylish app me.',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('Categories',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14),
              itemBuilder: (context, i) {
                final c = categories[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CategoryPage(category: c[0] as String)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(.12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: c[2] as Color,
                          child: Icon(c[1] as IconData, color: Colors.white, size: 30),
                        ),
                        const SizedBox(height: 12),
                        Text(c[0] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
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
    final list = ShayariStore.data[widget.category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} Shayari')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => AddShayariPage(defaultCategory: widget.category)));
          setState(() {});
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, i) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(list[i], style: const TextStyle(fontSize: 18, height: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.copy), label: const Text('Copy')),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.share), label: const Text('Share')),
                    ],
                  )
                ],
              ),
            ),
          );
        },
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
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Shayari')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: category,
              items: ShayariStore.data.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => category = v!),
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Write your shayari',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Shayari'),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    ShayariStore.data[category]!.add(controller.text.trim());
                    Navigator.pop(context);
                  }
                },
              ),
            )
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
    'π', 'log', '=', 
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
      final parser = ExpressionParser(exp);
      final ans = parser.parse();
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
                    Text(input, style: const TextStyle(color: Colors.white70, fontSize: 26)),
                    const SizedBox(height: 10),
                    Text(result, style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
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

  double parse() {
    final v = parseExpression();
    return v;
  }

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
    while (pos < s.length && (RegExp(r'[0-9.]').hasMatch(s[pos]))) {
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
