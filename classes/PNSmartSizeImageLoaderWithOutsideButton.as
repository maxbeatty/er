/**
* image loader
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/
import caurina.transitions.Tweener;
class PNSmartSizeImageLoaderWithOutsideButton extends PNSmartSizeImageLoader
{
	static public var LINK_ID:String = "PNSmartSizeImageLoader_with_OutsideButton";
	static public var BUTTON_XYGAP:Number = 5;
	//
	/**
	 * Cons..
	 * @param	target
	 */
	public function PNSmartSizeImageLoaderWithOutsideButton(target:MovieClip,defaultSize:Vector) 
	{
		super(target, defaultSize.getClone());
		smoothImage = false;
	}
	/**
	 * Must set all the images to the loader..
	 * @param	images
	 */
	public function setImages(images:Array):Void
	{
		super.setImages(images);
		nextAndPrevController["buttonType"] = PrevAndNextController.ALPHA_TYPE;
		nextAndPrevController['isFade'] = false;
		nextAndPrevController.show();
	}
	public function load(image:Image):Void
	{
		super.load(image)
		//nextAndPrevController.hide();
		nextAndPrevController.show();
		nextAndPrevController.setEnabled(false)
	}
	/**
	 * fit the image size.
	 */
	public function fitSize():Void
	{
		super.fitSize();
	}
	private function setLoaderSize():Void
	{
		super.setLoaderSize();
		var w:Number = bg._width;
		var h:Number = bg._height;
		prevBtn._x = -(w / 2) - BUTTON_XYGAP - prevBtn._width;
		nextBtn._x = (w / 2) + BUTTON_XYGAP +prevBtn._width;
	}
	private function resetUI():Void
	{
		setLoaderSize();
	}
	/**
	 * on fade complete.
	 * @return void
	 */
	public function onFadeInComplete():Void {
		super.onFadeInComplete();
		nextAndPrevController.setEnabled(true)
	}
}