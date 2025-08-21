part of 'store_documents_bloc.dart';

abstract class StoreDocumentsEvent extends Equatable {
  const StoreDocumentsEvent();

  @override
  List<Object> get props => [];
}
class UploadFile extends StoreDocumentsEvent {
  final File file;
  final String folder;
  final String fileName;

  const UploadFile({
    required this.file,
    required this.folder,
    required this.fileName,
  });
}