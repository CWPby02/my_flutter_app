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

  void toggleTheme() {
    setState(() {
      darkMode = !darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'shyari_by_piyush',
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: HomePage(
        darkMode: darkMode,
        onThemeChange: toggleTheme,
      ),
    );
  }
}

class ShayariDB {
  static Map<String, List<Map<String, String>>> data = {
    "Love": [
      {
        "text":
            "Mohabbat bhi udhaar ki tarah nikli,\nLog le toh lete hain… par lautate nahi 💔",
        "author": "Piyush"
      }
    ],
    "Sad": [
      {
        "text":
            "Usne kaha bhool jao mujhe,\nHumne muskura kar kaha — kaun ho tum? 🥀",
        "author": "Piyush"
      }
    ],
    "Attitude": [
      {
        "text":
            "Humse jalne wale bhi kamaal karte hain,\nMehfil khud ki aur charche hamare 😎",
        "author": "Piyush"
      }
    ],
    "Motivation": [
      {
        "text":
            "Sapne woh nahi jo neend me aaye,\nSapne woh hain jo neend uda dein 🔥",
        "author": "Piyush"
      }
    ],
  };
}

class HomePage extends StatelessWidget {
  final bool darkMode;
  final VoidCallback onThemeChange;

  const HomePage({
    super.key,
    required this.darkMode,
    required this.onThemeChange,
  });

  final categories = const [
    ["Love", Icons.favorite, Colors.pink],
    ["Sad", Icons.dark_mode, Colors.indigo],
    ["Attitude", Icons.flash_on, Colors.orange],
    ["Motivation", Icons.rocket_launch, Colors.green],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.pink],
                ),
              ),
              child: Center(
                child: Text(
                  "shyari_by_piyush ✨",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text("Advanced Calculator"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CalculatorPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text("Admin Add Shayari"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PasswordPage(),
                  ),
                );
              },
            ),
            SwitchListTile(
              value: darkMode,
              onChanged: (_) => onThemeChange(),
              title: const Text("Dark Mode"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("shyari_by_piyush"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onThemeChange,
            icon: Icon(
              darkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff141e30),
              Color(0xff243b55),
            ],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: categories.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, i) {
            final item = categories[i];

            return InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(
                      category: item[0] as String,
                    ),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      (item[2] as Color).withOpacity(.7),
                      (item[2] as Color),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (item[2] as Color).withOpacity(.5),
                      blurRadius: 18,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item[1] as IconData,
                      color: Colors.white,
                      size: 45,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      item[0] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final list = ShayariDB.data[category]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: list.length,
        itemBuilder: (context, i) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [
                  Color(0xff8E2DE2),
                  Color(0xff4A00E0),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list[i]["text"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "- ${list[i]["author"]}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.text == "12345") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddShayariPage(),
                    ),
                  );
                }
              },
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}

class AddShayariPage extends StatefulWidget {
  const AddShayariPage({super.key});

  @override
  State<AddShayariPage> createState() => _AddShayariPageState();
}

class _AddShayariPageState extends State<AddShayariPage> {
  String category = "Love";

  final shayariController = TextEditingController();
  final authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Shayari"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            DropdownButtonFormField(
              value: category,
              items: ShayariDB.data.keys.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  category = v!;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: "Author Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: shayariController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Write Shayari",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Shayari"),
              onPressed: () async {
                final prefs =
                    await SharedPreferences.getInstance();

                ShayariDB.data[category]!.add({
                  "text": shayariController.text,
                  "author": authorController.text,
                });

                prefs.setString(
                  "lastshayari",
                  shayariController.text,
                );

                Navigator.pop(context);
              },
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
  State<CalculatorPage> createState() =>
      _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = "";
  String result = "0";

  final buttons = [
    "7",
    "8",
    "9",
    "÷",
    "4",
    "5",
    "6",
    "×",
    "1",
    "2",
    "3",
    "-",
    "0",
    ".",
    "=",
    "+",
    "C"
  ];

  void press(String v) {
    setState(() {
      if (v == "C") {
        input = "";
        result = "0";
      } else if (v == "=") {
        try {
          String exp = input
              .replaceAll("×", "*")
              .replaceAll("÷", "/");

          result = exp;
        } catch (_) {
          result = "Error";
        }
      } else {
        input += v;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                input,
                style: const TextStyle(fontSize: 35),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: buttons.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () => press(buttons[i]),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      buttons[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
