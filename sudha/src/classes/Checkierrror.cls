public with sharing class Checkierrror {
public account account1 {get;set;}
    public Checkierrror(ApexPages.StandardController controller) {
    account1=new account();
   
    }
    public pagereference savein()
    {

 Try
 {

    insert account1;
    }
    
     catch(Exception dmle)
         {
               ApexPages.addMessages(dmle);               
              return null;
         }
         
    
    return null;
    }

}