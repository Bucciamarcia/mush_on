import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/edit_kennel/add_dog/main.dart';

class AddDogButtonAction extends AddDogMain {
  const AddDogButtonAction({super.key});

  Future<void> addDogToDb(String name, Map<String, bool> positions) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    var ref = db.collection("data").doc("kennel").collection("dogs");

    var data = {"name": name, "positions": positions};

    await ref.add(
      data,
    );
  }
}

