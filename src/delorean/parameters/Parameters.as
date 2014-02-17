package delorean.parameters 
{
	import flash.display.LoaderInfo;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	/**
	 * 
	 */
	public class Parameters extends Proxy
	{
		public static var instance:Parameters = new Parameters ();
		
		private var _dict:Dictionary = new Dictionary (true);
		
		public function Parameters () { }
		
		override flash_proxy function setProperty(name:*, value:*):void 
		{
			_dict[name] = value;
		}
		
		override flash_proxy function getProperty(name:*):* 
		{
			return _usePrintf(name) ? (printf(_dict[name], this) || '') : _dict[name];
			return _dict[name] || "";
		}
		
		public function _usePrintf(name:*):Boolean
		{
			return _dict[name] == null || _dict[name] is String || !isNaN(_dict[name]);
		}
		
		public static function fromObj(obj:Object):void 
		{
			for (var i:String in obj)
			{
				instance[i] = obj[i];
			}
		}
		
		// TODO: implementar
		public static function fromQueryString (query:String):void
		{
			
		}
		
		public static function fromXML(xml:XMLList):void
		{
			for each (var paramXML:XML in xml.children())
			{
				instance[paramXML.name()] = paramXML.toString();
			}
		}
		
	}

}