
<cfif  NOT structKeyExists(session, "userid") OR  session.userid EQ "" OR session.userid IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false" >
</cfif>



<cfset datasource="dsn_addressbook">
<cfparam name="form.currentPage" default="1">
<cfparam name="form.recordsPerPage" default="10">
<cfif structKeyExists(URL, "currentPage")>
    <cfset currentPage = val(URL.currentPage)>
<cfelseif structKeyExists(form, "currentPage")>
    <cfset currentPage = val(form.currentPage)>
<cfelse>
    <cfset currentPage = 1>
</cfif>
<cfset recordsPerPage = val(form.recordsPerPage)>
<cfset startRecord = (currentPage - 1) * recordsPerPage>




<cfquery name="qryTotalContacts" datasource="#datasource#">
    select COUNT(*) as totalCount
    from contacts
</cfquery>

<cfset totalcontacts=qryTotalContacts.totalCount>
<cfset totalpages=ceiling(totalcontacts/recordsPerPage)>


<cffunction name="getContacts" returnType="query">
    <cfset var qryResults = "">
    <cfset var datasource = "dsn_addressbook">
    <cfquery name="qryResults" datasource="#datasource#">
        SELECT *
        FROM contacts
       ORDER BY intContactId
        LIMIT <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryResults>
</cffunction>


<!---pagination--->
<cfset contactData = getContacts()>






<!-- Query user permissions during login -->
<cfquery name="qryUserPermissions" datasource="dsn_addressbook">
    SELECT int_permission_id
    FROM tbl_user_permissions
    WHERE int_user_id = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<!-- Store permissions in SESSION -->
<cfset SESSION.permissions = ArrayNew(1)>
<cfloop query="qryUserPermissions">
    <cfset ArrayAppend(SESSION.permissions, qryUserPermissions.int_permission_id)>
</cfloop>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/file.css">
</head>
<body>
<div class="header">
    <img src="../img/logo.png" alt="logo" class="logo">
    <a href="fullcontacts.cfm">Home</a>
    <a href="fullcontacts.cfm">Contacts</a>
    <a href="index.cfm">Create Contact</a>
    <a href="../userlogin.cfm" class="moveright">Log out</a>
</div>
<h1 align="center">CONTACT LIST</h1>
<table class="table table-bordered" align="center" style="border-color:#82a5c7;">
    <thead>
        <tr>
            <th>Firstname</th>
            <th>Lastname</th>
            <th>Details</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="contactData">
            <tr>
                <td>#strFirstName#</td>
                <td>#strLastName#</td>
                <td>
                    <!-- Link to the details page with the contactId -->
                   

                    <cfif ArrayContains(SESSION.permissions, 1)>
                        <a href="userdetails.cfm?contactId=#intContactId#" class="text-decoration-none">
                            view Details
                        </a>
                    </cfif>
                </td>
                <td>
                    <!-- Conditionally display Edit and Delete buttons -->
                    
                    <!-- Edit Button (Permission ID: 2) -->
                    <cfif ArrayContains(SESSION.permissions, 2)>
                        <a href="editcontact.cfm?contactId=#intContactId#" class="btn btn-warning btn-sm">
                            Edit
                        </a>
                    </cfif>
                    
                    <!-- Delete Button (Permission ID: 3) -->
                    <cfif ArrayContains(SESSION.permissions, 3)>
                        <a href="deletecontact.cfm?contactId=#intContactId#" 
                           class="btn btn-danger btn-sm" 
                           onclick="return confirm('Are you sure you want to delete this contact?');">
                            Delete
                        </a>
                    </cfif>

                   
                </td>
            </tr>
        </cfoutput>
    </tbody>
</table>
<cfoutput>
<nav aria-label="Page navigation">
    <ul class="pagination">
        <!-- Previous Button -->
        <cfif currentPage GT 1>
            <li class="page-item">
                <a class="page-link" href="fullcontacts.cfm?currentPage=#currentPage - 1#" aria-label="Previous">Previous</a>
            </li>
        </cfif>

        <!-- Page Numbers -->
        <cfloop index="i" from="1" to="#totalPages#">
            <li class="page-item <cfif i EQ currentPage>active</cfif>">
                <a class="page-link" href="fullcontacts.cfm?currentPage=#i#">#i#</a>
            </li>
        </cfloop>

        <!-- Next Button -->
        <cfif currentPage LT totalPages>
            <li class="page-item">
                <a class="page-link" href="fullcontacts.cfm?currentPage=#currentPage + 1#" aria-label="Next">Next</a>
            </li>
        </cfif>
    </ul>
</nav>

</cfoutput>
</body>
</html>
