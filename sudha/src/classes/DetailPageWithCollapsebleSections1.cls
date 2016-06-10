public with sharing class DetailPageWithCollapsebleSections1 {
public list<CampaignMember> accsandtmember{get;set;}
  public  CampaignMember  getaccsandtmember1()
  {
       CampaignMember  CampaignMemberlist=[SELECT LeadId,CampaignId,campaign.name,lead.name,lead.Status FROM CampaignMember where CampaignId=:ApexPages.currentPage().getParameters().get('id')];
       //='70128000000LcNP'];
        //:ApexPages.currentPage().getParameters().get('id')];
       //,ContactId,contact.name,contact.phone
       List<Campaign> Campaignslist= [Select Id,Name,(select id from tasks),(select id,name from Sponsors__r) from Campaign where id=:CampaignMemberlist.CampaignId   ];
     accsandtmember=new list<CampaignMember>();
     accsandtmember.add(CampaignMemberlist);
      return CampaignMemberlist;
  }

  public  list<CampaignMember> getaccsandtmember()
  {
            return accsandtmember;
  }
}