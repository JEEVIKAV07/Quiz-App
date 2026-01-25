import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  bool quizFinished = false;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "Which is the largest planet in our solar system?", 
      "options": ["Earth", "Jupiter", "Mars", "Saturn"], 
      "answer": 1 },
       { "question": "Who is known as the Father of the Nation in India?", "options": [ "Jawaharlal Nehru", "Mahatma Gandhi", "B. R. Ambedkar", "Subhash Chandra Bose" ], "answer": 1 }, { "question": "What is the capital of Australia?", "options": ["Sydney", "Melbourne", "Canberra", "Perth"], "answer": 2 }, { "question": "Which gas is most abundant in the Earth’s atmosphere?", "options": ["Oxygen", "Nitrogen", "Carbon Dioxide", "Hydrogen"], "answer": 1 }, { "question": "Who invented the light bulb?", "options": [ "Nikola Tesla", "Alexander Graham Bell", "Thomas Edison", "James Watt" ], "answer": 2 }, { "question": "Which is the national flower of India?", "options": ["Rose", "Lotus", "Lily", "Sunflower"], "answer": 1 }, { "question": "Which continent is known as the Dark Continent?", "options": ["Asia", "South America", "Africa", "Australia"], "answer": 2 }, { "question": "What is the chemical symbol for Gold?", "options": ["Ag", "Gd", "Au", "Go"], "answer": 2 }, { "question": "Who wrote the national anthem of India?", "options": [ "Rabindranath Tagore", "Bankim Chandra Chatterjee", "Sarojini Naidu", "Subramania Bharati" ], "answer": 0 }, { "question": "Which country hosted the 2016 Summer Olympics?", "options": ["China", "Brazil", "UK", "Russia"], "answer": 1 },
    // ... your other questions
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void checkAnswer(int selected) {
    if (questions[currentQuestion]['answer'] as int == selected) {
      score++;
    }
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      setState(() {
        quizFinished = true;
      });
      saveScore(); // Save to Firestore
    }
  }

  Future<void> saveScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('score').doc(user.uid).set({
          'sc': score,
          'email': user.email,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Score saved successfully!');
      } catch (e) {
        print('Error saving score: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("General Knowledge Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: quizFinished
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Quiz Finished!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Your Score: $score/${questions.length}",
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "User: ${user?.email ?? "Unknown"}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentQuestion = 0;
                        score = 0;
                        quizFinished = false;
                      });
                    },
                    child: const Text("Restart Quiz"),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Q${currentQuestion + 1}. ${questions[currentQuestion]['question']}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    questions[currentQuestion]['options'].length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.green, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                          ),
                          onPressed: () => checkAnswer(index),
                          child: Text(
                            questions[currentQuestion]['options'][index],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
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
