<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Completed_Date_to_Current_Date</fullName>
        <description>Sets the Completed Date field to the current date</description>
        <field>Completed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Completed Date to Current Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Completed Date on Task Completed</fullName>
        <actions>
            <name>Set_Completed_Date_to_Current_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Update the Completed Date field with the current date when a Task is marked "Completed."</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
