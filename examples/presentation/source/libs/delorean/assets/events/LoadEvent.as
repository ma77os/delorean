package delorean.assets.events {
	
	import flash.events.Event;
	import delorean.assets.loaders.BasicLoader;
	
	
	/**
	 * ...
	 */
	public class LoadEvent extends Event {
		
		public static const PROGRESS:String = "LoadEvent_Progress";
		public static const FINISH:String = "LoadEvent_Finish";
		public static const ERROR:String = "LoadEvent_Error";
		public static const ITEM_COMPLETE:String = "LoadEvent_ItemComplete";
		
		public var bytesTotal:Number;
		public var bytesLoaded:Number;
		public var bytesPercent:Number;
		
		public var currentLoader:BasicLoader;
		
		
		public function LoadEvent(type:String) {
			super(type);
		}
		
	}
	
}