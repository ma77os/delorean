package delorean.display
{
	import flash.utils.getQualifiedClassName;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class GetAsyncDisplay {
		public function GetAsyncDisplay() {
		}
		
		public static function onAddedToStage(root : MovieClip, find : String, callback : Function, ...params) : void {
			root.addEventListener(Event.ADDED_TO_STAGE, onAdded, true);
			
			function onAdded(ev : Event) : void {
				var mc : MovieClip;
				if (getQualifiedClassName(ev.target) == find) {
					root.removeEventListener(Event.ADDED_TO_STAGE, onAdded, true);
					mc = ev.target as MovieClip;
					
					if (params.length > 0) {
						callback.apply (null, [mc].concat(params));
					} else {
						callback(mc);
					}
				}
			}
		}
	}
}