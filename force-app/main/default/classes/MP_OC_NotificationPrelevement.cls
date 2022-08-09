/*********************************************************************************************************
* @projet: Mypower
* @date: 2020-01-14
* @description: POJO 
********************************************************************************************************/
public with sharing class MP_OC_NotificationPrelevement {
    public String idTiers { get; set; }
    public String firstname { get; set; }
    public String lastname { get; set; }
    public Decimal montant { get; set; }
    public String datePrelevement { get; set; }
    public String iban { get; set; }
    public String rum { get; set; }
    public String startDate { get; set; }
    public String endDate { get; set; }
}