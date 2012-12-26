/**
 * ...
 * @author Shuhan Kuang {shuhankuang[at]gmail.com}
 * @site http://www.shuhanarts.com
 */
interface com.shuhanarts.components.IImageLoaderUI extends IComponent
{
	/*init the UI*/
	public function initUI(data:Object):Void;
	/*get the imageloader container*/
	public function getTarget():MovieClip;
	/*show the imageloader container*/
	public function show():Void;
	/*hide the imageloader container*/
	public function hide():Void;
	/*load the image*/
	public function load(image:Image):Void;
	/*load the image done*/
	public function onLoadInit(e:Object):Void;
}