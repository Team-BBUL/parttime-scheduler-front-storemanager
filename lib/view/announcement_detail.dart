
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/announcement_view_model.dart';


class AnnouncementDetailScreen extends StatefulWidget {
  const AnnouncementDetailScreen({super.key});

  @override
  _AnnouncementDetailScreenState createState() => _AnnouncementDetailScreenState();
}
class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar의 높이 지정
        child: Consumer<AnnouncementViewModel>(
          builder: (context, viewModel, _) {
            return AppBar(
              title: Text(viewModel.isEditMode ? 'Edit Mode${viewModel.announcement['id']}' : 'View Mode${viewModel.announcement['id']}'),
              actions: [
                if(viewModel.isEditMode)
                  IconButton(
                    icon: Icon(Icons.check_box),
                    onPressed: () => viewModel.toggleEditMode(),
                  )
                else
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => viewModel.toggleEditMode(),
                ),
              ],
            );
          },
        ),
      ),
      body: Consumer<AnnouncementViewModel>(
          builder:(context, viewModel,child){
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: !viewModel.isEditMode ? const BoxDecoration(
                                border: Border(
                                    bottom : BorderSide(width: 1, color: Colors.grey)
                                ),
                              ): const BoxDecoration(),
                              child:Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    if(viewModel.isEditMode)
                                      TextFormField(
                                        initialValue: '${viewModel.announcement['subject']}' ?? '',
                                        onChanged: (text) => viewModel.updateText(text),
                                      )
                                    else
                                      Text(
                                        viewModel.announcement['subject'] ?? '',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                  ],
                                ),
                              )
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    if(viewModel.isEditMode)
                                      TextFormField(
                                        maxLines: 10,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none, // 밑줄 제거
                                        ),
                                        initialValue: '${viewModel.announcement['body']}' ?? '',
                                        onChanged: (text) => viewModel.updateText(text),
                                      )
                                    else
                                      Text(
                                        viewModel.announcement['body'] ?? '',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                  ],
                                ),
                              )
                          )
                      )
                    ],
                  ),
                  Row(

                    children: [

                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: viewModel.imagePaths.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Image.file(
                                File(viewModel.imagePaths[index]),
                                fit: BoxFit.cover,
                              ),
                              title: Text(viewModel.imagePaths[index]),
                            );
                          },
                        ),
                      ),
                      if(viewModel.isEditMode)
                        IconButton(
                          onPressed: () => viewModel.pickImage(),
                          icon: const Icon(Icons.add_a_photo),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(viewModel.announcement['timestamp'] ?? '', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  )
                ],
              )
            );
          }
      ),
    );
  }



}