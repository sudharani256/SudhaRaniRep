public with sharing class MappingFields_controller {

public MappingFields_controller ()
{
}
public list<selectoption> getSourceObjects()
{
Map<String, Schema.SObjectType> gd = 
Schema.getGlobalDescribe(); 
 list<selectoption> objvals=new  list<selectoption>();
for(string sobj : gd.keyset())
{
objvals.add(new selectoption(sobj,sobj));
}
return objvals;
}
 public String getFieldAPIfromobject(String sobjectName)
    {
        String strFields='';
        Map<String, Schema.SObjectType> sobjectSchemaMap = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult objDescribe = sobjectSchemaMap.get(sobjectName).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        for(Schema.SObjectField fieldDef : fieldMap.values()) 
        {
         Schema.Describefieldresult fieldDescResult = fieldDef.getDescribe();
         System.debug('field name =' + fieldDescResult.getName());
         String fieldname = fieldDescResult.getName();
         //lstfields.add(fieldname);
         strFields += fieldname +',';
        }
        strFields = strFields.substring(0,strFields.length() - 1);
        return strFields;
    }
}