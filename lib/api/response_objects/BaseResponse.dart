class BaseResponse{
    bool success;
    String message;

    setSuccess(bool success){
      this.success = success;
    }

    setMessage(String message){
      this.message = message;
    }

    isSuccess(){
      return this.success;
    }

    getMessage(){
      return this.message;
    }
}