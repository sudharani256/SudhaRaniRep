public with sharing class knowledgelabDownloadPagePlacement {

    public knowledgelabDownloadPagePlacement(ApexPages.StandardController controller) {

    }


    public PageReference DownloadTxtFile() {
    string idv=apexpages.currentpage().getparameters().get('id');
    //ApexPages.currentPage().getparameters().get('id');
    //apexpages.currentpage().getparameters().get('id');
    Knowledgelab__c knl=new Knowledgelab__c(id=idv);
//   knl.FileCOntent__c+=
    string uno=UserInfo.getName();
       Knowledgelab__c  kn=[select id,name,FileCOntent__c from Knowledgelab__c where id=:idv]; 
       string olguserinfo= kn.FileCOntent__c;
   
    system.debug('old user info'+olguserinfo);
//    string newuserinfo=olguserinfo+uno;
  //  kn.FileCOntent__c=newuserinfo;
  
   kn.FileCOntent__c+=UserInfo.getName()+'<br>'+'iS IT hTML dISP'+'<br>'+'IS IT IN NEW LINE';
    if(idv!=null)
    upsert kn;
    
    
    PageReference p=new PageReference('/apex/knowledgelabDownload');
    p.setredirect(false);
    
    
        return p;
    }

}