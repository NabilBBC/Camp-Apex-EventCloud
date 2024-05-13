@isTest
private class TestUpdateGrossRevenueUponSponsorAccept {
    @isTest static void createEventAndSponsor() {
        Test.startTest();
        
        CAMPX__Event__c evn = new CAMPX__Event__c(
            Name = 'Fake Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
        );
        insert evn;
        
        CAMPX__Sponsor__c spons = new CAMPX__Sponsor__c(
            Name = 'Sponsor Tilege',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 1000,
            CAMPX__Event__c = evn.id
        );
        insert spons;
        
        evn = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :evn.Id];
        System.assertEquals(1000, evn.CAMPX__GrossRevenue__c);
        
        Test.stopTest();
    }
    
    @isTest static void createEventAnd2Sponsors() {
        Test.startTest();
        
        List<CAMPX__Sponsor__c> sponsors = new List<CAMPX__Sponsor__c>();
        
        CAMPX__Event__c evn = new CAMPX__Event__c(
            Name = 'Fake Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
        );
        insert evn;
        
        CAMPX__Sponsor__c spons1 = new CAMPX__Sponsor__c(
            Name = 'Sponsor Tilege',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 1000,
            CAMPX__Event__c = evn.id
        );
        sponsors.add(spons1);
        
        CAMPX__Sponsor__c spons2 = new CAMPX__Sponsor__c(
            Name = 'Sponsor Bet',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 5000,
            CAMPX__Event__c = evn.id
        );
        sponsors.add(spons2);
        
        insert sponsors;
        
        evn = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :evn.Id];
        System.assertEquals(6000, evn.CAMPX__GrossRevenue__c);
        
        Test.stopTest();
    }
    
    @isTest static void sponsorIsChangedFromAcceptedToPending() {
        Test.startTest();
        
        List<CAMPX__Sponsor__c> listOfSponsors = new List<CAMPX__Sponsor__c>();
        
        CAMPX__Event__c mainEvent = new CAMPX__Event__c(
            Name = 'Main Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
        );
        insert mainEvent;
        
        CAMPX__Sponsor__c secondSponsor = new CAMPX__Sponsor__c(
            Name = 'Sponsor Bet',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 500,
            CAMPX__Event__c = mainEvent.id
        );
        listOfSponsors.add(secondSponsor);
        
        insert listOfSponsors;
        
        mainEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :mainEvent.Id];
        System.assertEquals(500, mainEvent.CAMPX__GrossRevenue__c);
        
        secondSponsor.CAMPX__Status__c = 'Pending';
        update listOfSponsors;
        
        mainEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :mainEvent.Id];
        System.assertEquals(0, mainEvent.CAMPX__GrossRevenue__c);
        
        Test.stopTest();
    }
    
    @isTest static void sponsorIsChangedFromAcceptedToRejected() {
        Test.startTest();
        
        List<CAMPX__Sponsor__c> listOfSponsors = new List<CAMPX__Sponsor__c>();
        
        CAMPX__Event__c mainEvent = new CAMPX__Event__c(
            Name = 'Main Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
        );
        insert mainEvent;
        
        CAMPX__Sponsor__c secondSponsor = new CAMPX__Sponsor__c(
            Name = 'Sponsor Tebe',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 500,
            CAMPX__Event__c = mainEvent.id
        );
        listOfSponsors.add(secondSponsor);
        
        insert listOfSponsors;
        
        mainEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :mainEvent.Id];
        System.assertEquals(500, mainEvent.CAMPX__GrossRevenue__c);
        
        secondSponsor.CAMPX__Status__c = 'Rejected';
        update listOfSponsors;
        
        mainEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :mainEvent.Id];
        System.assertEquals(0, mainEvent.CAMPX__GrossRevenue__c);
        
        Test.stopTest();
    }
}@isTest
private class TestUpdateGrossRevenueUponSponsorAccept {
    @isTest static void createEventAndSponsor() {
        // Test code here
    }
    @isTest static void createEventAnd2Sponsors() {
        // Test code here
    }
    @isTest static void sponsorIsChangedFromAcceptedToPending() {
        // Test code here
    }
    @isTest static void sponsorIsChangedFromAcceptedToRejected() {
        // Test code here
    }
    
    // Generated tests
    @isTest static void testCreateEventAndSponsor() {
        Test.startTest();
        CAMPX__Event__c evn = new CAMPX__Event__c(
            Name = 'Fake Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
        );
        insert evn;
        CAMPX__Sponsor__c spons = new CAMPX__Sponsor__c(
            Name = 'Sponsor Tilege',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 1000,
            CAMPX__Event__c = evn.id
        );
        insert spons;
        evn = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :evn.Id];
        System.assertEquals(1000, evn.CAMPX__GrossRevenue__c);
        Test.stopTest();
    }
    
    @isTest static void testCreateEventAnd2Sponsors() {
        Test.startTest();
        CAMPX__Event__c evn = new CAMPX__Event__c(
            Name = 'Fake Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
        );
        insert evn;
        List<CAMPX__Sponsor__c> sponsors = new List<CAMPX__Sponsor__c>();
        CAMPX__Sponsor__c spons1 = new CAMPX__Sponsor__c(
            Name = 'Sponsor Tilege',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 1000,
            CAMPX__Event__c = evn.id
        );
        sponsors.add(spons1);
        CAMPX__Sponsor__c spons2 = new CAMPX__Sponsor__c(
            Name = 'Sponsor Bet',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 5000,
            CAMPX__Event__c = evn.id
        );
        sponsors.add(spons2);
        insert sponsors;
        evn = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :evn.Id];
        System.assertEquals(6000, evn.CAMPX__GrossRevenue__c);
        Test.stopTest();
    }
    
    @isTest static void testSponsorIsChangedFromAcceptedToPending() {
        Test.startTest();
        CAMPX__Event__c mainEvent = new CAMPX__Event__c(
            Name = 'Main Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
        );
        insert mainEvent;
        CAMPX__Sponsor__c secondSponsor = new CAMPX__Sponsor__c(
            Name = 'Sponsor Bet',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 500,
            CAMPX__Event__c = mainEvent.id
        );
        insert secondSponsor;
        mainEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :mainEvent.Id];
        System.assertEquals(500, mainEvent.CAMPX__GrossRevenue__c);
        secondSponsor.CAMPX__Status__c = 'Pending';
        update secondSponsor;
        mainEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :mainEvent.Id];
        System.assertEquals(0, mainEvent.CAMPX__GrossRevenue__c);
        Test.stopTest();
    }
    
    @isTest static void testSponsorIsChangedFromAcceptedToRejected() {
        Test.startTest();
        CAMPX__Event__c mainEvent = new CAMPX__Event__c(
            Name = 'Main Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
        );
        insert mainEvent;
        CAMPX__Sponsor__c secondSponsor = new CAMPX__Sponsor__c(
            Name = 'Sponsor Tebe',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 500,
            CAMPX__Event__c = mainEvent.id
        );
        insert secondSponsor;
        mainEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :mainEvent.Id];
        System.assertEquals(500, mainEvent.CAMPX__GrossRevenue__c);
        secondSponsor.CAMPX__Status__c = 'Rejected';
        update secondSponsor;
        mainEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :mainEvent.Id];
        System.assertEquals(0, mainEvent.CAMPX__GrossRevenue__c);
        Test.stopTest();
    }
}