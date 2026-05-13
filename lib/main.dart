import 'package:flutter/material.dart';

void main() {
  runApp(const ShayariApp());
}

class ShayariApp extends StatelessWidget {
  const ShayariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shayari Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int page = 0;

  final pages = const [
    HomePage(),
    ShayariPage(),
    CalculatorPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (value) {
          setState(() => page = value);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Shayari'),
          NavigationDestination(icon: Icon(Icons.calculate), label: 'Calc'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ['Love', Icons.favorite, Colors.pink],
      ['Attitude', Icons.flash_on, Colors.orange],
      ['Sad', Icons.nightlight, Colors.indigo],
      ['Motivation', Icons.rocket_launch, Colors.green],
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1b0036), Color(0xff5f2c82), Color(0xff49a09d)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'Shayari Hub ✨',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Love, attitude, sad aur motivation shayari ek hi app me.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today Special 🔥',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Humse jalne wale bhi kamaal karte hain,\nMehfil khud ki… aur charche hamare karte hain 😎',
                    style: TextStyle(color: Colors.white, fontSize: 17, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Categories',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
              itemBuilder: (context, index) {
                final item = categories[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: item[2] as Color,
                        radius: 28,
                        child: Icon(item[1] as IconData, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item[0] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
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

class ShayariPage extends StatelessWidget {
  const ShayariPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shayari = [
      'Mohabbat bhi udhaar ki tarah nikli,\nLog le toh lete hain… par lautate nahi 💔',
      'Attitude to bachpan se hai sahab,\nBas ab dard ne use khamosh bana diya 😎',
      'Usne kaha bhool jao mujhe,\nHumne muskura kar kaha — kaun ho tum? 🥀',
      'Sapne woh nahi jo neend me aaye,\nSapne woh hain jo neend uda dein 🔥',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Best Shayari')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: shayari.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xfffdfbfb), Color(0xffebedee)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shayari[index],
                    style: const TextStyle(fontSize: 18, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
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

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '0';

  void press(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '0';
      } else if (value == 'DEL') {
        if (input.isNotEmpty) input = input.substring(0, input.length - 1);
      } else if (value == '=') {
        result = calculate(input);
      } else {
        input += value;
      }
    });
  }

  String calculate(String exp) {
    try {
      exp = exp.replaceAll('×', '*').replaceAll('÷', '/');
      final numbers = exp.split(RegExp(r'[+\-*/]'));
      final ops = RegExp(r'[+\-*/]').allMatches(exp).map((e) => e.group(0)!).toList();

      if (numbers.length < 2) return exp;

      double ans = double.parse(numbers[0]);
      for (int i = 0; i < ops.length; i++) {
        double n = double.parse(numbers[i + 1]);
        if (ops[i] == '+') ans += n;
        if (ops[i] == '-') ans -= n;
        if (ops[i] == '*') ans *= n;
        if (ops[i] == '/') ans /= n;
      }
      return ans.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      'C', 'DEL', '÷', '×',
      '7', '8', '9', '-',
      '4', '5', '6', '+',
      '1', '2', '3', '=',
      '0', '.', '00',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff232526), Color(0xff414345)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                    Text(input, style: const TextStyle(color: Colors.white70, fontSize: 28)),
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
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final btn = buttons[index];
                return ElevatedButton(
                  onPressed: () => press(btn),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: btn == '=' ? Colors.deepPurple : Colors.white,
                    foregroundColor: btn == '=' ? Colors.white : Colors.black,
                  ),
                  child: Text(btn, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
