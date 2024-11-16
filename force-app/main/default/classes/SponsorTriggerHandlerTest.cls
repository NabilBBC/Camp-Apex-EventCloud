@isTest
private class SponsorTriggerHandlerTest {

    @isTest
    static void updateEventGrossRevenueWhenSponsAccepted() {
        CAMPX__Event__c newEvent1 = new CAMPX__Event__c();
        newEvent1.Name = 'new Event';
        insert newEvent1;
        System.debug('new Event was created');
        CAMPX__Sponsor__c newSpons = new CAMPX__Sponsor__c();
        newSpons.name = 'new Spons';
        newSpons.CAMPX__Status__c = 'Accepted';
        newSpons.CAMPX__Email__c = 'newspons@blablamail.com';
        newSpons.CAMPX__ContributionAmount__c = 5000;
        newSpons.CAMPX__Event__c = newEvent1.Id;
        insert newSpons;
        System.debug('new Spons was created');
        CAMPX__Event__c createdEvent = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE id = :newEvent1.Id];
        CAMPX__Sponsor__c createdSponsor = [SELECT CAMPX__ContributionAmount__c FROM CAMPX__Sponsor__c WHERE id = :newSpons.Id];
        Assert.areEqual(createdEvent.CAMPX__GrossRevenue__c, createdSponsor.CAMPX__ContributionAmount__c);
    }
    @isTest
    static void updateEventGrossRevenueWhith2Sponsors() {
        List<CAMPX__Sponsor__c> listOfSponsors = new List<CAMPX__Sponsor__c>();
        CAMPX__Event__c newEvent1 = new CAMPX__Event__c();
        newEvent1.Name = 'new Event';
        insert newEvent1;
        System.debug('new Event was created');
        
        CAMPX__Sponsor__c newSpon1 = new CAMPX__Sponsor__c();
        newSpon1.name = 'new Spon1';
        newSpon1.CAMPX__Status__c = 'Accepted';
        newSpon1.CAMPX__Email__c = 'newspons@blablamail.com';
        newSpon1.CAMPX__ContributionAmount__c = 5000;
        newSpon1.CAMPX__Event__c = newEvent1.Id;
        listOfSponsors.add(newSpon1);

        System.debug('new Spon1 was created');

        CAMPX__Sponsor__c newSpon2 = new CAMPX__Sponsor__c();
        newSpon2.name = 'new Spon2';
        newSpon2.CAMPX__Status__c = 'Accepted';
        newSpon2.CAMPX__Email__c = 'newspons@blablamail.com';
        newSpon2.CAMPX__ContributionAmount__c = 10000;
        newSpon2.CAMPX__Event__c = newEvent1.Id;
        listOfSponsors.add(newSpon2);
        System.debug('new Spon2 was created');

        insert listOfSponsors;
        
        List<CAMPX__Event__c> listOfCreatedEvents = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE id = :newEvent1.Id ORDER BY name ASC];
        List<CAMPX__Sponsor__c> listOfCreatedSponsors = [SELECT CAMPX__ContributionAmount__c FROM CAMPX__Sponsor__c WHERE Campx__Event__c = :newEvent1.Id ORDER BY name ASC];
 
        Assert.areEqual(listOfCreatedEvents.get(0).CAMPX__GrossRevenue__c, (newSpon1.CAMPX__ContributionAmount__c + newSpon2.CAMPX__ContributionAmount__c));
    }

    @isTest
    static void updateEventGrossRevenueRemove1sponsor() {
        List<CAMPX__Sponsor__c> listOfSponsors = new List<CAMPX__Sponsor__c>();
        CAMPX__Event__c newEvent1 = new CAMPX__Event__c();
        newEvent1.Name = 'new Event';
        insert newEvent1;
        System.debug('new Event was created');
        
        CAMPX__Sponsor__c newSpon1 = new CAMPX__Sponsor__c();
        newSpon1.name = 'new Spon1';
        newSpon1.CAMPX__Status__c = 'Accepted';
        newSpon1.CAMPX__Email__c = 'newspons@blablamail.com';
        newSpon1.CAMPX__ContributionAmount__c = 5000;
        newSpon1.CAMPX__Event__c = newEvent1.Id;
        listOfSponsors.add(newSpon1);

        System.debug('new Spon1 was created');

        CAMPX__Sponsor__c newSpon2 = new CAMPX__Sponsor__c();
        newSpon2.name = 'new Spon2';
        newSpon2.CAMPX__Status__c = 'Accepted';
        newSpon2.CAMPX__Email__c = 'newspons@blablamail.com';
        newSpon2.CAMPX__ContributionAmount__c = 10000;
        newSpon2.CAMPX__Event__c = newEvent1.Id;
        listOfSponsors.add(newSpon2);
        System.debug('new Spon2 was created');

        insert listOfSponsors;
        
        List<CAMPX__Event__c> listOfCreatedEvents = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE id = :newEvent1.Id ORDER BY name ASC];
        List<CAMPX__Sponsor__c> listOfCreatedSponsors = [SELECT CAMPX__ContributionAmount__c FROM CAMPX__Sponsor__c WHERE Campx__Event__c = :newEvent1.Id ORDER BY name ASC];
 
        Assert.areEqual(listOfCreatedEvents.get(0).CAMPX__GrossRevenue__c, (newSpon1.CAMPX__ContributionAmount__c + newSpon2.CAMPX__ContributionAmount__c));
        System.debug('Gross Revenue de l\'event avec 2 sponsors: ' + listOfCreatedEvents.get(0).CAMPX__GrossRevenue__c);

        newSpon2.CAMPX__ContributionAmount__c = 0;
        update newSpon2;
        List<CAMPX__Event__c> listOfCreatedEvents2 = [SELECT CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE id = :newEvent1.Id ORDER BY name ASC];
        Assert.areEqual(listOfCreatedEvents2.get(0).CAMPX__GrossRevenue__c, (newSpon1.CAMPX__ContributionAmount__c));
        System.debug('Gross Revenue de l\'event avec 1 sponsor en moins: ' + listOfCreatedEvents2.get(0).CAMPX__GrossRevenue__c);
    }

    @isTest
    static void update2EventsGrossRevenueWhith2Sponsors() {
        List<CAMPX__Sponsor__c> listOfSponsors = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Event__c> listOfEvents = new List<CAMPX__Event__c>();
        CAMPX__Event__c newEvent1 = new CAMPX__Event__c();
        CAMPX__Event__c newEvent2 = new CAMPX__Event__c();
        
        newEvent1.Name = 'new Event 1';
        newEvent2.Name = 'new Event 2';
        listOfEvents.add(newEvent1);
        listOfEvents.add(newEvent2);
        insert listOfEvents;
        System.debug('new Events were created : ' + listOfEvents);
        
        CAMPX__Sponsor__c newSpon1 = new CAMPX__Sponsor__c();
        newSpon1.name = 'new Spon1';
        newSpon1.CAMPX__Status__c = 'Accepted';
        newSpon1.CAMPX__Email__c = 'newspons@blablamail.com';
        newSpon1.CAMPX__ContributionAmount__c = 250;
        newSpon1.CAMPX__Event__c = newEvent1.Id;
        listOfSponsors.add(newSpon1);

        CAMPX__Sponsor__c newSpon2 = new CAMPX__Sponsor__c();
        newSpon2.name = 'new Spon2';
        newSpon2.CAMPX__Status__c = 'Accepted';
        newSpon2.CAMPX__Email__c = 'newspons@blablamail.com';
        newSpon2.CAMPX__ContributionAmount__c = 150;
        newSpon2.CAMPX__Event__c = newEvent2.Id;
        listOfSponsors.add(newSpon2);

        insert listOfSponsors;
        System.debug('new Sponsors were created : ' + listOfSponsors);

        
        List<CAMPX__Event__c> listOfCreatedEvents = [SELECT id, name, CAMPX__GrossRevenue__c FROM CAMPX__Event__c ORDER BY name ASC];
        List<CAMPX__Sponsor__c> listOfCreatedSponsors = [SELECT CAMPX__ContributionAmount__c FROM CAMPX__Sponsor__c ORDER BY name ASC];
 
        Assert.areEqual(listOfCreatedEvents.get(0).CAMPX__GrossRevenue__c, listOfCreatedSponsors.get(0).CAMPX__ContributionAmount__c);
        Assert.areEqual(listOfCreatedEvents.get(1).CAMPX__GrossRevenue__c, listOfCreatedSponsors.get(1).CAMPX__ContributionAmount__c);

    }
}