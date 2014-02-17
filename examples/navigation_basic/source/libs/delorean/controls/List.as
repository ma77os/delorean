package delorean.controls 
{
	import delorean.controls.sliders.SimpleSlider;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 * TODO: implementar resize de largura automatico, ou valor especificado
	 */
	public class List extends EventDispatcher
	{
		public var view:MovieClip;
		private var _bg:MovieClip;
		private var _slider:MovieClip;
		private var _maskList:Sprite;
		private var _sliderController:SimpleSlider;
		private var _rowCount:uint = 9;
		private var _itemListClass:Class;
		private var _itemsContainer:Sprite;
		private var _dataProvider:Array;
		private var _arrItems:Array;
		private var _selectedItem:Object;
		private var _listYInit:Number = 0;
		private var _autoSizeSlider:Boolean = false;
		
		public function List(pView:MovieClip, itemListClass:*) 
		{
			super();
			view = pView;
			_itemListClass = itemListClass is Class ? itemListClass : getDefinitionByName (itemListClass) as Class;
			
			_bg = view["bg"];
			_slider = view["slider"];
			if (_slider) _slider.visible = false;
			
			_itemsContainer = new Sprite ();
			_itemsContainer.name = 'listItemsContainer';
			view.addChild (_itemsContainer);
			_maskList = view["maskList"];
			
		}
		
		public function addItem (label:String, data:Object = null):void
		{
			if (_dataProvider == null) _dataProvider = new Array ();
			var itemData:Object = {label:label, data:data}
			_dataProvider.push (itemData)
			_createItem (itemData);
			_updateScroll();
			
		}
		
		// TODO: implementar deleteItem. usar dictionary?
		public function removeItem():void
		{
			_updateScroll();
		}
		
		public function selectItemByIndex(index:uint):void
		{
			if (!_dataProvider || _dataProvider.length == 0) return; 
			if (index >= _dataProvider.length) return;
			_selectedItem = _dataProvider[index];
		}
		
		public function selectItemByData(id:String):void
		{
			
			if (!_dataProvider || _dataProvider.length == 0) return; 
			
			var i:uint = 0;
			var len:uint = _dataProvider.length;
			
			for (; i < len; i++)
			{
				if (_dataProvider[i].data == id)
				{
					_selectedItem = _dataProvider[i];
					break;
				}
			}
		}
		
		public function resetScroll():void
		{
			if (!_sliderController) return;
			_sliderController.currentValue = _listYInit;
			_onScroll();
		}
		
		
		public function clear():void
		{
			for each (var item:Sprite in _arrItems)
			{
				item.removeEventListener (MouseEvent.MOUSE_DOWN, _onClickItem);
				_itemsContainer.removeChild (item);
				item = null;
			}
			
			_arrItems = null;
			if (_bg) _bg.height = 0;
		}
		
		private function _buildItems ():void
		{
			if (_arrItems != null) clear ();
			
			for (var i:uint; i < _dataProvider.length; i++)
			{
				_createItem (_dataProvider[i]);
			}
			
			_updateScroll ();
		}
		
		private function _createItem (itemData:Object):void
		{
			if (!_arrItems) _arrItems = new Array ();
			var item:Sprite = new _itemListClass ();
			item.y = _arrItems.length * item.height;
			var itemDataObj:Object = itemData.hasOwnProperty ("label") && itemData.hasOwnProperty ("data") ? itemData : { label:String(itemData), data:itemData }
			IItemList(item).label = itemDataObj.label;
			IItemList(item).data = itemDataObj;
			IItemList(item).index = _arrItems.length;
			item.mouseChildren = false;
			item.buttonMode = true;
			item.addEventListener(MouseEvent.MOUSE_DOWN, _onClickItem, false, 0, true);
			_itemsContainer.addChild (item);
			_arrItems.push (item);
			
			if (_bg) _bg.height = item.height * (_slider && needScroll ? _rowCount : _arrItems.length);
		}
		
		private function _onClickItem(e:MouseEvent):void 
		{
			_selectedItem = IItemList (e.target).data;
			dispatchEvent (new Event (Event.SELECT));
		}
		
		protected function _updateScroll():void
		{
			if (!_slider) return;
			if (!_maskList) _drawMask();
			_itemsContainer.mask = _maskList;
			_maskList.width = _itemsContainer.width;
			if (itemHeight) _maskList.height = itemHeight * _rowCount;
			
			if (!_slider || !_dataProvider) return;
			//trace ("_updateScroll");
			_initSlider()
			
			if (needScroll)
			{
				if (autoSizeSlider) _sliderController.trackLenght = _maskList.height;
				_sliderController.maxValue = _listYInit - _itemsContainer.height + _maskList.height;
				_slider.visible = true;
			}
			else
			{
				_slider.visible = false;
			}
			
			//_maskList.visible = needScroll;
			
		}
		
		private function _drawMask():void 
		{
			_maskList = new Sprite();
			_maskList.x = _itemsContainer.x;
			_maskList.y = _itemsContainer.y;
			_maskList.mouseEnabled = false;
			_maskList.graphics.beginFill (0xFF0000, 0.5);
			_maskList.graphics.drawRect(0,0,_itemsContainer.width,20);
			_maskList.graphics.endFill ();
			view.addChild (_maskList);
		}
		
		private function _initSlider():void 
		{
			_sliderController = new SimpleSlider (_slider);
			_sliderController.minValue = _listYInit;
			_sliderController.maxValue = 1;
			_sliderController.currentValue = _listYInit;
			_sliderController.addEventListener (Event.CHANGE, _onScroll);
		}
		
		protected function _onScroll(e:Event = null):void
		{
			_itemsContainer.y = _sliderController.currentValue;
		}
		
		private function get needScroll ():Boolean
		{
			return _dataProvider.length > _rowCount;
		}
		
		public function get dataProvider():Array { return _dataProvider; }
		
		public function set dataProvider(value:Array):void 
		{
			_dataProvider = value;
			_buildItems ();
		}
		
		public function get rowCount():Number { return _rowCount; }
		
		public function set rowCount(value:Number):void 
		{
			_rowCount = value;
			//_updateScroll();
		}
		
		public function get selectedItem():Object { return _selectedItem; }
		
		public function get itemHeight():Number { return _arrItems[0].height; }
		
		public function get itemsContainer():Sprite 
		{
			return _itemsContainer;
		}
		
		public function get autoSizeSlider():Boolean 
		{
			return _autoSizeSlider;
		}
		
		public function set autoSizeSlider(value:Boolean):void 
		{
			_autoSizeSlider = value;
		}
	}

}