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

  Future<void> _onUploadData(
      UploadData event, Emitter<StoreDocumentsState> emit) async {
    log("Uploading data field: ${event.field} with value: ${event.value}");
    
    // Set loading state for this field
    final updated = Map<String, DocumentFieldState>.from(state.documents)
      ..[event.field] =
          const DocumentFieldState(status: DocumentStatus.loading);

    emit(state.copyWith(documents: updated));

    try {
      await firestoreRepository.setDataAndDocuments(
        currentUser!.uid,
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
    if (currentUser == null) return;

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
        await firestoreRepository.deleteDocument(currentUser!.uid, event.field);
        updated[event.field] = const DocumentFieldState(status: DocumentStatus.initial);
      } else {
        // If setting a value, save to Firestore
        log("Setting field: ${event.field} to value: ${event.value}");
        await firestoreRepository.setDataAndDocuments(
          currentUser!.uid,
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
    if (currentUser == null) return;
    
    // Set loading state immediately for all fields to show loading indicators
    final loadingMap = Map<String, DocumentFieldState>.from(state.documents);
    loadingMap.forEach((key, value) {
      loadingMap[key] = const DocumentFieldState(status: DocumentStatus.loading);
    });
    emit(state.copyWith(documents: loadingMap));
    
    try {
      final documentData =
          await firestoreRepository.getDataAndDocuments(currentUser!.uid);

      log("Fetched document data: $documentData");

      final newMap = Map<String, DocumentFieldState>.from(state.documents);

      documentData?.forEach((key, value) {
        // Skip file name fields
        if (key.endsWith("File")) return;
        
        log("Processing field: $key with value: $value");
        
        // Handle different field types
        if (key == 'experience') {
          // For experience field, just mark as success if value exists
          if (value != null && value.toString().isNotEmpty) {
            newMap[key] = DocumentFieldState(
              status: DocumentStatus.success,
              url: value.toString(),
            );
            log("Set experience field to success with value: ${value.toString()}");
          } else {
            newMap[key] = const DocumentFieldState(status: DocumentStatus.initial);
          }
        } else if (key == 'addressProof' || key == 'licence' || key == 'pvc') {
          // For file fields, check if both URL and fileName exist
          final fileName = documentData["${key}File"];
          if (value != null && fileName != null && value.toString().isNotEmpty) {
            newMap[key] = DocumentFieldState(
              status: DocumentStatus.success,
              url: value,
              fileName: fileName,
            );
            log("Set $key field to success with URL: $value and fileName: $fileName");
          } else {
            newMap[key] = const DocumentFieldState(status: DocumentStatus.initial);
          }
        }
      });

      log("Final newMap: $newMap");
      emit(state.copyWith(documents: newMap));
    } catch (e) {
      log("Error fetching documents: $e");
      // On error, set all fields back to initial state
      final errorMap = Map<String, DocumentFieldState>.from(state.documents);
      errorMap.forEach((key, value) {
        errorMap[key] = const DocumentFieldState(status: DocumentStatus.initial);
      });
      emit(state.copyWith(documents: errorMap));
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
