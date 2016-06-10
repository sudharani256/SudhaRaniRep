public with sharing class MailPreviewBeforesendwithAttachments5 {

   


public String emailVal{get;set;}
public String cc{get;set;}
public String emailSubject{get;set;}
public String body{get;set;}
public Attachment att{get;set;}
public List<Attachment> attList{get;set;}
private List<String> emailIds;
private List<String> ccEmailIds;
public list<EmailTemplate> EventEmailTemplatelist{get;set;}
public string templateId{get;set;}
//='00X28000000prYn';
   

    // simple Constructor for creting object of Attachment list and Attachment.
    public MailPreviewBeforesendwithAttachments5 (){
   // templateId= System.currentPagereference().getParameters().get('conid');
        attList = new List<Attachment>();
        att = new Attachment();
        
      
    }
    public List<SelectOption> getEmailTemps() {
       EventEmailTemplatelist=[SELECT FolderId,Id,Name FROM EmailTemplate]; 
            List<SelectOption> options = new List<SelectOption>();
            for(EmailTemplate e:EventEmailTemplatelist)
               options.add(new SelectOption(e.id,e.name));
            return options;
        }
          
  
    // method to attach attachment to attachment list.
    public void upload(){
        if(att.name == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select File Path First.'));
        }
        else{
            att.OwnerId = UserInfo.getUserId();
            attList.add(att);
            att = new Attachment();
        }        
    }
    
    // this action method is calls from send button.
    public void sendMail() {
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
  
      // List<String> toMail, List<String> ccEmailIdList,List<String> bccEmailIdList, String strSubject, String strMsgBody ){
        List<Messaging.EmailFileAttachment> mailAttList = new List<Messaging.EmailFileAttachment>();
         // email.setToAddresses(toMail);
      /*  if(ccEmailIdList != null && ccEmailIdList.size()>0){
            email.setCcAddresses(ccEmailIdList);
        }
        if(bccEmailIdList != null && bccEmailIdList.size()>0){
            email.setBccAddresses(bccEmailIdList);
            email.setBccSender(true);
        }*/
        list<sponsor__c> cn=[select id,name,Contact__c from sponsor__c where Contact__C!=null];
        system.debug('template id'+templateId);
        for(sponsor__c c:cn)
        {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
          for(Attachment att1 : attList){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setBody(att1.body);
            efa.setFileName(att1.name);
            mailAttList.add(efa);
            
       }
          email.setwhatId (c.id);
      
         email.settargetObjectId (c.Contact__c);
       email.setTemplateId(templateId);
      
          email.setFileAttachments(mailAttList);
  
     
        mails .add(email);
       
       } 
        
       
        
         Messaging.SendEmailResult[] resultMail=Messaging.sendEmail(mails);
         
     /*  if( emailVal !='' && emailVal.length() > 0 )
           emailIds = emailVal.split(';');
       if( cc !='' && cc.length() > 0 )
           ccEmailIds = cc.split(';');
       */
      /* Messaging.SingleEmailMessage mail = sendEmail();
       if(mail != null){
           Messaging.SendEmailResult [] r =Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Email Has Been Sent');
           ApexPages.addMessage(myMsg);
       }*/
       
    }
     public PageReference ChooseEmailTemplate() {
        return null;
    }

    
    // from this method the actual mail is sends.
    private Messaging.SingleEmailMessage sendEmail()
    {
    // List<String> toMail, List<String> ccEmailIdList,List<String> bccEmailIdList, String strSubject, String strMsgBody ){
        List<Messaging.EmailFileAttachment> mailAttList = new List<Messaging.EmailFileAttachment>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       // email.setToAddresses(toMail);
      /*  if(ccEmailIdList != null && ccEmailIdList.size()>0){
            email.setCcAddresses(ccEmailIdList);
        }
        if(bccEmailIdList != null && bccEmailIdList.size()>0){
            email.setBccAddresses(bccEmailIdList);
            email.setBccSender(true);
        }*/
        list<sponsor__c> cn=[select id,name,Contact__c from sponsor__c where Contact__C!=null];
        system.debug('template id'+templateId);
        ID[] whatidss;
        ID[] targetids;
        for(sponsor__c c:cn)
        {
        //  email.setwhatId (c.id);
      
        // email.settargetObjectId (c.Contact__c);
       //email.setTemplateId(templateId);
       whatidss.add(c.id);
       targetids.add(c.Contact__c);
       }
        
        for(Attachment att1 : attList){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setBody(att1.body);
            efa.setFileName(att1.name);
            mailAttList.add(efa);
        }
        email.setFileAttachments(mailAttList);
        
   //      Messaging.SendEmailResult[] resultMail=Messaging.sendEmail(mails);
           
      //  Messaging.SendEmailResult[] sendResult;
      
      
      
       Messaging.MassEmailMessage mailm = new Messaging.MassEmailMessage();
       mailm.setTargetObjectIds(targetids);
       mailm.setTemplateId(templateId);
       mailm.setwhatids(whatidss);
      Messaging.SendEmailResult [] mailResult= Messaging.sendEmail(new Messaging.MassEmailMessage[] { mailm });
      for( Messaging.SendEmailResult mer:mailResult)
{
         if(mer.isSuccess())    
        {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Mail Sent successfully');
           ApexPages.addMessage(myMsg);
           }
           else
           {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,mailResult[0].getErrors().get(0).getMessage());
           ApexPages.addMessage(myMsg);
        
           }
           }
        return  email ;
    }
}