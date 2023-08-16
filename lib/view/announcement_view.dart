

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_future_builder.dart';
import '../utils/app_toast.dart';
import '../view_model/announcement_view_model.dart';
import 'announcement_frame.dart';
import '../utils/image_hero.dart';
import 'enum/image_type.dart';


class AnnouncementDetailScreen extends StatelessWidget {
  final int index;

  AnnouncementDetailScreen(this.index);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AnnouncementViewModel>(context,listen: false );
    return AppFutureBuilder<void>(
      future: viewModel.getAnnouncement(index),
      builder: (context, snapshot){
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight), // AppBar의 높이 지정
              child: AppBar(
                title: const Text('View Mode'),
                actions:[
                  Builder(builder: (context){
                    return IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          _showSelectDialog(context, viewModel);
                        });
                  },)
                ],
              ),
            ),
            body: Consumer<AnnouncementViewModel>(
                builder:(context, viewModel,child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          flex: 1,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  decoration:  const BoxDecoration(),
                                  child: Text(
                                    viewModel.announcement?.subject ?? '',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(30, 5, 0, 5),
                                  child: Text(
                                      viewModel.announcement?.timeStamp != null
                                          ? '${viewModel.announcement?.timeStamp?.year}년 '
                                          '${viewModel.announcement?.timeStamp?.month}월 '
                                          '${viewModel.announcement?.timeStamp?.day}일 '
                                          '${viewModel.announcement?.koreanWeekday()}요일': '',
                                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                ),
                              ]
                          )
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.grey)
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 7,
                          child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                    viewModel.announcement?.content ?? '',
                                    style: TextStyle(fontSize: 16)),

                              )
                          )
                      ),
                      Flexible(
                          flex: 3,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                              margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                              decoration: BoxDecoration(
                                border: const Border(
                                    top : BorderSide(width: 1, color: Colors.grey)
                                ),
                              ),
                              child: Row(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: viewModel.images?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      if(viewModel.images![index] is File){
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) {
                                                  return ImageHero(image : viewModel.images![index].path, type: ImageType.FILE);
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
                                              child: Image.file(File(viewModel.images![index].path)
                                              ),
                                            ),
                                          ),
                                        );
                                      }else{
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) {
                                                  return ImageHero(image : viewModel.images![index], type: ImageType.MEMORY);
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
                                                viewModel.images![index],
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
                          )

                      ),

                    ],
                  );
                }
            )

        );
      },
    );

  }

  void _showSelectDialog(BuildContext context, AnnouncementViewModel viewModel) async{

    await showDialog(
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (builder){
          return Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 200,
                  height: 150,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey, offset: Offset(4.0, 4.0), blurRadius: 15.0, spreadRadius: 1.0,),
                        BoxShadow(color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0,),
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  viewModel.createEditForm();
                                  return AnnouncementFrameScreen();
                                }
                            ));
                          },
                          child: Text("수정하기",style: TextStyle(fontSize: 20),)
                      ),
                      GestureDetector(
                          onTap: (){
                            _showDeleteDialog(context, viewModel);
                          },
                          child: Text("삭제하기",style: TextStyle(fontSize: 20),)
                      ),
                    ],
                  ),
                ),
              )
          );
        });
  }

  void _showDeleteDialog(BuildContext context, AnnouncementViewModel viewModel) async{
    await showDialog(
        context: context,
        builder: (builder){
          return AlertDialog(
            title: Text("정말 삭제하시겠습니까?"),
            content: Text("삭제된 공지사항은 복구할 수 없습니다."),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("취소")
              ),
              TextButton(
                  onPressed: (){
                    viewModel.deleteAnnouncement(viewModel.announcement!.id!).then((_){
                      AppToast.showToast("삭제 되었습니다");
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }).catchError((onError){
                      AppToast.showToast("삭제 실패");
                      print(onError);
                    });
                  },
                  child: Text("삭제")
              ),
            ],
          );
        });
  }
}
