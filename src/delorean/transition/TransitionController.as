package delorean.transition 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 * TODO: melhorar, fazer o queue direito
	 */
	public class TransitionController extends EventDispatcher
	{
		public var overwrite:Boolean = false;
		private var _theFunction:Function;
		private var _onCallbackComplete:Function;
		private var _onCallbackCompleteParams:Array;
		private var _inProgress:Boolean;
		private var _queue:Props;
		private var _interval:uint;
		
		public function TransitionController() 
		{
			super();
		}
		
		public function call(theFunction:Function, delay:Number = 0, onComplete:Function = null, ...onCompleteParams):void 
		{
			if (_inProgress && !overwrite)
			{
				_queue = new Props (theFunction, delay, onComplete, onCompleteParams);
				return;
			}
			_theFunction = theFunction;
			_onCallbackComplete = onComplete;
			_onCallbackCompleteParams = onCompleteParams;
			_inProgress = true;
			clearTimeout (_interval);
			_interval = setTimeout (_theFunction, delay*1000)
		}
		
		public function notifyComplete():void 
		{
			_inProgress = false;
			if (_onCallbackComplete != null) _onCallbackComplete.apply(null, _onCallbackCompleteParams);
			dispatchEvent (new Event (Event.COMPLETE));
			if (_queue != null)
			{
				call (_queue.theFunction, _queue.delay, _queue.onComplete, _queue.onCompleteParams);
				_queue = null;
			}
		}
		
		public function get inProgress():Boolean 
		{
			return _inProgress;
		}
		
	}
}

class Props
{
	public var theFunction:Function;
	public var delay:Number;
	public var onComplete:Function;
	public var onCompleteParams:Array;
	public function Props (theFunction:Function, delay:Number, onComplete:Function, onCompleteParams:Array):void
	{
		this.theFunction = theFunction;
		this.delay = delay;
		this.onComplete = onComplete;
		this.onCompleteParams = onCompleteParams;
	}
}
