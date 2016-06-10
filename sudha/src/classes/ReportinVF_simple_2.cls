public with sharing class ReportinVF_simple_2 {
public string reportidval{get;set;}
public  ReportinVF_simple_2()
{
reportidval=[SELECT DeveloperName,Format,Id,Name FROM Report where name='Summary check in apex2'].id;
}
}