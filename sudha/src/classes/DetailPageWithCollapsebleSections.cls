public with sharing class DetailPageWithCollapsebleSections {
  public List<Campaign> getaccsandtmember()
  {
      List<Campaign> Campaignslist= [Select Id,Name,HierarchyNumberOfOpportunities  from Campaign ];
      return Campaignslist;
  }

}