part of 'store_documents_bloc.dart';

// abstract class StoreDocumentsState extends Equatable {
//   const StoreDocumentsState();

//   @override
//   List<Object?> get props => [];
// }

// final class StoreDocumentsInitial extends StoreDocumentsState {}

// class UploadLoading extends StoreDocumentsState {
//   final String field;
//   const UploadLoading({required this.field});
// }

// class UploadSuccess extends StoreDocumentsState {
//   final String downloadUrl;
//   final Map<String, dynamic>? documents;
//   const UploadSuccess(this.downloadUrl, this.documents);

//   @override
//   List<Object?> get props => [downloadUrl];
// }

// class UploadFailure extends StoreDocumentsState {
//   final String error;
//   final String field;
//   const UploadFailure(this.error, this.field);

//   @override
//   List<Object?> get props => [error];
// }

// class SetDocumentLoading extends StoreDocumentsState {}

// class SetDocumentSuccess extends StoreDocumentsState {
//   final String field;
//   final String value;
//   const SetDocumentSuccess(this.field, this.value);

//   @override
//   List<Object?> get props => [field, value];
// }

// class SetDocumentFailure extends StoreDocumentsState {
//   final String error;
//   final String field;
//   const SetDocumentFailure(this.error, this.field);

//   @override
//   List<Object?> get props => [error];
// }

// class GetDocumentLoading extends StoreDocumentsState {}

// class GetDocumentSuccess extends StoreDocumentsState {
//   final Map<String, dynamic>? documents;

//   const GetDocumentSuccess(this.documents);

//   @override
//   List<Object?> get props => [documents];
// }

// class GetDocumentFailure extends StoreDocumentsState {
//   final String error;
//   const GetDocumentFailure(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// class DeleteDocumentLoading extends StoreDocumentsState {}

// class DeleteDocumentSuccess extends StoreDocumentsState {
//   final String message;
//   const DeleteDocumentSuccess(
//     this.message,
//   );

//   @override
//   List<Object?> get props => [
//         message,
//       ];
// }

// class DeleteDocumentFailure extends StoreDocumentsState {
//   final String error;
//   const DeleteDocumentFailure(this.error);

//   @override
//   List<Object?> get props => [error];
// }
class StoreDocumentsState extends Equatable {
  final Map<String, DocumentFieldState> documents;

  const StoreDocumentsState({required this.documents});

  factory StoreDocumentsState.initial() {
    return const StoreDocumentsState(documents: {});
  }

  StoreDocumentsState copyWith({
    Map<String, DocumentFieldState>? documents,
  }) {
    return StoreDocumentsState(
      documents: documents ?? this.documents,
    );
  }

  @override
  List<Object?> get props => [documents];
}
