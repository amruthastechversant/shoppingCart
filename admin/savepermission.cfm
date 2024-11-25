<cfif NOT structKeyExists(session, "adminid") OR session.adminid EQ "" OR session.adminid IS 0>
    <cflocation url="../loginasadmin.cfm" addtoken="false">
</cfif>

<cfset int_user_id = form.id>
<cfif NOT structKeyExists(form, "id") OR NOT isNumeric(int_user_id) OR int_user_id EQ "">
    <cflocation url="InvalidUserId" addtoken="false">
</cfif>

 <cfset datasource="dsn_addressbook">

<cfparam name="form.id" default="">
<cfparam name="form.int_permission_id_list" default="">

<!-- Initialize permissions as an empty array if not already an array -->
<cfset permissions = []> 

<cfif structKeyExists(form, "int_permission_id_list") AND isArray(form.int_permission_id_list)>
    <!-- If form.permissions is an array, assign it to permissions -->
    <cfset permissions = form.int_permission_id_list>
<cfelseif structKeyExists(form, "int_permission_id_list") AND len(form.int_permission_id_list) GT 0>
    <!-- If form.permissions is a string, convert it to an array -->
    <cfset permissions = listToArray(form.int_permission_id_list)>
<cfelse>
    <!-- Otherwise, leave permissions as an empty array -->
    <cfset permissions = []>
</cfif>



 <cfquery datasource="dsn_addressbook" name="qryDeletePermission">
        DELETE FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>

<!-- Check if permissions are not empty -->
<cfif arrayLen(permissions) GT 0>
    <cfloop index="i" from="1" to="#arrayLen(permissions)#">
        <!-- Ensure permission is not empty -->
        <cfif permissions[i] NEQ "">
            <cfquery name="qryUserPermissions" datasource="#datasource#">
                INSERT INTO tbl_user_permissions (int_user_id, int_permission_id)
                VALUES (
                    <cfqueryparam value="#int_user_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#permissions[i]#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
      
        </cfif>
    </cfloop>
</cfif>
<cflocation url="admindashboard.cfm" addtoken="false">