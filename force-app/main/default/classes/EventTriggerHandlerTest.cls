
@isTest
private class EventTriggerHandlerTest {

    @isTest
    private static void assignPlanningStatusAtInsert() {
        CAMPX__Event__c testEvent = new CAMPX__Event__c(
            Name = 'Firt Test Event'
        );
        
        Test.startTest();
        insert testEvent;
        Test.stopTest();

        testEvent = [SELECT CAMPX__Status__c FROM CAMPX__Event__c WHERE Name = 'Firt Test Event'];
        Assert.areEqual('Planning', testEvent.CAMPX__Status__c);
    }

    @isTest
    private static void captureStatusChangeDate() {
        
    }
}