package delorean.controls.scroll.event {
	
	import flash.events.Event;

	public class ScrollerEvent extends Event {
		
		public static const START_SCROLLING:String = "startScrolling";
		public static const STOP_SCROLLING:String = "stopScrolling";
		public static const SCROLL:String = "scroll";
		
		public function ScrollerEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
		}
		
	}
	
}
