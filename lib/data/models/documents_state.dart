import 'package:equatable/equatable.dart';

enum DocumentStatus { initial, loading, success, failure, deleting, existing }

class DocumentFieldState extends Equatable {
  final DocumentStatus status;
  final String? url;
  final String? fileName;
  final String? error;

  const DocumentFieldState({
    this.status = DocumentStatus.initial,
    this.url,
    this.fileName,
    this.error,
  });

  DocumentFieldState copyWith({
    DocumentStatus? status,
    String? url,
    String? fileName,
    String? error,
  }) {
    return DocumentFieldState(
      status: status ?? this.status,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, url, fileName, error];
}
