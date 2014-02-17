package delorean.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	/**
	 * ...
	 * @author Tiago Canzian
	 */
	public class List extends Sprite {
		
		private var items				: Array = [];
		
		private var totalRows			: int;
		private var totalColumns		: int;
		private var widthColumn			: Number;
		private var offsetMargin		: int;
		private var itemHeight			: Number;
		private var posX 				: int = 0;
		private var posY 				: int = 0;
		
		private var holder				: Sprite;
		
		
		public function List(columns : int = 0, offsetMargin : int = 10, itemHeight : Number = 0) {
			this.totalColumns = columns;
			this.offsetMargin = offsetMargin;
			this.itemHeight = itemHeight;
			
			this.holder = new Sprite();
			this.addChild(this.holder);
		}
		
		
		public function addItem(template : DisplayObject) : void {
			this.items.push(template);
			template.x = posX;
			template.y = posY;
			this.holder.addChild(template);
			
			
			if (this.totalColumns > 0) {
				posX += template.width + offsetMargin;
				if ((this.items.length % this.totalColumns == 0)) {
					posX = 0;
					posY += ((this.itemHeight > 0) ? this.itemHeight : template.height) + offsetMargin; 
				}
			}
		}
		
	}
}

