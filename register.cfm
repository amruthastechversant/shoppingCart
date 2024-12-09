<cfinclude  template="registeraction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/file.css">
</head>
<body>
    <cfoutput>
        <div class="container">
            <h2 class="text-center">REGISTER</h2>
            <div class="text-center">
            <div class="errordiv text-danger">
                <p id="errorMsg"></p>
                <cfif len(variables.error_msg) GT 0>#variables.error_msg#</cfif>
            </div>
            <div class="errordiv text-success">
                #variables.success_msg#
            </div>
            </div>
            <div class="logintblreg col-lg-4 mx-auto">
                <form action="register.cfm" method="post">
                    <div class="mb-3">
                        <label for="name">NAME</label>
                        <input type="text" name="name" id="name" class="form-control" value="#variables.str_name#">
                    </div>
                    <div class="mb-3">
                        <label for="phone">PHONE</label>
                        <input type="number" name="phone" id="phone" class="form-control" value="#variables.str_phone#">
                    </div>
                    <div class="mb-3">
                        <label for="username">USERNAME</label>
                        <input type="text" name="username" id="username" class="form-control" value="#variables.str_username#">
                    </div>
                    <div class="mb-3">
                        <label for="password">PASSWORD</label>
                        <input type="password" name="password" id="password" class="form-control" value="#variables.str_password#">
                    </div>
                    <div class="mb-3 col-auto">
                        <label for="confirmpassword">CONFIRM PASSWORD</label>
                        <input type="password" name="confirmpassword" id="confirmpassword" class="form-control" value="#variables.confirmpassword#">
                    </div>
                    <div class="mb-3 col-auto">
                        <input type="submit" id="submit" value="SIGN UP" name="usersave" class="userlogin">
                    </div>
                </form>
            </div>
        </div>
    </cfoutput>
</body>
</html>
