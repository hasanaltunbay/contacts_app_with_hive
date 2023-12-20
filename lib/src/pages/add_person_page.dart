import 'package:contacts_app/src/contacts/contacts_model/contacts_model.dart';
import 'package:contacts_app/src/contacts/contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {

  TextEditingController tfPersonName = TextEditingController();
  TextEditingController tfPersonNumber = TextEditingController();

  final ContactsService _service = ContactsService();

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Person",
      style: TextStyle(color: Colors.white),),
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      },icon: Icon(Icons.arrow_back,color: Colors.white,),),
      backgroundColor: Colors.black,
      centerTitle: true,),
      backgroundColor: Colors.grey.shade500,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 100,),
              TextFormField(
                controller: tfPersonName,
                decoration: InputDecoration(
                labelText: "Person Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.red),
                )
                ),
                validator: (name)=>name!.isEmpty ? 'Name cannot be empty' : null,
          
              ),
          
              SizedBox(height: 50,),
          
              TextFormField(
                controller: tfPersonNumber,
                decoration: InputDecoration(
                labelText: "Person Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.red),
                )
                ),
                keyboardType: TextInputType.number,
                validator: (number)=>number!.isEmpty ? 'Number cannot be empty' : null,
                
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                
              ),
          
              SizedBox(height: 50,),
          
              SizedBox(
                height: 50,
                width: 370,
                child: ElevatedButton(onPressed: ()async{
                  if(_formKey.currentState!.validate()){
                    var person = ContactsModel(tfPersonName.text, tfPersonNumber.text);
                
                     await _service.addPerson(person);
                      Navigator.pop(context);
                  
                  }
                 
                }, child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 17),),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.black
                ),),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}