package
{
	import flash.utils.describeType;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public function log(target:*, ...rest):void 
	{
		var output:Array = ["[" + describeType (target).@name + "]: "].concat(rest);
		trace.apply(null, output);
		if (ExternalInterface.available)
			ExternalInterface.call.apply (null, ["console.log"].concat(output));
	}

}