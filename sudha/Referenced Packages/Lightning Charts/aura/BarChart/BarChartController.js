({
    initScripts: function(component, event, helper) {
        
  	},

    
  	init: function(component, event, helper) {
    	//this function is called when the Component is initialized
        //set the value of the docmId attribute to be equivalent to the Local Id
        var localId = component.getLocalId();
        if (typeof localId == "undefined") {
            localId = helper.generateUniqueId(component);
        }
       	component.set("v.docmId", localId);
  	},
        
    //additional application events handled
  	refreshUI: function(component, event, helper) {
        //Application Event fired to refresh the Component
        //There might be multiple instances of this Component on a Flexi Page
        //Retrieve the ID of the Component passed (in the "source" attribute) as part of this Refresh event
        var passedGlobalId = event.getParam("source");
        var currentComponentGlobalId = component.getGlobalId();
        if (currentComponentGlobalId == passedGlobalId) {
            var currentComponent = $A.getCmp(currentComponentGlobalId);
            //implement repaint event??
        }
  	},
    
})