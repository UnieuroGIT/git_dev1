public with sharing class SG_DispProdController {

    public string var {get; set;}

    public SG_DispProdController (ApexPages.StandardController stc){
    var = 'webservice_example';
    List<Product2> products_list = new List<Product2>();
    System.debug('hello');
    }

    public PageReference UpdateProduct() {
        Product2 prod = new Product2();
        String st=ApexPages.currentPage().getParameters().get('id');
        System.debug('ciao3'+st);
        System.debug('ciao');
        prod=[select id,Disponibilit_Prodotto__c from Product2 where Id=:st];
        prod.Disponibilit_Prodotto__c='disponibile'+ Datetime.now();
        System.debug('ciao1' + prod);
        update prod;
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        Pageref.setredirect(true);
        return pageRef;

    }
    public String Prod_Name{get;set;}
    public String Prod_Code{get;set;}
    Public String Prod_Descr{get;set;}
    
    public List<Product2> products_list{get; Set;}

    public PageReference Search_Product(){

    //Prod_Name='';
    // Prod_Code='';
    //Prod_Descr='';

    String CName = Prod_Name+'%';
    String CDesc = Prod_Descr+'%';
    String CCode = Prod_Code+'%';

        products_list = [Select Id, Name, Description, ProductCode 
                from 
                    Product2
                where(
                    Name LIKE :CName AND
                    Description LIKE :CDesc AND
                    ProductCode LIKE :CCode)
                    limit 50];
                    
                    update products_list;
            
            System.debug('risultati:'+ products_list.size());
            string s = '';
            for (Product2 r : products_list) s += '\n' + r;
            system.debug(s);

        return null;
    }
    
}
//public class wrapproduct{
        //public Product2 prod {get; set;}
        //public Boolean selected{get;set;}

        //public wrapproduct(Product2 p){
        //  prod=p;
        //  selected=false;
        //}
    //}