@isTest
private class TestUpdateSponsorTierUponContribution {

    @isTest static void createSponsorWithNullTier() {
        Test.startTest();
        
        CAMPX__Event__c evn = new CAMPX__Event__c(
            Name = 'Random Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
            );
        insert evn;

        CAMPX__Sponsor__c spons = new CAMPX__Sponsor__c(
            Name = 'Random Sponsor',
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__Event__c = evn.id);
        insert spons;

        spons = [SELECT CAMPX__Tier__c FROM CAMPX__Sponsor__c WHERE id=:spons.id];
        Assert.isNull(spons.CAMPX__Tier__c);
        Test.stopTest();
    }
    @isTest static void createBronzeSponsor() {
        Test.startTest();
        
        CAMPX__Event__c evn = new CAMPX__Event__c(
            Name = 'Random Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
            );
        insert evn;

        CAMPX__Sponsor__c spons = new CAMPX__Sponsor__c(
            Name = 'Random Sponsor',
            CAMPX__ContributionAmount__c = 999,
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__Event__c = evn.id);
        insert spons;

        spons = [SELECT CAMPX__Tier__c FROM CAMPX__Sponsor__c WHERE id=:spons.id];
        Assert.areEqual('Bronze',spons.CAMPX__Tier__c);
        Test.stopTest();
    }

    @isTest static void createSilverSponsor() {
        Test.startTest();
        
        CAMPX__Event__c evn = new CAMPX__Event__c(
            Name = 'Random Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
            );
        insert evn;

        CAMPX__Sponsor__c spons = new CAMPX__Sponsor__c(
            Name = 'Random Sponsor',
            CAMPX__ContributionAmount__c = 4000,
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__Event__c = evn.id);
        insert spons;

        spons = [SELECT CAMPX__Tier__c FROM CAMPX__Sponsor__c WHERE id=:spons.id];
        Assert.areEqual('Silver',spons.CAMPX__Tier__c);
        Test.stopTest();
    }

    @isTest static void createGoldandBronzeSponsor() {
        Test.startTest();
        
        CAMPX__Event__c evn = new CAMPX__Event__c(
            Name = 'Random Event',
            CAMPX__TotalExpenses__c = 0,
            CAMPX__Venue_Capacity__c = 50,
            CAMPX__Status__c = 'Planning'
            );
        insert evn;

        List<CAMPX__Sponsor__c> sponsorsToInsert = new List<CAMPX__Sponsor__c>();
        CAMPX__Sponsor__c spons1 = new CAMPX__Sponsor__c(
            Name = 'Random Sponsor',
            CAMPX__ContributionAmount__c = 5000,
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__Event__c = evn.id);
            sponsorsToInsert.add(spons1);

        CAMPX__Sponsor__c spons2 = new CAMPX__Sponsor__c(
            Name = 'Random Sponsor',
            CAMPX__ContributionAmount__c = 500,
            CAMPX__Email__c = 'noemail@noemail.com',
            CAMPX__Status__c = 'Accepted',
            CAMPX__Event__c = evn.id);
            sponsorsToInsert.add(spons2);

        insert sponsorsToInsert;

        sponsorsToInsert = [SELECT id, CAMPX__Tier__c FROM CAMPX__Sponsor__c];
        Assert.areEqual('Gold',sponsorsToInsert.get(0).CAMPX__Tier__c);
        Assert.areEqual('Bronze',sponsorsToInsert.get(1).CAMPX__Tier__c);
        Test.stopTest();
    }
}