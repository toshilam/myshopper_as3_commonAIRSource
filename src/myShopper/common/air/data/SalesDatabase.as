package myShopper.common.air.data 
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import myShopper.common.utils.Tools;
	import myShopper.common.utils.Tracer;
	
	/**
	 * ...
	 * @author Toshi
	 */
	
	public class SalesDatabase extends Database 
	{
		
		public function SalesDatabase(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
		}
		
		override public function init(inDBName:String, inDBTableName:String):Boolean 
		{
			if ( super.init(inDBName, inDBTableName) )
			{
				var createStmt:SQLStatement = new SQLStatement();
				createStmt.sqlConnection = conn;
				
				
				var sql:String = ""; 
				sql += "CREATE TABLE IF NOT EXISTS "+ DBTableName + " ("; 
				sql += " s_no INTEGER PRIMARY KEY AUTOINCREMENT,"; 
				sql += " s_shop_no TEXT,"; 
				sql += " s_invoice TEXT,"; 
				sql += " s_data TEXT"; //sales data in json format
				//sql += " s_date_time DATETIME NOT NULL DEFAULT CURRENT_DATETIME";
				sql += ")"; 
				
				createStmt.text = sql;
				
				//createStmt.addEventListener(SQLEvent.RESULT, onCreateDBResult); 
				//createStmt.addEventListener(SQLErrorEvent.ERROR, onCreateDBError);
				
				try
				{
					createStmt.execute();
					_isDBCreated = true;
					dispatchEvent(new SQLEvent(SQLEvent.RESULT));
				}
				catch (e:Error)
				{
					dispatchEvent(new SQLErrorEvent(SQLErrorEvent.ERROR, false, false));
					
					return false;
				}
				
				return true;
			}
			
			return false;
		}
		
		
		
		/*private function onCreateDBError(e:SQLErrorEvent):void 
		{
			dispatchEvent(e);
		}
		
		private function onCreateDBResult(e:SQLEvent):void 
		{
			_isDBCreated = true;
			dispatchEvent(e);
		}*/
		
		public function addSales(inShopNo:String, inInvoice:String, inData:Object):Boolean
		{
			if (!isReady) return false;
			
			var insertStmt:SQLStatement = new SQLStatement(); 
			insertStmt.sqlConnection = conn; 
			
			var sql:String = ""; 
			var jsonData:String =  JSON.stringify(inData);
			
			var resultObj:Object = getSales(inShopNo, inInvoice);
			if (resultObj && resultObj[inInvoice])
			{
				sql += "UPDATE " + DBTableName + " SET s_data='{0}' ";
				sql += "WHERE s_shop_no='{1}' AND s_invoice='{2}'"; 
				
				insertStmt.text = Tools.formatString( sql, [jsonData, inShopNo, inInvoice]); 
			}
			else
			{
				sql += "INSERT INTO " + DBTableName + " (s_shop_no, s_invoice, s_data) ";
				sql += "VALUES ('{0}', '{1}', '{2}')"; 
				
				insertStmt.text = Tools.formatString( sql, [inShopNo, inInvoice, jsonData] ); 
			}
			
			
			
			//insertStmt.addEventListener(SQLEvent.RESULT, onInsertResult); 
			//insertStmt.addEventListener(SQLErrorEvent.ERROR, onInsertError); 
			
			try
			{
				insertStmt.execute(); 
				
			}
			catch(e:Error)
			{
				Tracer.echo('SalesDatabase : add : fail adding recode : ' + e.message);
				return false;
			}
			
			return true;
		}
		
		/*private function onInsertError(e:SQLErrorEvent):void 
		{
			dispatchEvent(e);
		}
		
		private function onInsertResult(e:SQLEvent):void 
		{
			
		}*/
		
		public function removeSales(inShopNo:String, inInvoice:String):Boolean
		{
			if (!isReady) return false;
			
			var insertStmt:SQLStatement = new SQLStatement(); 
			insertStmt.sqlConnection = conn; 
			
			var sql:String = "";
			sql += "DELETE FROM " + DBTableName + " WHERE s_shop_no='{0}' AND s_invoice='{1}'";
			
			insertStmt.text = Tools.formatString( sql, [inShopNo, inInvoice]); 
			//insertStmt.addEventListener(SQLEvent.RESULT, onInsertResult); 
			//insertStmt.addEventListener(SQLErrorEvent.ERROR, onInsertError); 
			
			try
			{
				insertStmt.execute(); 
				
			}
			catch (e:Error)
			{
				Tracer.echo('SalesDatabase : remove : fail adding recode : ' + e.message);
				return false;
			}
			
			return true;
			
		}
		
		public function getSales(inShopNo:String, inInvoice:String = null):Object
		{
			if (!isReady) return false;
			
			var insertStmt:SQLStatement = new SQLStatement(); 
			insertStmt.sqlConnection = conn; 
			
			var arrArg:Array = [inShopNo];
			var sql:String = ""; 
			sql += "SELECT s_shop_no, s_invoice, s_data FROM " + DBTableName + " WHERE s_shop_no='{0}'";
			
			if (inInvoice)
			{
				sql += " AND s_invoice='{1}'"; 
				
				arrArg.push(inInvoice);
			}
			
			insertStmt.text = Tools.formatString(sql, arrArg); 
			//insertStmt.addEventListener(SQLEvent.RESULT, onInsertResult); 
			//insertStmt.addEventListener(SQLErrorEvent.ERROR, onInsertError); 
			
			try
			{
				insertStmt.execute(); 
				
			}
			catch(e:Error)
			{
				Tracer.echo('SalesDatabase : getSales : fail getting recode : ' + e.message);
				return false;
			}
			
			var resultObj:Object = { };
			var result:SQLResult = insertStmt.getResult();
			var numResults:int = result.data ? result.data.length : 0; 
			
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 
				resultObj[row.s_invoice] = JSON.parse(row.s_data); 
			} 
			
			return resultObj;
		}
	}

}