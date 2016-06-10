public with sharing class MailPreviewBeforesendwithAttachments4 {
 
    public String subject{get;set;}
    public String body{get;set;}
    public List<string> bodyWithLineBreaks{get;set;}
    public String contactId;
    public String templateId;
    public String mailerId;
    public EmailTemplate emailTemplate;
    public String mailerType;
     
    public MailPreviewBeforesendwithAttachments4 ()
    {
        contactId = ApexPages.currentPage().getParameters().get('id');
        mailerType = ApexPages.currentPage().getParameters().get('MailerType');
                       
        try
        {        
            mailerId = [select email,accountid  from contact where Id = :contactId].Email;                        
            //The Id of the Email Template is stored in a Custom Object.
            templateId = [select id from emailtemplate where Id ='00X28000000prYp'].id;                        
            emailTemplate = [select subject, body from EmailTemplate where Id = :templateId];
        }
        catch(System.QueryException e)
        {
            ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'This Email Template does not exist.');
            ApexPages.addMessage(myMsg);
        }
         
        if(emailTemplate!=null)
        {
            subject = emailTemplate.subject;
            body = emailTemplate.body;
            body = substitute(body, contactId);
            bodyWithLineBreaks = body.split('\n');
        }
    }
     
    public String substitute(String emailBody, String contactId) {
         
        List<string> objects = new List<string>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();  
        Map<String, String> fieldsValues = new Map<String,String>{};
        /*Add all objects from which merge fields will be used in the email template*/
        objects.add('contact');
        objects.add('account');
         
        for (String objName : objects){
             
            Schema.SObjectType obj = gd.get(objName) ;
            Map<String, Schema.SObjectField> M = obj.getDescribe().fields.getMap() ;
            String objFields = '';
            for (Schema.SObjectField field : M.values()){
                    String fieldname = field.getDescribe().getName();
                    objFields += fieldname + ',';
            }
             
            objFields = objFields.substring(0, objFields.lastIndexOf(',')); //trim last comma;
            System.debug('objFields: ' + objFields);  
            Sobject relObj;
            String qryString = 'SELECT ' + objFields + ' FROM contact' + ' WHERE Id = '+'\''+contactId+'\'' + ' or email = '+'\''+mailerId+'\'';           
            relObj = Database.query(qryString + ' limit 1');    
             
            for(String s : M.keySet()) {
                 try {
                      
                     if (relObj.get(s) != null){
                        fieldsValues.put('{!' + objName + '.' + m.get(s).getDescribe().getName() + '}', String.valueOf(relObj.get(s)) );
                     } else {
                        fieldsValues.put('{!' + objName + '.' + m.get(s).getDescribe().getName() + '}', '');
                     }
                 } catch(System.Exception e) {
                      
                 }
            }
     
        }
     
        for(String s : fieldsValues.keySet()) {
             
            if(emailBody.contains(s))
            {
                emailBody = emailBody.replace(s, fieldsValues.get(s));
            }
        }
        return emailBody;
    }
}