package delorean.utils 
{
	import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public function getClass(classStr:String):Class 
	{
		return ApplicationDomain.currentDomain.getDefinition (classStr) as Class;
	}

}