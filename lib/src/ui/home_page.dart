import 'package:apos/src/bloc/bloc.dart';
import 'package:apos/src/ui/kelola_menu.dart';
import 'package:apos/src/ui/KelolaOutlet/kelola_outlet.dart';
import 'package:apos/src/ui/kelola_pegawai.dart';
import 'package:apos/src/ui/side_bar.dart';
import 'package:apos/src/ui/Transaksi/transaksi_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabController controller;
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(HomeTransactionPageLoad());

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc,HomeState>(
      builder: (context, state){
        if(state is HomeTransactionPage){
          return TransaksiMenuPage();
        }if(state is HomeOutletPage){
          return KelolaOutletPage();
        }
        if(state is HomeMenuPage){
          return KelolaMenu();
        }
        if(state is HomeEmployeePage){
          return KelolaPegawaiPage();
        }
        return Container(
            color: Colors.white);
      }
    );
  }
}



