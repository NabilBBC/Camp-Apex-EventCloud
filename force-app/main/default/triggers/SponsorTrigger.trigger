trigger SponsorTrigger on CAMPX__Sponsor__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        SponsorTriggerHandler.updateSponsorStatusAtCreation(trigger.new);
       SponsorTriggerHandler.preventSponsorCreationWithoutEmail(trigger.new);
    }
    if (Trigger.isBefore && Trigger.isInsert) {
        system.debug('le trigger appelle la méthode assignTierToSponsor');
        SponsorTriggerHandler.assignTierToSponsor(trigger.new);
        system.debug('le trigger appelle la méthode preventSponsorAcceptedWithoutEvent');
        SponsorTriggerHandler.preventSponsorAcceptedWithoutEvent(trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        system.debug('le trigger appelle la méthode updateSponsorStatusAtUpdate');
        SponsorTriggerHandler.updateSponsorStatusAtUpdate(trigger.new);
        system.debug('le trigger appelle la méthode assignTierToSponsor');
        SponsorTriggerHandler.assignTierToSponsor(trigger.new);
        system.debug('le trigger appelle la méthode preventSponsorAcceptedWithoutEvent');
        SponsorTriggerHandler.preventSponsorAcceptedWithoutEvent(trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isInsert) {
        system.debug('le trigger appelle la méthode updateEventRevenueWithSponsorContribAtCreation');
        SponsorTriggerHandler.updateEventRevenueWithSponsorContribAtCreation(trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        system.debug('le trigger appelle la méthode updateEventRevenueWithSponsorContribAtUpdate');
        SponsorTriggerHandler.updateEventRevenueWithSponsorContribAtUpdate(trigger.new, trigger.oldMap);
    }
}