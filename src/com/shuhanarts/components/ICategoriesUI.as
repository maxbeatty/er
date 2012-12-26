/**
 * ...
 * @author Shuhan Kuang {shuhankuang[at]gmail.com}
 */
interface com.shuhanarts.components.ICategoriesUI extends IComponent
{
	/*init the UI*/
	public function initUI(data:Object):Void;
	/*get the categories container*/
	public function getContainer():MovieClip;
	/*show the categories container*/
	public function show():Void;
	/*hide the categories container*/
	public function hide():Void;
	/*change the category*/
	public function change(index:Number):Void;
}