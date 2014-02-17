package delorean.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 * @since 24/01/2010
	 * 
	 * TODO: ajustar quando o total for 0 (numa busca, por exemplo);
	 * TODO: implement Iterator pattern (?)
	 *
	 * @example 
	var p:Paginator = new Paginator (30, 4, 0);
	trace (p.totalPages) // total of pages: 8
	
	trace (p.page) // vector of indexes: [0,1,2,3]
	
	p.next();
	trace (p.page) // [4,5,6,7]
	
	p.last();
	trace (p.page) // [28,29]
	
	p.previous();
	trace (p.page) // [24,25,26,27]
	
	p.first();
	trace (p.page) // [0,1,2,3]
	
	trace (p.current) // current page index: 6
	
	p.goto(5);
	trace (p.page) // [20,21,22,23]
	
	// you can add a sprite for nextButton and/or prevButton, and its visibility will be managed automatically
	p.nextButton = myNextButtonSprite;
	p.prevButton = myPrevButtonSprite;
	 * 
	 */
	public class Paginator extends EventDispatcher
	{
		public static const FIRST_LAST:String = "firstLast";
		public static const CIRCLE:String = "circle";
		
		private var _perPage:int;
		private var _total:int;
		private var _totalPages:int;
		private var _current:int;
		private var _mode:String = FIRST_LAST;
		private var _isFirst:Boolean;
		private var _isLast:Boolean;
		private var _hideButtons : Boolean = false;
		private var _page:Vector.<int>;
		private var oldIndex : int;
		
		private var _nextButton:MovieClip;
		private var _prevButton:MovieClip;
		private var _direction:int;
		
		public function Paginator (perPage:int = 1, startPage:int = 0, total:int = 0) 
		{
			_total = total;
			_perPage = perPage;
			_current = startPage;
			
			_validate ();
		}
		
		/**
		 * 
		 */
		
		public function next(e:Event = null):void
		{
			goto (_current + 1);
		}
		
		/**
		 * 
		 */
		public function previous(e:Event = null):void
		{
			goto (_current - 1);
		}
		
		/**
		 * 
		 * @param	index
		 *
		 */
		public function goto (index:int):void
		{
			
			_direction = index >= _current ? 1 : -1;
			
			//if (index >= _totalPages || index < 0) throw new Error ("The specified page index ("+index+") is out of boundaries. The last page index is " + (_totalPages-1));
			_current = index;
			_validate ();
			
			if (current != this.oldIndex) dispatchEvent (new Event (Event.CHANGE));
			
			this.oldIndex = current;
		}
		
		public function first():void
		{
			goto (0);
		}
		
		public function last():void
		{
			goto (_totalPages - 1);
		}
		
		public function update() : void {
			_current = 0;
			this.oldIndex = -1;
			_validate();
		}
			
		
		/**
		 *
		 */
		private function _validate():void
		{
			_totalPages = Math.ceil(_total / _perPage);
			
			if (_current > _totalPages -1) _current = _mode == FIRST_LAST ? _totalPages - 1 : 0;
			else if (_current < 0) _current = _mode == FIRST_LAST ? 0 : _totalPages - 1;
			
			_isFirst = _isLast = false;
			_isFirst = _current == 0;
			_isLast = _current == _totalPages - 1;
			
			if (_nextButton != null)
			{
				_nextButton.visible = !_isLast;
			}
			if (_prevButton != null)
			{
				_prevButton.visible = !_isFirst;
			}
			
			if (total == 0 && _prevButton && _nextButton)
			{
				
				_nextButton.visible = false;
				_prevButton.visible = false;
				
			}
			
			_fetchPage ();
		}
		
		private function _fetchPage():void
		{
			_page = new Vector.<int>();
			
			if (total == 0){
				return;
			}
			
			var startIndex:int = _current * _perPage;
			var endIndex:int = Math.min (startIndex + _perPage, _total);
			var i:int;
			
			for (i = startIndex; i < endIndex; i++)
			{
				_page.push (i);
			}
		}
		
		public function get mode():String { return _mode; }
		
		// TODO: validate only FIRST_LAST and CIRCLE modes
		public function set mode(value:String):void 
		{
			_mode = value;
			_validate ();
		}
		
		public function get perPage():int { return _perPage; }
		
		public function set perPage(value:int):void 
		{
			_perPage = value;
			_validate ();
		}
		
		public function get total():int { return _total; }
		
		public function set total(value:int):void 
		{
			_total = value;
			_validate ();
		}
		
		public function get page():Vector.<int> { return _page; }
		
		public function get totalPages():int { return _totalPages; }
		
		public function get current():int { return _current; }
		
		public function get nextButton():MovieClip { return _nextButton; }
		
		public function set nextButton(value:MovieClip):void 
		{
			_nextButton = value;
			_nextButton.addEventListener (MouseEvent.CLICK, next, false, 0, true);
			_nextButton.buttonMode = true;
		}
		
		public function get prevButton():MovieClip { return _prevButton; }
		
		public function set prevButton(value:MovieClip):void 
		{
			_prevButton = value;
			_prevButton.addEventListener (MouseEvent.CLICK, previous);
			_prevButton.buttonMode = true;
		}
		
		public function get direction():int { return _direction; }

		public function get hideButtons():Boolean {
			return _hideButtons;
		}

		public function set hideButtons(value:Boolean):void {
			_hideButtons = value;
		}

		
	}

}