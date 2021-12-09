import 'package:history_cards_app/controllers/storage.dart';

import 'controllers/authentication.dart';
import 'controllers/survey.dart';
import 'models/User.dart';

User currentUser = User("anzoman", "Anže Luzar", "anze.luzar@gmail.com", "slika", 0, 0);
Authentication authentication;
DataStorage dataStorage;
Survey survey;
List<String> favouriteQuizzes = [];
