/**
 * Created by phg49389 on 2019-03-18.
 */

import { LightningElement, track, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import UDCID from '@salesforce/schema/Contact.UDCID__c';

const FIELDS = [UDCID];

export default class EnrollChecklist extends LightningElement {
    @api recordId;
    @track contact;
    @track error;

    @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    wiredOpp({ error, data }) {
        if (data) {
            this.contact = data;
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.contact = undefined;
        }
    }

    renderedCallback(){
        if( this.contact !== undefined) {
            this.template.querySelector('[id^=mybethel-iframe]').innerHTML = '<iframe src="https://my.xp.bethel.edu/public/iframe-checklist/' + getFieldValue(this.contact, UDCID) + '" width="430" height="540"></iframe>';
        }
    }

    // Unless this function gets called in the template somewhere, renderedCallback() won't work for some reason?
    get udc(){
        if( this.contact !== undefined) {
            return getFieldValue(this.contact, UDCID);
        }
        else {
            return this.error;
        }
    }
}