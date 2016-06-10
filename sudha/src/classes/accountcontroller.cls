public class accountcontroller{
public account account{get;set;}

public accountcontroller()
{
account=new account(id=Apexpages.currentpage().getparameters().get('id'));
}
}