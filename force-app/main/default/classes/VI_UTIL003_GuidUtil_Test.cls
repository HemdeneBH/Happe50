/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_UTIL003_GuidUtil.
*@CreatedDate: 06/11/2020
*@LastModified: 06/11/2020
*/
@isTest
public class VI_UTIL003_GuidUtil_Test {
    @istest
    static void testgetCharAtIndex(){
        VI_UTIL003_GuidUtil.NewGuid();
        VI_UTIL003_GuidUtil.getCharAtIndex('asdfe',2);
    }

}