public with sharing class DetailPageWithCollapsebleSections2 {

    public String rowNum { get; set; }
public list<CampaignMember> accsandtmember{get;set;}
 set<id> contactids;
  
  list<CampaignMember>  CampaignMemberlist;
 public DetailPageWithCollapsebleSections2()
 {
   CampaignMemberlist= [SELECT LeadId,CampaignId,contactid,campaign.name,lead.name,lead.Status,name FROM CampaignMember where CampaignId=:ApexPages.currentPage().getParameters().get('id')];
        
 }
  
      public  list<CampaignMember>  getaccsandtmember1()
      {
           //  CampaignMemberlist=new  list<CampaignMember>();
         //   CampaignMemberlist= [SELECT LeadId,CampaignId,contactid,campaign.name,lead.name,lead.Status,name FROM CampaignMember where CampaignId=:ApexPages.currentPage().getParameters().get('id')];
                       //='70128000000LcNP'];
                       //:ApexPages.currentPage().getParameters().get('id')];
                       //,ContactId,contact.name,contact.phone
                        //  List<Campaign> Campaignslist= [Select Id,Name,(select id from tasks),(select id,name from Sponsors__r) from Campaign where id=:ApexPages.currentPage().getParameters().get('id')  ];
                        //     accsandtmember=new list<CampaignMember>();
                         //accsandtmember.add(CampaignMemberlist);
          return CampaignMemberlist;
      }

    
    public list<contact> GetContactsData()
    {
    
      contactids=new set<id>();
    for(CampaignMember cmbr:CampaignMemberlist)
    {
    contactids.add(cmbr.contactid);
    }
        list<contact> lstcons=[select id,name,phone from contact where id in:contactids];
        return lstcons;

 
       }
        public     list<Opportunity > GetOpportunitiesData()
    {
GetContactsData();
            set<id> acnttids=new set<id>();
            list<contact> cons=[select id,accountid from contact where id in:contactids];
        
          for(contact a:cons)
          {
          acnttids.add(a.accountid);
  
          }
    //new set<id>();
    /*for(CampaignMember cmbr:CampaignMemberlist)
    {
    contactids.add(cmbr.contactid);
    }*/
    //contactids
   
        list<Opportunity> lstcons=[select id,name,accountid,StageName   from Opportunity where accountid in:acnttids];
        return lstcons;

 
       }
  public  list<CampaignMember> getaccsandtmember()
  {
            return accsandtmember;
  }
   public  list<Campaign> getCampainChilds()
  {
   List<Campaign> Campaignslist= [Select Id,Name,(select id,subject from tasks),(select id,name from campaignmembers),(select id,name from Sponsors__r) from Campaign where id=:ApexPages.currentPage().getParameters().get('id')  ];
     
            return Campaignslist;
  }
}