public with sharing class agjsEgTable_opportunities{ 
    
    public String AccountList { get; set; }
    
    //Subclass : Wrapper Class 
    public class Accountwrap {
        //Static Variables 
        public string id;
        public string name;
        public string Phone;
        
        //Wrapper  Class Controller
        Accountwrap() {
            Phone = '';
        }
        
    }
    //opty wrap
       //Subclass : Wrapper Class 
    public class Optywrap {
        //Static Variables 
        public string id;
        public string name;
        public string stagename;
        
        //Wrapper  Class Controller
        Optywrap () {
            stagename= '';
        }
        
    }
       
    //Method to bring the list of Account and Serialize Wrapper Object as JSON
    public  static String getlstAccount() {
        List < Accountwrap > lstwrap = new List < Accountwrap > ();
        List < account > lstacc = [SELECT Id, Name, Phone
                                   FROM Account limit 100
                                  ];
        for (Account a: lstacc) {
            Accountwrap awrap = new Accountwrap();
            awrap.id = a.id;
            awrap.name = a.name;
            if (a.Phone != null) {
                awrap.Phone = a.Phone;
            }
            lstwrap.add(awrap);
        }
        return JSON.serialize(lstwrap);
     }
    //optys
        public  static String getlstOpty() {
        List < Optywrap > lstwrap = new List < Optywrap > ();
        List < opportunity> lstopty = [SELECT Id, Name, stagename
                                   FROM Opportunity limit 100
                                  ];
        for (Opportunity a: lstopty ) {
            Optywrap awrap = new Optywrap ();
            awrap.id = a.id;
            awrap.name = a.name;
            if (a.stagename!= null) {
                awrap.stagename= a.stagename;
            }
            lstwrap.add(awrap);
        }
        return JSON.serialize(lstwrap);
     }

}