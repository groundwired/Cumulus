public with sharing class SummaryProfileView {

    public Id sobjId {get; private set;}

    private sObject sobj;
    private String q;

    public Contact con {get; private set;}
    public Account acct {get; private set;}

    public list<npe5__Affiliation__c> affiliations {get; private set;}
    public list<npe4__Relationship__c> relationships {get; private set;}
    public list<ActivityHistory> activities {get; private set;}

    public Summary_Profile__c settings {get; private set;}
    public list<String> customFields {get; private set;}

    private static final map<String, list<String>> standardFields = 
        new map<String, list<String>> {
            'Account' => new list<String> {
                'Id',
                'RecordType.Name',
                'npe01__One2OneContact__r.Name',
                'AccountNumber',
                'AccountSource',
                'Active__c',
                'AnnualRevenue',
                'BillingCity',
                'BillingCountry',
                'BillingLatitude',
                'BillingLongitude',
                'BillingPostalCode',
                'BillingState',
                'BillingStreet',
                'CleanStatus',
                'CreatedById',
                'CreatedDate',
                'CustomerPriority__c',
                'DandbCompanyId',
                'Description',
                'DunsNumber',
                'Fax',
                'Industry',
                'Jigsaw',
                'JigsawCompanyId',
                'LastActivityDate',
                'LastModifiedById',
                'LastModifiedDate',
                'LastReferencedDate',
                'LastViewedDate',
                'MasterRecordId',
                'NaicsCode',
                'NaicsDesc',
                'Name',
                'npe01__FirstDonationDate__c',
                'npe01__LastDonationDate__c',
                'npe01__LifetimeDonationHistory_Amount__c',
                'npe01__LifetimeDonationHistory_Number__c',
                'npe01__One2OneContact__c',
                'npe01__SYSTEM_AccountType__c',
                'npe01__SYSTEMIsIndividual__c',
                'npo02__AverageAmount__c',
                'npo02__Best_Gift_Year__c',
                'npo02__Best_Gift_Year_Total__c',
                'npo02__FirstCloseDate__c',
                'npo02__Formal_Greeting__c',
                'npo02__HouseholdPhone__c',
                'npo02__Informal_Greeting__c',
                'npo02__LargestAmount__c',
                'npo02__LastCloseDate__c',
                'npo02__LastMembershipAmount__c',
                'npo02__LastMembershipDate__c',
                'npo02__LastMembershipLevel__c',
                'npo02__LastMembershipOrigin__c',
                'npo02__LastOppAmount__c',
                'npo02__MembershipEndDate__c',
                'npo02__MembershipJoinDate__c',
                'npo02__NumberOfClosedOpps__c',
                'npo02__NumberOfMembershipOpps__c',
                'npo02__OppAmount2YearsAgo__c',
                'npo02__OppAmountLastNDays__c',
                'npo02__OppAmountLastYear__c',
                'npo02__OppAmountThisYear__c',
                'npo02__OppsClosed2YearsAgo__c',
                'npo02__OppsClosedLastNDays__c',
                'npo02__OppsClosedLastYear__c',
                'npo02__OppsClosedThisYear__c',
                'npo02__SmallestAmount__c',
                'npo02__SYSTEM_CUSTOM_NAMING__c',
                'npo02__TotalMembershipOppAmount__c',
                'npo02__TotalOppAmount__c',
                'NumberOfEmployees',
                'NumberofLocations__c',
                'OwnerId',
                'Ownership',
                'ParentId',
                'Phone',
                'PhotoUrl',
                'Rating',
                'RecordTypeId',
                'ShippingCity',
                'ShippingCountry',
                'ShippingLatitude',
                'ShippingLongitude',
                'ShippingPostalCode',
                'ShippingState',
                'ShippingStreet',
                'Sic',
                'SicDesc',
                'Site',
                'SLA__c',
                'SLAExpirationDate__c',
                'SLASerialNumber__c',
                'TickerSymbol',
                'Tradestyle',
                'Type',
                'UpsellOpportunity__c',
                'Website',
                'YearStarted'
            }, 'Contact' => new list<String> {
                'Id',
                'Primary_Affiliation__r.Name',
                'AccountId',
                'AssistantName',
                'AssistantPhone',
                'Birthdate',
                'CleanStatus',
                'CreatedById',
                'CreatedDate',
                'Department',
                'Description',
                'Email',
                'EmailBouncedDate',
                'EmailBouncedReason',
                'Fax',
                'FirstName',
                'HomePhone',
                'IsEmailBounced',
                'Jigsaw',
                'JigsawContactId',
                'Languages__c',
                'LastActivityDate',
                'LastCURequestDate',
                'LastCUUpdateDate',
                'LastModifiedById',
                'LastModifiedDate',
                'LastName',
                'LastReferencedDate',
                'LastViewedDate',
                'LeadSource',
                'Level__c',
                'MailingCity',
                'MailingCountry',
                'MailingLatitude',
                'MailingLongitude',
                'MailingPostalCode',
                'MailingState',
                'MailingStreet',
                'MasterRecordId',
                'MobilePhone',
                'Name',
                'npe01__AlternateEmail__c',
                'npe01__Home_Address__c',
                'npe01__HomeEmail__c',
                'npe01__Last_Donation_Date__c',
                'npe01__Lifetime_Giving_History_Amount__c',
                'npe01__Organization_Type__c',
                'npe01__Other_Address__c',
                'npe01__Preferred_Email__c',
                'npe01__PreferredPhone__c',
                'npe01__Primary_Address_Type__c',
                'npe01__Private__c',
                'npe01__Secondary_Address_Type__c',
                'npe01__SystemAccountProcessor__c',
                'npe01__SystemIsIndividual__c',
                'npe01__Type_of_Account__c',
                'npe01__Work_Address__c',
                'npe01__WorkEmail__c',
                'npe01__WorkPhone__c',
                'npo02__AverageAmount__c',
                'npo02__Best_Gift_Year__c',
                'npo02__Best_Gift_Year_Total__c',
                'npo02__FirstCloseDate__c',
                'npo02__Formula_HouseholdMailingAddress__c',
                'npo02__Formula_HouseholdPhone__c',
                'npo02__Household__c',
                'npo02__Household_Naming_Order__c',
                'npo02__LargestAmount__c',
                'npo02__LastCloseDate__c',
                'npo02__LastCloseDateHH__c',
                'npo02__LastMembershipAmount__c',
                'npo02__LastMembershipDate__c',
                'npo02__LastMembershipLevel__c',
                'npo02__LastMembershipOrigin__c',
                'npo02__LastOppAmount__c',
                'npo02__MembershipEndDate__c',
                'npo02__MembershipJoinDate__c',
                'npo02__Naming_Exclusions__c',
                'npo02__NumberOfClosedOpps__c',
                'npo02__NumberOfMembershipOpps__c',
                'npo02__OppAmount2YearsAgo__c',
                'npo02__OppAmountLastNDays__c',
                'npo02__OppAmountLastYear__c',
                'npo02__OppAmountLastYearHH__c',
                'npo02__OppAmountThisYear__c',
                'npo02__OppAmountThisYearHH__c',
                'npo02__OppsClosed2YearsAgo__c',
                'npo02__OppsClosedLastNDays__c',
                'npo02__OppsClosedLastYear__c',
                'npo02__OppsClosedThisYear__c',
                'npo02__SmallestAmount__c',
                'npo02__Soft_Credit_Last_Year__c',
                'npo02__Soft_Credit_This_Year__c',
                'npo02__Soft_Credit_Total__c',
                'npo02__Soft_Credit_Two_Years_Ago__c',
                'npo02__SystemHouseholdProcessor__c',
                'npo02__Total_Household_Gifts__c',
                'npo02__TotalMembershipOppAmount__c',
                'npo02__TotalOppAmount__c',
                'OtherCity',
                'OtherCountry',
                'OtherLatitude',
                'OtherLongitude',
                'OtherPhone',
                'OtherPostalCode',
                'OtherState',
                'OtherStreet',
                'OwnerId',
                'Phone',
                'PhotoUrl',
                'ReportsToId',
                'Salutation',
                'Title'
            }
        };

    public SummaryProfileView(ApexPages.StandardController stdController) {
        
        this.sobjId = stdController.getId();
        if (this.sobjId == null) {
            return;
        }

        String objectType = (stdController.getRecord().getSObjectType() == Account.sObjectType) ? 
            'Account' : 'Contact';

        // get custom settings
        settings = getSummaryProfileSettings();
        Boolean getActivities = (settings.Max_Activities__c != null && settings.Max_Activities__c > 0);

        customFields = new list<String>();
        for (Summary_Profile_Custom_Fields__c cf : [SELECT Field_Name__c FROM Summary_Profile_Custom_Fields__c WHERE Object_Name__c = :objectType ORDER BY Order__c]) {
            customFields.add(cf.Field_Name__c);
        }

        this.sobj = Database.query( buildQuery(objectType, customFields, getActivities) );

        if (objectType == 'Account') {
            acct = (Account)sobj;
            if (getActivities) {
                activities = acct.ActivityHistories;
            }
        } else {
            con = (Contact)sobj;
            if (getActivities) {
                activities = con.ActivityHistories;
            }
        }

        if (settings.Affiliations_Active__c || settings.Affiliations_Inactive__c) {
            String q = 'SELECT CreatedBy.Name, CreatedDate, Id, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Name, npe5__Contact__c, npe5__Description__c, npe5__EndDate__c, npe5__Organization__c, npe5__Organization__r.Name, npe5__Organization__r.Website, npe5__Primary__c, npe5__Role__c, npe5__StartDate__c, npe5__Status__c FROM npe5__Affiliation__c ';
            q += 'WHERE npe5__Primary__c != true ';
            if (objectType == 'Account') {
                q += 'AND npe5__Organization__c = : sobjId ';
            } else {
                q += 'AND npe5__Contact__c = : sobjId ';
            }
            if (settings.Affiliations_Active__c && !settings.Affiliations_Inactive__c) {
                q += 'AND npe5__Status__c = \'Current\' ';
            } else if (!settings.Affiliations_Active__c && settings.Affiliations_Inactive__c) {
                q += 'AND npe5__Status__c != \'Current\' ';
            }
            q += 'ORDER BY npe5__StartDate__c DESC ';
            if (settings.Max_Affiliations__c != null) {
                q += 'LIMIT ' + String.valueOf(settings.Max_Affiliations__c.intValue());
            }
            affiliations = Database.query(q);
        }

        if (objectType == 'Contact' && (settings.Relationships_Active__c || settings.Relationships_Inactive__c)) {
            String q = 'SELECT CreatedById, CreatedDate, Id, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Name, npe4__Contact__c, npe4__Description__c, npe4__ReciprocalRelationship__c, npe4__RelatedContact__c, npe4__Relationship_Explanation__c, npe4__Status__c, npe4__SYSTEM_SystemCreated__c, npe4__Type__c, SystemModstamp FROM npe4__Relationship__c ';
            q += 'WHERE npe4__Contact__c = : sobjId ';
            if (settings.Relationships_Active__c && !settings.Relationships_Inactive__c) {
                q += 'AND npe4__Status__c = \'Current\' ';
            } else if (!settings.Relationships_Active__c && settings.Relationships_Inactive__c) {
                q += 'AND npe4__Status__c != \'Current\' ';
            }
            q += 'ORDER BY CreatedDate ';
            if (settings.Max_Relationships__c != null) {
                q += 'LIMIT ' + String.valueOf(settings.Max_Relationships__c.intValue());
            }
            relationships = Database.query(q);
        }
    }

    private String buildQuery(String objectType, list<String> customFields, Boolean getActivities) {
        String q = 'SELECT ' + String.join(standardFields.get(objectType), ', ');

        if (customFields != null && !customFields.isEmpty()) {
            q += ', ' + String.join(customFields, ', ');
        }

        if (getActivities) {
            q += ', (SELECT AccountId, ActivityDate, ActivityType, CallDisposition, CallDurationInSeconds, CallObject, CallType, CreatedById, CreatedDate, Description, DurationInMinutes, EndDateTime, Id, IsAllDayEvent, IsClosed, IsHighPriority, IsReminderSet, IsTask, IsVisibleInSelfService, LastModifiedById, LastModifiedDate, Location, OwnerId, Priority, ReminderDateTime, StartDateTime, Status, Subject, WhatId, WhoId from ActivityHistories ORDER BY ActivityDate DESC) ';
        }

        q += ' FROM ' + objectType + ' WHERE Id = :sobjId LIMIT 1';

        return q;
    }

    private Summary_Profile__c getSummaryProfileSettings() {
        Summary_Profile__c sp = Summary_Profile__c.getInstance('Default');
        if (sp == null) {
            sp = new Summary_Profile__c(Name = 'Default');
            insert sp;
            sp = Summary_Profile__c.getInstance('Default');
        }
        return sp;
    }
}