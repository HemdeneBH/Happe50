/**
 * @author Sutharsan Pushparajah
 * @date 11/04/2022
 * @description SM_WS103_NotesDebitsCredits - Implement the NotesDebitsCredits remote service
 */
public inherited sharing class SM_WS103_NotesDebitsCredits {
    
    /* Name of the http request service setting */
    public static final String SERVICE_NAME = 'NOTES_DEBITS_CREDITS';
    /* Root node of the response payload */
    private static final String ROOT_NODE = '_data';
    /* Replace Root node by node of the response payload */
    private static final String REPLACEMENT_NODE = 'x_data';
    /* Size of the response */
    private static final String RESPONSE_SIZE = '30';
    /* NotesDebitsCredits remote service instance */
    private static final ITF004_HttpRequestManager notesDebitsCreditsServiceHttp = new SM_DM202_ApigeeRest(SERVICE_NAME);

    /**
     * @author Sutharsan Pushparajah
     * @date 11/04/2022
     * @description Call NotesDebitsCredits API to get record based on idPortefeuilleContrat
     * @param idPortefeuilleContrat Id of the Contract record to identify the NotesDebitsCredits record
     * @return SM_wrapperNoteDebitCredit response from WS call into a wrapper class
     */
    public static SM_wrapperNoteDebitCredit getNotesDebitsCredits(String idPortefeuilleContrat){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = 'GET';
        httpRequestInfos.queryParameters  = '?idPortefeuilleContrat='+String.escapeSingleQuotes(idPortefeuilleContrat)+'&size='+RESPONSE_SIZE;

        notesDebitsCreditsServiceHttp.sendRequest(httpRequestInfos);

        SM_wrapperNoteDebitCredit wrpdebitcredit = (SM_wrapperNoteDebitCredit) JSON.deserialize(httpRequestInfos.httpResponse.getBody().replace(ROOT_NODE, REPLACEMENT_NODE), SM_wrapperNoteDebitCredit.class);

        return wrpdebitcredit;
    }

}