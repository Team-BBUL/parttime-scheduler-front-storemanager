import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/app_future_builder.dart';
import 'package:sidam_storemanager/view/announcement_frame.dart';

import '../view_model/announcement_view_model.dart';
import 'announcement_view.dart';

class AnnouncementListScreen extends StatelessWidget{
  const AnnouncementListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mainContext = context;
    final viewModel = Provider.of<AnnouncementViewModel>(context,listen: false );
    return AppFutureBuilder(
        future: viewModel.getAnnouncementList(10),
        builder: (builder, context){
          return Scaffold(
              appBar: AppBar(
                  title: const Text('공지사항 목록'),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.add_box),
                      tooltip: 'Go to the next page',
                      onPressed: () {
                        viewModel.createNewForm();
                        Navigator.push(mainContext , MaterialPageRoute(
                            builder: (context) {
                              return AnnouncementFrameScreen();
                              // const AnnouncementFramePage(
                              //   announcement: null,
                              // ),
                            }
                        ));
                      },
                    ),
                  ]
              ),
              body: Consumer<AnnouncementViewModel>(
                  builder:(context, viewModel,child) {
                    return ListView.builder(
                      // mainAxisAlignment: MainAxisAlignment.start
                        itemCount: viewModel.announcementList?.length ?? 0,
                        controller: viewModel.scrollController,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context){
                                    int id = viewModel.announcementList?[index].id ?? 0;
                                    return AnnouncementDetailScreen(id);
                                  }
                              ));
                            },
                            child : Container(
                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black12,width: 1.0,),),
                                // border: Border.all(width: 1, color: Colors.black)
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        viewModel.announcementList?[index].subject ?? '',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(viewModel.announcementList?[index].timeStamp != null
                                        ? '${viewModel.announcementList?[index].appendZeroMonth()}/'
                                        '${viewModel.announcementList?[index].appendZeroDay()}'
                                        : '',
                                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                                  )
                                  ,
                                ],
                              ),
                            ),
                          );
                        });
                  }
              )
          );
        });
  }
}
