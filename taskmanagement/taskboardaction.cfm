


<cfset datasource="dsn_addressbook">
<!-- Function to retrieve total contact count -->
<cffunction name="qryContacts" access="public" returnType="numeric">
    <cfquery name="qryTotalContacts" datasource="#datasource#">
        SELECT COUNT(int_task_id) AS totalCount
        FROM tasks
    </cfquery>
    <cfreturn qryTotalContacts.totalCount>
</cffunction>

<cffunction name="getContacts" returnType="query">
    <cfset var qryResults = "">
    <cfset var datasource = "dsn_addressbook">
    <cfquery name="qryResults" datasource="#datasource#">
        SELECT 
            c.int_task_id,
            c.str_task_name, 
            c.str_task_description, 
            c.int_task_priority,
            c.dt_task_due_date, 
            c.int_task_status,
            s.status as task_status,
            c.created_at,
             c.is_recurring, 
        c.recurrence_type, 
        c.recurrence_end_date,
            e.priority
        FROM 
            tasks AS c 
             JOIN  priority AS e 
             ON c.int_task_priority = e.id
       
            JOIN 
            status AS s ON c.int_task_status = s.status 
           
          <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
            AND (
                
                str_task_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
                OR s.status LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            )
        </cfif> 
        ORDER BY 
            c.int_task_priority, c.dt_task_due_date
        LIMIT <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer"> 
        OFFSET <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryResults>
</cffunction>



<cffunction name="getTodayTask" returnType="query">
    <cfset var qryResults = "">
    <cfset var datasource = "dsn_addressbook">
    <cfquery name="qryResults" datasource="#datasource#">
        SELECT 
            c.int_task_id,
            c.int_user_id,
            c.str_task_name, 
            c.str_task_description, 
            c.int_task_priority,
            c.dt_task_due_date, 
            c.int_task_status,
            s.status as task_status,
            c.created_at,
             c.is_recurring, 
        c.recurrence_type, 
        c.recurrence_end_date,
            e.priority
        FROM 
            tasks AS c 
             JOIN  priority AS e 
             ON c.int_task_priority = e.id
       
            JOIN 
            status AS s ON c.int_task_status = s.status 
            where  CAST(c.dt_task_due_date AS DATE) = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">
          <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
            AND (
                
                str_task_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
                OR s.status LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            )
        </cfif> 
        ORDER BY 
            c.int_task_priority, c.dt_task_due_date
        LIMIT <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer"> 
        OFFSET <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryResults>
</cffunction>




<cfparam name="url.userId" default="0">
<cfquery name="contactDetails" datasource="dsn_addressbook">
    SELECT int_task_id,int_user_id,str_task_name,str_task_description,int_task_priority,dt_task_due_date,int_task_status,is_recurring,recurrence_type,recurrence_end_date,created_at
    FROM tasks
    WHERE int_task_id  = <cfqueryparam value="#url.userId#" cfsqltype="cf_sql_integer">
</cfquery>


<cffunction name="setDefaultValues" access="public" returnType="void">
    <cfset datasource = "dsn_addressbook">
    <cfparam name="form.currentPage" default="1">
    <cfparam name="form.recordsPerPage" default="4">

    <!-- Determine the current page based on URL or form input -->
    <cfif structKeyExists(URL, "currentPage")>
        <cfset currentPage = val(URL.currentPage)>
    <cfelseif structKeyExists(form, "currentPage")>
        <cfset currentPage = val(form.currentPage)>
    <cfelse>
        <cfset currentPage = 1>
    </cfif>

    <!-- Set records per page and calculate starting record -->
    <cfset recordsPerPage = val(form.recordsPerPage)>
    <cfset startRecord = (currentPage - 1) * recordsPerPage>
    <cfset totalContacts = qryContacts()>
    <cfset totalPages = ceiling(totalContacts / recordsPerPage)>
</cffunction>


<cffunction  name="getResults" access="public" returnType="query">
<cfquery name="qryPendingStatus" datasource="#datasource#">
    SELECT int_task_id,str_task_name,str_task_description,dt_task_due_date,int_task_status
    FROM tasks
    WHERE  1=1
       
    <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
        AND (
            
             str_task_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            OR CAST(int_task_status AS CHAR) LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>
    ORDER BY int_task_id
    LIMIT <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">, 
          <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
</cfquery>
    <cfreturn qryPendingStatus>
</cffunction>

<cfset setDefaultValues()>
<cfset getResults()>
<cfset tasks=getContacts()>
<cfset TodaysTasks=getTodayTask()>
