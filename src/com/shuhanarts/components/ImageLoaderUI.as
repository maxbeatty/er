import com.shuhanarts.components.AbstractImageLoaderUI;
/**
* ...
* @author ShuhanKuang {shuhankuang@gmail.com}
*/
import caurina.transitions.Tweener;
class com.shuhanarts.components.ImageLoaderUI extends AbstractImageLoaderUI
{
	private var mask:MaskController;;
	private var root:MovieClip;
	private var loader:PNSmartSizeImageLoaderWithOutsideButton;
	private var closebtn:Button;
	/**
	 * Cons..
	 * @param	target
	 */
	public function ImageLoaderUI(target:MovieClip)
	{
		super(target);
		root = this.target._parent;
		mask = new MaskController(root.tmask);
		loader = new PNSmartSizeImageLoaderWithOutsideButton(target, new Vector(200, 200));
		loader.hide();
		loader.setMoveOverDescriptionText(true);
		StageController.getInstance().removeObjByName('ImageLoaderUI');
		StageController.getInstance().addObj(this, 'ImageLoaderUI');
		closebtn = root.imgclosebtn;
		closebtn._visible = false;
		closebtn.onRelease = Delegate.create(this, close);
		resize();
	}
	public function initUI(data:Object):Void {
		PNSmartSizeImageLoaderWithOutsideButton.XYGAP = _global.imgborder;
		loader['bgTweenType'] = _global.imgtweentype;
		loader['bgTweenTime'] = _global.imgtweentime;
		super.initUI(data);
		loader.setImages(data.images);
	}
	public function load(image:Image):Void {
		super.load(image);
		loader.load(this.image)
		mask.fadeIn(80);
		show();
		closebtn._visible = true;
		closebtn._alpha = 0;
		Tweener.addTween(closebtn, { _alpha:100, time:_time, transition:'linear' } );
	}
	/**
	 * run the resize when stage resize.
	 */
	private function resize():Void {
		var size:Object = StageController.getInstance().getSize();
		var w:Number = size.w;
		var h:Number = size.h;
		var rx:Number = root._x;
		var ry:Number = root._y;
		mask.getTarget()._x = -rx;
		mask.getTarget()._y = -ry;
		loader.getTarget()._x = 0;
		loader.getTarget()._y = 0;
	    closebtn._x = w/2-30;
		closebtn._y = -h / 2+30;
	}
	private function close():Void {
		closebtn._alpha = 0;
		closebtn._visible = false;
		hide();
		mask.fadeOut(0)
	}
}