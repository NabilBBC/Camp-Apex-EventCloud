public with sharing class SponsorTriggerHandler {

    public static void updateSponsorStatusAtCreation(List<CAMPX__Sponsor__c> newSponsors) {
        for (CAMPX__Sponsor__c spon : newSponsors) {
            if (spon.CAMPX__Status__c == null) {
                spon.CAMPX__Status__c = 'Pending';
            }
        }
    }

    public static void updateSponsorStatusAtUpdate(List<CAMPX__Sponsor__c> newSponsors) {
        for (CAMPX__Sponsor__c sponsor  : newsponsors) {
            if (sponsor.CAMPX__Status__c != null && sponsor.CAMPX__Status__c ==  'Accepted' && sponsor.CAMPX__Event__c == null) {
                sponsor.CAMPX__Status__c = 'Pending';
            }
        }        
    }

    public static void preventSponsorCreationWithoutEmail(List<CAMPX__Sponsor__c> triggeringSponsors) {
        for (CAMPX__Sponsor__c sponz : triggeringSponsors) {
            if (String.isblank(sponz.CAMPX__Email__c)) {
                sponz.addError('A sponsor can not be created without an email address');
            }   
        }
    }

    public static void assignTierToSponsor(List<CAMPX__Sponsor__c> sponsorsToBeAssigned) {
        for (CAMPX__Sponsor__c spons : sponsorsToBeAssigned) {

            System.debug('La contribution du sponsor est de : ' + spons.CAMPX__ContributionAmount__c);

            if (spons.CAMPX__ContributionAmount__c == null || spons.CAMPX__ContributionAmount__c <= 0) {
                spons.CAMPX__Tier__c = null;
            }
            if (spons.CAMPX__ContributionAmount__c >0 && spons.CAMPX__ContributionAmount__c <= 999) {
                spons.CAMPX__Tier__c = 'Bronze';
            }
            if (spons.CAMPX__ContributionAmount__c >999 && spons.CAMPX__ContributionAmount__c <= 4999) {
                spons.CAMPX__Tier__c = 'Silver';
            }
            if (spons.CAMPX__ContributionAmount__c >= 5000) {
                spons.CAMPX__Tier__c = 'Gold';
            }
            System.debug('Le tier du sponsor est  : ' + spons.CAMPX__Tier__c);
        }   
    }

    public static void preventSponsorAcceptedWithoutEvent(List<CAMPX__Sponsor__c> spons) {
        for (CAMPX__Sponsor__c sponz : spons) {
            System.debug('Le statut du sponsor est : ' + sponz.CAMPX__Status__c);
            if (sponz.CAMPX__Status__c == 'Accepted' && String.isblank(sponz.CAMPX__Event__c)) {
                sponz.addError('A Sponsor must be associated with an event before being Accepted.');
            }   
        }
    }

    public static void updateEventRevenueWithSponsorContribAtCreation(List<CAMPX__Sponsor__c> newSponsors) {
        List<CAMPX__Event__c> ListOfEventsToBeUpdated = new List<CAMPX__Event__c>();
    
        if (!newSponsors.isEmpty()) {
            for (CAMPX__Sponsor__c newSpons : newSponsors) {
                // Proceed only if there is a related Event and the status is 'Accepted'
                if (newSpons.CAMPX__Event__c != null && newSpons.CAMPX__Status__c == 'Accepted') {
                    // Fetch the related Event record
                    CAMPX__Event__c newSponsEvent = [
                        SELECT Id, CAMPX__GrossRevenue__c
                        FROM CAMPX__Event__c
                        WHERE Id = :newSpons.CAMPX__Event__c
                        LIMIT 1
                    ];
    
                    // Proceed only if the event record was found
                    if (newSponsEvent != null) {
                        System.debug('newSponsEvent = ' + newSponsEvent);
                        System.debug('newSpons Contribution = ' + newSpons.CAMPX__ContributionAmount__c);
    
                        // Update the GrossRevenue field with contribution amount
                        if (newSpons.CAMPX__ContributionAmount__c != null) {
                            if (newSponsEvent.CAMPX__GrossRevenue__c == null) {
                                newSponsEvent.CAMPX__GrossRevenue__c = newSpons.CAMPX__ContributionAmount__c;
                            } else {
                                newSponsEvent.CAMPX__GrossRevenue__c += newSpons.CAMPX__ContributionAmount__c;
                            }
                            ListOfEventsToBeUpdated.add(newSponsEvent);
                        }
                    }
                }
            }
    
            // Update the list of events if there are any events to update
            if (!ListOfEventsToBeUpdated.isEmpty()) {
                update ListOfEventsToBeUpdated;
                System.debug('Updated event revenues successfully');
            } else {
                System.debug('No events to update');
            }
        }
    }
    

    public static Decimal calculateTotalContribOfEvent(Id IdOfEvent) {
        // Aggregate query to sum contributions of all sponsors for the event
        List<AggregateResult> sumOfContributions = [
            SELECT SUM(CAMPX__ContributionAmount__c) totalContributions
            FROM CAMPX__Sponsor__c 
            WHERE CAMPX__Event__c = :IdOfEvent AND CAMPX__Status__c = 'Accepted'
        ];
    
        // Retrieve the result and handle cases where the result is null
        Decimal totalOfContributions = (sumOfContributions.isEmpty() || sumOfContributions[0].get('totalContributions') == null) 
            ? 0 
            : (Decimal)sumOfContributions[0].get('totalContributions');
    
        System.debug('calculateTotalContribOfEvent was called and result is: ' + totalOfContributions);
    
        return totalOfContributions;
    }
    

    public static void updateEventRevenueWithSponsorContribAtUpdate(List<CAMPX__Sponsor__c> newSponsors, Map <Id, CAMPX__Sponsor__c> oldSponsorsMap) {                
        Set<CAMPX__Event__c> SetAllEventsToUpdate = new Set<CAMPX__Event__c>();
    
        for (CAMPX__Sponsor__c sp : newSponsors) {
            // Query the new event associated with the sponsor, if any
            CAMPX__Event__c spEvent = null;
            if (sp.CAMPX__Event__c != null) {
                List<CAMPX__Event__c> spEventList = [
                    SELECT Id, Name, CAMPX__GrossRevenue__c
                    FROM CAMPX__Event__c
                    WHERE Id = :sp.CAMPX__Event__c
                    LIMIT 1
                ];
                if (!spEventList.isEmpty()) {
                    spEvent = spEventList[0];
                    System.debug('spEvent : ' + spEvent.Name);
                }
            }
            
            // Retrieve the old event associated with the sponsor, if any
            if (oldSponsorsMap.containsKey(sp.Id) && oldSponsorsMap.get(sp.Id).CAMPX__Event__c != null) {
                Id spOldEventId = oldSponsorsMap.get(sp.Id).CAMPX__Event__c;
                List<CAMPX__Event__c> spOldEventList = [
                    SELECT Id, Name, CAMPX__GrossRevenue__c
                    FROM CAMPX__Event__c
                    WHERE Id = :spOldEventId
                    LIMIT 1
                ];
                
                CAMPX__Event__c spOldEvent = spOldEventList.isEmpty() ? null : spOldEventList[0];
                
                if (spOldEvent != null) {
                    System.debug('spOldEvent Name : ' + spOldEvent.Name);
    
                    // Recalculate the Gross Revenue for the old event
                    System.debug('Previous Event Gross Revenue before update = ' + spOldEvent.CAMPX__GrossRevenue__c);
                    spOldEvent.CAMPX__GrossRevenue__c = calculateTotalContribOfEvent(spOldEvent.Id);
                    SetAllEventsToUpdate.add(spOldEvent);
                }
            }
    
            // If there's a new event, recalculate the Gross Revenue for it as well
            if (spEvent != null) {
                System.debug('New Event Gross Revenue before update = ' + spEvent.CAMPX__GrossRevenue__c);
                spEvent.CAMPX__GrossRevenue__c = calculateTotalContribOfEvent(spEvent.Id);
                SetAllEventsToUpdate.add(spEvent);
            }
        }
    
        // Convert Set to List and update only if there are events to update
        if (!SetAllEventsToUpdate.isEmpty()) {
            List<CAMPX__Event__c> ListOfEventsToUpdate = new List<CAMPX__Event__c>(SetAllEventsToUpdate);
            update ListOfEventsToUpdate;
            System.debug('All events were updated successfully');
        } else {
            System.debug('No events to update');
        }
    }    
}