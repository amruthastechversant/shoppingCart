<cfcomponent>
    <cffunction name="getUser" access="public" returnType="query">
        <cfargument name="username" type="string" required="true">
        <cfargument name="password" type="string" required="true">
       <cfset qryUser=""/>
        <cfquery name="qryUser" datasource="dsn_addressbook">
            SELECT u.id, u.str_name, u.str_phone, u.str_username, r.str_user_role
            FROM tbl_users AS u
            INNER JOIN tbl_user_roles AS r ON u.int_user_role_id = r.id
            WHERE u.str_username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
              AND u.str_password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">
              AND u.cbr_status = 'A'
              AND r.str_user_role = 'user'
        </cfquery>
        <cfreturn qryUser />
    </cffunction>
</cfcomponent>
