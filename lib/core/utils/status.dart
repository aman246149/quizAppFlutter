sealed class OperationState<T> {
  const OperationState();
}

final class OperationInitial<T> extends OperationState<T> {
  const OperationInitial();
}

final class OperationLoading<T> extends OperationState<T> {
  const OperationLoading();
}

final class OperationSuccess<T> extends OperationState<T> {
  final T data;
  const OperationSuccess(this.data);
}

final class OperationError<T> extends OperationState<T> {
  final String message;
  final Object? error;
  const OperationError({required this.message, this.error});
}
