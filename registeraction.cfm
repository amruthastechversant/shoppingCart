<!---setDefaultValues()
getFormValues()
validateFormValues()
saveContacts()--->

<cffunction  name="setDefaultValues" access="public" returnType="void">
    <cfset variables.success_msg = "">
    <cfset variables.error_msg = "">
    <cfset variables.str_name = "">
    <cfset variables.str_phone = "">
    <cfset variables.str_username = "">
    <cfset variables.str_password = "">
    <cfset variables.confirmpassword = "">
</cffunction>

<cffunction  name="getFormValues" access="public" returnType="void">
    <cfif structKeyExists(form, "usersave")>
        <cfset variables.str_name = form.name>
        <cfset variables.str_phone = form.phone>
        <cfset variables.str_username = form.username>
        <cfset variables.str_password = form.password>
        <cfset variables.confirmpassword = form.confirmpassword>
    </cfif>
</cffunction>


<!--- Control block --->
<cffunction  name="validateFormValues" returnType="string">
<cfargument name="name" type="string">
    <cfargument name="phone">
    <cfargument name="username" type="string">
    <cfargument name="password">
    <cfargument name="confirmpassword">

    <cfset var error_msg = ''>
    
    <cfif len(arguments.name) EQ 0>
        <cfset error_msg &= "enter name .<br>">
    </cfif>

    <cfif len(arguments.phone) EQ 0>
        <cfset error_msg &= "enter phone.<br>">
    </cfif>

    <cfif len(arguments.username) EQ 0>
        <cfset error_msg &= "enter username.<br>">
    </cfif>

    <cfif len(arguments.password) EQ 0>
        <cfset error_msg &= "enter password.<br>">
    </cfif>

    <cfif len(arguments.confirmpassword) EQ 0>
        <cfset error_msg &= "retype password.<br>">
    </cfif>

    <cfreturn error_msg>

</cffunction>
    
   
<cffunction name="saveContacts" returnType="void">
    <cfargument name="name">
    <cfargument name="phone">
    <cfargument name="username">
    <cfargument name="password">
    <cfargument name="confirmpassword">

    <cfset datasource = "dsn_addressbook">
    <cfset name = arguments.name>
    <cfset phone = arguments.phone>

    <cfquery name="checkuserexists" datasource="#datasource#">
        SELECT COUNT(id) AS userCount
        FROM tbl_users
        WHERE str_name = <cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">
        AND str_phone = <cfqueryparam value="#phone#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkuserexists.userCount GT 0>
        <cfoutput>
            <h2 style="color:red;">name and phone already exists</h2>
        </cfoutput>
    <cfelse>
        <cfif arguments.password EQ arguments.confirmpassword>
            <cfquery name="saveContacts" datasource="#datasource#">
                INSERT INTO tbl_users(
                    str_name, str_phone, str_username, str_password, int_user_role_id, cbr_status
                )
                VALUES (
                    <cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#phone#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">,
                    2,
                    'P'
                )
            </cfquery>
            <cfset variables.success_msg = 'your account is in pending approval'>
          
        <cfelse>
            <cfoutput>
                <h2 class="text-center" style="color:red;">password and confirm password doesn't match</h2>
            </cfoutput>
        </cfif>
    </cfif>
</cffunction>


<cfset setDefaultValues()>

  <cfif structKeyExists(form, "usersave")>
    <cfset getFormValues()>

    <cfset variables.error_msg = validateFormValues(
        name = variables.str_name,
        phone = variables.str_phone,
        username = variables.str_username,
        password = variables.str_password,
        confirmpassword = variables.confirmpassword
    )>

    <cfif len(variables.error_msg) EQ 0>
        <cfset saveContacts(
            name = variables.str_name,
            phone = variables.str_phone,
            username = variables.str_username,
            password = variables.str_password,
            confirmpassword = variables.confirmpassword
        )>
    </cfif>
</cfif>