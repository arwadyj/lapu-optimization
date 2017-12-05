<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Abort_Task</fullName>
        <field>Status</field>
        <literalValue>Closed - Stage change closed all open tasks</literalValue>
        <name>Abort Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Number_of_Attempts_Update</fullName>
        <field>Number_of_Attempts__c</field>
        <formula>Number_of_Attempts__c +1</formula>
        <name>Number of Attempts Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
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
    <fieldUpdates>
        <fullName>Update_UC_Activity_Type_Call</fullName>
        <field>UC_Activity_Type__c</field>
        <literalValue>Call</literalValue>
        <name>Update UC Activity Type Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_UC_Activity_Type_Email</fullName>
        <field>UC_Activity_Type__c</field>
        <literalValue>Email</literalValue>
        <name>Update UC Activity Type Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contacted Task Close if Stage is Different</fullName>
        <actions>
            <name>Abort_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5 OR 6 OR 7 OR 8)</booleanFilter>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Stage_on_Task__c</field>
            <operation>notEqual</operation>
            <value>Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Stage_on_Task__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Alexandra Martin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Tyler Kluz</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Haily Osterhaus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Maricris Dar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Jason Elliott</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inquiry Task Close if Stage is Different</fullName>
        <actions>
            <name>Abort_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5 OR 6 OR 7 OR 8)</booleanFilter>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Stage_on_Task__c</field>
            <operation>notEqual</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Stage_on_Task__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Alexandra Martin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Tyler Kluz</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Haily Osterhaus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Maricris Dar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>equals</operation>
            <value>Jason Elliott</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Number of Attempts Update</fullName>
        <actions>
            <name>Number_of_Attempts_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Unable to Communicate with Student</value>
        </criteriaItems>
        <description>Updates Number of Attempts with +1</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Over Due Task</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.ActivityDate</field>
            <operation>greaterThan</operation>
            <value>LAST 4 DAYS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Overdue Task Reassignment</fullName>
        <actions>
            <name>Change_overdue_task_assignment</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.ActivityDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Completed Date on Task Completed</fullName>
        <actions>
            <name>Set_Completed_Date_to_Current_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update the Completed Date field with the current date when a Task is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Close if Stage is Different</fullName>
        <actions>
            <name>Abort_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Stage_on_Task__c</field>
            <operation>notEqual</operation>
            <value>Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Stage_on_Task__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UC Activity Type</fullName>
        <actions>
            <name>Update_UC_Activity_Type_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>Call</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UC Email Activity Type</fullName>
        <actions>
            <name>Update_UC_Activity_Type_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>→ Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>← Email</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Change_overdue_task_assignment</fullName>
        <assignedTo>jrmteam.apu@jenzabar.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Change overdue task assignment</subject>
    </tasks>
</Workflow>
