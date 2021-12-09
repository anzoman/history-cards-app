import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:history_cards_app/models/Question.dart';
import 'package:history_cards_app/models/User.dart';
import 'package:history_cards_app/models/UserQuestion.dart';
import 'package:history_cards_app/models/Quiz.dart';
import 'package:history_cards_app/models/UserQuiz.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class DataStorage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  CollectionReference users;
  CollectionReference quizzes;
  CollectionReference questions;
  CollectionReference userQuizzes;
  CollectionReference userQuestions;
  CollectionReference ranks;
  String imagesBucketName;
  String filesBucketName;
  Uuid uuid;

  DataStorage() {
    users = firestore.collection('users');
    quizzes = firestore.collection('quizzes');
    questions = firestore.collection('questions');
    userQuizzes = firestore.collection('user_quizzes');
    userQuestions = firestore.collection('user_questions');
    ranks = firestore.collection('ranks');
    imagesBucketName = "images";
    filesBucketName = "files";
    uuid = Uuid();
  }

  Future<User> login(String email, String password) async {
    try {
      return await getUserByEmail(email);
    } catch (error) {
      throw Exception("Failed to login: $error");
    }
  }

  Future<User> register(User user) async {
    try {
      return await createUser(user);
    } catch (error) {
      throw Exception("Failed to register: $error");
    }
  }

  Future<User> createUser(User user) async {
    usernameExists(user.username).then((value) {
      if (value) {
        return null;
      }
    });
    emailExists(user.email).then((value) {
      if (value) {
        return null;
      }
    });
    return await users.add({
      'username': user.username,
      'full_name': user.fullName,
      'email': user.email,
      'image': user.image,
      'points': user.points,
      'permission': user.permission
    }).then((value) {
      user.id = value.id;
      return user;
    }).catchError((error) => throw Exception("Failed to add user: $error"));
  }

  Future<bool> usernameExists(String username) async {
    try {
      return await users.where('username', isEqualTo: username).get().then((value) => value.size > 0 ? true : false);
    } catch (error) {
      throw Exception("Failed to check if username exists: $error");
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      return await users.where('email', isEqualTo: email).get().then((value) => value.size > 0 ? true : false);
    } catch (error) {
      throw Exception("Failed to check if email exists: $error");
    }
  }

  Future<User> getUserById(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(userId).get();
      User user = User.fromJson(documentSnapshot.data());
      user.id = documentSnapshot.reference.id;
      return user;
    } catch (error) {
      throw Exception("Failed to search for user by id: $error");
    }
  }

  Future<User> getUserByUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await users.where('username', isEqualTo: username).get();
      if (querySnapshot.size != 1) {
        return null;
      }
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      User user = User.fromJson(documentSnapshot.data());
      user.id = documentSnapshot.reference.id;
      return user;
    } catch (error) {
      throw Exception("Failed to search for user by username: $error");
    }
  }

  Future<User> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();
      if (querySnapshot.size != 1) {
        return null;
      }
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      User user = User.fromJson(documentSnapshot.data());
      user.id = documentSnapshot.reference.id;
      return user;
    } catch (error) {
      throw Exception("Failed to search for user by email: $error");
    }
  }

  Future<List<User>> getUsersForLeaderboard() async {
    try {
      List<User> userList = [];
      QuerySnapshot querySnapshot = await users.orderBy("points", descending: true).get();
      if (querySnapshot.size == 0) {
        return userList;
      }
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        User user = User.fromJson(documentSnapshot.data());
        user.id = documentSnapshot.reference.id;
        userList.add(user);
      }
      return userList;
    } catch (error) {
      throw Exception("Failed to search for users: $error");
    }
  }

  Future<User> updateUserPoints(User user, int points) async {
    return await users.doc(user.id).update({'points': points}).then((value) {
      user.points = points;
      return user;
    }).catchError((error) => throw Exception("Failed to update user points: $error"));
  }

  Future<Quiz> createQuiz(Quiz quiz) async {
    quizNameExists(quiz.name).then((value) {
      if (value) {
        return null;
      }
    });
    return await quizzes
        .add({'name': quiz.name, 'description': quiz.description, 'survey': quiz.survey, 'user_id': quiz.userId}).then(
            (value) {
      quiz.id = value.id;
      return quiz;
    }).catchError((error) => throw Exception("Failed to add quiz: $error"));
  }

  Future<bool> quizNameExists(String name) async {
    try {
      return await quizzes.where('name', isEqualTo: name).get().then((value) => value.size > 0 ? true : false);
    } catch (error) {
      throw Exception("Failed to check if quiz name exists: $error");
    }
  }

  Future<Quiz> getQuizById(String quizId) async {
    try {
      DocumentSnapshot documentSnapshot = await quizzes.doc(quizId).get();
      Quiz quiz = Quiz.fromJson(documentSnapshot.data());
      quiz.id = documentSnapshot.reference.id;
      return quiz;
    } catch (error) {
      throw Exception("Failed to search for quiz by id: $error");
    }
  }

  Future<Quiz> getQuizByName(String name) async {
    try {
      QuerySnapshot querySnapshot = await quizzes.where('name', isEqualTo: name).get();
      if (querySnapshot.size != 1) {
        return null;
      }
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      Quiz quiz = Quiz.fromJson(documentSnapshot.data());
      quiz.id = documentSnapshot.reference.id;
      return quiz;
    } catch (error) {
      throw Exception("Failed to search for quiz by name: $error");
    }
  }

  Future<Quiz> getQuizByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await quizzes.where('user_id', isEqualTo: userId).get();
      if (querySnapshot.size != 1) {
        return null;
      }
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      Quiz quiz = Quiz.fromJson(documentSnapshot.data());
      quiz.id = documentSnapshot.reference.id;
      return quiz;
    } catch (error) {
      throw Exception("Failed to search for quiz by user id: $error");
    }
  }

  Future<List<Quiz>> getQuizzesForUser(User user) async {
    try {
      QuerySnapshot querySnapshot = await quizzes.where('user_id', isNotEqualTo: user.id).get();
      if (querySnapshot.size == 0) {
        return null;
      }
      List<Quiz> quizList = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Quiz quiz = Quiz.fromJson(documentSnapshot.data());
        quiz.id = documentSnapshot.reference.id;
        if (!(await userQuizSolved(user, quiz))) {
          quizList.add(quiz);
        }
      }
      return quizList;
    } catch (error) {
      throw Exception("Failed to search for quizzes for user: $error");
    }
  }

  Future<Quiz> updateQuiz(Quiz quiz) async {
    return await quizzes.doc(quiz.id).update({
      'name': quiz.name,
      'description': quiz.description,
      'survey': quiz.survey,
      'user_id': quiz.userId
    }).then((value) {
      return quiz;
    }).catchError((error) => throw Exception("Failed to update quiz: $error"));
  }

  Future<Question> createQuestion(Question question) async {
    return await questions.add({
      'question': question.question,
      'answer': question.answer,
      'number': question.number,
      'image': question.image,
      'quiz_id': question.quizId
    }).then((value) {
      question.id = value.id;
      return question;
    }).catchError((error) => throw Exception("Failed to add question: $error"));
  }

  Future<Question> getQuestionById(String questionId) async {
    try {
      DocumentSnapshot documentSnapshot = await questions.doc(questionId).get();
      Question question = Question.fromJson(documentSnapshot.data());
      question.id = documentSnapshot.reference.id;
      return question;
    } catch (error) {
      throw Exception("Failed to search for quiz by id: $error");
    }
  }

  Future<List<Question>> getQuestionsForQuiz(Quiz quiz) async {
    try {
      QuerySnapshot querySnapshot = await questions.where('quiz_id', isEqualTo: quiz.id).get();
      if (querySnapshot.size == 0) {
        return null;
      }
      List<Question> questionList = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Question question = Question.fromJson(documentSnapshot.data());
        question.id = documentSnapshot.reference.id;
        questionList.add(question);
      }
      return questionList;
    } catch (error) {
      throw Exception("Failed to search for quiz questions: $error");
    }
  }

  Future<UserQuiz> createUserQuiz(UserQuiz userQuiz) async {
    if (await userQuizExists(userQuiz)) {
      return null;
    }
    return await userQuizzes
        .add({'user_id': userQuiz.userId, 'quiz_id': userQuiz.quizId, 'solved': userQuiz.solved}).then((value) {
      userQuiz.id = value.id;
      return userQuiz;
    }).catchError((error) => throw Exception("Failed to add user_quiz: $error"));
  }

  Future<UserQuiz> updateUserQuizSolved(UserQuiz userQuiz) async {
    return await userQuizzes.doc(userQuiz.id).update({'solved': true}).then((value) {
      userQuiz.solved = true;
      return userQuiz;
    }).catchError((error) => throw Exception("Failed to update user_quiz solved: $error"));
  }

  Future<bool> userQuizExists(UserQuiz userQuiz) async {
    try {
      return await userQuizzes
          .where('user_id', isEqualTo: userQuiz.userId)
          .where('quiz_id', isEqualTo: userQuiz.quizId)
          .get()
          .then((value) => value.size > 0 ? true : false);
    } catch (error) {
      throw Exception("Failed to check if user_quiz exists: $error");
    }
  }

  Future<bool> userQuizSolved(User user, Quiz quiz) async {
    try {
      return await userQuizzes
          .where('user_id', isEqualTo: user.id)
          .where('quiz_id', isEqualTo: quiz.id)
          .where('solved', isEqualTo: true)
          .get()
          .then((value) => value.size > 0 ? true : false);
    } catch (error) {
      throw Exception("Failed to check if user_quiz is solved: $error");
    }
  }

  Future<UserQuestion> createUserQuestion(UserQuestion userQuestion) async {
    if (await userQuestionExists(userQuestion)) {
      return null;
    }
    return await userQuestions.add({
      'user_id': userQuestion.userId,
      'question_id': userQuestion.questionId,
      'correct': userQuestion.correct
    }).then((value) {
      userQuestion.id = value.id;
      return userQuestion;
    }).catchError((error) => throw Exception("Failed to add user_question: $error"));
  }

  Future<bool> userQuestionExists(UserQuestion userQuestion) async {
    try {
      return await userQuestions
          .where('user_id', isEqualTo: userQuestion.userId)
          .where('question_id', isEqualTo: userQuestion.questionId)
          .get()
          .then((value) => value.size > 0 ? true : false);
    } catch (error) {
      throw Exception("Failed to check if user_question exists: $error");
    }
  }

  Future<String> uploadImage(String filePath) async {
    File file = File(filePath);
    String extension = p.extension(filePath);
    String uniqueFilePath = imagesBucketName + '/' + uuid.v1() + extension;
    try {
      await storage.ref(uniqueFilePath).putFile(file);
      return uniqueFilePath;
    } catch (error) {
      throw Exception("Failed to upload image: $error");
    }
  }

  Future<String> uploadJSON(Map<String, dynamic> jsonTask) async {
    String uniqueFilePath = filesBucketName + '/' + uuid.v1() + '.json';
    try {
      SettableMetadata metadata = SettableMetadata(
        contentType: "application/json",
      );
      await storage.ref(uniqueFilePath).putString(json.encode(jsonTask), metadata: metadata);
      return uniqueFilePath;
    } catch (error) {
      throw Exception("Failed to upload JSON: $error");
    }
  }

  Future<String> getDownloadURL(String ref) async {
    try {
      if (ref != null) {
        return await storage.ref(ref).getDownloadURL();
      }
      return null;
    } catch (error) {
      throw Exception("Failed to get download URL: $error");
    }
  }

  Future<String> downloadJSON(String ref) async {
    try {
      return utf8.decode(await storage.ref(ref).getData());
    } catch (error) {
      throw Exception("Failed to download JSON: $error");
    }
  }
}
