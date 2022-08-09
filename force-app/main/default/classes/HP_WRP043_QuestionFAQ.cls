/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 08-18-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
global class HP_WRP043_QuestionFAQ {
    
    global class Request {
		public final List<QuestionFaqApi> questionFaqApiList;

		global Request(List<QuestionFaqApi> questionFaqApiList){
			this.questionFaqApiList = questionFaqApiList;
		}
	}

	global class QuestionFaqApi {
        public final Long digitalId;
        public final Integer votesPositifs;
        public final Integer votesNegatifs;
		public final String titre;
		public final String categorie;
		public final String sousCategorie;
		public final String path;

		global QuestionFaqApi(Long digitalId,Integer votesPositifs,Integer votesNegatifs,
					String titre,String categorie,String sousCategorie,String path) {
			this.digitalId = digitalId;
			this.votesPositifs = votesPositifs;
			this.votesNegatifs = votesNegatifs;
			this.titre = titre;
			this.categorie = categorie;
			this.sousCategorie = sousCategorie;
			this.path = path;		
			}
	}

}