import 'package:mush_on/create_team/create_team.dart';
import 'package:mush_on/edit_kennel/add_dog/add_dog.dart';
import 'package:mush_on/edit_kennel/edit_kennel.dart';
import 'package:mush_on/main.dart';

var appRoutes = {
  "/": (context) => const HomeScreen(),
  "/editkennel": (context) => const EditKennelScreen(),
  "/adddog": (context) => const AddDogScreen(),
  "/createteam": (context) => const CreateTeamScreen(),
};
