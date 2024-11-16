public with sharing class SponsorTriggerHandler {

    public static void updateSponsorStatusAtCreation(List<CAMPX__Sponsor__c> newSponsors) {
        for (CAMPX__Sponsor__c spon : newSponsors) {
            if (spon.CAMPX__Status__c == null) {
                spon.CAMPX__Status__c = 'Pending';
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

    public static void updateEventGrossRevenueWhenSponsAccepted(List<CAMPX__Sponsor__c> newSponsors, Map <id, CAMPX__Sponsor__c> oldSponsorsMap) {
        
        Id eventId;
        Decimal totalOfContibutions;
        CAMPX__Sponsor__c oldSponsor;
        List<CAMPX__Event__c> events2Update = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> eventsList = [SELECT id, Name, CAMPX__GrossRevenue__c FROM Campx__Event__c];
        System.debug('List of events : ' + eventsList);
    //Récupére la somme des contribs ayant le même event et un status accepted
        for (CAMPX__Sponsor__c triggeredSponsor : newSponsors) {
            if (triggeredSponsor.CAMPX__Status__c != null && triggeredSponsor.CAMPX__Status__c == 'Accepted' && triggeredSponsor.CAMPX__Event__c != null) {
                eventId = triggeredSponsor.CAMPX__Event__c;
                List <AggregateResult> sumOfContributions = [SELECT SUM (CAMPX__ContributionAmount__c) totalContributions FROM CAMPX__Sponsor__c WHERE CAMPX__Event__c = :eventId AND CAMPX__Status__c = 'Accepted'];
                System.debug('Sum of contributions for the event '+ eventId + ' = ' + sumOfContributions);
    //Stock la somme totale des contrib pour cet event
                totalOfContibutions = (Decimal)sumOfContributions[0].get('totalContributions');
                System.debug('totalOfContributions variable : ' + totalOfContibutions);
            }
        }
    //Assigne la valeur des contribs à l'event
        System.debug('eventid avant la boucle sur les events : ' + eventId);
        for (CAMPX__Event__c eventToUpdate : eventsList) {
            if (eventToUpdate.Id == eventId) {
                System.debug('eventToUpdate Id : ' + eventToUpdate.Id);
                System.debug('eventToUpdate Gross Revenue before assignment : ' + eventToUpdate.CAMPX__GrossRevenue__c);
                System.debug('total des contributions avant assignement : ' + totalOfContibutions);
                if (totalOfContibutions != null) {
                    eventToUpdate.CAMPX__GrossRevenue__c = totalOfContibutions;
                    System.debug('event to update Gross Revenue : ' + eventToUpdate.CAMPX__GrossRevenue__c);
                    events2Update.add(eventToUpdate);
                }else if (totalOfContibutions == null) {
                    eventToUpdate.CAMPX__GrossRevenue__c = 0;
                    System.debug('event to update Gross Revenue est null');
                }
            }
        }update events2Update;
        System.debug('Les events suivants ont été updatés : ' + events2Update);
    }
}



 

















/*   
    
    public static void removeContribWhenEventOrSponsStatusIsChanged(List<CAMPX__Sponsor__c> newSpons, Map <id, CAMPX__Sponsor__c> oldSponsMap) {
        List<CAMPX__Event__c> events2BUpdated = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> listOfEventz = new List<CAMPX__Event__c>();
        System.debug('List of events : ' + listOfEventz);
        Id IdOfEvent;
        Decimal totalOfContibutions;

        if (Trigger.isUpdate) {
            //Boucle sur le trigger
            for (CAMPX__Sponsor__c triggSpon : newSpons) {
                //Récupère l'id de l'event associé au sponsor
                IdOfEvent = triggSpon.CAMPX__Event__c;
            }
            listOfEventz =  [SELECT id, Name, CAMPX__GrossRevenue__c,
                                (SELECT id, Name, CAMPX__ContributionAmount__c, CAMPX__Event__c from CAMPX__Sponsors__r)
                                FROM Campx__Event__c WHERE id = IdOfEvent;
                            ]
            System.debug('List of events : ' + listOfEventz);

            for (CAMPX__Event__c ev2Update : listOfEventz) {
                if (ev2Update.ID == ev2Update.CAMPX__Sponsors__r.CAMPX__Event__c && ev2Update.CAMPX__Sponsors__r.campx ) {
                    ev2Update.CAMPX__GrossRevenue__c 
                    
                }
                
            }
        }



    public static void removeContribWhenEventOrSponsStatusIsChanged(List<CAMPX__Sponsor__c> newSpons, Map <id, CAMPX__Sponsor__c> oldSponsMap) {

        List<CAMPX__Event__c> events2BUpdated = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> listOfEventz = [SELECT id, Name, CAMPX__GrossRevenue__c FROM Campx__Event__c];
        System.debug('List of events : ' + listOfEventz);
        Id IdOfEvent;
        Decimal totalOfContibutions;
        CAMPX__Sponsor__c oldSponsor;

        
        //Si Update
        if (Trigger.isUpdate) {
            
        //Boucle sur le trigger
            for (CAMPX__Sponsor__c triggSpon : newSpons) {
        //Récupère l'id de l'event associé au sponsor
                IdOfEvent = triggSpon.CAMPX__Event__c;
            
        //Récupère les anciennes valeurs du Sponsor
                oldSponsor = oldSponsMap.get(triggSpon.id);
                System.debug('old sponsor status : ' + oldSponsor.CAMPX__Status__c);

                
        //Si le statut n'est plus accepted ou si le sponsor change d'event
                if ((triggSpon.CAMPX__Status__c != 'Accepted' && oldSponsor.CAMPX__Status__c == 'Accepted') || (triggSpon.CAMPX__Event__c != oldSponsor.CAMPX__Event__c)){

        //Additionne les contribution de tous les sponsors de cet event
                    List <AggregateResult> sumOfContributions = [SELECT SUM (CAMPX__ContributionAmount__c) totalContributions FROM CAMPX__Sponsor__c WHERE CAMPX__Event__c = :IdOfEvent  AND CAMPX__Status__c = 'Accepted'];
                    System.debug('Sum of contributions for the event '+ IdOfEvent + ' = ' + sumOfContributions);
        //Retire la contribution du sponsor en question
                    totalOfContibutions = (Decimal)sumOfContributions[0].get('totalContributions');
                    System.debug('totalOfContributions variable : ' + totalOfContibutions);
                }

        //Boucle sur les events
                for (CAMPX__Event__c eventToUpdate : listOfEventz) {
                    if (eventToUpdate.Id == IdOfEvent) {
                        System.debug('eventToUpdate Id : ' + eventToUpdate.Id);
                        System.debug('eventToUpdate Gross Revenue before assignment : ' + eventToUpdate.CAMPX__GrossRevenue__c);
                        
                        if (totalOfContibutions != null) {
                            eventToUpdate.CAMPX__GrossRevenue__c = totalOfContibutions;
                            events2BUpdated.add(eventToUpdate);
                        }
                    }
                }
            } update events2BUpdated;
        }
    }


    /*     public static void updateEventGrossRevenueWhenSponsAccepted(List<CAMPX__Sponsor__c> newSponsors, Map <id, CAMPX__Sponsor__c> oldSponsorsMap) {
        List<CAMPX__Event__c> listOfAllEvents = [SELECT id, CAMPX__GrossRevenue__c FROM Campx__Event__c];
        System.debug('List of all events' + listOfAllEvents);
        List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();
        CAMPX__Sponsor__c oldSponsor;
        Id sponsorEventId;
        for (CAMPX__Sponsor__c newSponsor : newSponsors) {

            if (oldSponsorsMap != null && oldSponsorsMap.containsKey(newSponsor.Id)){
                oldSponsor = oldSponsorsMap.get(newSponsor.Id);
                System.debug('oldSponsor : ' + oldSponsor);
            } else {
                    System.debug('oldSponsorsMap est null : ' + oldSponsorsMap);
            }

            //on récupère l'Id de l'event auquel le sponsor est rattaché
            if (newSponsor.CAMPX__Event__c != null) {
                sponsorEventId = newSponsor.CAMPX__Event__c;
                System.debug('sponsorEventId : ' + sponsorEventId);
            } else {
                System.debug('newSponsor event est null : ' + newSponsor.Campx__Event__c);
            }
            
            //Si le statut du sponsor est à accepté
            if (newSponsor.CAMPX__Status__c == 'Accepted') {
                //on récupère l'event lié
                for (CAMPX__Event__c eventToUpdate : listOfAllEvents) {
                    if (eventToUpdate.Id == sponsorEventId) {
                        System.debug('eventToUpdate.id : ' + eventToUpdate.id);
                        
                        //on ajoute le montant de la contrib du sponsor au gross revenue de l'event.
                        if (newSponsor.CAMPX__ContributionAmount__c >0) {
                            System.debug('Montant de la contrib du sponsor : ' + newSponsor.CAMPX__ContributionAmount__c);
                            eventToUpdate.CAMPX__GrossRevenue__c = newSponsor.CAMPX__ContributionAmount__c;
                            System.debug('Nouveau montant du Event CAMPX__GrossRevenue__c : ' + eventToUpdate.CAMPX__GrossRevenue__c);
                            eventsToUpdate.add(eventToUpdate);
                        }
                    }
                }
            }
        }update eventsToUpdate;
    } */