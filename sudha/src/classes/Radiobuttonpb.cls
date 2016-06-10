public class Radiobuttonpb
{
    public list<account>  emp;
    public Radiobuttonpb()
    {
        emp= [select id, name from Account];
    }
    public list<Account> emp_p
    {
        get
        {
            return emp;
        }
    }
}