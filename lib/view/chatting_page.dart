import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/mock_repository/mock_user_repository.dart';
import 'package:sidam_storemanager/view/chatting.dart';
import 'package:sidam_storemanager/view_model/chatting_view_model.dart';

class ChattingPage extends StatelessWidget {
  const ChattingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChattingViewModel>(
        create: (_) => ChattingViewModel(FixedUserRepositoryStub()),
        child: const ChattingScreen());
  }
}