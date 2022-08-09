/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-10-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public class HP_EnergyContractResponse {

	public String prestationDistributorId;
	public DateTime prestationDateTime;
	public Boolean isSuccess;
	public String messageError;

	public HP_EnergyContractResponse(){}

	public HP_EnergyContractResponse(String prestationDistributorId, DateTime prestationDateTime, Boolean isSuccess, String messageError){
		this.prestationDistributorId = prestationDistributorId;
		this.prestationDateTime = prestationDateTime;
		this.isSuccess = isSuccess;
		this.messageError = messageError;
	}
}