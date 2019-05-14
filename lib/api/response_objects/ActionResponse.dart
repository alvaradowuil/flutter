class ActionResponse{
  final bool success;
  final String message;
  final Object result;

  ActionResponse(this.success, this.message, this.result);

  isSuccess(){
    return this.success;
  }

  getMessage(){
    return this.message;
  }

  getResult(){
    return this.result;
  }
}