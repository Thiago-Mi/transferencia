import 'package:flutter/material.dart';
import 'dart:math';

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
  List<int> espaco = [0, 0, 0, 0, 0, 0];

  void incrementValue(int increment, int espacoIndice) {
    setState(() {
      if (espaco[espacoIndice] + increment > 0 & espaco[espacoIndice] + increment < 61 ){

        espaco[espacoIndice] += increment;
      }
    });
  }

  List<int> gerarNumerosAleatorios() {
    Random random = Random();
    List<int> numeros = [];

    while (numeros.length < 6) {
      int numero = random.nextInt(60) + 1;
      if (!numeros.contains(numero)) {
        numeros.add(numero);
      }
    }

    return numeros;
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
        title: const Text('MEGA SENA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sorteados:',
              style: TextStyle(fontSize: 25),
            ),
            Row(
              children: [
                
                const SizedBox(width: 80),
                Text(
                  '${espaco[0]}',
                  style: const TextStyle(fontSize: 24),
                ),
                
                const SizedBox(width: 60),
                Text(
                  '${espaco[1]}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 60),
                Text(
                  '${espaco[2]}',
                  style: const TextStyle(fontSize: 24),
                ),
                
                const SizedBox(width: 60),
                Text(
                  '${espaco[3]}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 60),
                Text(
                  '${espaco[4]}',
                  style: const TextStyle(fontSize: 24),
                ),
                
                const SizedBox(width: 60),
                Text(
                  '${espaco[5]}',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1,
              color: Colors.black,
            ),
            
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => incrementValue(-1, 0),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(1, 0),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(-1, 1),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(1, 1),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(-1, 2),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(1, 2),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(-1, 3),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(1, 3),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(-1, 4),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(1, 4),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(-1, 5),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => incrementValue(1, 5),
                  child: const Text('+'),
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
              'Você Transferiu',
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
