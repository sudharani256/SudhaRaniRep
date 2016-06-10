//Declaring Class
public with sharing class SendMass_EventRegistered_Ppl_Extension {

//Declaring Globalvariables
    public Boolean isEmailTEmp { get; set; }
    public Boolean isContact { get; set; }
    public boolean isPreview{get;set;}
    public boolean pgmsg{get;set;}    
    public String EmailTemplateId{get;set;}
    public String EventStatus{get;set;}  
    public Id erId {get;set;}
    public List<EventRegistrationWrapper> EventRegistrationsList{get;set;} 
    public list<contact> EventRegstrations{get;set;}  
    List<contact> selectedERS = new List<contact>(); 
    public list<EmailTemplate> EventEmailTemplatelist{get;set;}
    public String response {get; set;} 
    //atchemnt
    public Attachment att{get;set;}
    public List<Attachment> attList{get;set;}
    
    
        
//constructor     
    public SendMass_EventRegistered_Ppl_Extension(ApexPages.StandardController controller)
     {
      erId = controller.getId();
     
      isContact=false;
      isEmailTEmp=true;
      isPreview=false;
        attList = new List<Attachment>();
        att = new Attachment();
        
        EventEmailTemplatelist=[SELECT FolderId,Id,Name FROM EmailTemplate]; 
        //WHERE FolderId =:Event_Email_Templates__c.getInstance('Events Related Email Templates').Folder_ID__c];

   
    }
    //End of Constructor  
    
    //Email Tempalte Selection
    public List<SelectOption> getEmailTEmpaltesList() {
       
        list<EmailTemplate> EventEmailTemplatelist=[SELECT FolderId,Id,Name FROM EmailTemplate ];
        //WHERE FolderId =:Event_Email_Templates__c.getInstance('Events Related Email Templates').Folder_ID__c];

        List<SelectOption> options = new List<SelectOption>();
        for(EmailTemplate emtmps:EventEmailTemplatelist)
        {
         options.add(new SelectOption(emtmps.id,emtmps.name));
        
        } 
        return options; 
    }
    
    //Templates Choosing
    
     public void  ChooseEmailTemplate()
      {
       //EmailTemplateId= System.currentPagereference().getParameters().get('conid');
       system.debug('email id'+EmailTemplateId);
 
      if(EmailTemplateId==null)
      {
      
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Choose Email Template'));
      pgmsg=true;
      isContact=false;
       isEmailTEmp=true;
       isPreview=false;
      
      }
      else
      {
       isEmailTEmp=false;
       isContact=true;
       }
       
       system.debug('renderd status'+isContact+isEmailTEmp);
     
      }
     
  
     //Picking all Event Stutus list
    public List<SelectOption> getEvenstatusdisp() 
    {   
     
      List<SelectOption> options = new List<SelectOption>();
        
     Schema.DescribeFieldResult fieldResult =contact.LeadSource.getDescribe();
    
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
     for( Schema.PicklistEntry f : ple)
     {
      options.add(new SelectOption(f.getLabel(), f.getValue()));
     }       
     return options;
   }
    
    //Send Email To Desired Users
    Public PageReference sendMail()
    {
    return null;
    }
    
    //Execute for onchange Event Registration status 
     public void find()
    {
     EventRegistrationsList = new List<EventRegistrationWrapper>();
     string stringAuery='select id,name,email,LeadSource from contact';
     //Registration_Status__c,Attendee__c,Attendee__r.name,Event__c,Attendee_Email_Id__c,Payment_Status__c from Event_Registration__c where Registration_Status__c=:EventStatus and Event__c=:erId';
              
      EventRegstrations=database.query(stringAuery);
      
       for(contact ers:EventRegstrations)
       {
          EventRegistrationsList.add(new EventRegistrationWrapper(ers));
       }
     }
     
     //Get Selected Registrations
      public void  getSelected()
    {
       selectedERS.clear();
        for(EventRegistrationWrapper erWrapper : EventRegistrationsList)
        if(erWrapper.selected == true)
        selectedERS.add(erWrapper.acc);
      
      
    }
     //cheking whether selected users size is greater than zero or not
    public List<contact> GetSelectedErs()
    {
        if(selectedERS.size()>0)
        return selectedERS;
        else
        return null;
    }  
    public pagereference Preview()
    {
    isPreview=true;
    pagereference p=new pagereference('/apex/MailPreviewBeforesendwithAttachmentsp');
 
    p.setredirect(false);
    return p;
    }
     // method to attach attachment to attachment list.
    public void upload(){
     isPreview=true;
        if(att.name == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select File Path First.'));
        }
        else{
            att.OwnerId = UserInfo.getUserId();
            attList.add(att);
            att = new Attachment();
        }        
    }
    
    //Sending Mail Process
      public PageReference sendEmail() { 
       List<Messaging.EmailFileAttachment> mailAttList = new List<Messaging.EmailFileAttachment>();
      
       
           
   system.debug('selected es'+selectedERS);       
     if(selectedERS.size()>0)
     {
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
  
      
    for(contact er:selectedERS)
    {
     Messaging.SingleEmailMessage mail =new Messaging.SingleEmailMessage();
  
      mail.setWhatId(er.id);
      mail.setTargetObjectId(er.id);
       mail.setTemplateId(EmailTemplateId);
          for(Attachment att1 : attList){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setBody(att1.body);
            efa.setFileName(att1.name);
            mailAttList.add(efa);
        } 
       mail.setFileAttachments(mailAttList);
       mails.add(mail);
     }
   
try{
           Messaging.SendEmailResult[] resultMail=Messaging.sendEmail(mails);
                 if(resultMail[0].isSuccess())       
                response = 'ok sent!';
            else{
                response = resultMail[0].getErrors().get(0).getMessage();
            }
        }catch(System.EmailException ex){
            response = ex.getMessage();
        }

mails.clear();

}
else if(selectedERS.size()==0)
{

}

        return null;
    }



 public class EventRegistrationWrapper
    {
        public contact  acc{get; set;}
        public Boolean selected {get; set;}
        public EventRegistrationWrapper(contact a)
        {
            acc = a;
            selected = false;
        }
    }

    
    

}