class ApiresponseModel {
  final String status;
  final String message;
  final dynamic errors;
  final dynamic data;

  ApiresponseModel({
    required this.status,
    required this.message,
     this.errors,
     this.data,
  });

  factory ApiresponseModel.fromJson(Map<String,dynamic> json){
    return ApiresponseModel(
      status: json['status'], 
      message: json['message'], 
      errors: json['errors'], 
      data: json['data']
      );
  }
}