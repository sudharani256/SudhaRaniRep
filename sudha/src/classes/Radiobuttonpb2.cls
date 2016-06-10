public with sharing class Radiobuttonpb2 {

    public PageReference next() {
        return null;
    }

public List<cContact> myContacts {get;set;}
public List<cContact> myaccounts {get;set;}
public Radiobuttonpb2 ()
{
 myContacts=new List<cContact>();
for(contact c:[select id,name,lastname from contact])
{
myContacts .add(new cContact(c));
}
}

 public class cContact {  
    public Contact con {get; set;}  
    public boolean selected {get; set;}  


    public cContact(Contact c) {  
        con = c;  
        selected = false;  
    }  
} 
}