package myShopper.common.air.data {
	import flash.data.SQLConnection;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import myShopper.common.utils.Tracer;
	
	/**
	 * ...
	 * @author Toshi
	 */
	[Event(name = "error", type = "flash.events.SQLErrorEvent")] 
	[Event(name="result", type="flash.events.SQLEvent")] 
	public class Database extends EventDispatcher 
	{
		//public static const DB_NAME:String = 'my';
		protected var conn:SQLConnection;
		protected var DBFile:File;
		protected var DBName:String;
		protected var DBTableName:String;
		
		protected var _isConnected:Boolean;
		public function get isConnected():Boolean 
		{
			return _isConnected;
		}
		
		
		protected var _isDBCreated:Boolean;
		public function get isReady():Boolean 
		{
			return _isDBCreated && _isConnected;
		}
		
		public function Database(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
			_isConnected = false;
			
			conn = new SQLConnection(); 
			//conn.addEventListener(SQLEvent.OPEN, onConnectionSuccess); 
			//conn.addEventListener(SQLErrorEvent.ERROR, onConnectionFail); 
		}
		
		public function init(inDBName:String, inDBTableName:String):Boolean
		{
			if (!inDBName || !inDBTableName) return false;
			
			DBName = inDBName;
			DBTableName = inDBTableName;
			
			DBFile = File.applicationStorageDirectory.resolvePath(/*"DBSample.db"*/ DBName);
			
			if (!DBFile)
			{
				Tracer.echo('Database : init : unable to resolve file : ' + DBName);
				return false;
			}
			
			try
			{
				conn.open(DBFile);
				//conn.openAsync(DBFile);
				_isDBCreated = _isConnected = true;
			}
			catch (e:Error)
			{
				_isDBCreated = _isConnected = false;
				Tracer.echo('Database : init : fail openning DB!');
				return false;
			}
			
			return true;
		}
		
		/*protected function onConnectionFail(e:SQLErrorEvent):void 
		{
			dispatchEvent(e);
		}
		
		protected function onConnectionSuccess(e:SQLEvent):void 
		{
			_isConnected = true;
		}*/
		
		
	}

}