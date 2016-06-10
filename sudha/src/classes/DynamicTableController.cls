public class DynamicTableController
{
    //List displayed on UI
    public List<selectoption> supportedObject {get; set;}
    
    //Selected Object
    public String SelectedObject {get; set;}
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    
    //Global describe
   // Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    Set<String> objectKeys = gd.keySet();
    
    //Field Select List
    public List<SelectOption> fieldLableAPI {get; set;}
    
    //Selected fields to be displayed in table
    public List<String> SelectedFields {get; set;}
    
    //List to maintain dynamic query result
    public List<sObject> ObjectList {get; set;}
    
    
    //Constructor
    public DynamicTableController()
    {
        //Initialize
        supportedObject = new List<selectoption>() ;
        SelectedObject = '' ;
        fieldLableAPI = new List<SelectOption>() ;
        SelectedFields = new List<String>() ;
        ObjectList = new List<sObject>() ;
        

 
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
}