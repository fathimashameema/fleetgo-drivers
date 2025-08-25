import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetgo_drivers/data/models/documents_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driver_repository/driver_repository.dart';

part 'store_documents_event.dart';
part 'store_documents_state.dart';

// class StoreDocumentsBloc
//     extends Bloc<StoreDocumentsEvent, StoreDocumentsState> {
//   final FirebaseStorageRepository storageRepo;
//   final FirestoreRepo firestoreRepository;
//   final User? currentUser;
//   StoreDocumentsBloc(
//       this.storageRepo, this.firestoreRepository, this.currentUser)
//       : super(StoreDocumentsInitial()) {
//     on<UploadFile>(_onUploadFile);
//     on<GetDocument>(_onGetDocument);
//     on<DeleteDocument>(_onDeleteDocument);
//   }

//   Future<void> _onUploadFile(
//       UploadFile event, Emitter<StoreDocumentsState> emit) async {
//     emit(UploadLoading(field: event.field));
//     try {
//       final url = await storageRepo.uploadFile(
//         file: event.file,
//         folderName: '${event.folder}_${currentUser!.uid}',
//         fileName: event.fileName,
//       );

//       await firestoreRepository.setDataAndDocuments(
//         currentUser!.uid,
//         event.field,
//         url,
//       );
//       await firestoreRepository.setDataAndDocuments(
//         currentUser!.uid,
//         event.fileField,
//         event.fileName,
//       );
//       final documents = await firestoreRepository.getDataAndDocuments(
//         currentUser!.uid,
//       );

//       emit(SetDocumentSuccess(event.field, url));
//       emit(UploadSuccess(url, documents));
//     } catch (e) {
//       log(e.toString());
//       emit(UploadFailure(e.toString(), event.field));
//     }
//   }

//   Future<void> _onGetDocument(
//       GetDocument event, Emitter<StoreDocumentsState> emit) async {
//     emit(GetDocumentLoading());
//     try {
//       if (currentUser != null) {
//         final documentData = await firestoreRepository.getDataAndDocuments(
//           currentUser!.uid,
//         );

//         emit(GetDocumentSuccess(documentData));
//       } else {
//         log('current user is not getting');
//       }
//     } catch (e) {
//       log('error getting the document${e.toString()}');
//       emit(GetDocumentFailure(e.toString()));
//     }
//   }

//   Future<void> _onDeleteDocument(
//       DeleteDocument event, Emitter<StoreDocumentsState> emit) async {
//     emit(DeleteDocumentLoading());
//     try {
//       if (currentUser != null) {
//         await storageRepo.deleteFile(
//             folderName: '${event.folder}_${currentUser!.uid}',
//             fileName: event.fileName);
//         log('deleted document from storage');

//         await firestoreRepository.deleteDocument(
//           currentUser!.uid,
//           event.field,
//         );
//         await firestoreRepository.deleteDocument(
//           currentUser!.uid,
//           event.fileField,
//         );
//         log('deleted file field and document from firestore');

//         emit(DeleteDocumentSuccess('deleted ${event.field}'));
//       } else {
//         log('current user is not getting');
//       }
//     } catch (e) {
//       log(e.toString());
//       emit(DeleteDocumentFailure(e.toString()));
//     }
//   }
// }
class StoreDocumentsBloc
    extends Bloc<StoreDocumentsEvent, StoreDocumentsState> {
  final FirebaseStorageRepository storageRepo;
  final FirestoreRepo firestoreRepository;
  final User? currentUser;

  StoreDocumentsBloc(
      this.storageRepo, this.firestoreRepository, this.currentUser)
      : super(StoreDocumentsState.initial()) {
    on<UploadFile>(_onUploadFile);
    on<GetDocument>(_onGetDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  Future<void> _onUploadFile(
      UploadFile event, Emitter<StoreDocumentsState> emit) async {
    // Set loading state for this field only
    final updated = Map<String, DocumentFieldState>.from(state.documents);
    updated[event.field] =
        const DocumentFieldState(status: DocumentStatus.loading);
    emit(state.copyWith(documents: updated));

    try {
      final url = await storageRepo.uploadFile(
        file: event.file,
        folderName: '${event.folder}_${currentUser!.uid}',
        fileName: event.fileName,
      );

      await firestoreRepository.setDataAndDocuments(
          currentUser!.uid, event.field, url);
      await firestoreRepository.setDataAndDocuments(
          currentUser!.uid, event.fileField, event.fileName);

      final documents =
          await firestoreRepository.getDataAndDocuments(currentUser!.uid);

      final newMap = Map<String, DocumentFieldState>.from(updated);
      newMap[event.field] = DocumentFieldState(
        status: DocumentStatus.success,
        url: url,
        fileName: event.fileName,
      );

      emit(state.copyWith(documents: newMap));
    } catch (e) {
      final newMap = Map<String, DocumentFieldState>.from(updated);
      newMap[event.field] = DocumentFieldState(
        status: DocumentStatus.failure,
        error: e.toString(),
      );
      emit(state.copyWith(documents: newMap));
    }
  }

  Future<void> _onGetDocument(
      GetDocument event, Emitter<StoreDocumentsState> emit) async {
    if (currentUser == null) return;
    try {
      final documentData =
          await firestoreRepository.getDataAndDocuments(currentUser!.uid);

      final newMap = <String, DocumentFieldState>{};
      documentData?.forEach((key, value) {
        if (key.endsWith("File")) return;
        newMap[key] = DocumentFieldState(
          status: DocumentStatus.success,
          url: value,
          fileName: documentData["${key}File"],
        );
      });

      emit(state.copyWith(documents: newMap));
    } catch (e) {
      log("Error fetching documents: $e");
    }
  }

  Future<void> _onDeleteDocument(
      DeleteDocument event, Emitter<StoreDocumentsState> emit) async {
    if (currentUser == null) return;

    // mark document as deleting
    final updated = Map<String, DocumentFieldState>.from(state.documents);
    updated[event.field] = state.documents[event.field]!.copyWith(
      status: DocumentStatus.deleting,
    );
    emit(state.copyWith(documents: updated));

    try {
      await storageRepo.deleteFile(
        folderName: '${event.folder}_${currentUser!.uid}',
        fileName: event.fileName,
      );

      await firestoreRepository.deleteDocument(currentUser!.uid, event.field);
      await firestoreRepository.deleteDocument(
          currentUser!.uid, event.fileField);

      final refreshed = Map<String, DocumentFieldState>.from(state.documents);
      refreshed[event.field] =
          const DocumentFieldState(status: DocumentStatus.initial);

      emit(state.copyWith(documents: refreshed));
    } catch (e) {
      final refreshed = Map<String, DocumentFieldState>.from(state.documents);
      refreshed[event.field] = DocumentFieldState(
        status: DocumentStatus.failure,
        error: e.toString(),
      );

      emit(state.copyWith(documents: refreshed));
    }
  }
}
