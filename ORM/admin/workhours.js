
    document.addEventListener('DOMContentLoaded', function () {
       
        var modal = new bootstrap.Modal(document.getElementById('estimateModal'), {
            keyboard: false
        });

     
        var modalElement = document.getElementById('estimateModal');
        modalElement.addEventListener('show.bs.modal', function (event) {
        
            var button = event.relatedTarget; 
            var taskId = button.getAttribute('data-task-id'); 
            var userId = button.getAttribute('data-user-id');
           
            document.getElementById('modalTaskId').value = taskId;
            document.getElementById('modalUserId').value = userId;
        });
    });
