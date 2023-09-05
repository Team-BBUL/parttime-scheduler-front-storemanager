import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/mock_repository/mock_schedule_api_repository.dart';
import 'package:sidam_storemanager/data/repository/anniversary_repository.dart';
import 'package:sidam_storemanager/data/repository/cost_policy_repository.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';
import 'package:sidam_storemanager/view/alarm_view.dart';
import 'package:sidam_storemanager/view/chatting_page.dart';
import 'package:sidam_storemanager/view/cost.dart';
import 'package:sidam_storemanager/view/home.dart';
import 'package:sidam_storemanager/view/time_table.dart';
import 'package:sidam_storemanager/view_model/announcement_view_model.dart';
import 'package:sidam_storemanager/view_model/cost_view_model.dart';
import 'package:sidam_storemanager/view_model/store_list_view_model.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

import 'data/repository/announcement_repository.dart';
import 'data/repository/incentive_repository.dart';
import 'data/repository/store_repository.dart';
import 'utils/app_color.dart';
import 'utils/sp_helper.dart';
import 'view/check_login.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => AnnouncementViewModel(AnnouncementRepositoryImpl()),
            ),
            ChangeNotifierProvider(
              create: (_) => StoreManagementViewModel(StoreRepositoryImpl(),
                  UserRepositoryImpl(),AnniversaryRepositoryImpl(), IncentiveRepositoryImpl(), CostPolicyRepositoryImpl()),
            ),
            ChangeNotifierProvider(
              create: (_) => StoreListViewModel(StoreRepositoryImpl(),UserRepositoryImpl()),
            ),
            ChangeNotifierProvider(
                create: (_) => CostViewModel(FixedScheduleApiRepositoryStub(),IncentiveRepositoryImpl()),
            ),
      ],
          child: const MyApp()

      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sidam Worker App',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFF89B3),
        useMaterial3: true,
      ),
      home: CheckLoginScreen(),
    );
  }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SPHelper helper = SPHelper();
  final AppColor color = AppColor();
  int _currentIndex = 0;
  init(){
    helper.init();
  }
  final List<Widget> _children = [HomeScreen(), TimeTableScreen(), CostScreen(), AlarmView()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: color.mainColor,
          type: BottomNavigationBarType.fixed,
          onTap: _onTap,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home, color: Colors.black),
              label: "Home",
              activeIcon: Column(
                children: <Widget>[
                  Icon(Icons.home, color: color.mainColor),
                  Container(
                    height: 4,
                    width: 24,
                    color: color.mainColor,
                  )
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('asset/icons/table_icon.svg'),
              label: "Time Table",
              activeIcon: Column(
                children: <Widget>[
                  SvgPicture.asset('asset/icons/table_icon.svg', color: color.mainColor),
                  Container(
                    height: 4,
                    width: 24,
                    color: color.mainColor,
                  )
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('asset/icons/dollar_sign_icon.svg'),
              label: "Cost",
              activeIcon: Column(
                children: <Widget>[
                  SvgPicture.asset('asset/icons/dollar_sign_icon.svg', color: color.mainColor),
                  Container(
                    height: 4,
                    width: 24,
                    color: color.mainColor,
                  )
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('asset/icons/bell_icon.svg'),
              label: "Alarm",
              activeIcon: Column(
                children: <Widget>[
                  SvgPicture.asset('asset/icons/bell_icon.svg', color: color.mainColor),
                  Container(
                    height: 4,
                    width: 24,
                    color: color.mainColor,
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}