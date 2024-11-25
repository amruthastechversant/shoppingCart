
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/file.css">
</head>
<body>
<div class="header">
    <img src="../img/logo.png" alt="logo" class="logo">
    <a href="homepage.html">Home</a>
    <a href="contactList.cfm">Contacts</a>
    <a href="index.cfm">Create Contact</a>
    <a href="../userlogin.cfm" class="moveright">Log out</a>
</div>



<cfparam name="url.contactId" default="0">
<cfquery name="contactDetails" datasource="dsn_addressbook">
    SELECT strFirstName, strLastName, strEducation, intAge, strProfile, 
           strAddress, intphoneNo, strGender, strHobbies
    FROM contacts
    WHERE intContactId = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
</cfquery>


<cfif contactDetails.recordCount EQ 1>
    <h1 align="center">CONTACT DETAILS</h1>
    <table class="table table-bordered" align="center" >
        <tbody>
            <tr>
                <td><strong>Firstname:</strong></td>
                <td>#contactDetails.strFirstName#</td>
            </tr>
            <tr>
                <td><strong>Lastname:</strong></td>
                <td>#contactDetails.strLastName#</td>
            </tr>
            <tr>
                <td><strong>Education:</strong></td>
                <td>#contactDetails.strEducation#</td>
            </tr>
            <tr>
                <td><strong>Age:</strong></td>
                <td>#contactDetails.intAge#</td>
            </tr>
            <tr>
                <td><strong>Profile:</strong></td>
                <td>#contactDetails.strProfile#</td>
            </tr>
            <tr>
                <td><strong>Address:</strong></td>
                <td>#contactDetails.strAddress#</td>
            </tr>
            <tr>
                <td><strong>Phone Number:</strong></td>
                <td>#contactDetails.intphoneNo#</td>
            </tr>
            <tr>
                <td><strong>Gender:</strong></td>
                <td>#contactDetails.strGender#</td>
            </tr>
            <tr>
                <td><strong>Hobbies:</strong></td>
                <td>#contactDetails.strHobbies#</td>
            </tr>
        </tbody>
    </table>
<cfelse>
    <h1 align="center">No Contact Found</h1>
</cfif>

<div class="footer">
    <a class="p-0 px-md-3 px-1" href="https://www.amazon.in/gp/help/customer/display.html?nodeId=200507590&ref_=footer_gw_m_b_he">Copyright Info</a>
    <a class="p-0 px-md-3 px-1" href="https://www.facebook.com/login.php">References</a>
    <a class="p-0 px-md-3 px-1" href="htmlpage.html">Contact</a>
</div>

</body>
</html>
</cfoutput>