trigger EventTrigger on CAMPX__Event__c (before insert, before update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        EventTriggerHandler.beforeInsert(Trigger.New);
        system.debug('beforeInsert');

    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        EventTriggerHandler.updateDateTimeStatusChange(Trigger.new, Trigger.oldMap);
        system.debug('updateDateTimeStatusChange');
    }

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        EventTriggerHandler.calculateNetRevenue(Trigger.New);
    }
}