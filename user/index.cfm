


<cfif  NOT structKeyExists(session, "userid") OR  session.userid EQ "" OR session.userid IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false" >
</cfif>



<!---variable declaration--->
<cfset variables.error_msg=''>
<cfset variables.firstname=''>
<cfset variables.lastname=''>
<cfset variables.profile=''>
<cfset variables.age=''>
<cfset variables.phoneno=''>
<cfset variables.address=''>
<cfset variables.education=''>
<cfset variables.gender=''>
<cfset variables.hobbies=''>

<cfset variables.success_msg=''>

<!---control block --->

<cfif structKeyExists(form, "btnSave")>
  
    <cfset variables.firstname=form.firstname>
    <cfset variables.lastname=form.lastname>
      
      <cfset variables.profile=form.profile>
      <cfset variables.age=trim(form.age)>
    <cfset variables.phoneno=form.phoneno>
    <cfset variables.address=form.address>
    <cfif structKeyExists(form,"gender")>
        <cfset variables.gender=form.gender>
       </cfif>
 
    <cfif structKeyExists(form,"hobbies")>
        <cfset variables.hobbies=form.hobbies>
    </cfif>

    <cfif structKeyExists(form,"education")>
        <cfset variables.education=form.education>
    </cfif>
   
    <cfset variables.error_msg = validateFormValues(firstname=variables.firstname,lastname=variables.lastname,education=variables.education,profile=variables.profile,age=variables.age,phoneno=variables.phoneno,address=variables.address,gender=variables.gender,hobbies=variables.hobbies)>

    <cfif len(variables.error_msg) EQ 0>
        <cfset saveContacts(firstname=variables.firstname,lastname=variables.lastname,education=variables.education,profile=variables.profile,age=variables.age,phoneno=variables.phoneno,address=variables.address,gender=variables.gender,hobbies=variables.hobbies)>
    </cfif>
     
</cfif>



  <cffunction  name="validateFormValues" returnType="string">

                <cfargument  name="firstname" type="string" >
                <cfargument  name="lastname" type="string">
                <cfargument  name="profile" type="string">
                <cfargument  name="education" type="string">
                <cfargument  name="age" >          
                <cfargument  name="address" type="string">
                <cfargument  name="phoneno" >
                <cfargument  name="gender" type="string" >
                <cfargument  name="hobbies" type="string">
        
    <cfset var error_msg=''>
    <cfif len(arguments.firstname) EQ 0>
        <cfset error_msg &="enter firstname.<br>">
    </cfif>
 
    <cfif len(arguments.lastname) EQ 0>
        <cfset error_msg &="enter lastname.<br>">
    </cfif>
    
    <cfif len(arguments.profile) EQ 0>
        <cfset error_msg &="enter profile.<br>">
    </cfif>
    <cfif len(arguments.education) EQ 0>
        <cfset error_msg &="Select any education.<br>">
    </cfif>
    <!---<cfif len(arguments.profile) EQ 0>
        <cfset error_msg &="enter profile.<br>">
    </cfif>--->
   
    <cfif len(arguments.age) EQ 0>
        <cfset error_msg &="enter age.<br>">
    </cfif>
    
    <cfif len(arguments.address) EQ 0>
        <cfset error_msg &="enter address.<br>">
    </cfif>
    <cfif len(arguments.phoneno) EQ 0>
        <cfset error_msg &="enter phoneno.<br>">
    </cfif>
     <cfif len(arguments.gender) EQ 0>
        <cfset error_msg &="enter gender.<br>">
    </cfif>
     <cfif len(arguments.hobbies) EQ 0>
        <cfset error_msg &="enter hobbies.<br>">
    </cfif>
    <cfreturn error_msg>
  </cffunction>



  <cffunction  name="saveContacts" returnType="void">
                    <cfargument  name="firstname" >
                    <cfargument name="lastname">
                    <cfargument name="profile">
                    <cfargument name="education">
                    <cfargument name="age">
                    <cfargument name="gender">
                    <cfargument name="phoneno">
                    <cfargument name="hobbies">
                    <cfargument name="address">
                
                
         


    <cfset datasource="dsn_addressbook">
    <cfquery name="saveContacts" datasource="#datasource#">
        INSERT INTO contacts(strFirstname,strLastname,strEducation,strProfile,intAge,strGender,intphoneNo,strHobbies,strAddress)
            VALUES (<cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.education#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.profile#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.age#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.phoneno#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">
                   
                    
                   
                    )
    </cfquery>
        <cfset variables.success_msg='submitted'>
  </cffunction>

<cfquery name="qryGetEducationOptions" datasource="dsn_addressbook">
    SELECT id AS EducationId, title AS education
    FROM education
</cfquery>



<!---display block--->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add contact Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" >
    <link rel="stylesheet" href="../css/file.css">
</head>  
<body>
  <cfoutput>
        <div class="header">
            <img src="../img/logo.png" alt="logo" class="logo">
            <a href="">Home</a>
            <a href="fullcontacts.cfm">Contacts</a>
            <a href="index.cfm">Create Contact</a>
            <a href="userlogout.cfm" class="moveright">Log out</a>
        </div>
        <div class="headdiv">
            <h1>ADD CONTACT FORM</h1>
        </div>
        <div class="errordiv text-danger"><p id="errorMsg"></p><cfif len(variables.error_msg) GT 0>#variables.error_msg#</cfif></div>
        <div class="errordiv text-success"><p id="success_msg"></p> #variables.success_msg#</div>
        <form action="" method="post" name="form">
            <table class="indextable mx-auto">
                <tr>
                    <td class="alignRight"><label for="firstname">First Name</label></td>
                    <td><input type="text" id="firstname" name="firstname" value="#variables.firstname#"></td>
                    <td class="alignRight"><label for="lastname" >Last Name</label></td>
                    <td><input type="text" id="lastname" name="lastname" value="#variables.lastname#"></td>
                </tr>
                
            <tr>
    <td class="alignRight" ><label for="Education">Education</label></td>
    <td>
        <select name="education" id="Education" multiple class="selectBox" >
            <cfloop query="qryGetEducationOptions">
                <option value="#qryGetEducationOptions.education#">#qryGetEducationOptions.education#</option>
            </cfloop>
        </select>
    </td>
</tr>

                <tr>
                    <td class="alignRight"><label for="age">Age</label></td>
                    <td colspan="3"><input type="number" id="age" name="age" value="#variables.age#"></td>
                </tr>
                <tr>
                    <td class="alignRight"><label for="profile">Profile</label></td>
                     <td colspan="3"><textarea rows="4" cols="40" id="profile" name="profile" wrap="soft">#variables.profile#</textarea></td>
                </tr>

            
                <tr>
                    <td class="alignRight"><label for="address">Address</label></td>
                    <td colspan="3"><textarea rows="4" cols="40" id="address" name="address" wrap="soft"  >#variables.address#</textarea></td>
                </tr>
                <tr>
                    <td class="alignRight"><label for="phoneno">Phone Number</label></td>
                    <td colspan="3"><input type="text" id="phoneno" name="phoneno" maxlength="10" title="only numbers allowed" value="#variables.phoneno#" ></td>
                </tr>
                <tr>
                    <td class="alignRight"><label>Gender</label></td>
                    <td colspan="3">
                        <input type="radio" id="genderM" name="gender" value="male" <cfif variables.gender is "male">checked="true"</cfif>><label for="genderM"  >Male</label>
                        <input type="radio" id="genderF" name="gender" value="female" <cfif variables.gender is "female">checked="true"</cfif>><label for="genderF" >Female</label>
                    </td>
                </tr>
                <tr>
                    <td class="alignRight"><label>Hobbies</label></td>
                    <td colspan="3">
                        <input type="checkbox" id="reading" name="hobbies" value="reading"<cfif variables.hobbies is "reading">checked ="true"</cfif>><label for="reading">Reading</label>
                        <input type="checkbox" id="travel" name="hobbies" value="Travelling" <cfif variables.hobbies is "Travelling">checked="true"</cfif>><label for="travel">Travelling</label>    
                        <input type="checkbox" id="music" name="hobbies" value="Music"<cfif variables.hobbies is "Music">checked="true"</cfif>><label for="music">Music</label>
                    </td>
                </tr>
                
                <tr>
                    <td class="alignRight" colspan="4">
                        <input type="reset" name="btnReset" value="Reset">
                        <button type="submit" value="submit" name="btnSave" class="btnreg">Save</button>
                    </td>
                </tr>
            </table>
        </form>
        <br><br>
        <div class=" footer">
			<a class="p-0 px-md-3 px-1"href="https://www.amazon.in/gp/help/customer/display.html?nodeId=200507590&ref_=footer_gw_m_b_he">Copyright Info</a>
			<a class="p-0 px-md-3 px-1"  href="https://www.facebook.com/login.php">References</a>
			<a class="p-0 px-md-3 px-1" href="htmlpage.html">Contact</a>
			<div>
       
    </body>
</html>
</cfoutput>






























