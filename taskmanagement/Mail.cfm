

<cfinclude  template="taskboardaction.cfm">

<cfset TodaysTasks=getTodayTask()>
<cffunction  name="sendmail" access="public" returnType="void">
    <cfargument  name="email" type="string" required="true">
    <cfargument  name="str_username" type="string" required="true">
    <cfargument  name="taskDetails" type="string" required="true">



    <cftry>
     <cfmail 
        from="amrutha.s@techversantinfotech.com" 
        to="amrutha.s@techversantinfotech.com" 
        subject="Test Email" 
        server="smtp.gmail.com"
        port="587"
         useTLS="yes"
        >
       <cfoutput>
        hi #arguments.str_username# here is your pending task<br>
        #arguments.taskDetails#
       </cfoutput>
    </cfmail>


<cfcatch type="any">
        error found:sending mail
    
</cfcatch>
</cftry>
</cffunction>


    <cfquery name="usertasks" datasource="dsn_addressbook">
        select u.str_username,u.email,t.int_user_id,t.str_task_name,t.str_task_description,t.dt_task_due_date
        from tbl_users as u
        join tasks as t on u.id= t.int_user_id where
         CAST(t.dt_task_due_date AS DATE) = <cfqueryparam value="#dateAdd("d", 1, Now())#" cfsqltype="cf_sql_date">
         AND t.GetEmailSent=0
         ORDER BY u.str_username,t.dt_task_due_date
    </cfquery>
 <cfif usertasks.recordCount GT 0>
    <cfdump  var="#usertasks.recordCount#" abort>
    <cfset currentUserID = 0>
    
    <cfset taskDetails = "">
    <cfset isDateDisplayed = false>

    <cfloop query="usertasks">
      
        <cfif usertasks.int_user_id NEQ currentUserID AND currentUserID NEQ 0>
            <cfset sendmail(
                email=usertasks.email, 
                str_username=usertasks.str_username, 
                taskDetails=taskDetails
            )>

            <cfquery datasource="dsn_addressbook">
                update tasks
                set GetEmailSent=1
                where int_user_id=<cfqueryparam value="#currentUserID#" cfsqltype="cf_sql_integer">
                AND GetEmailSent=0
            </cfquery>
            <cfset taskDetails = ""> 
            <cfset isDateDisplayed = false> 
        </cfif>

       
        <cfif NOT isDateDisplayed>
            <cfset taskDetails &= "Task Due Date: #DateFormat(usertasks.dt_task_due_date, 'mm/dd/yyyy')#<br><br>">
            <cfset isDateDisplayed = true>
        </cfif>

        <cfset taskDetails &= "Task Name: #usertasks.str_task_name#<br>
                               Task Description: #usertasks.str_task_description#<br><br>">
        <cfset currentUserID = usertasks.int_user_id>
    </cfloop>

  
    <cfif taskDetails NEQ "">
        <cfset sendmail(
            email=usertasks.email, 
            str_username=usertasks.str_username, 
            taskDetails=taskDetails
        )>

        <cfquery datasource="dsn_addressbook">
            update tasks
            set GetEmailSent=1
            where  int_user_id=<cfqueryparam value="#currentUserID#" cfsqltype="cf_sql_integer">
                AND GetEmailSent=0
        </cfquery>
    </cfif>

    
<cfelse>
    <p>No tasks for today</p>
</cfif>