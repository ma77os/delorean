package delorean.utils 
{
	/**
	 * ...
	 * @author Luiza Prata
	 */
	public class NumberUtils 
	{
		
		public function NumberUtils() 
		{
			
		}
		
		public static function translateQuantity(value:int):String
		{
			var str:String; 
			
			if (value >= 1000)
				str = (Math.round(value / 100)/10) + 'k';
			else if (value < 0)
				str = '0';
			else
				str = value.toString();
			
			return str;
		}
		
	}

}