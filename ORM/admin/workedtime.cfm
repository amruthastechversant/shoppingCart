<cfinclude template="../taskmanagement/taskboardaction.cfm">
<cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false">
</cfif>

<cfif structKeyExists(form, "int_task_id") AND structKeyExists(form, "hours") AND structKeyExists(form, "minutes")>

    <cfset int_task_id = form.int_task_id>
    <cfset int_hours=form.hours>
    <cfset int_user_id = form.int_user_id> 
    <cfset int_minutes = form.minutes>
    <cfset datasource = "dsn_addressbook">

    
    <cfif Not isNumeric(int_task_id)>
        <cfset int_task_id=0>
    </cfif>

    <cfif not isNumeric(int_user_id)>
        <cfset int_user_id=0>
    </cfif>
    
    <cfif not isNumeric(int_hours)>
        <cfset int_hours=0>
    </cfif>

         <cfif not isNumeric(int_minutes)>
        <cfset int_minutes=0>
    </cfif>
    


    <cfset total_minutes = (int_hours * 60) + int_minutes>
       


    <!-- Fetch task details -->
    <cfquery name="getTaskDetails" datasource="#datasource#">
        SELECT 
            int_task_id, 
            int_user_id, 
            str_task_name, 
            str_task_description, 
            dt_task_due_date, 
            int_task_status, 
            estimate_hours, 
           COALESCE(working_hours, 0) AS working_hours
        FROM tasks
        WHERE int_task_id = <cfqueryparam value="#int_task_id#" cfsqltype="cf_sql_integer">
          AND int_user_id = <cfqueryparam value="#int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!-- Update task with working hours if found -->
    <cfif getTaskDetails.recordCount>
        <cfset str_task_name = getTaskDetails.str_task_name>
        <cfset str_task_description = getTaskDetails.str_task_description>
        <cfset dt_task_due_date = getTaskDetails.dt_task_due_date>
        <cfset int_task_status = getTaskDetails.int_task_status>
        <cfset estimate_hours = getTaskDetails.estimate_hours>
        <cfset existing_time = getTaskDetails.working_hours>


            <cfif not isNumeric(existing_time)>
                <cfset existing_time=0>
            </cfif>
        <cfset updated_time = existing_time + total_minutes>

        <!-- Update the task -->
        <cfquery datasource="#datasource#" name="updateTaskTime">
            UPDATE tasks
            SET working_hours = <cfqueryparam value="#updated_time#" cfsqltype="cf_sql_float">
            WHERE int_task_id = <cfqueryparam value="#int_task_id#" cfsqltype="cf_sql_integer">
              AND int_user_id = <cfqueryparam value="#int_user_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cflocation url="../taskmanagement/usertaskboard.cfm">
    <cfelse>
        <!-- Task not found -->
        <cfoutput><p class="text-danger">Task ID: #int_task_id# not found or user mismatch.</p></cfoutput>
    </cfif>
</cfif>
