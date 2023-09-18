import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/dialog_message.dart';
import 'package:sidam_storemanager/view/enum/image_type.dart';
import '../view_model/announcement_view_model.dart';
import 'enum/announcement_mode.dart';
import '../utils/image_hero.dart';

class AnnouncementFrameScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
              appBar: AppBar(
                title:
                viewModel.mode == AnnouncementMode.CREATE ?
                const Text('작성하기')
                    : const Text('수정하기'),
                centerTitle: true,
                actions:[
                  viewModel.mode == AnnouncementMode.CREATE ?
                  IconButton(
                      icon: Icon(Icons.check_box),
                      onPressed: () {
                        // viewModel.setMode(AnnouncementMode.VIEW);
                        Message().showConfirmDialog(
                            context: context,
                            title: "저장하시겠습니까?",
                            message: "",
                            apiCall: () => viewModel.createAnnouncement(),
                        popCount: 2);
                      }
                  )
                      :
                  IconButton(
                      icon: Icon(Icons.check_box),
                      onPressed: ()  {
                        Message().showConfirmDialog(
                            context: context,
                            title: "수정하시겠습니까??",
                            message: "",
                            apiCall: () => viewModel.updateAnnouncement(),
                        popCount: 2);
                      }
                  ),
                ],
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom : BorderSide(width: 1, color: Colors.grey)
                                ),
                              ),
                              child:Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                    initialValue: viewModel.newAnnouncement?.subject ?? '',
                                    onChanged: (text) => viewModel.updateSubject(text),
                                  )
                              )
                          )
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                    maxLines: 10,
                                    initialValue: viewModel.newAnnouncement?.content ?? '',
                                    onChanged: (text) => viewModel.updateBody(text),
                                  )
                              )
                          )
                        ],
                      ),
                  ),
                  Flexible(
                    flex: 2,
                      child: Row(
                        children: [
                          Flexible(
                              flex: 8,
                              child: Row(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: viewModel.newImages!.length ?? 0,
                                    itemBuilder: (context, index) {
                                      if(viewModel.newImages![index] is File){
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) {
                                                  return ImageHero(image : viewModel.newImages![index].path, type: ImageType.FILE);
                                                }
                                            ));
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 2),
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Image.file(File(viewModel.newImages![index].path)
                                              ),
                                            ),
                                          ),
                                        );
                                      }else{
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) {
                                                  return ImageHero(image : viewModel.newImages![index], type: ImageType.MEMORY);
                                                }
                                            ));
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 2),
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Image.memory(
                                                viewModel.newImages![index],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  // Container(),
                                ],
                              )
                          ),
                          Flexible(
                            flex: 2,
                            child: IconButton(
                              onPressed: () => viewModel.pickImage(),
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
                  ),
                ],
              )
          );
        }
    );
  }
}