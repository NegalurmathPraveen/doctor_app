import 'package:flutter/material.dart';
class FilesPage extends StatefulWidget {
  final List files;
  final onOpenedFile;
  FilesPage({
    required this.files,
    required this.onOpenedFile
});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {


  getColor(ext)
  {
    if(ext=='pdf')
      {
        return Colors.red;
      }
   else if(ext=='jpeg')
     {
       return Colors.blue;
     }
   else
     {
       return Colors.yellow;
     }
  }
  buildFile(var file)
  {
    final kb=file.size/1024;
    final mb=kb/1024;
    final fileSize=mb>=1?'${mb.toStringAsFixed(2)}MB':'${kb.toStringAsFixed(2)}Kb';
    print(fileSize);
    final extension=file.extension??'none';
    print(extension);
    final color=getColor(extension);
    return InkWell(
      onTap: (){
        widget.onOpenedFile(file);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container(
              alignment: Alignment.center,
              width:double.infinity,
              decoration: BoxDecoration(
                color:color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('.$extension',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color:Colors.white),),
            )),
            const SizedBox(height: 8,),
            Text(file.name,
                style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black,overflow: TextOverflow.ellipsis)
            ),
            Text(fileSize,
                style:TextStyle(fontSize: 16,)
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    return Container(
      height: height*0.5,
      child: GridView.builder(
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount:widget.files.length,
          itemBuilder:(context,index){
        final file=widget.files[index];
        return buildFile(file);
      }),
    );
  }
}
