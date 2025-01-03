


<cfinclude  template="taskboardaction.cfm">
<cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
    <cflocation url="userlogin.cfm" addtoken="false">
</cfif>

<cfoutput>
<cfinclude  template="header.cfm">

<div class="d-flex justify-content-end">
                      
    <a href="addtask.cfm" class="btn btn-outline-info btn-lg  my-2 ms-3 me-4">Tasks</a>
</div>

<div class="container mt-5">
    <h2 class="text-center">Tasks Sorted by Priority</h2>
    <form class="d-flex justify-content-between align-items-center" action="usertaskboard.cfm" method="post">
        <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" id="str_keyword" name="str_keyword" value="<cfif structKeyExists(form, 'str_keyword')> #form.str_keyword#</cfif>">
        <button class="btn btn-outline-success my-2 ms-3" type="submit">Search</button>
    </form>

    <!-- Fetch and Display Tasks -->

    
    <!-- Cards Row -->
    <div class="row">
        <cfif tasks.recordCount>
        <cfloop query="tasks">
            <div class="col-md-6 mb-3">
                <div class="card w-100">
                    <div class="card-header 
                        <cfif int_task_priority EQ 1>bg-danger text-white
                        <cfelseif int_task_priority EQ 2>bg-warning text-dark
                        <cfelse>bg-success text-white</cfif>">
                        <strong>Priority: 
                            <cfif int_task_priority EQ 1>High   
                            <cfelseif int_task_priority EQ 2>Medium
                            <cfelse>Low</cfif>
                        </strong>
                    </div>
                   <div class="card-body">
    <h1 class="card-title">#int_task_id#</h1>
    <h5 class="card-title">#str_task_name#</h5>
    <p class="card-text">#str_task_description#</p>
    <p class="card-text"><strong>Due Date:</strong> #DateFormat(dt_task_due_date, "mm/dd/yyyy")#</p>
    <p class="card-text"><strong>Status:</strong> #task_status#</p>
    <p class="card-text"><strong>Created At:</strong> #DateFormat(created_at, "mm/dd/yyyy")#</p>
    <p class="card-text"><strong>Recurring:</strong> 
    <cfif is_recurring EQ 1>Yes
    <cfelseif is_recurring EQ 0>No
    <cfelse>Not Set</cfif>
</p>

    <p class="card-text"><strong>Recurrence Type:</strong> #recurrence_type#</p>
    <p class="card-text"><strong>Recurrence End Date:</strong> #DateFormat(recurrence_end_date, "mm/dd/yyyy")#</p>
    <a href="addtask.cfm?userId=#tasks.int_task_id#" class="btn btn-warning btn-sm">Edit</a>
    <a href="deletecontact.cfm?userId=#tasks.int_task_id#" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this contact?');">Delete</a>      
</div>


                </div>
            </div>
        </cfloop>
      </cfif>
    </div>
</div>



    <div class="d-flex justify-content-end">
    <!-- Pagination controls -->
    <cfoutput>
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <!-- Previous Button -->
                <cfif currentPage GT 1>
                    <li class="page-item">
                        <a class="page-link" href="usertaskboard.cfm?currentPage=#currentPage - 1#" aria-label="Previous">Previous</a>
                    </li>
                </cfif>

                <!-- Page Numbers -->
                <cfloop index="i" from="1" to="#totalPages#">
                    <li class="page-item <cfif i EQ currentPage>active</cfif>">
                        <a class="page-link" href="usertaskboard.cfm?currentPage=#i#">#i#</a>
                    </li>
                </cfloop>

                <!-- Next Button -->
                <cfif currentPage LT totalPages>
                    <li class="page-item">
                        <a class="page-link" href="usertaskboard.cfm?currentPage=#currentPage + 1#" aria-label="Next">Next</a>
                    </li>
                </cfif>
            </ul>
        </nav>
        </cfoutput>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
<cfinclude  template="../taskmanagement/footer.cfm">
</body>
</html>
</cfoutput>
