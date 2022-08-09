/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-15-2022
 * @last modified by  : Clément Bauny
**/
@isTest
public with sharing class HP_EC_UTL_PortalExceptionManager_TEST {


    @isTest
    static void throwCustomException() {
        try {
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, Label.HP_EC_InternalError);
        }
        catch (Exception e) {
            System.assertEquals(Label.HP_EC_InternalError, e.getMessage(), 'Invalid message thrown to client for custom exception');
        }
    }

    @isTest
    static void throwNodataException() {
        try {
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.NODATA, Label.HP_EC_NoDataException);
        }
        catch (Exception e) {
            System.assertEquals(Label.HP_EC_NoDataException, e.getMessage(), 'Invalid message thrown to client for nodata exception');
        }
    }
}