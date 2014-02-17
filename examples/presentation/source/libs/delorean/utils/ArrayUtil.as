package delorean.utils {
	
	/**
	 * ...
	 */
	public class ArrayUtil {
		
		public static function randomize(array:Array):Array {
			var clone:Array;
			var result:Array;
			var idx:uint;
			
			clone = [].concat(array);
			result = [];
			
			while (clone.length) {
				idx = Math.floor(clone.length * Math.random());
				result.push(clone[idx]);
				clone.splice(idx, 1);
			}
			
			return result;
		}
		
		
		public static function extract(mainArray:Array, selectedItens:Array):Array {
			var i:uint;
			var idx:uint;
			var result:Array = [];
			
			
			
			for (i = 0; i < selectedItens.length; i++) {
				result.push(mainArray[selectedItens[i]]);
			}
			
			return result;
		}
		
	}
	
}