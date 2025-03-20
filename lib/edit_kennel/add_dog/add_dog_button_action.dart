import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/edit_kennel/add_dog/main.dart';
import 'package:mush_on/services/firestore.dart';

class AddDogButtonAction extends AddDogMain {
  const AddDogButtonAction({super.key});

  Future<void> addDogToDb(String name, Map<String, bool> positions) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String account = await FirestoreService().getUserAccount() ?? "";
    String path = "accounts/$account/data/kennel/dogs";
    var ref = db.collection(path);

    var data = {"name": name, "positions": positions};

    await ref.add(
      data,
    );
  }
}
