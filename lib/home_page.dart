import 'package:flutter/material.dart';
import 'package:sql_database/database/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///controllers
  TextEditingController titleController=TextEditingController();
  TextEditingController descController=TextEditingController();

  List<Map<String,dynamic>> allNotes=[];
  DBhelper? dbref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbref=DBhelper.getinstance;
    getNotes();
  }
  void getNotes()async{
    allNotes=await dbref!.getAllNotes();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: allNotes.isNotEmpty?ListView.builder(
          itemCount: allNotes.length,
          itemBuilder: (_,index){
            return ListTile(
              leading: Text('${allNotes[index][DBhelper.COLUMN_NAME_SNO]}'),
                title:Text(allNotes[index][DBhelper.COLUMN_NAME_TITLE]),
              subtitle: Text(allNotes[index][DBhelper.COLUMN_NAME_DESC]),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    InkWell(onTap:(){
                      showModalBottomSheet(context: context, builder:(context){
                        titleController.text=allNotes[index][DBhelper.COLUMN_NAME_TITLE];
                        descController.text=allNotes[index][DBhelper.COLUMN_NAME_DESC];
                        int sno=0;
                      return Container(
                        padding: EdgeInsets.all(11),
                        width:double.infinity,
                        child: Column(
                          children: [
                            Text('Update Note', style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),),
                            SizedBox(height: 20,),
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: "Enter Title Here",
                                label: Text('Title*'),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                            ),
                            SizedBox(height: 11,),
                            TextField(
                              controller: descController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                  hintText: "Enter Description Here",
                                  label:Text('Update Description*'),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  )
                              ),
                            ),
                            SizedBox(height: 11,),
                            Row(
                              children: [
                                Expanded(child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(shape:
                                    RoundedRectangleBorder(
                                        side: BorderSide(
                                          width:1,
                                        ))),
                                    onPressed: ()async{
                                      var title=titleController.text;
                                      var desc=descController.text;
                                      if(title.isNotEmpty && desc.isNotEmpty){
                                        bool check=await dbref!.updateNote(mtitle: title, mdesc: desc, sno:sno );
                                        if(check){
                                          getNotes();
                                        }
                                      } else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the required blanks')));
                                      }
                                      titleController.clear();
                                      descController.clear();
                                      Navigator.pop(context);

                                    }, child: Text('Update Note'))),
                                SizedBox(height: 11,),
                                Expanded(child: OutlinedButton(
                                    style:OutlinedButton.styleFrom(shape: RoundedRectangleBorder(side: BorderSide(width: 1,))),
                                    onPressed: (){Navigator.pop(context);}, child: Text('Cancel'))),

                              ],
                            ),
                          ],
                        ),
                      );
                      });

                       },child: Icon(Icons.edit)),
                    InkWell(onTap:() async{
                         //bool check = await dbref!.deleteNote( mtitle: 'title', mdesc: 'desc', sno: sno);
                       }

                : Icon(Icons.delete,color: Colors
                    }.red,))
                  ],
                ),
              ),
            );

      }):Center(
        child: Text("No notes yet!!"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          String errormsg="";
          //notes to be addes from here
          showModalBottomSheet(context: context, builder: (context)
          {
            titleController.clear();
            descController.clear();
            return Container(
              padding: EdgeInsets.all(11),
              width:double.infinity,
              child: Column(
                children: [
                  Text('Add Note', style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Enter Title Here",
                      label: Text('Title*'),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                  SizedBox(height: 11,),
                  TextField(
                    controller: descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                        hintText: "Enter Description Here",
                        label:Text('Description*'),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        )
                    ),
                  ),
                  SizedBox(height: 11,),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(
                          style: OutlinedButton.styleFrom(shape:
                          RoundedRectangleBorder(
                              side: BorderSide(
                                width:1,
                              ))),
                          onPressed: ()async{
                            var title=titleController.text;
                            var desc=descController.text;
                            if(title.isNotEmpty && desc.isNotEmpty){
                              bool check=await dbref!.addNote(mtitle: title, mdesc: desc);
                              if(check){
                                getNotes();
                              }
                            } else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the required blanks')));
                            }
                            titleController.clear();
                            descController.clear();
                            Navigator.pop(context);

                          }, child: Text('Add Note'))),
                      SizedBox(height: 11,),
                      Expanded(child: OutlinedButton(
                          style:OutlinedButton.styleFrom(shape: RoundedRectangleBorder(side: BorderSide(width: 1,))),
                          onPressed: (){Navigator.pop(context);}, child: Text('Cancel'))),
                      Text('$errormsg'),
                    ],
                  ),
                ],
              ),
            );
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}