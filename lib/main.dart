import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Page1(),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  int valor = 0;

  void incrementValue(int increment) {
    setState(() {
      valor += increment;
    });
  }

  void transferValue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Page2(valor: valor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha o valor:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Valor:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '$valor',
              style: const TextStyle(fontSize: 24),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => incrementValue(2),
                  child: const Text('+2'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(20),
                  child: const Text('+20'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(50),
                  child: const Text('+50'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(100),
                  child: const Text('+100'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: transferValue,
                child: const Text('Transferir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final int valor;

  const Page2({super.key, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Voce Transferiu',
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 10),
            Text(
              'R\$ $valor,00',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
