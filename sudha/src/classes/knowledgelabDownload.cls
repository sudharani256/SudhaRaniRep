public with sharing class knowledgelabDownload {
public String empId;
    public account emp {get;set;}
    
 
    
    public void fetch()
    {
        empId = Apexpages.currentpage().getparameters().get('id');
        emp = [SELECT Name, accountnumber, phone FROM account WHERE ID ='00128000003irXp'];
        //=: empId];
       /* pagereference p=new pagereference('/apex/knowledgelabDownloadPagePlacement');
        p.setredirect(false);
        return p;*/
    }    
}