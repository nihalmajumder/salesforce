/**
 * Created by phg49389 on 2019-04-01.
 */

import { LightningElement, track, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import UDCID from '@salesforce/schema/Contact.UDCID__c';

const FIELDS = [UDCID];

export default class Studentholds extends LightningElement {
    @api recordId;
    @track contact;
    @track error;

    holds = [];
    holdsFetched = false;

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

    get fetchHolds(){
        // This method abuses the fact that VisualForce is built on top of JavaScript, and uses raw JS to send
        // the GET request to WSAPI.
        if( this.contact !== undefined) {
            var endpoint = 'https://wsapi.bethel.edu/salesforce/student-holds/' + getFieldValue(this.contact, UDCID);
            var response = [];
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (this.readyState === 4 && this.status === 200) {
                    response = JSON.parse(this.responseText);
                }
            };

            // ******************** WARNING ********************
            // This sends a SYNCHRONOUS request to WSAPI.
            // That means that this function WILL NOT continue
            // until WSAPI sends a response.
            // **************** SO MUCH WARNING ****************
            xhr.open('GET', endpoint, false);
            xhr.send();

            this.holds = response;
            this.holdsFetched = true;
        }
    }

    get hasHolds() {
        if( this.contact !== undefined && this.holdsFetched === true ) {
            return this.holds.length > 0;
        }
        else {
            return false;
        }
    }

    get studentHolds(){
        if( this.contact !== undefined && this.holdsFetched === true ) {
            return this.holds;
        }
        else {
            return [];
        }
    }
}