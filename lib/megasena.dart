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
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List<int> espaco = [4, 7, 15, 20, 34, 58];

  void incrementValue(int increment, int espacoIndice) {
    setState(() {
      if ((espaco[espacoIndice] + increment >= 1) & (espaco[espacoIndice] + increment < 61)) {
        espaco[espacoIndice] += increment;
      }
    });
  }

  void transferValue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Page2(espaco: espaco),
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
                NumberDisplay(number: '${espaco[0]}'),
                const SizedBox(width: 60),
                NumberDisplay(number: '${espaco[1]}'),
                const SizedBox(width: 60),
                NumberDisplay(number: '${espaco[2]}'),
                const SizedBox(width: 60),
                NumberDisplay(number: '${espaco[3]}'),
                const SizedBox(width: 60),
                NumberDisplay(number: '${espaco[4]}'),
                const SizedBox(width: 60),
                NumberDisplay(number: '${espaco[5]}'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SquareButton(
                  onPressed: () => incrementValue(-1, 0),
                  child: const Text('-'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(1, 0),
                  child: const Text('+'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(-1, 1),
                  child: const Text('-'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(1, 1),
                  child: const Text('+'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(-1, 2),
                  child: const Text('-'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(1, 2),
                  child: const Text('+'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(-1, 3),
                  child: const Text('-'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(1, 3),
                  child: const Text('+'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(-1, 4),
                  child: const Text('-'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(1, 4),
                  child: const Text('+'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(-1, 5),
                  child: const Text('-'),
                ),
                SquareButton(
                  onPressed: () => incrementValue(1, 5),
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: transferValue,
                child: const Text('Sortear e Conferir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final List<int> espaco;
  final List<int> numerosAleatorios;

  Page2({super.key, required this.espaco}) : numerosAleatorios = gerarNumerosAleatorios();

  @override
  Widget build(BuildContext context) {
    int matchingCount = compareLists(espaco, numerosAleatorios);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Números Selecionados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: espaco.map((num) => NumberDisplay(number: '$num')).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Números Sorteados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: numerosAleatorios.map((num) => NumberDisplay(number: '$num')).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Você fez $matchingCount pontos',
              style: const TextStyle(
              fontFamily: 'PlaywriteCU', 
              fontStyle: FontStyle.italic,
              fontSize: 24),
            ),
            const SizedBox(height: 20),
            Image.asset('imagens/200_front.jpg'),
          ],
        ),
      ),
    );
  }

  static List<int> gerarNumerosAleatorios() {
    Random random = Random();
    Set<int> numeros = {};

    while (numeros.length < 6) {
      numeros.add(random.nextInt(60) + 1);
    }

    return numeros.toList();
  }

  int compareLists(List<int> list1, List<int> list2) {
    return list1.where((element) => list2.contains(element)).length;
  }
}

class NumberDisplay extends StatelessWidget {
  final String number;
  const NumberDisplay({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        number,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const SquareButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(16),
      ),
      child: child,
    );
  }
}
