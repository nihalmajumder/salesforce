/**
 * Created by ejc84332 on 2019-02-15.
 */

import {LightningElement, track, wire, api} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

// Import each field so SF will update the code with field renames, prevent field deletions.
import AGREE_AFFIRMATION_FIELD from '@salesforce/schema/Opportunity.Application__r.Agree_To_Affirmation__c';
import AGREE_COVENANT_FIELD from '@salesforce/schema/Opportunity.Application__r.Agree_To_Covenant__c';
import AGREE_COMMUNITY_AGREEMENT_FIELD from '@salesforce/schema/Opportunity.Application__r.Agree_To_Community_Agreement__c';
import PLED_GUILTY_FIELD from '@salesforce/schema/Opportunity.Contact__r.Pled_Guilty__c';
import WARNING_IDENTIFIED_FIELD from '@salesforce/schema/Opportunity.Contact__r.Warning_Identified__c';
import WARNING_REVIEWED_FIELD from '@salesforce/schema/Opportunity.Contact__r.Warning_Reviewed__c';
import CONVICTED_OF_OFFENSE_FIELD from '@salesforce/schema/Opportunity.Application__r.Has_Been_Convicted_Of_Offense__c';

const FIELDS = [
    AGREE_COVENANT_FIELD,
    AGREE_AFFIRMATION_FIELD,
    AGREE_COMMUNITY_AGREEMENT_FIELD,
    PLED_GUILTY_FIELD,
    CONVICTED_OF_OFFENSE_FIELD,
    WARNING_IDENTIFIED_FIELD,
    WARNING_REVIEWED_FIELD
];

export default class OpportunityWarnings extends LightningElement {
    @api recordId;
    @track record;
    @track error;

    // Decorator to get fields and handle results in a function. Load data into 'record' variable.
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredOpp({ error, data }) {
        if (data) {
            this.record = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }

    // Helpers so the template can get values. In this case we only care if they answered no.
    get covenant() {
        if( this.record !== undefined) {
            return getFieldValue(this.record, AGREE_COVENANT_FIELD) === "No";
        }
    }

    get affirmation() {
        if( this.record !== undefined) {
            return getFieldValue(this.record, AGREE_AFFIRMATION_FIELD) === "No";
        }
    }

    get community_agreement() {
        if( this.record !== undefined) {
            return getFieldValue(this.record, AGREE_COMMUNITY_AGREEMENT_FIELD) === "No";
        }
    }

    get pled_guilty() {
        if( this.record !== undefined) {
            return getFieldValue(this.record, PLED_GUILTY_FIELD) === "Yes";
        }
    }

    get convicted() {
        if( this.record !== undefined) {
            return getFieldValue(this.record, CONVICTED_OF_OFFENSE_FIELD) === "Yes";
        }
    }

    get has_warning(){
        return getFieldValue(this.record, WARNING_IDENTIFIED_FIELD) === true || getFieldValue(this.record, PLED_GUILTY_FIELD) === "Yes";
    }

    get warning_message() {
        if( this.record !== undefined) {

            if (getFieldValue(this.record, WARNING_IDENTIFIED_FIELD) === true || getFieldValue(this.record, PLED_GUILTY_FIELD) === "Yes"){

                if(getFieldValue(this.record, WARNING_REVIEWED_FIELD) !== true){
                    return "Warning on contact needs to be reviewed before this student can be accepted."
                }else if(getFieldValue(this.record, WARNING_REVIEWED_FIELD) === true){
                    return "Previous warning on this contact has been reviewed. If this is a new app, please review again before moving forward.";
                }

            }

        }
    }
}