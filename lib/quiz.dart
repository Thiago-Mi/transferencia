import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// A classe principal do aplicativo Flutter
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

// A classe StatefulWidget que gerencia o estado do quiz
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Controlador para o campo de texto onde o usuário digita seu nome
  final TextEditingController _nameController = TextEditingController();

  // Variáveis de estado
  String? userName;             // Nome do usuário
  bool isAdult = true;          // Indica se o quiz é para adultos
  int currentQuestionIndex = 0; // Índice da pergunta atual
  int score = 0;                // Pontuação do usuário
  bool quizFinished = false;    // Indica se o quiz foi concluído
  bool showAnswers = false;     // Controla a exibição das respostas corretas
  List<Question> questions = []; // Lista de perguntas do quiz atual
  List<Answer> shuffledAnswers = []; // Alternativas embaralhadas da pergunta atual

  // Flags para verificar se as duas listas de perguntas foram completadas
  bool adultQuizCompleted = false;
  bool minorQuizCompleted = false;

  @override
  void dispose() {
    _nameController.dispose(); // Limpa o controlador de texto ao destruir o widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: quizFinished
            ? buildResultPage() // Exibe a página de resultados se o quiz foi concluído
            : (userName == null ? buildStartPage() : buildQuestionPage()), // Exibe a página inicial ou de perguntas
      ),
    );
  }

  // Constrói a página inicial do quiz
  Widget buildStartPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        buildImages(), // Exibe as imagens no topo da página
        const Text(
          'QUIZ',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        // Campo de texto para o usuário digitar seu nome
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Seu Nome'),
        ),
        // Checkbox para selecionar se o usuário é maior ou menor de idade
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
        // Botão "Começar" que inicia o quiz
        ElevatedButton(
          onPressed: () {
            setState(() {
              userName = _nameController.text; // Armazena o nome do usuário
              currentQuestionIndex = 0;
              score = 0;
              quizFinished = false;
              showAnswers = false;
              // Seleciona a lista de perguntas com base na escolha do usuário
              questions = isAdult ? adultQuestions : minorQuestions;
              // Embaralha as alternativas da primeira pergunta
              shuffledAnswers = questions[currentQuestionIndex].answers..shuffle();
            });
          },
          child: const Text('Começar'),
        ),
        const Spacer(),
      ],
    );
  }

  // Constrói a página das perguntas do quiz
  Widget buildQuestionPage() {
    // Verifica se o quiz foi completado
    if (currentQuestionIndex >= questions.length) {
      quizFinished = true;
      return buildResultPage();
    }

    Question currentQuestion = questions[currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        buildImages(), // Exibe as imagens no topo da página
        const Text(
          'QUIZ',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        // Exibe a pergunta atual
        Text(currentQuestion.question),
        // Exibe as alternativas como uma lista de ListTiles
        for (Answer answer in shuffledAnswers)
          ListTile(
            title: Text(answer.text),
            leading: showAnswers
                ? Icon(
                    answer.isCorrect ? Icons.check_circle : Icons.cancel,
                    color: answer.isCorrect ? Colors.green : Colors.red,
                  )
                : null,
            // Ação ao selecionar uma alternativa
            onTap: () {
              if (!showAnswers) {
                setState(() {
                  showAnswers = true;
                  // Incrementa a pontuação se a resposta estiver correta
                  if (answer.isCorrect) {
                    score++;
                  }
                });
              }
            },
          ),
        const Spacer(),
        // Botão "Próxima" para avançar para a próxima pergunta
        ElevatedButton(
          onPressed: showAnswers
              ? () {
                  setState(() {
                    currentQuestionIndex++;
                    showAnswers = false;
                    // Embaralha as alternativas da próxima pergunta
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

  // Constrói a página de resultados do quiz
  Widget buildResultPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        buildImages(), // Exibe as imagens no topo da página
        const Text(
          'QUIZ',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        // Exibe a pontuação do usuário
        Text('Resultado: $userName, você fez $score acertos.'),
        const Text('Experimente responder as questões para a outra opção.'),
        // Botão para recomeçar o quiz ou reiniciar a aplicação
        ElevatedButton(
          onPressed: () {
            setState(() {
              // Marca o quiz como completo e verifica se ambos foram completados
              if (isAdult) {
                adultQuizCompleted = true;
              } else {
                minorQuizCompleted = true;
              }

              // Se ambos os quizzes foram completados, reseta a aplicação
              if (adultQuizCompleted && minorQuizCompleted) {
                userName = null;
                _nameController.clear(); // Limpa o nome do usuário
                adultQuizCompleted = false;
                minorQuizCompleted = false;
                isAdult = true;
              } else {
                userName = _nameController.text;
                isAdult = !isAdult; // Alterna para a outra lista de perguntas
              }

              // Reseta o estado do quiz
              currentQuestionIndex = 0;
              score = 0;
              quizFinished = false;
              showAnswers = false;
              questions = isAdult ? adultQuestions : minorQuestions;
              shuffledAnswers = questions[currentQuestionIndex].answers..shuffle();
            });
          },
          // Exibe "Voltar ao início" se ambos os quizzes foram completados
          child: Text(adultQuizCompleted && minorQuizCompleted ? 'Voltar ao início' : 'Recomeçar'),
        ),
        const Spacer(),
      ],
    );
  }

  // Constrói a linha de imagens na parte superior da tela
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
