/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/
import caurina.transitions.Tweener;
class osimageloader.MotionRectImageLoader extends OneSizeImageLoader
{
	static public var LINK_ID:String='MotionRectImageLoader'
	private var motionRectangleMask:MovieClip;
	public var motionDis:Number = 5;
	/**
	 * Cons..
	 * @param	target
	 */
	public function MotionRectImageLoader(target:MovieClip,size:Vector) 
	{
		super(target,size);
		motionRectangleMask = this.target.mrecmask;
		imageMask = motionRectangleMask;
		_type = 'linear'
		_time = 0.3;
		imageMask._alpha = 0;
		setLoaderSize();
	}
	/**
	 * set the image loader size.
	 * @return void
	 */
	private function setLoaderSize():Void
	{
		super.setLoaderSize();
		motionRectangleMask._x = XYGAP + imageSize.x / 2;
		motionRectangleMask._y = XYGAP + imageSize.y / 2;
		motionRectangleMask._width = imageSize.x;
		motionRectangleMask._height = imageSize.y;
	}
	/**
	 * buttons functions.
	 */
	public function onRollOver():Void {
		super.onRollOver();
		var motion_dis:Number = motionDis * 2;
		Tweener.addTween(motionRectangleMask, { _width:imageSize.x - motion_dis, time:_time, transition:_type } );
		Tweener.addTween(motionRectangleMask, { _height:imageSize.y - motion_dis, time:_time, transition:_type } );
	}
	public function onRollOut():Void {
		super.onRollOut();
		var motion_dis:Number = 0;
		Tweener.addTween(motionRectangleMask, { _width:imageSize.x - motion_dis, time:_time, transition:_type } );
		Tweener.addTween(motionRectangleMask, { _height:imageSize.y - motion_dis, time:_time, transition:_type } );
	}
	public function removeMotionTween():Void {
		Tweener.removeTweens(motionRectangleMask);
	}
}