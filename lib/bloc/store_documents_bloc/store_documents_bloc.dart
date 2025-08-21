

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driver_repository/driver_repository.dart';

part 'store_documents_event.dart';
part 'store_documents_state.dart';

class StoreDocumentsBloc
    extends Bloc<StoreDocumentsEvent, StoreDocumentsState> {
  final FirebaseStorageRepository storageRepo;

  StoreDocumentsBloc(this.storageRepo) : super(StoreDocumentsInitial()) {
    on<UploadFile>(_onUploadFile);
  }

  Future<void> _onUploadFile(
      UploadFile event, Emitter<StoreDocumentsState> emit) async {
    emit(UploadLoading());
    try {
      final url = await storageRepo.uploadFile(
        file: event.file,
        folderName: event.folder,
        fileName: event.fileName,
      );
      emit(UploadSuccess(url));
    } catch (e) {
      emit(UploadFailure(e.toString()));
    }
  }

  
}
