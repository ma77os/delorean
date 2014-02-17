package delorean.parameters 
{
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 * TODO: implement a clearMemory parameter
	 */
	public function getParam(key:*):* 
	{		
		return Parameters.instance[key];
	}
}