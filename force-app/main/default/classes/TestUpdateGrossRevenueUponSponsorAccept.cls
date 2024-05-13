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
        system.debug('ID de l\'event créé : '+evn.id);
        system.debug('Création du sponsor');

        CAMPX__Sponsor__c spons = new CAMPX__Sponsor__c(
            Name = 'Sponsor Tilege',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 1000,
            CAMPX__Event__c = evn.id);
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
            CAMPX__Event__c = evn.id);
        sponsors.add(spons1);

        CAMPX__Sponsor__c spons2 = new CAMPX__Sponsor__c(
            Name = 'Sponsor Bet',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 5000,
            CAMPX__Event__c = evn.id);
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
            CAMPX__Event__c = mainEvent.id);
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

        CAMPX__Event__c secondEvent = new CAMPX__Event__c(
            Name = 'Second Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
            );
        insert secondEvent;

        CAMPX__Sponsor__c secondSponsor = new CAMPX__Sponsor__c(
            Name = 'Sponsor Tebe',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 500,
            CAMPX__Event__c = secondEvent.id);
        listOfSponsors.add(secondSponsor);
            
        insert listOfSponsors;
        secondEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :secondEvent.Id];
        System.assertEquals(500, secondEvent.CAMPX__GrossRevenue__c);

        System.debug('Status du sponsor avant udpate : '+secondSponsor.CAMPX__Status__c);
        secondSponsor.CAMPX__Status__c = 'Rejected';
        update listOfSponsors;
        secondEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :secondEvent.Id];
        System.debug('Status du sponsor après udpate : '+secondSponsor.CAMPX__Status__c);
        System.assertEquals(0, secondEvent.CAMPX__GrossRevenue__c);
        
        Test.stopTest();
    }

    @isTest static void eventIsDissociedFromTheSponsor() {
        Test.startTest();
        
        List<CAMPX__Sponsor__c> listOfSponsors = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Event__c> listOfEvents = new List<CAMPX__Event__c>();


        CAMPX__Event__c oneEvent = new CAMPX__Event__c(
            Name = 'One Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning');
            listOfEvents.add(oneEvent);

        CAMPX__Event__c anotherEvent = new CAMPX__Event__c(
            Name = 'Another Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 30,
            CAMPX__Status__c = 'Planning');
            listOfEvents.add(anotherEvent);

        insert listOfEvents;
        System.debug('Liste des events créés : '+listOfEvents);

        CAMPX__Sponsor__c acceptedSponsor = new CAMPX__Sponsor__c(
            Name = 'Accepted Sponsor',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__ContributionAmount__c = 100,
            CAMPX__Event__c = oneEvent.id);
        listOfSponsors.add(acceptedSponsor);
            
        insert listOfSponsors;
        oneEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :oneEvent.Id];
        Assert.areEqual(100, oneEvent.CAMPX__GrossRevenue__c);
        
        acceptedSponsor.CAMPX__Event__c = anotherEvent.id;
        update listOfSponsors;
        listOfEvents = [SELECT CAMPX__GrossRevenue__c, Name FROM CAMPX__Event__c];
        listOfSponsors = [SELECT CAMPX__Event__c FROM CAMPX__Sponsor__c];

        System.debug('Event lié au sponsor : '+acceptedSponsor.CAMPX__Event__c);
        Assert.areEqual(acceptedSponsor.CAMPX__Event__c, anotherEvent.id);
        Assert.areEqual(0, oneEvent.CAMPX__GrossRevenue__c);
        
        Test.stopTest();
    }

}