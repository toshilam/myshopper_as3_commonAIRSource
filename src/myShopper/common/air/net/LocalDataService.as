package myShopper.common.air.net 
{
	import flash.events.EventDispatcher;
	import myShopper.common.air.data.Database;
	import myShopper.common.events.ServiceEvent;
	import myShopper.common.interfaces.IService;
	import myShopper.common.interfaces.IServiceRequest;
	import myShopper.common.utils.Tracer;
	
	/**
	 * 
	 * @author Toshi Lam
	 */
	public class LocalDataService extends EventDispatcher implements IService
	{
		
		private static var instance:LocalDataService;
		protected var _data:Database;
		
		
		public function LocalDataService(inPvtClass:PrivateClass, inData:Database) 
		{
			super();
			
			_data = inData;
		}
		
		public static function getInstance(inData:Database):LocalDataService
		{
			if (LocalDataService.instance == null) 
			{
				LocalDataService.instance = new LocalDataService(new PrivateClass(), inData);
			}
			
			return LocalDataService.instance;
		}
		
		public function isReady():Boolean
		{
			return isAvailable() && _data.isReady;
		}
		
		public function request(inRequest:IServiceRequest):Boolean
		{
			if (!(inRequest is IServiceRequest))
			{
				Tracer.echo('LocalDataService : unknown data type : ' + inRequest, this, 0xFF0000);
				return false;
			}
			
			if (!isAvailable())
			{
				Tracer.echo('LocalDataService : request : database not defined!');
				dispatchEvent(new ServiceEvent(ServiceEvent.FAULT));
				
				return false;
			}
			
			
			//to be implemented by sub class
			
			return true;
		}
		
		public function isAvailable():Boolean 
		{
			/*CONFIG::desktop
			{
				return true;
			}*/
			
			return !!_data;
		}
		
		
		
	}

}

/*class PrivateClass
{
	public function PrivateClass():void{}
}*/