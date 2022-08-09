import { LightningElement, track, api } from 'lwc';
import template from "./sm_LWC_createContact_questConsent.html";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
export default class Sm_LWC_createContact_questConsent extends OmniscriptBaseMixin(LightningElement) {
    @track 
    questionsConsentements = [];
    omniJsonDataCopy;
    firstLoad = true;
    resultIP;
    get optionsRadio() {
        return [
            { label: 'Oui', value: 'true'},
            { label: 'Non', value: 'false' },
        ];
    }
    @api
    checkValidity() {
        let isValid = true;
        this.questionsConsentements.forEach(qc => {
            isValid = isValid && qc.consent !== "" && qc.consent !== null;
        });
        return isValid;
    }
    handleChangeConsentements(event) {
        this.questionsConsentements.filter(item => item.key === event.target.name)[0].consent = event.detail.value;
        this.setConsentementAnswersInJsonOmni();
    }
    setConsentementAnswersInJsonOmni() {
        let newListConsentement = JSON.parse(JSON.stringify(this.questionsConsentements));
        for(let consentement of newListConsentement) {
            delete consentement.key;
        }
        console.log(newListConsentement);
        console.log(this.questionsConsentements);

        let finalListConsentement = [];

        newListConsentement.forEach(lc => {
            if (lc.consent != null){
                finalListConsentement.push(lc);
            }
        });

        if (finalListConsentement){
            this.omniApplyCallResp({ 
                "ContactInfo": {
                    "answerModified" : finalListConsentement
                }
            });
            this.omniValidate(!this.firstLoad);
        }
    }
    @api
    set omniJsonData(omniJsonParam) {
        this.omniJsonDataCopy = omniJsonParam;
        if (this.omniJsonDataCopy && this.omniJsonDataCopy.labelsquestion && this.omniJsonDataCopy.questions && this.firstLoad) {
            this.createModelQuestions();
            this.setConsentementAnswersInJsonOmni();
            this.firstLoad = false;
        }
    }
    get omniJsonData() {
        return this.omniJsonDataCopy;
    }
    createModelQuestions() {

        let foundAnswer, consent;

        var questions = this.omniJsonDataCopy.questions;
        var labelQuestionsCons = this.omniJsonDataCopy.labelsquestion;
        var answerModified = this.omniJsonDataCopy.ContactInfo.answerModified;
        var labelQ = '';


        for(var i=0;i < questions.length; i++){
            for(var j=0;j<labelQuestionsCons.length;j++){
                if(labelQuestionsCons[j].codeQuestion == questions[i].codeQuestionnaireQuestion){
                    labelQ = labelQuestionsCons[j].libelleQuestion;

                    foundAnswer = (typeof answerModified === "undefined") ? "" : answerModified.find( x => x.idQuestionnaire == questions[i].idQuestionnaire && x.idQuestion == questions[i].idQuestion);
                    consent = foundAnswer ? foundAnswer.consent : "";
                    let consentementItem = {
                        questionLabel: labelQ,
                        idQuestionnaire: questions[i].idQuestionnaire,
                        idQuestion: questions[i].idQuestion,
                        key: questions[i].idQuestionnaire + "_" + questions[i].idQuestion,

                        consent: questions[i].consent

                    };
                    this.questionsConsentements.push(consentementItem);
                }
            }
        }             
    }
}