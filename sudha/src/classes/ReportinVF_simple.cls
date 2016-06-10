public with sharing class ReportinVF_simple {

    public ReportinVF_simple(ApexPages.StandardController controller) {
r=new Report();
r=[SELECT Id,Name FROM Report where name='Summary check in apex2' limit 1];
reportidval=r.id;
    }

public Report r{get;set;}
public string reportidval{get;set;}
public ReportinVF_simple()
{

}
}