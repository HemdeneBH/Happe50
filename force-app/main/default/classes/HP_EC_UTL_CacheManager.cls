/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-18-2022
 * @last modified by  : Clément Bauny
**/
public with sharing class HP_EC_UTL_CacheManager {
    static Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.HPClientPortal');

    public static void putCacheData(string key, object valueToCache) {
        System.debug('Caching - put ' + key + ' : ' + JSON.serialize(valueToCache));
        if (!FeatureManagement.checkPermission('HP_ByPassCache')) {
            sessionPart.put(key, valueToCache);
        }
    }

    public static object getCacheData(string key) {
        System.debug('Caching - get ' + key);
        if (sessionPart.contains(key) && !FeatureManagement.checkPermission('HP_ByPassCache')) {
            //System.debug(sessionPart.get(key));
            return sessionPart.get(key);
        }
        else {
            return null;
        }
    }

    public static void invalidateCache(string key) {
        System.debug('Caching - invalidate ' + key);
        if (sessionPart.contains(key) && !FeatureManagement.checkPermission('HP_ByPassCache')) {
            sessionPart.remove(key);
        }
    }

    public static boolean cacheContains(string key) {
        System.debug('Caching - contains ' + key);
        if (sessionPart.contains(key) && !FeatureManagement.checkPermission('HP_ByPassCache')) {
            return true;
        }
        else {
            return false;
        }

    }
}