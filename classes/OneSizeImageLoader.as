/**
* image loader (you can set the size)
* @author Shuhan Kuang {shuhankuang[at]gmail.com};
*/
import caurina.transitions.Tweener;
import Delegate;
import flash.display.BitmapData;
//
class OneSizeImageLoader extends AbstractThumbnail {
	static public var LINK_ID:String = "OneSizeImageLoader";
	//some event 
	static public var ON_SELECT:String = "onselect";
	static public var ON_ROLLOVER:String = "onrollover";
	static public var ON_ROLLOUT:String = "onrollout";
	//xy gap.
	static public var XYGAP:Number = 5;
	//default text width
	static public var TEXT_WIDTH:Number = 20;
	//mask the image loaded..with tween motion.
	public var imageMask:MovieClip;
	//the image index.
	public var index:Number;
	//tween arguments.
	private var _time:Number = 0.5;
	private var _type:String = "easeOutCirc";
	//file type [flv,pic,swf]
	private var fileType:MovieClip;
	//the loading circle movieclip
	private var loadingCircle:MovieClip;
	//
	private var pressAbled = false;
	//loading text.
	private var loadingText:TextField;
	//show loading number
	private var showLoadingNumber :Boolean = true;
	//show loading circle
	private var showLoadingCircle:Boolean = true;
	private var bitMap:BitmapData;
	//
	//
	/**
	 * Cons..
	 * @param	target
	 * @param	size
	 */
	public function OneSizeImageLoader(target:MovieClip,size:Vector) {
		super(target);
		this.imageSize = size.getClone();
		this.fileType = this.target.filetype
		this.fileType._visible = false;
		imageMask = this.target.mask;
		imageMask._alpha = 0;
		//trace("-->"+target._name.split("_")[1])
		index = Number(this.target._name.split("_")[1]);
		bg.onRollOver = Delegate.create(this, onRollOver);
		bg.onRollOut = Delegate.create(this, onRollOut);
		bg.enabled = false;
		loadingCircle = this.target.loadingmotion;
		loadingCircle.stop();
		showCircle(false);
		//
		loadingText = this.target.loading_txt;
		//loadingText.autoSize = true;
		loadingText._width = TEXT_WIDTH;
		setLoaderSize();
		//
		addEventListener(AbstractThumbnail.ON_LOAD_PROGRESS, Delegate.create(this, setLoadingText));
	}
	/**
	 * set the image.
	 * @param	image
	 */
	public function setImage(image:Image):Void {
		this.image = (image == undefined)?this.image:image;
		//fileType.gotoAndStop(image.fileType);
	}
	/**
	 * load the image.
	 * @param	image
	 */
	public function load(image:Image):Void
	{
		bitMap.dispose();
		loadingCircle.play();
		setImage(image);
		super.load();
	    setEnabled(false);
		showCircle(true);
		fileType._visible = false;
	}
	/**
	 * buttons functions.
	 */
	public function onRollOver():Void {
		dispatchEvent( { target:this, type:ON_ROLLOVER } );
	}
	public function onRelease():Void {
		dispatchEvent( { target:this, type:ON_SELECT } );
	}
	public function onRollOut():Void {
		dispatchEvent( { target:this, type:ON_ROLLOUT } );
	}
	public function onReleaseOutside():Void {
		onRelease();
	}
	/**
	 * on load init.
	 * @param	target_mc
	 */
	public function onLoadInit(target_mc:MovieClip):Void {
		//that make it looks smoothly..
		var ss:Array = image.imageurl.split('.');
		var ft:String = ss[ss.length-1];
		target_mc._xscale = target_mc._yscale = 100;
		if (ft!='swf' && ft!='SWF' && smoothImage==true) {
			bitMap = new BitmapData(target_mc._width, target_mc._height, true);
			bitMap.draw(target_mc);
			target_mc.attachBitmap(bitMap, 1, "auto", true);
		}
		this.fileType._x = XYGAP + imageSize.x / 2;
		this.fileType._y = XYGAP + imageSize.y / 2;
		//this.fileType.gotoAndStop(image.fileType);
		this.container._width = imageSize.x;
		this.container._height = imageSize.y;
		this.container.setMask(imageMask);
		changeContainerState();
		runInEffectFunction();
		setEnabled(true);
		showCircle(false);
		loadingCircle.stop();
		loadingText.text = "";
		//super.onLoadInit();
		dispatchEvent( { target:this, type:ON_LOAD_INIT } );
	}
	/**
	 * fade in complete
	 */
	public function onFadeInComplete():Void {
		bg.onRelease = Delegate.create(this, onRelease);
		bg.onRollOut = Delegate.create(this, onRollOut);
		bg.onRollOver = Delegate.create(this, onRollOver);
		bg.onReleaseOutside = Delegate.create(this, onReleaseOutside);
		super.onFadeInComplete();
		//file type
		if (image.fileType!=Image.FLV) {
			return;
		}
		this.fileType._visible = true;
		MovieClipFadeIn([this.fileType], 0, 50, undefined);
	}
	/**
	 * set the background enabeld 
	 * @param	b
	 */
	public function setEnabled(b:Boolean):Void {
		if (pressAbled==false)
		{
			return;
		}
		bg.enabled = b;
	}
	/**
	 * get the image (see image.as)
	 * @return
	 */
	public function getImage():Image
	{
		return image;
	}
	/**
	 * remove the image.
	 */
	public function remove():Void
	{
		this.target.removeMovieClip();
	}
	/**
	 * set the image loader size.
	 * @return void
	 */
	private function setLoaderSize():Void
	{
		var w:Number = imageSize.x;
		var h:Number = imageSize.y;
		//bg
		bg._x = 0;
		bg._y = 0;
		bg._width = w + 2 * XYGAP;
		bg._height = h + 2 * XYGAP;
		selectedRec._width = bg._width;
		selectedRec._height = bg._height;
		//mask
		imageMask._x = XYGAP;
		imageMask._y = XYGAP;
		imageMask._width = w;
		imageMask._height = h;
		//container
		container._x = XYGAP;
		container._y = XYGAP;
		//loaingmotion;
		loadingCircle._x = bg._width / 2;
		loadingCircle._y = bg._height / 2;
		//
		fileType._x=bg._width / 2;
		fileType._y=bg._height / 2;
		//loadingText
		loadingText._x = bg._width / 2 - loadingText._width/2;
		loadingText._y = bg._height/2-loadingText._height/2-2;
		//trace([loadingText._width,loadingText._height])
		//
	}
	/**
	 * run when stage resize.
	 */
	public function resize():Void
	{
		//
	}
	public function setPressAbled(b:Boolean):Void
	{
		pressAbled = b;
	}
	/**
	 * set the loading visible.
	 * @param	b
	 */
	public function setLoadingTextVisible(b:Boolean):Void
	{
		showLoadingNumber = b;
	}
	/**
	 * set the circle visible.
	 * @param	b
	 */
	public function setLoadingCircleVisible(b:Boolean):Void
	{
		showLoadingCircle = b;
	}
	/**
	 * show the circle.
	 * @param	b
	 */
	private function showCircle(b:Boolean):Void
	{
		if (showLoadingCircle==true)
		{
			loadingCircle._visible = b;
		}
	}
	private function setLoadingText():Void
	{
		if (showLoadingNumber==false)
		{
			return;
		}
		loadingText.text = String(percent);
	}
	public function getPercent():Number
	{
		return percent;
	}
	public function setFileType(ftype:String):Void {
		if (ftype==Image.PIC) {
			//
		}else if (ftype == Image.FLV) {
			fileType.gotoAndStop(Image.FLV);
		}
		fileType._alpha = 0;
	}
	/**
	 * unload movieclip
	 */
	public function unLoad() : Void
	{
		Tweener.removeTweens(bg);
		Tweener.removeTweens(fileType);
		container.unloadMovie();
		mcLoader.unloadClip();
	}
}