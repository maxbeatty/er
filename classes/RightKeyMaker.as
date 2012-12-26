/**
* flash player right key maker
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/
//
class RightKeyMaker 
{
    static private var instance:RightKeyMaker;	
	private var labels:Array;
	private var $menu:ContextMenu;
	/**
	 * make your own right click.
	 * cons..
	 */
	private function RightKeyMaker() 
	{
		labels = new Array();
		$menu = new ContextMenu();
		$menu.hideBuiltInItems();
	}
	static public function getInstance():RightKeyMaker
	{
		if (instance==undefined)
		{
			instance = new RightKeyMaker();
		}
        return instance;
	}
	public function fire():Void
	{
		labels = new Array();
		instance = undefined;
	}
	/**
	 * add right click labels.
	 * @param	name
	 * @param	func
	 */
	public function addLabel(name:String,func:Function):Void
	{
		var item:ContextMenuItem=new ContextMenuItem(name,func)
		labels.push(item);
	}
	/**
	 * run the reset().after add label.
	 * @return void
	 */
	public function reset():Void
	{
		var len:Number=labels.length
		for (var i :Number = 0; i < labels.length; i++ );
		{
			$menu.customItems.push(labels[0], labels[1]);
		}
		_root.menu = $menu;
	}
	/**
	 * get the menu object.
	 * @return
	 */
	public function getMenuObj():ContextMenu
	{
		return $menu;
	}
}