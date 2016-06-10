public with sharing class Selectradio1{
List<contact> selectcon;
Public List<contact> getAllContacts()
{
    List<contact> allcons = [Select Id,FirstName,LastName,Email,Phone from Contact limit 5];
    return allcons;
}    
Public void selectcon()
{

    String selcontactid = System.currentPagereference().getParameters().get('conid1');
    system.debug('select id value'+selcontactid);
    if(selcontactid!=null)
    {
    Contact con = [Select Id,FirstName,LastName,Email,Phone from Contact where Id=:selcontactid];
    selectcon =  new List<contact>();
    selectcon.add(con);
    }
}
Public List<contact> getselectedContact()
{
selectcon();
    return selectcon;
}
}