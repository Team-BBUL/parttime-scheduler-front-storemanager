import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/main.dart';
import 'package:sidam_storemanager/utils/sp_helper.dart';
import 'package:sidam_storemanager/view/store_register_page.dart';
import 'package:sidam_storemanager/view_model/store_list_view_model.dart';
import '../utils/app_future_builder.dart';


class StoreListScreen extends StatelessWidget{
  SPHelper helper = SPHelper();
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StoreListViewModel>(context,listen: false );
    final builderContext = context;
    return AppFutureBuilder(
        future: viewModel.getMyStoreList(),
        builder: (builder,context){
          return Scaffold(
            appBar: AppBar(
                title: const Text('매장 목록'),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add_box),
                    tooltip: 'Go to the next page',
                    onPressed: () {
                      Navigator.push(builderContext, MaterialPageRoute(
                          builder: (builderContext) {
                            return StoreRegisterPage();
                            // const AnnouncementFramePage(
                            //   announcement: null,
                            // ),
                          }
                      ));
                    },
                  ),
                ]
            ),
            body: viewModel.storeList?.length != 0 ?
            ListView.builder(
              // mainAxisAlignment: MainAxisAlignment.start
                itemCount: viewModel.storeList?.length ?? 0,
                controller: viewModel.scrollController,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: () {
                      viewModel.enterStore(viewModel.storeList![index].id!).catchError((e){
                        print(e);
                      }).then( (value){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context){
                                return const MyHomePage(title: '',);
                              }
                          ), (route) => false);
                      });
                      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      //     builder: (context){
                      //       helper.writeStoreId(viewModel.storeList?[index].id);
                      //       helper.writeStoreName(viewModel.storeList?[index].name);
                      //       return const MyHomePage(title: '',);
                      //     }
                      // ), (route) => false);
                    },
                    child : Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey,width: 1.0,),),
                        // border: Border.all(width: 1, color: Colors.black)
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                viewModel.storeList?[index].name ?? '',
                                style: TextStyle(fontSize: 16)),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("${viewModel.storeList?[index].location}"
                                , style: TextStyle(fontSize: 15, color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                  );
                })
                    : const Center(
                  child: Text('가게가 없습니다.'),
                ),
          );
        });
  }
}