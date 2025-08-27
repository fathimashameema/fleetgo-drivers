import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetgo_drivers/data/models/documents_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driver_repository/driver_repository.dart';

part 'store_documents_event.dart';
part 'store_documents_state.dart';

class StoreDocumentsBloc
    extends Bloc<StoreDocumentsEvent, StoreDocumentsState> {
  final FirebaseStorageRepository storageRepo;
  final FirestoreRepo firestoreRepository;
  final User? currentUser;

  StoreDocumentsBloc(
      this.storageRepo, this.firestoreRepository, this.currentUser)
      : super(StoreDocumentsState.initial()) {
    on<UploadImage>(_onUploadImage);
    on<UploadData>(_onUploadData);
    on<SetDocument>(_onSetDocument);
    on<GetDocument>(_onGetDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  Future<void> _onUploadImage(
      UploadImage event, Emitter<StoreDocumentsState> emit) async {
    // Set loading state for this field only
    final updated = Map<String, DocumentFieldState>.from(state.documents);
    updated[event.field] =
        const DocumentFieldState(status: DocumentStatus.loading);
    emit(state.copyWith(documents: updated));

    try {
      final liveUser = FirebaseAuth.instance.currentUser;
      if (liveUser == null) {
        throw Exception('No authenticated user');
      }
      final url = await storageRepo.uploadFile(
        file: event.file,
        folderName: '${event.folder}_${liveUser.uid}',
        fileName: event.fileName,
      );

      await firestoreRepository.setDataAndDocuments(
          liveUser.uid, event.field, url);
      await firestoreRepository.setDataAndDocuments(
          liveUser.uid, event.fileField, event.fileName);

      final documents =
          await firestoreRepository.getDataAndDocuments(liveUser.uid);

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

  Future<void> _onUploadData(
      UploadData event, Emitter<StoreDocumentsState> emit) async {
    log("Uploading data field: ${event.field} with value: ${event.value}");

    // Set loading state for this field
    final updated = Map<String, DocumentFieldState>.from(state.documents)
      ..[event.field] =
          const DocumentFieldState(status: DocumentStatus.loading);

    emit(state.copyWith(documents: updated));

    try {
      final liveUser = FirebaseAuth.instance.currentUser;
      if (liveUser == null) {
        throw Exception('No authenticated user');
      }
      await firestoreRepository.setDataAndDocuments(
        liveUser.uid,
        event.field,
        event.value,
      );

      updated[event.field] = DocumentFieldState(
        status: DocumentStatus.success,
        url: event.value,
      );

      log("Successfully uploaded data field: ${event.field}");
      emit(state.copyWith(documents: updated));
    } catch (e) {
      log("Error uploading data field ${event.field}: $e");
      updated[event.field] = DocumentFieldState(
        status: DocumentStatus.failure,
        error: e.toString(),
      );

      emit(state.copyWith(documents: updated));
    }
  }

  Future<void> _onSetDocument(
      SetDocument event, Emitter<StoreDocumentsState> emit) async {
    final liveUser = FirebaseAuth.instance.currentUser;
    if (liveUser == null) return;

    log("Setting document field: ${event.field} with value: ${event.value}");

    // Set loading state for this field
    final updated = Map<String, DocumentFieldState>.from(state.documents);
    updated[event.field] =
        const DocumentFieldState(status: DocumentStatus.loading);
    emit(state.copyWith(documents: updated));

    try {
      if (event.value.toString().isEmpty) {
        // If clearing the field, delete from Firestore and set to initial
        log("Clearing field: ${event.field}");
        await firestoreRepository.deleteDocument(liveUser.uid, event.field);
        updated[event.field] =
            const DocumentFieldState(status: DocumentStatus.initial);
      } else {
        // If setting a value, save to Firestore
        log("Setting field: ${event.field} to value: ${event.value}");
        await firestoreRepository.setDataAndDocuments(
          liveUser.uid,
          event.field,
          event.value,
        );

        updated[event.field] = DocumentFieldState(
          status: DocumentStatus.success,
          url: event.value.toString(),
        );
      }

      log("Updated field ${event.field} status: ${updated[event.field]?.status}");
      emit(state.copyWith(documents: updated));
    } catch (e) {
      log("Error setting document field ${event.field}: $e");
      updated[event.field] = DocumentFieldState(
        status: DocumentStatus.failure,
        error: e.toString(),
      );

      emit(state.copyWith(documents: updated));
    }
  }

  Future<void> _onGetDocument(
      GetDocument event, Emitter<StoreDocumentsState> emit) async {
    final liveUser = FirebaseAuth.instance.currentUser;
    if (liveUser == null) return;

    // Mark everything loading
    final loadingMap = Map<String, DocumentFieldState>.from(state.documents);
    loadingMap.forEach((key, value) {
      loadingMap[key] =
          const DocumentFieldState(status: DocumentStatus.loading);
    });
    emit(state.copyWith(documents: loadingMap));

    try {
      final documentData =
          await firestoreRepository.getDataAndDocuments(liveUser.uid);

      log("Fetched document data: $documentData");

      // Start with all tracked fields as initial
      final newMap = <String, DocumentFieldState>{
        'addressProof': const DocumentFieldState(status: DocumentStatus.initial),
        'licence': const DocumentFieldState(status: DocumentStatus.initial),
        'pvc': const DocumentFieldState(status: DocumentStatus.initial),
        'experience': const DocumentFieldState(status: DocumentStatus.initial),
      };

      if (documentData == null || documentData.isEmpty) {
        emit(state.copyWith(documents: newMap));
        return;
      }

      documentData.forEach((key, value) {
        if (key.endsWith("File")) return; // skip filename keys

        log("Processing field: $key with value: $value");

        if (key == 'experience') {
          if (value != null && value.toString().isNotEmpty) {
            newMap[key] = DocumentFieldState(
              status: DocumentStatus.success,
              url: value.toString(),
            );
          } else {
            newMap[key] =
                const DocumentFieldState(status: DocumentStatus.initial);
          }
        } else if ([
          'addressProof',
          'licence',
          'pvc',
          'rc',
          'insurance',
          'permit'
        ].contains(key)) {
          final fileName = documentData["${key}File"];
          if (value != null &&
              fileName != null &&
              value.toString().isNotEmpty) {
            newMap[key] = DocumentFieldState(
              status: DocumentStatus.success,
              url: value,
              fileName: fileName,
            );
          } else {
            newMap[key] =
                const DocumentFieldState(status: DocumentStatus.initial);
          }
        } else {
          // generic text fields (modelName, seating, baseFare, moreDetails, etc.)
          if (value != null && value.toString().isNotEmpty) {
            newMap[key] = DocumentFieldState(
              status: DocumentStatus.success,
              url: value.toString(),
            );
          } else {
            newMap[key] =
                const DocumentFieldState(status: DocumentStatus.initial);
          }
        }
      });

      emit(state.copyWith(documents: newMap));
    } catch (e) {
      log("Error fetching documents: $e");
      // Fallback to initial on error
      emit(state.copyWith(documents: const {
        'addressProof': DocumentFieldState(status: DocumentStatus.initial),
        'licence': DocumentFieldState(status: DocumentStatus.initial),
        'pvc': DocumentFieldState(status: DocumentStatus.initial),
        'experience': DocumentFieldState(status: DocumentStatus.initial),
      }));
    }
  }

  Future<void> _onDeleteDocument(
      DeleteDocument event, Emitter<StoreDocumentsState> emit) async {
    final liveUser = FirebaseAuth.instance.currentUser;
    if (liveUser == null) return;

    // mark document as deleting
    final updated = Map<String, DocumentFieldState>.from(state.documents);
    updated[event.field] = state.documents[event.field]!.copyWith(
      status: DocumentStatus.deleting,
    );
    emit(state.copyWith(documents: updated));

    try {
      await storageRepo.deleteFile(
        folderName: '${event.folder}_${liveUser.uid}',
        fileName: event.fileName,
      );

      await firestoreRepository.deleteDocument(liveUser.uid, event.field);
      await firestoreRepository.deleteDocument(
          liveUser.uid, event.fileField);

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
