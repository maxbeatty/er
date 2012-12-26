/**
 * All my image is the class's subclase,the class support normal function,
 * like fadein, BRIGHTNESS in , and so on.
 * @author shuhankuang[at]gmail.com
 */
import flash.display.BitmapData;
import flash.geom.Matrix;
import caurina.transitions.Tweener;
class AbstractThumbnail extends Component {
	//some event 
	static public var ON_LOAD_START : String = "onloadstart";
	static public var ON_LOAD_INIT : String = "onloadinit";
	static public var ON_LOAD_PROGRESS : String = "onloadprogress";
	static public var ON_FADE_IN_COMPLETE : String = "onfadeincomplete";
	static public var ON_FADE_OUT_COMPLETE : String = "onfadeoutcomplete";
	//in type,fade in or brightness in,or saturation in
	static public var ALPHA_TYPE : String = 'alphatype';
	static public var BRIGHTNESS_TYPE : String = 'brightnesstype';
	static public var SATURATION_TYPE : String = 'saturationtype';
	//
	private var target : MovieClip;
	private var container : MovieClip;
	private var bg : MovieClip;
	private var mcLoader : MovieClipLoader;
	private var image : Image;
	private var imageSize : Vector;
	private var _time : Number = 0.7;
	private var _type : String = "linear";
	private var percent : Number = 0;
	private var selectedRec : MovieClip;
	//when loadinit , run the effect in.
	public var inType : String = ALPHA_TYPE;
	public var smoothImage:Boolean = true;
	/**
	 * cons..
	 */
	public function AbstractThumbnail(target : MovieClip) 
	{
		super();
		this.target = target;
		container = target.container
		bg = this.target.bg;
		selectedRec = this.target.selectbg;
	}
	/**
	 * load file
	 */
	public function load(image:Image) : Void 
	{
		setImage(image);
		Tweener.removeTweens(this.container);
		var url : String = this.image.imageurl;
		mcLoader.unloadClip();
		mcLoader = new MovieClipLoader();
		mcLoader.addListener(this);
		mcLoader.loadClip(url, container);
		dispatchEvent( { target:this, type:ON_LOAD_START } )
	}
	/**
	 * on load init
	 * @param	target_mc
	 */
	public function onLoadInit(target_mc:MovieClip) : Void 
	{
		dispatchEvent( { target:this, type:ON_LOAD_INIT } );
	}
	private function onLoadProgress(target : MovieClip, bytesLoaded : Number, bytesTotal : Number) : Void
	{
		dispatchEvent({ target:this, type:ON_LOAD_PROGRESS})
		if (bytesLoaded > 0 && bytesTotal > 4) {
			percent = Math.floor(bytesLoaded * 100 / bytesTotal);
		}else {
			percent = 0;
		}
	}
	/**
	 * set image
	 * @param	image
	 */
	public function setImage(image : Image) : Void 
	{
		this.image = image;
	}
	/**
	 * remove image (movieclip)
	 */
	public function remove() : Void 
	{
		this.target.removeMovieClip();
	}
	/**
	 * unload movieclip
	 */
	public function unLoad() : Void
	{
		Tweener.removeTweens(container);
		container.unloadMovie();
		mcLoader.unloadClip();
	}
	/**
	 * set the container visible.
	 * @param	b
	 */
	public function setVisible(b : Boolean) 
	{
		this.target._visible = b;
	}
	public function fadeIn() : Void 
	{
		Tweener.addTween(this.container, {_autoAlpha:100, time:_time, transition:_type, onComplete:Delegate.create(this, onFadeInComplete)})
	}
	public function onFadeInComplete() : Void 
	{
		dispatchEvent({ target:this, type:ON_FADE_IN_COMPLETE });
	}
	public function fadeOut() : Void 
	{
		Tweener.addTween(this.container, {_autoAlpha:0, time:_time, transition:_type, onComplete:Delegate.create(this, onFadeOutComplete)})
	}
	public function onFadeOutComplete() : Void 
	{
		dispatchEvent({ target:this, type:ON_FADE_OUT_COMPLETE });
	}
	/**
	 * Other effect...
	 */
	public function brightnessIn() : Void 
	{
		Tweener.addTween(container, { _brightness:0, time:_time, transition:_type, onComplete:Delegate.create(this, onFadeInComplete)});
	}
	public function saturationIn() : Void 
	{
		Tweener.addTween(container, { _saturation:1, time:_time, transition:_type, onComplete:Delegate.create(this, onFadeInComplete)});
	}
	private function changeContainerState() : Void 
	{
		switch (inType) {
			case ALPHA_TYPE :
				this.container._alpha = 0;
				break;
			case BRIGHTNESS_TYPE:
				this.container._alpha = 0;
				Tweener.addTween(container, { _brightness:2.5, time:0});
				break;
			case SATURATION_TYPE:
				Tweener.addTween(container, { _saturation:0, time:0});
				break;
		}
	}
	private function runInEffectFunction() : Void 
	{
		Tweener.removeTweens(this.container);
		switch (inType) {
			case ALPHA_TYPE :
				fadeIn();
				break;
			case BRIGHTNESS_TYPE:
				this.container._alpha = 100;
				brightnessIn();
				break;
			case SATURATION_TYPE:
				saturationIn();
				break;
		}
	}
	/**
	 * show and hide the container
	 * @return void
	 */
	public function show() : Void
	{
		setVisible(true);
	}
	public function hide() : Void
	{
		setVisible(false);
	}
	public function getTarget() : MovieClip
	{
		return target;
	}
	public function getContainer() : MovieClip 
	{
		return container;
	}
	public function getPercent():Number {
		return percent;
	}
}