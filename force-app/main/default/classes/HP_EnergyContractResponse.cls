public class HP_EnergyContractResponse {

	public String prestationDistributorId;
	public DateTime prestationDateTime;
	public Boolean isSuccess;

	public HP_EnergyContractResponse(){}
	public HP_EnergyContractResponse(String prestationDistributorId, DateTime prestationDateTime, Boolean isSuccess){
		this.prestationDistributorId = prestationDistributorId;
		this.prestationDateTime = prestationDateTime;
		this.isSuccess = isSuccess;
	}
}