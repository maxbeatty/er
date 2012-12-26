/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/

class osimageloader.UDMotionRecImageLoader extends OneSizeImageLoader
{
	static public var LINK_ID:String = 'UDMotionRecImageLoader';
	private var motionRectangle:MotionRectangle;
	/**
	 * cons..
	 * @param	target
	 * @param	size
	 */
	public function UDMotionRecImageLoader(target:MovieClip,size:Vector) 
	{
		super(target, size);
		var _mc_:MovieClip = this.target.mrec;
		motionRectangle = new MotionRectangle(_mc_.createEmptyMovieClip('mc',0));
		setLoaderSize();
		motionRectangle['_type'] = 'easeInOutCirc';
		motionRectangle['_time']=0.8
	}
	/**
	 * set the image loader size.
	 * @return void
	 */
	private function setLoaderSize():Void
	{
		super.setLoaderSize();
		motionRectangle.getTarget()._x = XYGAP
		motionRectangle.getTarget()._y = XYGAP;
		var w:Number = imageSize.x
		var h:Number = imageSize.y
		motionRectangle.setSize(w, h);
		_time = 0;
		motionRectangle.setSize(w, h);
		motionRectangle.defaultMotion = MotionRectangle.BOTTOM;
		motionRectangle.addEventListener(MotionRectangle.TO_MIN_SIZE_DONE, Delegate.create(this, onMotionRectangleComplete));
	}
	public function load(image:Image):Void
	{
		unLoad();
		super.load(image);
	}
	/**
	 * fade in complete
	 */
	public function onFadeInComplete():Void {
		motionRectangle.setMaxSize();
		super.onFadeInComplete();
		motionRectangle.toMinSize();
	}
	public function getMotionRectangle():MotionRectangle {
		return motionRectangle;
	}
	private function onMotionRectangleComplete(e:Object):Void {
		//bg.enabled = true;
		//bg.useHandCursor = true;
		bg.enabled = pressAbled;
	}
	public function setMotionRectangleColor(color:Number):Void {
		getMotionRectangle().color = color;
		getMotionRectangle()['_draw']();
	}
	/**
	 * unload movieclip
	 */
	public function unLoad() : Void
	{
		super.unLoad();
		loadingCircle._visible = false;
		bg.enabled = false;
	}
}