<cfparam name="session.logged_in" default="false">
<cfparam name="session.username" default="">
<cfparam name="session.loginError" default="">



<cfif structKeyExists(form, "username") AND structKeyExists(form, "password")>
    <cfset username=trim(form.username)>
    <cfset password=trim(form.password)>

<cfset validUser=false>


<cfquery datasource="dsn_addressbook" name="getUser">
        SELECT password from users where
        username=<cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
        LIMIT 1
</cfquery>

        <cfif getUser.recordCount EQ 1>
           

            <cfset storedhashedpassword=getUser.password>
            <cfset ispasswordValid= (password EQ storedhashedpassword)>


            <cfif ispasswordValid>
                <cfset session.logged_in=true>
                <cfset session.username=username>
                <cflocation  url="https:/www.amazon.com" addtoken="false"/>
             <cfelse>    
                <cfset session.loginError="incorrect username and password">
                <cflocation  url="userlogin.cfm" addtoken="false">
            </cfif> 

        <cfelse>
            <cfset session.loginError="username not found">
             <cflocation  url="userlogin.cfm" addtoken="false">
        </cfif>
<cfelse>
    <cfset session.loginError="please enter username and password">
    <cflocation  url="loginasadmin.cfm" addtoken="false">
</cfif> 


<!---<cfif username EQ "admin" AND password EQ "12">
<cfset validUser=true>
</cfif>
<cfif validUser>
    <cfset session.logged_in=true>
    <cfset session.username=username>
    

    <cfelse>
        <cfset session.loginError="please enter username and password">
        <cflocation  url="userlogin.cfm" addtoken="false">


</cfif>--->
