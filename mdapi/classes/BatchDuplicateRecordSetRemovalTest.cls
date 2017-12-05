@isTest
private class BatchDuplicateRecordSetRemovalTest {

    @TestSetup
    static void setup() {
        
        //Create two Leads with the same phone number (duplicates)
        List<Lead> duplicateLeads = new List<Lead>();
        
        Lead lead1 = new Lead();
        
        lead1.FirstName = 'Test';
        lead1.LastName = 'Lead1';
        lead1.Company = 'ABC Company';
        lead1.Phone = '(111) 111-1111';
        
        duplicateLeads.add(lead1);
        
        Lead lead2 = new Lead();
        
        lead2.FirstName = 'Test';
        lead2.LastName = 'Lead2';
        lead2.Company = 'ABC Company';
        lead2.Phone = '(111) 111-1111';
        
        duplicateLeads.add(lead2);
        
        insert duplicateLeads;
        
        //Create Duplicate Record Set
        
        //---Query for a Duplicate Rule NOTE: There MUST be at least one Duplicate Rule in the configuration
        DuplicateRule dupeRule = [SELECT Id FROM DuplicateRule][0];
        
        DuplicateRecordSet dupeSet = new DuplicateRecordSet();
        
        dupeSet.DuplicateRuleId = dupeRule.Id;
        
        insert dupeSet;
        
        //Create Two Duplicte Record Items
        
        List<DuplicateRecordItem> dupeItemList = new List<DuplicateRecordItem>();
        
        DuplicateRecordItem dupeItem1 = new DuplicateRecordItem();
        
        dupeItem1.DuplicateRecordSetId = dupeSet.Id;
        dupeItem1.RecordId = lead1.Id;
        
        dupeItemList.add(dupeItem1);
        
        DuplicateRecordItem dupeItem2 = new DuplicateRecordItem();
        
        dupeItem2.DuplicateRecordSetId = dupeSet.Id;
        dupeItem2.RecordId = lead2.Id;
        
        dupeItemList.add(dupeItem2);
        
        insert dupeItemList;
        
        //Verify that a Duplicate Record Set and Duplicate Record Items were Created
        List<DuplicateRecordSet> duplicateRecordSetList = new List<DuplicateRecordSet>();
        duplicateRecordSetList = [SELECT Id FROM DuplicateRecordSet];
        
        System.assertEquals(1, duplicateRecordSetList.size(), '### There should have been one Duplicate Record Set created; instead ' + duplicateRecordSetList.size() + ' were created. ###');
        
        List<DuplicateRecordItem> dupeItems = new List<DuplicateRecordItem>();
        dupeItems = [SELECT Id FROM DuplicateRecordItem WHERE DuplicateRecordSetId = :duplicateRecordSetList[0].Id];
        
        System.assertEquals(2, dupeItems.size(), '### There should have been two Duplicate Record Items created; instead ' + dupeItems.size() + ' were created. ###');
    }
    
    @isTest
    static void batchApexLogic() {
        
        //Query for Duplicate Record Items
        List<DuplicateRecordItem> duplicateRecordItemList = new List<DuplicateRecordItem>();
        duplicateRecordItemList = [SELECT Id FROM DuplicateRecordItem];
        
        System.assertEquals(2, duplicateRecordItemList.size(), '### There should have been two Duplicate Record Items created; instead ' +duplicateRecordItemList.size() + ' were created. ###');
        
        delete duplicateRecordItemList[0];
        
        Test.startTest();
        
        BatchDuplicateRecordSetRemoval batchDuplicateRecordSetRemoval = new BatchDuplicateRecordSetRemoval();
        Database.executeBatch(batchDuplicateRecordSetRemoval);
        
        Test.stopTest();
        
        List<DuplicateRecordSet> deletedDuplicateRecordSets = new List<DuplicateRecordSet>();
        
        deletedDuplicateRecordSets = [SELECT Id FROM DuplicateRecordSet];
        
        System.assertEquals(0, deletedDuplicateRecordSets.size(), '### There should be no Duplicate Record Sets; instead there are/is ' + deletedDuplicateRecordSets.size() + ' ###');
    }
    
    @isTest
    static void positiveFunctionBulk() {
        
        //Remove Existing Data
        delete [SELECT Id FROM DuplicateRecordSet][0];
        
        //Query for a Lead
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead1' LIMIT 1];
        
        //---Query for a Duplicate Rule NOTE: There MUST be at least one Duplicate Rule in the configuration
        DuplicateRule dupeRule = [SELECT Id FROM DuplicateRule][0];
        
        //Create 200 Duplicate Record Sets with One Child Duplicate Record Item Eaach
        List<DuplicateRecordSet> duplicateRecordSetsToInsert = new List<DuplicateRecordSet>();
        
        for(Integer i=0; i<200; i++) {
            
            DuplicateRecordSet dupeSet = new DuplicateRecordSet();
            
            dupeSet.DuplicateRuleId = dupeRule.Id;
            
            duplicateRecordSetsToInsert.add(dupeSet);
        }
        
        insert duplicateRecordSetsToInsert;
        
        List<DuplicateRecordItem> dupeItemList = new List<DuplicateRecordItem>();
        
        for(DuplicateRecordSet each :duplicateRecordSetsToInsert) {
            
            DuplicateRecordItem dupeItem = new DuplicateRecordItem();
            
            dupeItem.DuplicateRecordSetId = each.Id;
            dupeItem.RecordId = lead.Id;
            
            dupeItemList.add(dupeItem);
        }
        
        insert dupeItemList;
        
        Test.startTest();
        
        BatchDuplicateRecordSetRemoval batchDuplicateRecordSetRemoval = new BatchDuplicateRecordSetRemoval();
        Database.executeBatch(batchDuplicateRecordSetRemoval);
        
        Test.stopTest();
        
        List<DuplicateRecordSet> deletedDuplicateRecordSets = new List<DuplicateRecordSet>();
        
        deletedDuplicateRecordSets = [SELECT Id FROM DuplicateRecordSet];
        
        System.assertEquals(0, deletedDuplicateRecordSets.size(), '### There should be no Duplicate Record Sets; instead there are/is ' + deletedDuplicateRecordSets.size() + ' ###');
    }
}