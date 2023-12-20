
import 'package:hive/hive.dart';

part 'contacts_model.g.dart';

@HiveType(typeId: 1)
class ContactsModel{

@HiveField(0)
final String name;

@HiveField(1)
final String number;

ContactsModel(this.name, this.number);


}