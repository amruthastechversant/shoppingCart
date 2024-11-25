<cfif  NOT structKeyExists(session, "adminid") OR  session.adminid EQ "" OR session.adminid IS 0>
    <cflocation url="../loginasadmin.cfm" addtoken="false" >
</cfif>

<cfparam name="form.currentPage" default="1">
<cfparam name="form.recordsPerPage" default="5">
<cfif structKeyExists(URL, "currentPage")>
    <cfset currentPage = val(URL.currentPage)>
<cfelseif structKeyExists(form, "currentPage")>
    <cfset currentPage = val(form.currentPage)>
<cfelse>
    <cfset currentPage = 1>
</cfif>
<cfset recordsPerPage = val(form.recordsPerPage)>
<cfset startRecord = (currentPage - 1) * recordsPerPage>

<cfquery name="qryGetPermissionOptions" datasource="dsn_addressbook">
    SELECT int_permission_id AS permissionid, str_permissions AS permission
    FROM tbl_permissions
</cfquery>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/file.css">
    <title>User Management</title>
</head>
<cfoutput>
<body>

<cfset datasource="dsn_addressbook">



<!-- Total Pending Users -->
<cfquery name="qryTotalPendingUsers" datasource="#datasource#">
    SELECT COUNT(*) AS totalCount
    FROM tbl_users
    WHERE cbr_status = 'P'
</cfquery>

<cfset totalPendingRecords = qryTotalPendingUsers.totalCount><!---28--->
<cfset totalPendingPages = Ceiling(totalPendingRecords / recordsPerPage)><!---6--->

<!-- Total Approved Users -->
<cfquery name="qryTotalApprovedUsers" datasource="#datasource#">
    SELECT COUNT(*) AS totalCount
    FROM tbl_users
    WHERE cbr_status = 'A'
</cfquery>

<cfset totalApprovedRecords = qryTotalApprovedUsers.totalCount><!---28--->
<cfset totalApprovedPages = Ceiling(totalApprovedRecords / recordsPerPage)><!---6--->

<cfquery name="qryPendingUsers" datasource="#datasource#">
    SELECT Id, str_name, str_phone, str_username 
    FROM tbl_users 
    WHERE cbr_status = 'P' 
    <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
        AND (
            str_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            OR str_phone LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>

    ORDER BY id
    LIMIT <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
 </cfquery> 

<cfquery name="qryApprovedUsers" datasource="#datasource#">
    SELECT Id, str_name, str_phone, str_username 
    FROM tbl_users 
    WHERE cbr_status = 'A'
    AND str_username != 'admin'
    <!--- Check if keyword filtering is applicable --->
    <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
        AND (
            str_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            OR str_phone LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>
    ORDER BY id
    LIMIT <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
</cfquery>




<div class="sidebar ">
            <img src="../img/logo.png" alt="logo" class="logo">
            <a href="">Home</a>
            <a href="../user/fullcontacts.cfm">Contacts</a>
           
            <a href="adminlogout.cfm" class="moveright">Log out</a>
        </div>

<div class="container mt-5" style="margin-left:170px;">
    <h2 class="text-center">User Management</h2>
    
    <!--- Pending Users Section --->
    <div class=" d-flex justify-content-between">
    <h3>Pending User Approvals</h3>
    <form class="form-inline " action="admindashboard.cfm" method="post">
      <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" id="str_keyword" name="str_keyword" value="<cfif structKeyExists(form,"str_keyword")> #form.str_keyword#</cfif>">
      <button class="btn btn-outline-success my-2 my-sm-0" type="submit" >Search</button>    
    </form>
    </div>
       

    <table border="1" class="table table-bordered table-hover table-striped w-100">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Username</th>
                <th>Permissions</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <cfif qryPendingUsers.recordCount>
                <cfloop query="qryPendingUsers">
                    <tr>
                        <td>#id# </td>
                        <td>#str_name#</td>
                        <td>#str_phone#</td>
                        <td>#str_username#</td>
                        <td>
                            <cfquery name="qryUserPermissions" datasource="#datasource#">
                             SELECT int_permission_id
                            FROM tbl_user_permissions
                            WHERE int_user_id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
                            </cfquery>
                            <cfset variables.int_user_permission_list = valuelist(qryUserPermissions.int_permission_id)>

                            <form action="savepermission.cfm" method="post" class="text-center">
                            <cfloop query="qryGetPermissionOptions">                            
                                <input type="checkbox" class="form-check-input" name="int_permission_id_list" 
                                value="#qryGetPermissionOptions.permissionid#" 
                                 id="int_permission_id_list_#qryPendingUsers.Id#" 
                                <cfif ListContains("#variables.int_user_permission_list#",qryGetPermissionOptions.permissionid)>checked</cfif>>
                                    <label for="int_permission_id_list_#qryPendingUsers.Id#" class="form-check-label">
                                     #qryGetPermissionOptions.permission#
                                    </label>
                            </cfloop>
                                    <div class="d-inline-block ">
                                    <input type="hidden" name="id" value="#qryPendingUsers.Id#">
                                    <button type="submit" class="btn btn-primary btn-sm px-2 py-1 ">Save</button>
                                     </div>
                            </form>


                         </td>
                       <td>
                            <form action="approveuser.cfm" method="post" style="display: inline;">
                            <input type="hidden" name="id" value="#id#">
                            <button type="submit" class="btn btn-success btn-lg">Approve</button>
                            </form>
                        </td>
                    </tr>
                </cfloop>
            <cfelse>
                <tr>
                    <td colspan="3" class="text-center text-danger">No Pending Users</td>
                </tr>
            </cfif>
        </tbody>
    </table>    
 <nav aria-label="Page navigation">
    <ul class="pagination">
        <!-- Previous Button -->
        <cfif currentPage GT 1>
            <li class="page-item">
                <a class="page-link" href="admindashboard.cfm?currentPage=#currentPage - 1#" aria-label="Previous">Previous</a>
            </li>
        </cfif>

        <!-- Page Numbers -->
        <cfloop index="i" from="1" to="#totalPendingPages#">
            <li class="page-item <cfif i EQ currentPage>active</cfif>">
                <a class="page-link" href="admindashboard.cfm?currentPage=#i#">#i#</a>
            </li>
        </cfloop>

        <!-- Next Button -->
        <cfif currentPage LT totalPendingPages>
            <li class="page-item">
                <a class="page-link" href="admindashboard.cfm?currentPage=#currentPage + 1#" aria-label="Next">Next</a>
            </li>
        </cfif>
    </ul>
</nav>
    <!-- Approved Users Section -->
    <h3>Approved Users</h3>
    <table border="1" class="table table-bordered table-hover table-striped w-100">
        <thead class="table-dark">  
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Username</th>
                <th>Permissions</th>
                <th>Action</th>
            </tr>
        </thead>    
        <tbody>
            <cfif qryApprovedUsers.recordCount>
                <cfloop query="qryApprovedUsers">
                    <tr>
                        <td>#id#</td>
                        <td>#str_name#</td>
                        <td>#str_phone#</td>
                        <td>#str_username#</td>
                        <td>
                            <cfquery name="qryUserPermissions" datasource="#datasource#">
                             SELECT int_permission_id
                            FROM tbl_user_permissions
                            WHERE int_user_id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
                            </cfquery>
                            <cfset variables.int_user_permission_list = valuelist(qryUserPermissions.int_permission_id)>

                            <form action="savepermission.cfm" method="post" style="display: inline;">
                            <cfloop query="qryGetPermissionOptions">                            
                                <input type="checkbox" class="form-check-input" name="int_permission_id_list" 
                                value="#qryGetPermissionOptions.permissionid#" 
                                 id="int_permission_id_list_#qryApprovedUsers.Id#" 
                                <cfif ListContains("#variables.int_user_permission_list#",qryGetPermissionOptions.permissionid)>checked</cfif>>
                                    <label for="int_permission_id_list_#qryApprovedUsers.Id#" class="form-check-label">
                                     #qryGetPermissionOptions.permission#
                                    </label>
                            </cfloop>
                                    <div class="text-end">
                                    <input type="hidden" name="id" value="#qryApprovedUsers.Id#">
                                    <button type="submit" class="btn btn-primary btn-sm">Save</button>
                                     </div>
                            </form>


                         </td>
                       <td>No Action Required</td>
                    </tr>
                </cfloop>
            <cfelse>
                <tr>
                    <td colspan="4" class="text-center text-success">No Approved Users</td>
                </tr>
            </cfif>
        </tbody>
    </table>

<nav aria-label="Page navigation">
    <ul class="pagination">
        <!-- Previous Button -->
        <cfif currentPage GT 1>
            <li class="page-item">
                <a class="page-link" href="admindashboard.cfm?currentPage=#currentPage - 1#" aria-label="Previous">Previous</a>
            </li>
        </cfif>

        <!-- Page Numbers -->
        <cfloop index="i" from="1" to="#totalApprovedPages#">
            <li class="page-item <cfif i EQ currentPage>active</cfif>">
                <a class="page-link" href="admindashboard.cfm?currentPage=#i#">#i#</a>
            </li>
        </cfloop>

        <!-- Next Button -->
        <cfif currentPage LT totalApprovedPages>
            <li class="page-item">
                <a class="page-link" href="admindashboard.cfm?currentPage=#currentPage + 1#" aria-label="Next">Next</a>
            </li>
        </cfif>
    </ul>
</nav>

</div>

<div class=" footer">
			<a class="p-0 px-md-3 px-1"href="https://www.amazon.in/gp/help/customer/display.html?nodeId=200507590&ref_=footer_gw_m_b_he">Copyright Info</a>
			<a class="p-0 px-md-3 px-1"  href="https://www.facebook.com/login.php">References</a>
			<a class="p-0 px-md-3 px-1" href="htmlpage.html">Contact</a>
</div>
       
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
</cfoutput>