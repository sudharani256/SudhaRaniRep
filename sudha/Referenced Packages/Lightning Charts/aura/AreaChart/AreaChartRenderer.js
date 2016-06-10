({    
    render: function(cmp, helper) {
    	helper.initializeDisplayFlags();
        helper.initScripts(cmp);
        return this.superRender();
	},

    afterRender: function(cmp, helper) {
        this.superAfterRender();
    	helper.initializeDisplayFlags();        
	}
    
})