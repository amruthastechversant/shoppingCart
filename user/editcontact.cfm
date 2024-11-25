<cfif IsDefined("url.contactId")>
    <cfset  contactId = url.contactId>
    <cfset  datasource = "dsn_addressbook">
    <cfquery name="contactDetails" datasource="#datasource#">
        SELECT *
        FROM contacts
        WHERE intContactId = <cfqueryparam value="#contactId#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>
<cfquery name="qryGetEducationOptions" datasource="dsn_addressbook">
    SELECT id AS EducationId, title AS education
    FROM education
</cfquery>

<cfif structKeyExists(form, "submit")>
    <cfset datasource="dsn_addressbook">
    <cfquery  datasource="#datasource#">
    update contacts
        set strFirstname=<cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
        strLastname=<cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
        strEducation= <cfqueryparam value="#arguments.education#" cfsqltype="cf_sql_varchar">,
        strProfile=<cfqueryparam value="#arguments.profile#" cfsqltype="cf_sql_varchar">,
        intAge=<cfqueryparam value="#arguments.age#" cfsqltype="cf_sql_varchar">,
        strGender=<cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
        intphoneNo= <cfqueryparam value="#arguments.phoneno#" cfsqltype="cf_sql_varchar">,
        strHobbies=  <cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">,
        strAddress=       <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">
              WHERE intContactId = #url.contactId#    
                    
    </cfquery>
</cfif>
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
        
       
        <form action="editcontact.cfm?contactId=#url.contactId#" method="post" name="form">
            <table class="indextable mx-auto">
                <tr>
                    <td class="alignRight"><label for="firstname">First Name</label></td>
                    <td><input type="text" id="firstname" name="firstname" value="#contactDetails.strFirstname#"></td>
                    <td class="alignRight"><label for="lastname" >Last Name</label></td>
                    <td><input type="text" id="lastname" name="lastname" value="#contactDetails.strLastname#"></td>
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
                    <td colspan="3"><input type="number" id="age" name="age" value="#contactDetails.intAge#"></td>
                </tr>
                <tr>
                    <td class="alignRight"><label for="profile">Profile</label></td>
                     <td colspan="3"><textarea rows="4" cols="40" id="profile" name="profile" wrap="soft">#contactDetails.strProfile#</textarea></td>
                </tr>

            
                <tr>
                    <td class="alignRight"><label for="address">Address</label></td>
                    <td colspan="3"><textarea rows="4" cols="40" id="address" name="address" wrap="soft"  >#contactDetails.strAddress#</textarea></td>
                </tr>
                <tr>
                    <td class="alignRight"><label for="phoneno">Phone Number</label></td>
                    <td colspan="3"><input type="text" id="phoneno" name="phoneno" maxlength="10" title="only numbers allowed" value="#contactDetails.intphoneNo#" ></td>
                </tr>
                <tr>
                    <td class="alignRight"><label>Gender</label></td>
                    <td colspan="3">
                        <input type="radio" id="genderM" name="gender" value="male" ><label for="genderM"  >Male</label>
                        <input type="radio" id="genderF" name="gender" value="female" ><label for="genderF" >Female</label>
                    </td>
                </tr>
                <tr>
                    <td class="alignRight"><label>Hobbies</label></td>
                    <td colspan="3">
                        <input type="checkbox" id="reading" name="hobbies" value="reading"><label for="reading">Reading</label>
                        <input type="checkbox" id="travel" name="hobbies" value="Travelling" ><label for="travel">Travelling</label>    
                        <input type="checkbox" id="music" name="hobbies" value="Music"><label for="music">Music</label>
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






























