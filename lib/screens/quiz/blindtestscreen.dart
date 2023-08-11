// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import '../Auth/firestore.dart';
// import '../Constants/Widgets.dart';
// import '../Constants/quizWidget.dart';
// import '../modelClasses/Question_Model.dart';

// class ActualQuiz extends StatefulWidget {
//   final String id;
//   const ActualQuiz(this.id, {super.key});

//   @override
//   State<ActualQuiz> createState() => _ActualQuizState();
// }

// int total = 0, attempted = 0, correct = 0, incorrect = 0;

// class _ActualQuizState extends State<ActualQuiz> {
  
//   final FireStoreDataBase db = FireStoreDataBase();
//   QuerySnapshot<Map<String,dynamic>>? snapshot;

//   Question_Model GetQuestionData(DocumentSnapshot document) {
//     Map<String,dynamic> questionJson = document.data() as Map<String,dynamic>;

//     Question_Model model = Question_Model();
//     model.image = questionJson['ImageUrl'];
//     List<String> Options = [
//       questionJson['Option1'],
//       questionJson['Option2'],
//       questionJson['Option3'],
//     ];
//     Options.shuffle();
//     model.opt1 = Options[0];
//     model.opt2 = Options[1];
//     model.opt3 = Options[2];
//     model.correctAnswere = questionJson['Option1'];
//     model.answered = false;
//     return model;
//   }

//   @override
//   void initState() {
//     db.getQuizData(widget.id).then((value) {
      
//       attempted = 0;
//       correct = 0;
//       incorrect = 0;
//       setState(() {
//         snapshot = value;
//       total = snapshot!.docs.length;
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: appBar(context),
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             // ignore: unnecessary_null_comparison
//             snapshot?.docs == null
//                 ? Container(
//                     child: Center(
//                       child: Text('Hafsa'),
//                     ),
//                   )
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     physics: ClampingScrollPhysics(),
//                     itemCount: snapshot!.docs.length,
//                     itemBuilder: (context, index) {
//                       return QuizPLayTile(
//                         modelClass: GetQuestionData(
//                             snapshot!.docs[index] 
//                         ),
//                         index: index,
//                       );
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class QuizPLayTile extends StatefulWidget {
//   final Question_Model modelClass;
//   final int index;
//   const QuizPLayTile(
//       {required this.modelClass, required this.index, super.key});

//   @override
//   State<QuizPLayTile> createState() => _QuizPLayTileState();
// }

// class _QuizPLayTileState extends State<QuizPLayTile> {
//   String optionSelected = '';
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           OptionTile(
//             option: "1",
//             correctAns: widget.modelClass.opt1,
//             selectedAns: optionSelected,
//             description: widget.modelClass.opt1,
//           ),
//           const SizedBox(
//             height: 4,
//           ),
//           OptionTile(
//             option: "2",
//             correctAns: widget.modelClass.opt1,
//             selectedAns: optionSelected,
//             description: widget.modelClass.opt2,
//           ),
//           const SizedBox(
//             height: 4,
//           ),
//           OptionTile(
//             option: "3",
//             correctAns: widget.modelClass.opt1,
//             selectedAns: optionSelected,
//             description: widget.modelClass.opt3,
//           ),
//         ],
//       ),
//     );
//   }
// }








import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firestore.dart';

import 'Question_Model.dart';

class ActualQuiz extends StatefulWidget {
  final String id;
  const ActualQuiz(this.id, {Key? key});

  @override
  State<ActualQuiz> createState() => _ActualQuizState();
}

int total = 0, attempted = 0, correct = 0, incorrect = 0;

class _ActualQuizState extends State<ActualQuiz> {
  final FireStoreDataBase db = FireStoreDataBase();
  List<QuestionModel> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {

      List<QuestionModel> questions = [];
        
      QuerySnapshot<Map<String, dynamic>> questionSnapshot =
          await db.getQuestionsForQuiz(widget.id);
      
      questions.addAll(questionSnapshot.docs.map((doc) {
        log(doc.toString());
        log(doc.data().toString());
        return QuestionModel(
          image: doc.data()['ImageUrl'],
          options: [
            doc.data()['Option1'] ?? '',
            doc.data()['Option2'] ?? '',
            doc.data()['Option3'] ?? '',
          ],
        );
      },),);
      
      setState(() {
        quizQuestions = questions;
      });

    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        quizQuestions = [];
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Quiz'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            if (quizQuestions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: quizQuestions.length,
                itemBuilder: (context, index) {
                  return QuizPLayTile(
                    modelClass: quizQuestions[index],
                    index: index,
                  );
                },
              ),
            if (quizQuestions.isEmpty)
              Expanded(
                child: Center(
                  child: Text('No Data'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QuizPLayTile extends StatefulWidget {
  final QuestionModel modelClass;
  final int index;
  const QuizPLayTile({required this.modelClass, required this.index, Key? key})
      : super(key: key);

  @override
  State<QuizPLayTile> createState() => _QuizPLayTileState();
}

class _QuizPLayTileState extends State<QuizPLayTile> {
  String optionSelected = '';

  void checkAnswer() {
    if (optionSelected == widget.modelClass.correctAnswer) {
      setState(() {
        correct++;
      });
    } else {
      setState(() {
        incorrect++;
      });
    }
    setState(() {
      attempted++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Question image from Firestore
          if (widget.modelClass.image != null) Image.network(widget.modelClass.image!),

          // Question text from Firestore
          Text(widget.modelClass.options![0]),
          RadioListTile(
            title: Text(widget.modelClass.options![0]),
            value: widget.modelClass.options![0],
            groupValue: optionSelected,
            onChanged: (value) => setState(() => optionSelected = value!),
          ),
          RadioListTile(
            title: Text(widget.modelClass.options![1]),
            value: widget.modelClass.options![1],
            groupValue: optionSelected,
            onChanged: (value) => setState(() => optionSelected = value!),
          ),
          RadioListTile(
            title: Text(widget.modelClass.options![2]),
            value: widget.modelClass.options![2],
            groupValue: optionSelected,
            onChanged: (value) => setState(() => optionSelected = value!),
          ),
          ElevatedButton(
            onPressed: () {
              // Add the logic to check if the user has attempted all questions.
              // You can navigate to the result page here when all questions are attempted.
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

