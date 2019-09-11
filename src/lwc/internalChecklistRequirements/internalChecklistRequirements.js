/**
 * Created by ejc84332 on 2019-05-07.
 */

import { LightningElement, track, wire, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import ApplicationID from '@salesforce/schema/Opportunity.Application__c';
import getInternalQuestions from '@salesforce/apex/InternalChecklistRequirements.getInternalQuestions';

const FIELDS = [ApplicationID];

const cols = [
    { label: 'Name', fieldName: 'Question_Label__c', type: 'text'},
    { label: 'Value', fieldName: 'ValueText__c', type: 'text' },
    { label: 'Is Complete', fieldName: 'IsComplete__c', type: 'boolean' }
];


export default class InternalChecklistRequirements extends LightningElement {
    @api recordId;
    @track opportunity;
    @track error;
    @track appID;
    @track responses = [];
    @track draftValues = [];

    @track columns = cols;

    @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    wiredOpp({ error, data }) {
        if (data) {
            this.opportunity = data;
            this.error = undefined;

            this.appID = getFieldValue(this.opportunity, ApplicationID);
        }
        else if (error) {
            this.error = error;
            this.opportunity = undefined;
        }
    }

    // This wire will fetch new data for responses whenever appID changes
    @wire(getInternalQuestions, { applicationID: '$appID' })
    qr;
    // updateResponseLinks({ error, data }){
    //     if (data) {
    //         // This turns the raw SOQL results into usable values
    //         var dataCopy = new Array(data.length);
    //         for (var i = 0; i < data.length; i++){
    //             dataCopy[i] = {
    //                 // 'Id': data[i].Id,
    //                 // 'link': '/' + data[i].Id + '/view',
    //                 'Name': data[i].Question__r.Name,
    //                 'Value': data[i].ValueText__c,
    //                 'IsPopulated': data[i].IsPopulated__c
    //
    //                 // Question__r.Name, ValueText__c, IsPopulated__c
    //
    //             };
    //         }
    //         this.responses = dataCopy;
    //         this.responsesFetched = this.responses.length >= 0;
    //     }
    //     else if (error) {
    //         this.responses = [];
    //         this.responsesFetched = true
    //     }
    // }

    handleSave(event) {

    }
}