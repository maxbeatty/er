class Delegate {
	/**
	 * delegate ..
	 * @param	scope
	 * @param	func
	 * @return
	 */
	public static function create(scope:Object, func:Function):Function {
		var args:Array = arguments.splice(2);
		return function () {
			return func.apply(scope, args.concat(arguments));
		};
	}
}
