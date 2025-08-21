part of 'store_documents_bloc.dart';

sealed class StoreDocumentsState extends Equatable {
  const StoreDocumentsState();
  
  @override
  List<Object> get props => [];
}

final class StoreDocumentsInitial extends StoreDocumentsState {}
class UploadLoading extends StoreDocumentsState {}

class UploadSuccess extends StoreDocumentsState {
  final String downloadUrl;
  const UploadSuccess(this.downloadUrl);
}

class UploadFailure extends StoreDocumentsState {
  final String error;
  const UploadFailure(this.error);
}