class ApiResponse<T> {
  final String msg;
  final Map<String, dynamic>? errors;
  final T? body;
  final bool status;

  ApiResponse(this.status, this.body, this.msg, {this.errors});
}
