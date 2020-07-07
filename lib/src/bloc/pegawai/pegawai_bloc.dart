import 'package:apos/src/models/models.dart';
import 'package:apos/src/models/pegawaiModels.dart';
import 'package:apos/src/resources/pegawaiRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apos/src/bloc/bloc.dart';


class PegawaiBloc extends Bloc<PegawaiEvent, PegawaiState> {
  final PegawaiRepository _pegawaiRepository = PegawaiRepository();

  @override
  PegawaiState get initialState => PegawaiInitialized();

  @override
  Stream<PegawaiState> mapEventToState(PegawaiEvent event) async* {
    Pegawai pegawai;
    Menu menu;
    List<Pegawai> listPegawai;
    try{
    if(event is FetchingAllPegawai){
      yield PegawaiLoading();
      listPegawai = await _pegawaiRepository
      .fetchAllPegawaiOutlet("d586b2862d7645e497e41f3b1ae7a932");
      if(listPegawai.length == 0){
        yield PegawaiEmpty();
      } else {
        yield PegawaiLoaded(listPegawai: listPegawai);
      }
    }
    if(event is AddPegawaiButtonPressed) {
      yield PegawaiAddInitialized();
    }
    if(event is AddPegawaiButtonFormPressed){
      yield PegawaiLoading();
      Pegawai pegawai;
      User user;
      String role;

      pegawai = Pegawai(event.id_outlet, event.name_user, event.role.toLowerCase());
      user = User(event.name_user, event.email_user, event.username, event.password_user, event.phone_user, "");

      final response = await _pegawaiRepository.addPegawai(pegawai, user);
        final bool success = response['success'];
        if(success){
          yield PegawaiAddSuccess();
        } else{
          yield PegawaiAddFailed(message: response['message']);
        }
    }
    }catch(e){
      print(e);
      yield PegawaiAddError();
    }
  }

}

