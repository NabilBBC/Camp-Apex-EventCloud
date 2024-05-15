trigger updateSponsorTierUponContribution on CAMPX__Sponsor__c (before insert, before update) {

    for (CAMPX__Sponsor__c sponsor : trigger.new) {
        if (sponsor.CAMPX__ContributionAmount__c != null || sponsor.CAMPX__ContributionAmount__c >= 0) {
            if (sponsor.CAMPX__ContributionAmount__c >0 && sponsor.CAMPX__ContributionAmount__c <1000) {
                sponsor.CAMPX__Tier__c = 'Bronze';
                break;
            }
            if (sponsor.CAMPX__ContributionAmount__c >= 1000 && sponsor.CAMPX__ContributionAmount__c <5000) {
                sponsor.CAMPX__Tier__c = 'Silver';
                break;
            }
            if (sponsor.CAMPX__ContributionAmount__c >= 5000) {
                sponsor.CAMPX__Tier__c = 'Gold';
                break;
            }
        }
    }
}