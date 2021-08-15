import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required String label,
  @required Function validate,
   Function onTap,
  @required IconData prefix,
  @required TextInputType type,
  bool isClickable=true,
})=>TextFormField(
  controller: controller,
    keyboardType: type,
  validator: validate,
  onTap: onTap,
  enabled:isClickable ,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    enabledBorder:OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey
      )
    )
  ),



);

var statusOfDone=false;
Widget tasksBuilder({
  @required List<Map>tasks,
})=>ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context)=>ListView.separated(
      itemBuilder: (context,index)=>buildTaskItem( tasks[index],context),
      separatorBuilder: (context,index)=>Padding(
        padding: const EdgeInsetsDirectional.only(start:20.0,end: 20),
        child: Container(
          width:double.infinity ,
          height: 1,
          color: Colors.grey[400],
        ),
      ),
      itemCount: tasks.length),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment:MainAxisAlignment.center ,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'No tasks yet, Please add some tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        )
      ],
    ),
  ),
);
Widget buildTaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.pink,
          child: Text(
            '${model['time']}',
            style:TextStyle(color: Colors.white) ,),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5,),
              Text(
                '${model['date']}',
                style: TextStyle(
                  fontSize: 15,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.0,),
        (model['status']=='done') ?IconButton(
            icon: Icon(
              Icons.check_box,
              color: Colors.pink,
              size: 30,
            ),
            onPressed: (){
              AppCubit.get(context).updateData(status: 'new', id: model['id']);
            }):IconButton(
            icon: Icon(
              Icons.check_box_outline_blank,
              size: 30,
              color: Colors.pink,
            ),
            onPressed: (){
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
            }),
        (model['status']=='archived') ? IconButton(
            icon: Icon(
              Icons.archive,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: (){
              AppCubit.get(context).updateData(status: 'new', id: model['id']);
  }):IconButton(
            icon: Icon(
              Icons.archive_outlined,
              color: Colors.black45,
              size: 30,
            ),
            onPressed: (){
              AppCubit.get(context).updateData(status: 'archived', id: model['id']);
            }),
      ],
    ),
  ),
  onDismissed: (directions){
    AppCubit.get(context).deleteData(id:model['id']);
  },
);
