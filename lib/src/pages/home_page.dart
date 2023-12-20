

import 'package:contacts_app/src/contacts/contacts_model/contacts_model.dart';
import 'package:contacts_app/src/contacts/contacts_service/contacts_service.dart';
import 'package:contacts_app/src/pages/add_person_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

final ContactsService _service = ContactsService();

final _formKey = GlobalKey<FormState>();


myShowDiolog(int index, ContactsModel? contactsModel){

TextEditingController tfEditPersonName = TextEditingController();
TextEditingController tfEditPersonNumber = TextEditingController();

tfEditPersonName.text = contactsModel?.name ?? '';
tfEditPersonNumber.text = contactsModel?.number ?? '';

return showDialog(context: context, builder: (context){
  return AlertDialog(
    title: Text("Edit Person"),
    content: Form(key: _formKey,
      child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: tfEditPersonName,
            validator: (name)=>name!.isEmpty ? ' Name cannot be empty' : null,
          ),
          TextFormField(
            controller: tfEditPersonNumber,
            inputFormatters:<TextInputFormatter> [
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (number)=> number!.isEmpty ? 'Number cannot be empty' : null,
          ),
        ],
        
      ),
    ),
    actions: [
      ElevatedButton(onPressed: ()async{
        if(_formKey.currentState!.validate()){
         var person = ContactsModel(tfEditPersonName.text, tfEditPersonNumber.text);
         await _service.updatePerson(index, person);
         Navigator.pop(context);
        }
      }, child: Text("Edit",style: TextStyle(color: Colors.white),),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
      ),)
    ],
  );

});

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts App",
      style: TextStyle(fontSize: 20,color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade500,

      body: FutureBuilder(
        future: _service.getAllPersons(), 
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Placeholder();
          }
          else{
              return ValueListenableBuilder(
                valueListenable: Hive.box<ContactsModel>("contactsBox").listenable(), 
              builder: (context,box,child){
              return ListView.builder(
                itemCount: box.values.length,
                itemBuilder:(context,index){
                  var person = box.getAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(height: 100,
                      child: Row(
                        children: [
                          Expanded(flex: 1,
                            child: Text(person!.name,style: TextStyle(fontWeight: FontWeight.bold,),)
                            ),
                          Expanded(flex: 2,
                            child: Text(person.number)),
                          Expanded(flex: 1,
                            child: Row(
                              children: [
                                
                                IconButton(onPressed: (){
                                  _service.deletePerson(index);
                                }, icon: Icon(Icons.delete)),
                            
                                IconButton(onPressed: (){
                                  myShowDiolog(index, person);
                                }, icon: Icon(Icons.edit)),
                            
                              ],
                            ),
                          ),
                        ],
                        
                      ),
                    ),
                  );
                } );
              });
            }
          }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPersonPage()));
          },
          child: Icon(Icons.add,color: Colors.white,),backgroundColor: Colors.black,


        ),
    );
  }
}