import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxpakistan/widgets/custom_widgets.dart';

import 'doctor_model_file.dart';

class AllDrugsScreen extends StatefulWidget {
  const AllDrugsScreen({Key? key,required this.drgs}) : super(key: key);

  final List<Drugs> drgs;
  @override
  _AllDrugsScreenState createState() => _AllDrugsScreenState();
}

class _AllDrugsScreenState extends State<AllDrugsScreen> {
  

  void doNothing(BuildContext Context)
  {

  }
  
  @override
  Widget build(BuildContext context) {


    var con=ScrollController();
    if(!widget.drgs.isEmpty)
      {
        
        List<Drugs> data=widget.drgs;
        return Scaffold(
          appBar: Mywidgets.getAppBar("Drugs List"),
          body: Container(
            child: ListView.builder(

              itemCount: data.length,
                itemBuilder: (context,index)
                {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Slidable(
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    //dismissible: DismissiblePane(onDismissed: () {}),

                    key: const ValueKey(0),

                    // All actions are defined in the children parameter.
                    children:  [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        spacing: 1,
                        onPressed: (context){
                         data.remove(data[index]);

                         setState(() {

                         });
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),

                    ],
                  ),

                  // The end action pane is the one at the right or the bottom side.
                  endActionPane:  ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        spacing: 1,
                        onPressed: (context){
                          data.remove(data[index]);
                          Navigator.pop(context);
                        },
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),

                    ],
                  ),
                  child: Material(
                    elevation: 5,
                    shadowColor: Colors.indigo,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.pills,size: 30,),
                      title: Text("${data[index].name} ${data[index].comapny }"),
                      subtitle: Text("${data[index].type} ${data[index].method }"),
                      trailing: Text("${data[index].note}"),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }
    else
      {
        return Scaffold(
          appBar: AppBar(title: Text("NO Drugs Added"),centerTitle: true,),
          body: Center(
            child: Container(
              child: Mywidgets.getLottie(path: "assets/animations/pharmacist.json"),
            ),
          ),
        );
      }
    
    
    
  }
}
