package delorean.navigation.deeplink 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class SWFAddressDeepLink extends EventDispatcher implements IDeepLink
	{
		private var _dataParam:*;
		public function SWFAddressDeepLink() 
		{
			SWFAddress.addEventListener (SWFAddressEvent.CHANGE, _onChange);
		}
		
		private function _onChange(e:SWFAddressEvent):void 
		{
			//log (this, "_onChange: ", e.path);
			//log (this, "	params: ", SWFAddress.getParameterNames());
			dispatchEvent (new DeepLinkEvent (DeepLinkEvent.CHANGE, e.pathNames[0], _dataParam));
			_dataParam = null;
		}
		
		/* INTERFACE delorean.navigation.deeplink.IDeepLink */
		
		public function go(id:*, dataParam:* = null):void 
		{
			_dataParam = dataParam;
			SWFAddress.setValue (id);
		}
		
	}

}