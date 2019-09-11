/**
 * Created by phg49389 on 2019-04-16.
 */

import { LightningElement, track, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import ApplicationID from '@salesforce/schema/Opportunity.Application__c';
import getReferences from '@salesforce/apex/OpportunityReferences.getReferences';

const FIELDS = [ApplicationID];

export default class OpportunityReferences extends LightningElement {
    @api recordId;
    @track opportunity;
    @track error;
    @track appID = '';
    @track references = [];
    @api referencesFetched = false;

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

    // This wire will fetch new data for references whenever appID changes
    @wire(getReferences, { applicationID: '$appID' })
    updateReferenceLinks({ error, data }){
        if (data) {
            // This turns the raw SOQL results into usable values
            var dataCopy = new Array(data.length);
            for (var i = 0; i < data.length; i++){
                dataCopy[i] = {
                    'Id': data[i].Id,
                    'link': '/lightning/r/Reference__c/' + data[i].Id + '/view',
                    'type': data[i].Type__c + ' Reference',
                    'name': data[i].First_Name__c + ' ' + data[i].Last_Name__c
                };
            }
            this.references = dataCopy;
            this.referencesFetched = this.references.length > 0;
        }
        else if (error) {
            this.references = [];
            this.referencesFetched = false;
        }
    }
}