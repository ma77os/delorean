package delorean.parameters 
{
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public function setParam(key:*, value:*):void
	{
		Parameters.instance[key] = value;
	}
}