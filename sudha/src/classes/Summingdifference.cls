public with sharing class Summingdifference {

list<Opportunity> ops=new list<Opportunity>();
list<PastMOnthOp__c> pmo=new list<PastMOnthOp__c>();
public list<differencewraper> lws{get;set;}
public differencewraper df{get;set;}
List<AggregateResult> ago;
AggregateResult ago2;
public Summingdifference ()
{
df=new differencewraper();
lws=new list<differencewraper>();
ago=database.query('select SUM(amount) s,StageName snm   from Opportunity where CreatedDate = THIS_MONTH  group by ROLLUP(StageName)');                         
ago2=database.query('select SUM(Amount__c ) sm from PastMOnthOp__c'); 
ops=[select id,StageName,amount,createddate from Opportunity  where CreatedDate = THIS_MONTH]; 
pmo=[select id,name,createddate,Amount__c from PastMOnthOp__c where CreatedDate = THIS_MONTH];
for(AggregateResult op: ago)
{
 string stagename=((string)op.get('snm'));
                            
                             
for(PastMOnthOp__c  pos:pmo )
{
if(stagename==pos.name)
{
lws.add(new differencewraper(stagename,((decimal)op.get('s')),pos.Amount__c ,pos.Amount__c-((Double)op.get('s')))); 
}

}
if(stagename==null)
{

df.opdb=((decimal)op.get('s'));
df.podb=((decimal)ago2.get('sm'));
df.dif=(((decimal)ago2.get('sm'))-((Double)op.get('s')));
 
 //lws.add(new differencewraper(((decimal)op.get('s')),((decimal)ago2.get('sm')),(((decimal)ago2.get('sm'))-((Double)op.get('s')))));
}
}


}
public class differencewraper 
{
public String stage{get;set;}
public Opportunity op{get;set;}
public PastMOnthOp__c po{get;set;}
public Double opdb{get;set;}
public Double podb{get;set;}
public decimal dif {get;set;}
public differencewraper()
{
}
 public differencewraper(String stage,Opportunity op,PastMOnthOp__c po,decimal dif)
 {
 this.stage=stage;
 this.op=op;
 this.po=po;
 this.dif=dif ;
 }
  public differencewraper(String stage,Decimal opdb,Decimal podb,decimal dif)
 {
 this.stage=stage;
 this.opdb=opdb;
 this.podb=podb;
 this.dif=dif ;
 }
  public differencewraper(Decimal opdb,Decimal podb,decimal dif)
 {
 this.stage=stage;
 this.opdb=opdb;
 this.podb=podb;
 this.dif=dif ;
 }
}
}