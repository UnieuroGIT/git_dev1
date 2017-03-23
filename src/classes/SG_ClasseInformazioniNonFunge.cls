public class SG_ClasseInformazioniNonFunge {

    public String didascalia{get;set;}

    public SG_ClasseInformazioniNonFunge(ApexPages.StandardController stdControl){

        System.debug('test');
    } 

    public void funzione(){ // metodo che crea l'oggetto salesforce
        CaseComment CommentNuovo= new CaseComment();
        CommentNuovo.CommentBody=didascalia;

        insert CommentNuovo;
        }

            



}