/**
 * Created by ejc84332 on 2019-07-31.
 */


import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import updateReferenceResponses from '@salesforce/apex/UpdateReferenceController.updateReferenceResponses';


export default class UpdateReference extends LightningElement {
    @api recordId;
    @track error;
    errorMessage;

    handleSubmit(event) {
        console.log('handleSubmit');
        console.log(JSON.stringify(event.detail.fields));
        event.preventDefault();
        updateReferenceResponses({ referenceId: this.recordId,
                                   firstName: event.detail.fields['First_Name__c'],
                                   lastName: event.detail.fields['Last_Name__c'],
                                   emailAddress: event.detail.fields['Email__c'],
                                   relationship: event.detail.fields['Relationship__c']

            })
            .then(result => {
                console.log('RESULT');
                console.log(JSON.stringify(result));
                // this.clonedOpportunity = result;
                // this.error = undefined;
                // do the default action to update the reference itself
                this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
                this.dispatchEvent(new CustomEvent('close'));
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

    }
    handleError(event) {
        console.log('handleError');
        console.log(event.detail);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: event.detail.message,
                variant: 'error',
            }),
        );
    }
    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}