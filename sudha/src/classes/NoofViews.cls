public with sharing class NoofViews {
 
    public String visitorNumber{get;private set;}
    public NoofViews () {
        Cookie PageCounter = ApexPages.currentPage().getCookies().get('PageCounterCookie');
         
        // User is accessing page first time       
        if (PageCounter == null) {
            PageCounter = new Cookie('PageCounterCookie','1',null,-1,false);// create a new cookie 'PageCounterCookie', an initial value : '1', path :  'null', maxAge  : '-1'and isSecure : 'false'.
        } else {        
            Integer visitorNumber = Integer.valueOf(PageCounter.getValue());
            PageCounter = new Cookie('PageCounterCookie', String.valueOf(visitorNumber+1),null,-1,false);
        }    
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{PageCounter});  
        if(PageCounter == null) 
        {
            visitorNumber = '0';
        }   
        else
        {
            visitorNumber =  PageCounter.getValue();
        }     
    }
}