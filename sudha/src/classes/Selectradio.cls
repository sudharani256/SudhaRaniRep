public with sharing class Selectradio {
List<contact> selectcon;
Public List<contact> getAllContacts()
{
    List<contact> allcons = [Select Id,FirstName,LastName,Email,Phone from Contact limit 5];
    return allcons;
}    
Public void selectcon()
{
    String selcontactid = System.currentPagereference().getParameters().get('conid');
    Contact con = [Select Id,FirstName,LastName,Email,Phone from Contact where Id=:selcontactid];
    selectcon =  new List<contact>();
    selectcon.add(con);
}
Public List<contact> getselectedContact()
{
    return selectcon;
}
}