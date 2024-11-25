<cfif NOT structKeyExists(session, "initialized")>
    <cfset session.initialized = true>
</cfif>
    <cfset session.success_msg="">
   <cfset session.error_msg="">


<cfif NOT structKeyExists(session,"str_name" )>
    <cfset session.str_name="">
</cfif>

<cfif NOT structKeyExists(session,"str_phone" )>
    <cfset session.str_phone="">
</cfif>

<cfif NOT structKeyExists(session,"str_username" )>
    <cfset session.str_username="">
</cfif>


<cfif NOT structKeyExists(session,"str_password" )>
    <cfset session.str_password="">
</cfif>


<cfif NOT structKeyExists(session,"confirmpassword" )>
    <cfset session.confirmpassword="">
</cfif>





<!---control block --->

<cfif structKeyExists(form, "usersave")>
  
    <cfset session.str_name=form.name>
   <cfset session.str_phone=form.phone>
    <cfset session.str_username=form.username>
    <cfset session.str_password=form.password>
    <cfset  session.confirmpassword=form.confirmpassword>
   
    <cfset session.error_msg = validateFormValues(name=session.str_name,phone=session.str_phone,username=session.str_username,password=session.str_password,confirmpassword=session.confirmpassword)>

    <cfif len(session.error_msg) EQ 0>
        <cfset saveContacts(name=session.str_name,phone=session.str_phone,username=session.str_username,password=session.str_password,confirmpassword=session.confirmpassword)>
    </cfif>
     
</cfif>



  <cffunction  name="validateFormValues" returnType="string">

                <cfargument  name="name" type="string" >
                <cfargument  name="phone" >
                  <cfargument  name="username" type="string" >
                 <cfargument  name="password" >
                   <cfargument  name="confirmpassword" >
    <cfset var error_msg=''>
    <cfif len(arguments.name) EQ 0>
        <cfset error_msg &="enter name .<br>">
    </cfif>
 
    <cfif len(arguments.phone) EQ 0>
        <cfset error_msg &="enter phone.<br>">
    </cfif>
    
    <cfif len(username) EQ 0>
        <cfset error_msg &="enter username.<br>">
    </cfif>
    <cfif len(password) EQ 0>
        <cfset error_msg &="enter password.<br>">
    </cfif>
    <!---<cfif len(arguments.profile) EQ 0>
        <cfset error_msg &="enter profile.<br>">
    </cfif>--->
   
    <cfif len(confirmpassword) EQ 0>
        <cfset error_msg &="retype password.<br>">
    </cfif>
    
 
    <cfreturn error_msg>
  </cffunction>



  <cffunction  name="saveContacts" returnType="void">
                    <cfargument  name="name" >
                    <cfargument name="phone">
                    <cfargument name="username">
                    <cfargument name="password">
                    <cfargument name="confirmpassword">

                   
                    
                
                
         


    <cfset datasource="dsn_addressbook">

    <cfset name=arguments.name>
    <cfset phone=arguments.phone>

    
        <cfquery name="checkuserexists" datasource="#datasource#">
            select count(*) AS userCount
            from tbl_users
            where str_name=<cfqueryparam value="#name#" cfsqltype="cf_sql_varchar"> AND
                    str_phone=    <cfqueryparam value="#phone#" cfsqltype="cf_sql_varchar">
          
            </cfquery>
             
           <cfif checkuserexists.userCount GT 0>
                <cfoutput>
                    <h2 style="color:red;">name and phone already exists</h2>
                </cfoutput>
                <cfelse>
    <cfif password EQ confirmpassword>
    <cfquery name="saveContacts" datasource="#datasource#">
        INSERT INTO tbl_users(str_name,str_phone,str_username, str_password, int_user_role_id, cbr_status)
            VALUES (<cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#phone#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#password#" cfsqltype="cf_sql_integer">,
                        2,
            'P'
        )
                
                   
                    
    </cfquery>
        <cfset session.success_msg='your account is in pending approval'>
        <cfelse>
        <cfoutput>
            <h2 class="text-center" style="color:red;">password and confirm password doesn't match</h2>
        </cfoutput>
        </cfif>
        </cfif>
  </cffunction>

<!DOCTYPE html>
<html lang="en">
<head>
 <meta charset="UTF-8" >
    <meta name="viewport" content="width=device-width initial-scale= 1.0">
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" >
        <link rel="stylesheet" href="css/file.css">

</head>
<body>
<cfoutput>

    <div class="container">

        <h2 class="text-center">REGISTER</h2>
        <div class="errordiv text-danger"><p id="errorMsg"></p><cfif len(session.error_msg) GT 0>#session.error_msg#</cfif></div>
        <div class="errordiv text-success"><p id="success_msg"></p> #session.success_msg#</div>
        <div class="logintblreg col-lg-4 mx-auto">
        <form action="register.cfm" method="post">
            <div class="mb-3">
            <label for ="name">NAME</label>
            <input type="text" name="name" id="name" class="form-control" value="#session.str_name#">
            </div>
            <div class="mb-3">
            <label for="phone">PHONE</label>
            <input type="number" name="phone" id="phone"  class="form-control" value="#session.str_phone#">
            </div>
            <div class="mb-3">
            <label for="username">USERNAME</label>
            <input type="username" name="username" id="username"  class="form-control" value="#session.str_username#">
            </div>
            <div class="mb-3">
            <label for="password">PASSWORD</label>
            <input type="password" name="password" id="password"  class="form-control" value="#session.str_password#">
            </div>
            <div class="mb-3 col-auto">
            <label for="confirmpassword">CONFIRM PASSWORD</label>
            <input type="password" name="confirmpassword" id="confirmpassword"  class="form-control" value="#session.confirmpassword#">
            </div>

            <div class="mb-3 col-auto">
            <input type="submit" id="submit" value="SIGN UP" name="usersave" class="userlogin">
        </form>
        </div>
    </div>
</body>
</html>
</cfoutput>