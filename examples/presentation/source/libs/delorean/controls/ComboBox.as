package delorean.controls 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 * TODO: implement scroll via mouse
	 * TODO: implement item selection option (selectItemByData, selectItemByLabel, etc);
	 * TODO: implement search mode in selected field
	 */
	public class ComboBox extends EventDispatcher
	{
		public static const LIST_TOP:Number = -1;
		public static const LIST_MIDDLE:Number = -0.5;
		public static const LIST_BOTTOM:Number = 0;
		
		public static const OPEN:String = "combo_opened";
		public static const CLOSE:String = "combo_closed";
		
		public var view:MovieClip;
		private var _listController:List;
		private var _header:MovieClip;
		private var _list:MovieClip;
		private var _opened:Boolean = false;
		private var _listPos:Number;
		private var _initLabel:String;
		
		private var _autoCompleteMode:Boolean = false;
		
		public function ComboBox(pView:MovieClip, itemListClass:*, initLabel:String = "Selecione") 
		{
			super();
			view = pView;
			_header = view["header"];
			_list = view["list"];
			//_header.width = 300;
			
			_header.mouseChildren = false;
			_header.addEventListener (MouseEvent.CLICK, toogleOpen);
			
			_initList(itemListClass);
			
			this.initLabel = initLabel;
		}
		
		private function _initList(itemListClass:*) : void {
			_listController = new List(_list, itemListClass);
			_listController.addEventListener (Event.SELECT, _onListSelect, false, 0, true);
			
			listPos = LIST_BOTTOM;
			
			close();
		}
		
		public function toogleOpen (...e):void
		{
			if (_opened) close ();
			else open ();
		}
		

		
		public function open (...e):void
		{
			if (dataProvider == null || dataProvider.length == 0) return;
			
			view.stage.addEventListener (MouseEvent.MOUSE_DOWN, _onClickStage, false, 0, true);
			_opened = true;
			view.addChild(_list);
//			_list.visible = true;
			dispatchEvent(new Event(OPEN));
		}
		
		public function close (...e):void
		{
			_opened = false;
//			_list.visible = false;
			if (view.contains(_list)) view.removeChild(_list);
			_listController.resetScroll();
			
			dispatchEvent(new Event(CLOSE));
		}
		
		public function addItem (label:String, data:Object):void
		{
			_listController.addItem (label, data);
		}
		
		public function removeItem (itemData:Object):void
		{
			_listController.removeItem()
		}
		
		public function selectItemByIndex(index:uint):void
		{
			_listController.selectItemByIndex (index);
			_onSelectItem ();
		}
		
		public function selectItemByData(data : String) : void {
			_listController.selectItemByData(data);
			_onSelectItem ();
		}
		
		public function clear():void
		{
			close ();
			_listController.clear ();
		}
		
		private function _onClickHeader(e:MouseEvent):void 
		{
			toogleOpen ();
		}
		
		private function _onClickStage(e:MouseEvent):void 
		{
			if (!view.stage) return;
			if (!view.hitTestPoint (view.stage.mouseX, view.stage.mouseY))
			{
				view.stage.removeEventListener (MouseEvent.MOUSE_DOWN, _onClickStage);
				close( );
			}
		}
		
		private function _onListSelect(e:Event):void 
		{
			_onSelectItem ();
			close ();
		}
		
		private function _onSelectItem():void 
		{
			if (!_listController.selectedItem) return;
			//trace ("combobox onSelectItem");
			//trace ("_listController.selectedItem: " + _listController.selectedItem)
			_header.txt.text = _listController.selectedItem.label;
			dispatchEvent (new Event (Event.SELECT));
		}
		
		private function _update():void
		{
			//trace ("update");
			//Coloca o primeiro item da lista no selecionado
			if (_initLabel == null) selectItemByIndex (0);
			
		}
		
		public function set dataProvider (value:Array):void
		{
			_listController.dataProvider = value;
			_update ();
		}
		
		//Getter que retorna a array com os objetos
		public function get dataProvider ():Array
		{
			return _listController.dataProvider;
		}
		
		public function get selectedItem():Object { return  _listController.selectedItem; }
		
		public function get listPos():Number { return _listPos; }
		
		public function set listPos(value:Number):void 
		{
			_listPos = value;
			_list.y = _header.bg.height + _list.height * _listPos;
		}

		public function get initLabel():String
		{ 
			return _initLabel; 
		}

		public function set initLabel(value:String):void
		{
			_initLabel = value;
			_header.txt.text = _initLabel;
		}
		
		public function get label():String
		{
			return _header.txt.text;
		}
		
		public function get rowCount():Number 
		{
			return _listController.rowCount;
		}
		
		public function set rowCount(value:Number):void 
		{
			_listController.rowCount = value;
			_update ();
		}
		
		public function dispose():void
		{
			_header.removeEventListener (MouseEvent.CLICK, toogleOpen);
			view.stage.removeEventListener (MouseEvent.MOUSE_DOWN, _onClickStage);
			_listController.removeEventListener (Event.SELECT, _onListSelect);
		}
		
	}

}