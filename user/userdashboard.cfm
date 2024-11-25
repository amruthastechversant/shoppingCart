<cfif not structKeyExists(session, "userid")>
    <cflocation url="userlogin.cfm">
</cfif>

<h2>My Contacts</h2>

<!-- Display user contacts -->
<cfquery name="qryContacts" datasource="dsn_addressbook">
    SELECT * 
    FROM contacts 
    WHERE userid = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>
    <table border="1">
        <tr><th>strFirstname</th><th>strLastname</th><th>strEducation</th><th>strProfile</th><th>intAge</th><th>strGender</th><th>intphoneNo</th><th>strHobbies</th><th>strAddress</th></tr>
        <cfloop query="qryContacts">
            <tr>
                <td>#strFirstname#</td>
                <td>#strLastname#</td>
                <td>#strEducation#</td>
                <td>#strProfile#</td>
                <td>#intAge#</td>
                <td>#strGender#</td>
                <td>#intphoneNo#</td>
                <td>#strHobbies#</td>
                <td>#strAddress#</td>
            </tr>
        </cfloop>
    </table>
</cfoutput>
