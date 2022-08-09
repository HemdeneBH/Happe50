public class SM_BAT08_GenesysDeleteReqSchedule implements Schedulable {
    
    public static void execute(SchedulableContext SC) {
        // Nombre de records qui vont être traiter par le batch SM_BAT08_GenesysDeleteRequest
        Integer batchSizeLimit = Integer.valueOf(System.Label.bat08_SizeLimit);
        // lancement du batch pour faire le traitement des 300 demandes
        SM_BAT08_GenesysDeleteRequest genesysBatch = new SM_BAT08_GenesysDeleteRequest(batchSizeLimit);
        Id batchId = Database.executeBatch(genesysBatch, 99);
    }
}