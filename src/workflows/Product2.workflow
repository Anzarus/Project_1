<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Hot_Status</fullName>
        <field>Status__c</field>
        <literalValue>Hot</literalValue>
        <name>Set Hot Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Hot Status</fullName>
        <actions>
            <name>Set_Hot_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Price__c</field>
            <operation>greaterThan</operation>
            <value>1000</value>
        </criteriaItems>
        <description>set status on Hot when Price &gt; 1000</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
