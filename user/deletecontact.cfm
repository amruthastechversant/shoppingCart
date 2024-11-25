<cfif NOT structKeyExists(session, "userid") OR session.userid EQ "" OR session.userid IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false">
</cfif>

<!-- Check if the user has delete permission (Permission ID 3) -->
<cfif NOT ArrayContains(SESSION.permissions, 3)>
    <cfset errorMessage = "You do not have permission to delete contacts.">
    <cfoutput>#errorMessage#</cfoutput>
    <cflocation url="fullcontacts.cfm" addtoken="false">
</cfif>

<!-- Get the contactId from the URL -->
<cfset contactId = val(URL.contactId)>

<!-- Ensure the contactId is valid -->
<cfif contactId EQ 0 OR NOT isNumeric(contactId)>
    <cfset errorMessage = "Invalid contact ID.">
    <cfoutput>#errorMessage#</cfoutput>
    <cflocation url="fullcontacts.cfm" addtoken="false">
</cfif>

<!-- Perform the deletion -->
<cfquery name="deleteContact" datasource="dsn_addressbook">
    DELETE FROM contacts
    WHERE intContactId = <cfqueryparam value="#contactId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset successMessage = "Contact deleted successfully.">
<cfoutput>#successMessage#</cfoutput>

<!-- Redirect back to the contact list page -->
<cflocation url="fullcontacts.cfm" addtoken="false">
