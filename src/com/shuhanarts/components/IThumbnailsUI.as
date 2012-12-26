/**
 * ...
 * @author Shuhan Kuang {shuhankuang[at]gmail.com}
 * @site http://www.shuhanarts.com
 */
interface com.shuhanarts.components.IThumbnailsUI extends IComponent
{
	/*init the UI*/
	public function initUI(data:Object):Void;
	/*get the thumbnails container*/
	public function getContainer():MovieClip;
	/*show the thumbnails container*/
	public function show():Void;
	/*hide the thumbnails container*/
	public function hide():Void;
	/*set selectedIndex*/
	public function setSelectedIndex(index:Number):Void;
}