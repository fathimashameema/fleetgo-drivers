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
  final String field;
  final String fileField;

  const UploadFile(
      {required this.file,
      required this.folder,
      required this.fileName,
      required this.field,
      required this.fileField});
}

class SetDocument extends StoreDocumentsEvent {
  final dynamic value;
  final String field;

  const SetDocument({
    required this.field,
    required this.value,
  });
}

class GetDocument extends StoreDocumentsEvent {
  const GetDocument();
}

class DeleteDocument extends StoreDocumentsEvent {
  final String field;
  final String folder;
  final String fileName;
  final String fileField;
  const DeleteDocument({
    required this.field,
    required this.folder,
    required this.fileName,
    required this.fileField,
  });
}
