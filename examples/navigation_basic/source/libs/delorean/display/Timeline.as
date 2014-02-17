package delorean.display
{
	import flash.display.MovieClip;

	public class Timeline {
		
		public static function getFrameLabelNumber(label:String, mc:MovieClip):uint {
			var labels:Array = mc.currentLabels;
			var i:int = labels.length;
			while (i--) {
				if (labels[i].name == label) {
					return labels[i].frame;
				}
			}
			return mc.currentFrame;
		}
	}
}