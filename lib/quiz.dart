import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _nameController = TextEditingController();
  String? userName;
  bool isAdult = true;
  int currentQuestionIndex = 0;
  int score = 0;
  bool quizFinished = false;
  bool showAnswers = false;
  List<Question> questions = [];
  List<Answer> shuffledAnswers = [];
  bool adultQuizCompleted = false;
  bool minorQuizCompleted = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: quizFinished
            ? buildResultPage()
            : (userName == null ? buildStartPage() : buildQuestionPage()),
      ),
    );
  }

  Widget buildStartPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        buildImages(),
        const Text(
          'QUIZ',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Seu Nome'),
        ),
        CheckboxListTile(
          title: const Text('Maior de idade'),
          value: isAdult,
          onChanged: (value) => setState(() => isAdult = value!),
        ),
        CheckboxListTile(
          title: const Text('Menor de idade'),
          value: !isAdult,
          onChanged: (value) => setState(() => isAdult = !value!),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              userName = _nameController.text;
              currentQuestionIndex = 0;
              score = 0;
              quizFinished = false;
              showAnswers = false;
              questions = isAdult ? adultQuestions : minorQuestions;
              shuffledAnswers = questions[currentQuestionIndex].answers..shuffle();
            });
          },
          child: const Text('Começar'),
        ),
        const Spacer(),
      ],
    );
  }

  Widget buildQuestionPage() {
    if (currentQuestionIndex >= questions.length) {
      quizFinished = true;
      return buildResultPage();
    }

    Question currentQuestion = questions[currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        buildImages(),
        const Text(
          'QUIZ',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(currentQuestion.question),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: shuffledAnswers.length,
            itemBuilder: (context, index) {
              final answer = shuffledAnswers[index];
              return ListTile(
                title: Text(answer.text),
                leading: showAnswers
                    ? Image.asset(
                          // answer.isCorrect ? Icons.check_circle : Icons.cancel,
                          answer.isCorrect ? 
                      //     color: answer.isCorrect ? Colors.green : Colors.red,
                        'imagens/aceitar.jpg' : 'imagens/negativo.jpg'
                        )
                      : null,
                onTap: () {
                  if (!showAnswers) {
                    setState(() {
                      showAnswers = true;
                      if (answer.isCorrect) {
                        score++;
                      }
                    });
                  }
                },
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: showAnswers
              ? () {
                  setState(() {
                    currentQuestionIndex++;
                    showAnswers = false;
                    if (currentQuestionIndex < questions.length) {
                      shuffledAnswers = questions[currentQuestionIndex].answers..shuffle();
                    }
                  });
                }
              : null,
          child: const Text('Próxima'),
        ),
        const Spacer(),
      ],
    );
  }

  Widget buildResultPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        buildImages(),
        const Text(
          'QUIZ',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text('Resultado: $userName, você fez $score acertos.'),
        const Text('Experimente responder as questões para a outra opção.'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (isAdult) {
                adultQuizCompleted = true;
              } else {
                minorQuizCompleted = true;
              }

              if (adultQuizCompleted && minorQuizCompleted) {
                userName = null;
                _nameController.clear();
                adultQuizCompleted = false;
                minorQuizCompleted = false;
                isAdult = true;
              } else {
                userName = _nameController.text;
                isAdult = !isAdult;
              }

              currentQuestionIndex = 0;
              score = 0;
              quizFinished = false;
              showAnswers = false;
              questions = isAdult ? adultQuestions : minorQuestions;
              shuffledAnswers = questions[currentQuestionIndex].answers..shuffle();
            });
          },
          child: Text(adultQuizCompleted && minorQuizCompleted ? 'Voltar ao início' : 'Recomeçar'),
        ),
        const Spacer(),
      ],
    );
  }

  Widget buildImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset('imagens/200_front.jpg', width: 100, height: 100),
        Image.asset('imagens/200_front.jpg', width: 100, height: 100),
        Image.asset('imagens/200_front.jpg', width: 100, height: 100),
        Image.asset('imagens/200_front.jpg', width: 100, height: 100),
      ],
    );
  }
}

// Classe que representa uma pergunta
class Question {
  final String question; // Texto da pergunta
  final List<Answer> answers; // Lista de alternativas

  Question({required this.question, required this.answers});
}

// Classe que representa uma alternativa
class Answer {
  final String text; // Texto da alternativa
  final bool isCorrect; // Se a alternativa está correta

  Answer({required this.text, required this.isCorrect});
}

// Lista de perguntas para adultos
List<Question> adultQuestions = [
  Question(
    question: 'Qual a capital da França?',
    answers: [
      Answer(text: 'Paris', isCorrect: true),
      Answer(text: 'Londres', isCorrect: false),
      Answer(text: 'Berlim', isCorrect: false),
      Answer(text: 'Madri', isCorrect: false),
    ],
  ),
  Question(
    question: 'Qual o maior oceano do mundo?',
    answers: [
      Answer(text: 'Oceano Pacífico', isCorrect: true),
      Answer(text: 'Oceano Atlântico', isCorrect: false),
      Answer(text: 'Oceano Índico', isCorrect: false),
      Answer(text: 'Oceano Ártico', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quem escreveu "Dom Quixote"?',
    answers: [
      Answer(text: 'Miguel de Cervantes', isCorrect: true),
      Answer(text: 'William Shakespeare', isCorrect: false),
      Answer(text: 'Gabriel García Márquez', isCorrect: false),
      Answer(text: 'Jorge Luis Borges', isCorrect: false),
    ],
  ),
  Question(
    question: 'Qual é o elemento químico representado pelo símbolo "O"?',
    answers: [
      Answer(text: 'Oxigênio', isCorrect: true),
      Answer(text: 'Ouro', isCorrect: false),
      Answer(text: 'Prata', isCorrect: false),
      Answer(text: 'Platina', isCorrect: false),
    ],
  ),
  Question(
    question: 'Qual país é famoso pela Torre Eiffel?',
    answers: [
      Answer(text: 'França', isCorrect: true),
      Answer(text: 'Itália', isCorrect: false),
      Answer(text: 'Espanha', isCorrect: false),
      Answer(text: 'Alemanha', isCorrect: false),
    ],
  ),
];

// Lista de perguntas para menores
List<Question> minorQuestions = [
  Question(
    question: 'Qual é o maior planeta do sistema solar?',
    answers: [
      Answer(text: 'Júpiter', isCorrect: true),
      Answer(text: 'Saturno', isCorrect: false),
      Answer(text: 'Terra', isCorrect: false),
      Answer(text: 'Marte', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quantas cores tem o arco-íris?',
    answers: [
      Answer(text: 'Sete', isCorrect: true),
      Answer(text: 'Cinco', isCorrect: false),
      Answer(text: 'Oito', isCorrect: false),
      Answer(text: 'Seis', isCorrect: false),
    ],
  ),
  Question(
    question: 'Qual é o animal mais rápido do mundo?',
    answers: [
      Answer(text: 'Guepardo', isCorrect: true),
      Answer(text: 'Leão', isCorrect: false),
      Answer(text: 'Tigre', isCorrect: false),
      Answer(text: 'Águia', isCorrect: false),
    ],
  ),
  Question(
    question: 'Qual é o nome do nosso planeta?',
    answers: [
      Answer(text: 'Terra', isCorrect: true),
      Answer(text: 'Marte', isCorrect: false),
      Answer(text: 'Vênus', isCorrect: false),
      Answer(text: 'Júpiter', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quantos dias tem um ano bissexto?',
    answers: [
      Answer(text: '366', isCorrect: true),
      Answer(text: '365', isCorrect: false),
      Answer(text: '364', isCorrect: false),
      Answer(text: '367', isCorrect: false),
    ],
  ),
];
