import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import STAGE_VALUE_FIELD from '@salesforce/schema/Opportunity.Stage_Value__c';
import cloneOpportunity from '@salesforce/apex/OpportunityCloneController.cloneOpportunity'
import updateApplication from '@salesforce/apex/OpportunityCloneController.updateApplication'

export default class OpportunityClone extends NavigationMixin(LightningElement) {
   @api recordId;
   @track error;
   @track stage_value;
   @track clonedOpportunity;
   errorMessage;

    @wire(getRecord, { recordId: '$recordId', fields: [STAGE_VALUE_FIELD]})
    wireRec({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.stage_value = data.fields.Stage_Value__c.value;
        }
    }

    get today(){
        var d = new Date();
        return d.toISOString();
    }

    get true_boolean(){
        return true;
    }

    get accepeted_or_beyond(){
        // 40 is Accepted:Accepted
        return this.stage_value >= 40;
    }

   handleSubmit(event) {
      console.log('handleSubmit');
      console.log(JSON.stringify(event.detail.fields));
      event.preventDefault();
      cloneOpportunity({ oppId: this.recordId })
         .then(result => {
            console.log(JSON.stringify(result));
            this.clonedOpportunity = result;
            this.error = undefined;
            this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
         })
         .catch(error => {
            console.log(JSON.stringify(error));
            this.error = error;
            this.clonedOpportunity = undefined;
            if (error.body.message) {
               this.errorMessage = error.body.message;
            }
         });
      //event.preventDefault(); 
      //this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
   }
   handleSuccess(event) {
      console.log('handleSuccess');
      console.log('onsuccess: ', event.detail.id);
      updateApplication({ oppId: this.recordId })
         .then(result => {
            console.log(JSON.stringify(result));
         })
         .catch(error => {
            console.log(JSON.stringify(error));
            this.error = error;
            if (error.body.message) {
               this.errorMessage = error.body.message;
            }
         });
      
   }
   handleError(event) {
      console.log('handleError');
      console.log(event.detail);
      this.dispatchEvent(
         new ShowToastEvent({
            title: 'Error creating record',
            message: event.detail.message,
            variant: 'error',
         }),
      );
   }
   handleCloneView(event) {
      console.log('handleCloneView');
      console.log(event.target.value);
      this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
          attributes: {
              recordId: event.target.value,
              objectApiName: 'Opportunity',
              actionName: 'view',
          },
      });
   }
   handleClose() {
      this.dispatchEvent(new CustomEvent('close'));
   }
}