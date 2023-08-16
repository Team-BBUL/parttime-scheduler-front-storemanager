import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/mock_repository/mock_schedule_api_repository.dart';
import 'package:sidam_storemanager/data/repository/user_repository_mock.dart';
import 'package:sidam_storemanager/view/cost.dart';
import 'package:sidam_storemanager/view_model/cost_view_model.dart';

class CostPage extends StatelessWidget {
  const CostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CostViewModel>(
        create: (_) => CostViewModel(FixedScheduleApiRepositoryStub()),
        child: const CostScreen());
  }
}