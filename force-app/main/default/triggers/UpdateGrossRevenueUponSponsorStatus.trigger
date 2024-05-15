trigger UpdateGrossRevenueUponSponsorStatus on CAMPX__Sponsor__c(after insert, after update) {

    List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();

    if (Trigger.isInsert || Trigger.isUpdate) {
      for (CAMPX__Sponsor__c sponsor : Trigger.new) {
  
        if (
          sponsor.CAMPX__Status__c == 'Accepted' &&
          sponsor.CAMPX__ContributionAmount__c != null &&
          sponsor.CAMPX__ContributionAmount__c > 0
        ) {
          AggregateResult result = [SELECT SUM(CAMPX__ContributionAmount__c) total
                                    FROM CAMPX__Sponsor__c
                                    WHERE CAMPX__Status__c = 'Accepted'
                                    AND CAMPX__Event__c = :sponsor.CAMPX__Event__c];
  
          Decimal totalAmountOfContributions = (Decimal) result.get('total');
  
          eventsToUpdate = [SELECT CAMPX__GrossRevenue__c, name
                            FROM CAMPX__Event__c
                            WHERE id = :sponsor.CAMPX__Event__c];
  
          if (!eventsToUpdate.isEmpty()) {
            for (CAMPX__Event__c eventItem : eventsToUpdate) {
              eventItem.CAMPX__GrossRevenue__c = totalAmountOfContributions;
            }
          }
        }
  
        if (!eventsToUpdate.isEmpty()) {
          update eventsToUpdate;
        }
     
  
      if (Trigger.isUpdate) {
        for (CAMPX__Sponsor__c oldSponsor : Trigger.old) {
          List<CAMPX__Sponsor__c> oldSponsors = [
            SELECT CAMPX__Status__c, CAMPX__Event__c, CAMPX__ContributionAmount__c
            FROM CAMPX__Sponsor__c
            WHERE Id IN :Trigger.old
          ];
          System.debug('old sponsors : ' + oldsponsors);
  
          if (
            oldSponsor.CAMPX__Status__c == 'Accepted' &&
            (sponsor.CAMPX__Status__c == 'Pending' ||
            sponsor.CAMPX__Status__c == 'Rejected') ||
            sponsor.CAMPX__Event__c != oldSponsor.CAMPX__Event__c)
           {
              eventsToUpdate = [
                  SELECT CAMPX__GrossRevenue__c
                  FROM CAMPX__Event__c
                ];
                System.debug('events to update : ' + eventsToUpdate);
  
                if (!oldSponsors.isEmpty() && !eventsToUpdate.isEmpty()) {
                  for (CAMPX__Event__c eventToUpdate : eventsToUpdate) {
                    if (eventToUpdate.id == oldSponsor.CAMPX__Event__c) {
                      eventToUpdate.CAMPX__GrossRevenue__c -= oldSponsors.get(0).CAMPX__ContributionAmount__c;
                    }
                  }
            }
          }
        }
      update eventsToUpdate;
      }
    }
  }
    }