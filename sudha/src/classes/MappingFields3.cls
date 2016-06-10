public class MappingFields3
{
    //List displayed on UI
    public List<selectoption> supportedObject {get; set;}
     public List<selectoption> targetObject {get; set;}
    //Selected Object
    public String SelectedObject {get; set;}
    public String SelectedObject2 {get; set;}    
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    public list<AccWrap> acwr{get;set;}
      public list<AccWrap> targetobjfieldswr{get;set;}
    //=new list<AccWrap>();
    //Global describe
   // Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    Set<String> objectKeys = gd.keySet();
    
    //Field Select List
    public List<SelectOption> fieldLableAPI {get; set;}
     public List<string> fieldLableAPIs {get; set;}
        public List<SelectOption> fieldLableAPI2 {get; set;}
    //Selected fields to be displayed in table
    public List<String> SelectedFields {get; set;}
     public List<String> SelectedFields2 {get; set;}
    //List to maintain dynamic query result
    public List<sObject> ObjectList {get; set;}
     public List<sObject> ObjectList2 {get; set;}
    
    
    //Constructor
    public MappingFields3()
    {
    acwr=new list<AccWrap>();
    targetobjfieldswr=new list<AccWrap>();
        //Initialize
        supportedObject = new List<selectoption>() ;
        targetObject= new List<selectoption>() ;
        SelectedObject = '' ;
        fieldLableAPI = new List<SelectOption>() ;
        fieldLableAPIs=new list<string>();
         fieldLableAPI2 = new List<SelectOption>() ;
        SelectedFields = new List<String>() ;
              SelectedFields2 = new List<String>() ;
        ObjectList = new List<sObject>() ;
         ObjectList2 = new List<sObject>() ;
        

 
        //Get only reference to objects
        for(string  item : gd.keySet())
        //ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())
        {
            //Excluding custom setting objects
            //if(item.getDescribe().Custom)
            //CustomSetting)
            //{
                
               // supportedObject.add(new SelectOption(gd.get(item).getDescribe().getLocalName().toLowerCase() , gd.get(item).getDescribe().getLabel() ));
                 supportedObject.add(new SelectOption(item , item ));
                targetObject.add(new SelectOption(item , item ));
                
            //}
        } 
       
        
    }
    
    //Get fields of selected object
    public void ObjectFields()
    {
        if(SelectedObject  != null && SelectedObject != '--None--')
        
        {
         system.debug('supported objs----------'+supportedObject);
            system.debug('SelectedObject========'+SelectedObject);
            system.debug('gd========='+gd);
            system.debug('gd.get(SelectedObject)======='+gd.get(SelectedObject));
            //Creating sObject for dynamic selected object
            Schema.SObjectType systemObjectType = gd.get(SelectedObject);
            //Fetching field results
           // Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
           system.debug('systemObjectType ============'+systemObjectType );
            
                Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
            Map<String, Schema.SObjectField> M = r.fields.getMap();
            //Creating picklist of fields
            for(Schema.SObjectField fieldAPI : M.values())
            {
                fieldLableAPI.add(new SelectOption(fieldAPI.getDescribe().getName() , fieldAPI.getDescribe().getLabel())) ;
                 fieldLableAPIs.add(fieldAPI.getDescribe().getName() );
                 AccWrap acn=new AccWrap();
                 acn.selVal=fieldAPI.getDescribe().getName();
                 acwr.add(acn);
            }
        }
    }
    
    //target object
       //Get fields of selected object
    public void ObjectFields2()
    {
        if(SelectedObject2  != null && SelectedObject2 != '--None--')
        
        {
         system.debug('supported objs----------'+supportedObject);
            system.debug('SelectedObject========'+SelectedObject2);
            system.debug('gd========='+gd);
            system.debug('gd.get(SelectedObject)======='+gd.get(SelectedObject));
            //Creating sObject for dynamic selected object
            Schema.SObjectType systemObjectType = gd.get(SelectedObject2);
            //Fetching field results
           // Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
           system.debug('systemObjectType ============'+systemObjectType );
            
                Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
            Map<String, Schema.SObjectField> M = r.fields.getMap();
            //Creating picklist of fields
            for(Schema.SObjectField fieldAPI : M.values())
            {
                fieldLableAPI2.add(new SelectOption(fieldAPI.getDescribe().getName() , fieldAPI.getDescribe().getLabel())) ;
                        AccWrap acn=new AccWrap();
                 acn.selVal=fieldAPI.getDescribe().getName();
                 targetobjfieldswr.add(acn);
            }
        }
    }
    
    public void ShowTable()
    {
        //Creating dynamic query with selected field
        String myQuery = 'Select Id ' ;
        
        for(String field : SelectedFields)
        {
            if(field.toLowerCase() != 'id' && field.toLowerCase() != '--none--')
            myQuery += ','+ field + ' ' ;
        }
        
        //Limit is 100 for now you can change it according to need
        myQuery += ' from ' + SelectedObject + ' LIMIT 100' ;
        
        //Executing the query and fetching results
        ObjectList = Database.query(myQuery) ;
    }
    public void maprecords()
    {
    system.debug('slected field:'+acwr);
      system.debug('target slected field:'+targetobjfieldswr);
    //************source object**********************//
     //Creating dynamic query with selected field
     for(AccWrap s: acwr)
     {
     if(s.selVal!='--None--')
     {     
     SelectedFields.add(s.selVal); 
     }
     }
     //target object
     for(AccWrap s: targetobjfieldswr)
     {
     if(s.selVal!='--None--')
     {     
     SelectedFields2.add(s.selVal); 
     }
     }
      system.debug('slected field list:'+SelectedFields);
      system.debug('target slected field list:'+SelectedFields2);
        String myQuery = 'Select Id ' ;
        
        for(String field : SelectedFields)
        {
            if(field.toLowerCase() != 'id' && field.toLowerCase() != '--none--')
            myQuery += ','+ field + ' ' ;
        }
        
        //Limit is 100 for now you can change it according to need
        myQuery += ' from ' + SelectedObject + ' LIMIT 100' ;
        
        //Executing the query and fetching results
        ObjectList = Database.query(myQuery) ;
        
        //***************Target Object**************
           //Creating dynamic query with selected field
        String myQuery2 = 'Select Id ' ;
        
        for(String field : SelectedFields2)
        {
            if(field.toLowerCase() != 'id' && field.toLowerCase() != '--none--')
            myQuery += ','+ field + ' ' ;
        }
        
        //Limit is 100 for now you can change it according to need
        myQuery2 += ' from ' + SelectedObject2 + ' LIMIT 100' ;
        
        //Executing the query and fetching results
        ObjectList2 = Database.query(myQuery2) ;
        //maping to insert records
        /*
        Map<String, String> mpflds= new Map<String, String>();
  map<string,string> mpflds2=new map<string,string>();
  
       //maping
        for(integer i=0;i<SelectedFields2.size()-1;i++)
 {
    // for(String paramName2: SelectedFields2)
      {
          
         if(SelectedFields[i] != '--None--' && SelectedFields2[i] != '--None--')
         {
         
        mpflds.put(SelectedFields[i],SelectedFields2[i]);
        mpflds2.put(SelectedFields2[i],SelectedFields[i]);
         }
    }
 }
       //maping end
       //records map
  SObject sobjectInstance;
    SObject sourcesobjectInstance;

   SObjectType sObj;
      SObjectType sourcesObj;
  
 //Get all the Objects
 gd = Schema.getGlobalDescribe();
 
 //Get sobj for that particular object name
 sObj = gd.get(SelectedObject2 );
  sourcesObj = gd.get(SelectedObject );

  sobjectInstance = sObj.newSObject();
  sourcesobjectInstance=sourcesObj.newSObject();
 
list<sobject>  trginsert =new list<sobject>();
 //recs
    for(sobject s: ObjectList )
        {
  
   sourcesobjectInstance=sourcesObj.newSobject();
 Map<String, SObjectField> fields = sObj.getDescribe().fields.getMap();
   Map<String, SObjectField> fields2 = sObj.getDescribe().fields.getMap();
 for(string sf:fields)
 {
      sobjectInstance = sObj.newSObject();
 SObjectField fieldtoken = fields.get(mpflds.get(sf));

 SObjectField fieldtoken2 = fields2.get(mpflds2.get(fieldtoken));
 DescribeFieldResult dfr = fieldtoken.getDescribe();
  DescribeFieldResult dfr2 = fieldtoken2.getDescribe();
 String fieldAPIName = dfr.getName();
  String fieldAPIName2 = dfr2.getName();
  //Appending to the sObjectInstance
        
            sobjectInstance.put(fieldAPIName , s.get(fieldAPIName2));
            trginsert.add(sobjectInstance);
 } 
  
        }*/
        //insert trginsert
        
    }
    public class AccWrap
{
  
   public String selVal {get; set;}

   public AccWrap()
   {
     
   }
}
}