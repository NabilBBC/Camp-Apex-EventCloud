trigger SubstractSponsorContribution on CAMPX__Sponsor__c (before update) {

    List<CAMPX__Sponsor__c> oldSponsors = new List<CAMPX__Sponsor__c>();
    
    for (CAMPX__Sponsor__c sponsor : trigger.new) {

        /*When the CAMPX__Status__c of a CAMPX__Sponsor__c changes from "Accepted" to "Cancelled" or "Pending"
        the associated CAMPX__Event__c's CAMPX__GrossRevenue__c field should no longer reflect the sponsor's CAMPX__ContributedAmount__c*/
        for (CAMPX__Sponsor__c sponsor : trigger.old) {

            
        }


        /*When the CAMPX__Event__c lookup of a CAMPX__Sponsor__c changes,
        the previously associated CAMPX__Event__c's CAMPX__GrossRevenue__c field should no longer reflect the sponsor's CAMPX__ContributedAmount__c */
        
    }

}

