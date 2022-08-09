@isTest
public class VI_SM038_MAJMandat_Mock implements WebServiceMock{
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            VI_gdfsuezBefCalypsoMandatV1.majMandatResponse_element response_x = new VI_gdfsuezBefCalypsoMandatV1.majMandatResponse_element();
            VI_gdfsuezBefCalypsoMandatV1.majMandatOutputDt majMandatOutput=new VI_gdfsuezBefCalypsoMandatV1.majMandatOutputDt();
            
            majMandatOutput.idMandat='00S000127334';
            majMandatOutput.ancienIBAN='FR7610468022431011223344451';
            VI_gdfsuezComBefChpPivot.listeValeursDt statutMandatInitial=new VI_gdfsuezComBefChpPivot.listeValeursDt();
            statutMandatInitial.libelleCourt='Annulé';
            statutMandatInitial.code='4';
            VI_gdfsuezComBefChpPivot.listeValeursDt statutMandatFinal=new VI_gdfsuezComBefChpPivot.listeValeursDt();
            statutMandatFinal.libelleCourt='Actif';
            statutMandatFinal.code='1';
            majMandatOutput.statutMandatInitial=statutMandatInitial;
            majMandatOutput.statutMandatFinal=statutMandatFinal;
            
            
            response_x.majMandatOutput=majMandatOutput;
            response.put('response_x', response_x);
        }
}