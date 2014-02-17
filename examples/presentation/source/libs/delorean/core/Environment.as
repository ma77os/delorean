package delorean.core {
	
	import flash.system.Capabilities;
	
	
	/**
	 * ...
	 */
	public class Environment {
		
		
		public static function get externalPlayer():Boolean {
			
			return (Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone"|| Capabilities.playerType == "Desktop" );
			
		}
		
		
	}
	
}