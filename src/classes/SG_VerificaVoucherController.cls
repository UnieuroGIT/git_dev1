public class SG_VerificaVoucherController {

    private ApexPages.StandardController Controller;
    public string VoucherCode {get;set;}
    public string VoucherStatus {get;set;}
    
    public SG_VerificaVoucherController() {
    	VoucherCode='';
  
    }  
  
    public void verifica(){
        VoucherStatus = SG_WS_Voucher.VerificaVoucher(VoucherCode);
    }
    
    public void Annulla(){
        VoucherStatus = SG_WS_Voucher.AnnullaVoucher(VoucherCode);
        
        
    }
    
}