public with sharing class EventTriggerHandler {

    public static void beforeInsert(List<Campx__Event__c> newEvents) {
        for (Campx__Event__c event : newEvents) {
            event.CAMPX__Status__c = 'Planning';
            event.CAMPX__StatusChangeDate__c = Datetime.now();
            }
        }

    public static void updateDateTimeStatusChange(List<CAMPX__Event__c> newEvents, Map<Id, CAMPX__Event__c> oldEventMap) {
        for (CAMPX__Event__c event : newEvents) {
            CAMPX__Event__c oldEvent = oldEventMap.get(event.id);
            if (event.CAMPX__Status__c != oldEvent.CAMPX__Status__c) {
                event.CAMPX__StatusChangeDate__c = Datetime.now();
            }
        }
    }

    public static void calculateNetRevenue(List<Campx__Event__c> newEvents) {
        for (Campx__Event__c currentEvent : newEvents) {
            if (currentEvent.CAMPX__GrossRevenue__c != null && currentEvent.CAMPX__TotalExpenses__c != null) {
                currentEvent.CAMPX__NetRevenue__c = currentEvent.CAMPX__GrossRevenue__c - currentEvent.CAMPX__TotalExpenses__c;                
            }
            if (currentEvent.CAMPX__GrossRevenue__c == null || currentEvent.CAMPX__TotalExpenses__c == null) {
                currentEvent.CAMPX__NetRevenue__c = null;
            }
        }
    }
}