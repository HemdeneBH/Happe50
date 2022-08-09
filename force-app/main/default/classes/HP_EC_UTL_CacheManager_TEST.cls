/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-15-2022
 * @last modified by  : Clément Bauny
**/
@isTest
public with sharing class HP_EC_UTL_CacheManager_TEST {
    @isTest
    static void cacheController() {
        String valueToCache = 'test';

        HP_EC_UTL_CacheManager.putCacheData('TestRun', valueToCache);

        System.assertEquals(true, HP_EC_UTL_CacheManager.cacheContains('TestRun'), 'Value not found in cache');
        System.assertEquals('test', HP_EC_UTL_CacheManager.getCacheData('TestRun'), 'Incorrect value retrieved from cache');
        System.assertEquals(null, HP_EC_UTL_CacheManager.getCacheData('InvalidKey'),'Value could be retrieved for an invalid key');
        HP_EC_UTL_CacheManager.invalidateCache('TestRun');
        System.assertEquals(false, HP_EC_UTL_CacheManager.cacheContains('TestRun'), 'Value still found in cache');

    }
}