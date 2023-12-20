import 'package:contacts_app/src/contacts/contacts_model/contacts_model.dart';
import 'package:hive/hive.dart';


class ContactsService{

final String _boxName = "contactsBox";

Future<Box<ContactsModel>> get _box async => await Hive.openBox<ContactsModel>(_boxName);


Future<List<ContactsModel>> getAllPersons() async {
  var box = await _box;
  return box.values.toList();
}

Future<void> addPerson(ContactsModel contactsModel)async{
var box = await _box;
await box.add(contactsModel);
}

Future<void> deletePerson(int index) async {
  var box = await _box;
 await box.deleteAt(index);
}

Future<void> updatePerson(int index,ContactsModel contactsModel) async {
  var box = await _box;
  await box.putAt(index, contactsModel);
}




}