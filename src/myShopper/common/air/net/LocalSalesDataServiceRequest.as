package myShopper.common.air.net 
{
	import myShopper.common.interfaces.IResponder;
	import myShopper.common.net.ServiceRequest;
	
	/**
	 * ...
	 * @author Toshi Lam
	 */
	public class LocalSalesDataServiceRequest extends ServiceRequest 
	{
		private var _shopNo:String;
		private var _invoice:String;
		
		/**
		 * 
		 * @param	inKey - data key for retreve/remove data
		 * @param	inType - type of service that will be used Service handler object
		 * @param	inData - optional data that wanna pass to other subscriber
		 * @param	inRequester - responder object that will be used when add (ADD_COMMUNICATOR) itself to subscriber list
		 */
		public function LocalSalesDataServiceRequest(inShopNo:String, inInvoice:String, inType:String, inData:Object = null, inRequester:IResponder = null) 
		{
			super(inType, inData, inRequester)
			_shopNo = inShopNo;
			_invoice = inInvoice;
		}
		
		public function get shopNo():String 
		{
			return _shopNo;
		}
		
		public function get invoice():String 
		{
			return _invoice;
		}
		
		
		
		
		
	}

}