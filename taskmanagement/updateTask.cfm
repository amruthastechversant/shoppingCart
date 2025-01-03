<cfif structKeyExists(form, "completedtasks")>
    <cfset completedTasks = form.completedtasks>
    <cfif isArray(completedTasks)>
        <cfloop array="#completedTasks#" index="int_task_id">
            <cfquery datasource="dsn_addressbook">
                UPDATE tasks
                SET int_task_status = 3
                WHERE int_task_id = <cfqueryparam value="#int_task_id#" cfsqltype="cf_sql_integer">
            </cfquery>
         
        </cfloop>
        
        
    <cfelse>
        <cfquery datasource="dsn_addressbook">
            UPDATE tasks
            SET int_task_status = 3
            WHERE int_task_id = <cfqueryparam value="#completedTasks#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>
   
</cfif>
<cflocation url="../admin/homepage.cfm" addtoken="false">
