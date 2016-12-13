package myShopper.common.air.net 
{
	import flash.data.SQLResult;
	import flash.events.EventDispatcher;
	import myShopper.common.air.data.Database;
	import myShopper.common.air.data.SalesDatabase;
	import myShopper.common.emun.RequestType;
	import myShopper.common.interfaces.IService;
	import myShopper.common.interfaces.IServiceRequest;
	import myShopper.common.net.ServiceResponse;
	import myShopper.common.utils.Tracer;
	
	/**
	 * 
	 * @author Toshi Lam
	 */
	public class LocalSalesDataService extends LocalDataService
	{
		
		private static var instance:LocalSalesDataService;
		
		
		public function LocalSalesDataService(inPvtClass:PrivateClass, inData:Database) 
		{
			super(inPvtClass, inData);
			
			//_data = inData;
		}
		
		public function init(inDBName:String, inDBTableName:String):Boolean
		{
			return _data.init(inDBName, inDBTableName);
		}
		
		public static function getInstance(inData:Database):LocalSalesDataService
		{
			if (!(inData is SalesDatabase))
			{
				Tracer.echo('LocalSalesDataService : getInstance : unknown data!');
				return null;
			}
			
			if (LocalSalesDataService.instance == null) 
			{
				LocalSalesDataService.instance = new LocalSalesDataService(new PrivateClass(), inData);
			}
			
			return LocalSalesDataService.instance;
		}
		
		override public function request(inRequest:IServiceRequest):Boolean
		{
			var req:LocalSalesDataServiceRequest = inRequest as LocalSalesDataServiceRequest;
			
			if (!super.request(inRequest) || !(req is LocalSalesDataServiceRequest) || !_data)
			{
				Tracer.echo('LocalSalesDataService : requeset : unknown data!');
				return false;
			}
			
			
			
			var salesDB:SalesDatabase = _data as SalesDatabase;
			
			switch(req.type)
			{
				case RequestType.LOCAL_DATA_SAVE_ORDER:
				{
					return salesDB.addSales(req.shopNo, req.invoice, req.data);
					//break;
				}
				
				case RequestType.LOCAL_DATA_REMOVE_ORDER:
				{
					return salesDB.removeSales(req.shopNo, req.invoice);
					//break;
				}
				case RequestType.LOCAL_DATA_GET_ORDER_BY_NO:
				{
					var result:Object = salesDB.getSales(req.shopNo, req.invoice);
					
					//if (result)
					//{
						req.requester.result(new ServiceResponse(req, result));
					//}
					
					return !!result;
					//break;
				}
				case RequestType.LOCAL_DATA_GET_ORDERS:
				{
					req.requester.result(new ServiceResponse(req, salesDB.getSales(req.shopNo)));
					return true;
					//break;
				}
				
				default:
				{
					Tracer.echo('LocalSalesDataService : requeset : unknown request type!');
					return false;
				}
			}
			
			return true;
		}
		
		
		
		
	}

}

/*class PrivateClass
{
	public function PrivateClass():void{}
}*/