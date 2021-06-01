class ResponseVO{
 dynamic data;
 MsgState message;
 ErrorState error;

 ResponseVO({this.data, this.message, this.error});
}

enum MsgState{
  data,
  loading,
  error,
  success
}

enum ErrorState{
  tooMany,
  serverError,
  internetError,

}