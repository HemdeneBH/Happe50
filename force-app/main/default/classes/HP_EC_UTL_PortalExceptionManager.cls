/**
 * @description       : Throw dynamically an apex exception for the client portal
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-15-2022
 * @last modified by  : Clément Bauny
**/
public with sharing class HP_EC_UTL_PortalExceptionManager {
    //Enum of Exception types handled by the class
    public  enum ExceptionType {NODATA, CUSTOM}

    public static void throwPortalException(ExceptionType exceptionToThrow, String message) {
        if (exceptionToThrow == ExceptionType.NODATA) {
            throwNoDataException(message);
        }
        else if (exceptionToThrow == ExceptionType.CUSTOM) {
            throwCustomPortalException(message);
        }
    }

    private static void throwNoDataException(String message) {
        HP_EC_UTL_PortalException.NoDataFoundException portalNoDataException = new HP_EC_UTL_PortalException.NoDataFoundException();
        if (String.isNotBlank(message)) {
            portalNoDataException.setMessage(message);
        }
        throw portalNoDataException;
    }

    private static void throwCustomPortalException(String message) {
        HP_EC_UTL_PortalException.CustomException customException = new HP_EC_UTL_PortalException.CustomException();
        if (String.isNotBlank(message)) {
            customException.setMessage(message);
        }
        throw customException;
    }
}