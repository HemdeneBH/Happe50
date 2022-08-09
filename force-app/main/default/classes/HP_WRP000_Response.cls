public class HP_WRP000_Response {
    public Integer statusCode;
    public List<Error> errors;
 
    public HP_WRP000_Response(){
        this.statusCode = null;
        this.errors = new List<Error>();
    }
 
    public void addError(String err, String code){
        this.errors.add(new Error(err , code));
    }
 
    public class Error {
        private String message {get; set;}
        private String errorCode {get; set;}
 
        public Error(String err, String code) {
            this.message = err;
            this.errorCode = code;
        }
    }
}