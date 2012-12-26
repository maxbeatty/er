/**
* ...
* @author Shuhan Kuang {shuhankuang@gmail.com}
*/
import caurina.transitions.Tweener;
class SmartSizeImageLoader extends OneSizeImageLoader
{
	//event.
	static public var ON_RESIZE_COMPLETE:String = "onresizecomplete";
	//text mask.
	private var desTextMask:MovieClip;
	//description text.
	private var desText:DescriptionText;
	//only one can work..(:-()
	private var autoShowDescriptionText:Boolean = false;
	private var moveOverDescriptionText:Boolean = false;
	private var canLinkTo:Boolean = true;
	private var bgTweenType:String = 'easeInOutBack';
	private var bgTweenTime:Number = 0.8;
	/**
	 * fit size of the image.
	 * @param	target
	 * @param	defalutSize
	 */
	public function SmartSizeImageLoader(target:MovieClip,defalutSize:Vector) 
	{
		super(target, defalutSize.getClone());
		bg._width = imageSize.x + XYGAP;
		bg._height = imageSize.y + XYGAP;
		//
		desText = new DescriptionText(this.target.destxt);
		desTextMask = this.target.destextmask;
		desTextMask._alpha = 60;
		desText.getTarget().setMask(desTextMask);
		desText.setPressAbled(false);
		desText.hide();
		addEventListener(ON_FADE_IN_COMPLETE, Delegate.create(this, setText));
		//
	}
	/**
	 * load the image.
	 * @param	image
	 */
	public function load(image:Image):Void
	{
		Tweener.removeTweens(desText.getTarget());
		Tweener.removeTweens(bg);
		desText.getTarget()._visible = false;
		super.load(image);
		container.enabled = false;
	}
	/**
	 * on load init.
	 * @param	target_mc
	 */
	public function onLoadInit(target_mc:MovieClip):Void {
		//this.container._alpha = 0;
		imageSize.x = (this.container._width % 2 == 0)?this.container._width:this.container._width + 1;
		imageSize.y = (this.container._height % 2 == 0)?this.container._height:this.container._height + 1;
		this.container.setMask(imageMask);
		changeContainerState();
		setEnabled(true);
		showCircle(false)
		loadingText.text = "";
		fitSize();
		dispatchEvent( { target:this, type:ON_LOAD_INIT } );
	}
	/**
	 * fit the image size.
	 */
	public function fitSize():Void
	{
		setLoaderSize();
		Tweener.removeTweens(bg);
		var $time:Number = bgTweenTime
		var $type:String = bgTweenType;
		Tweener.addTween(bg, { _width:imageSize.x+2*XYGAP, time:$time, transition:$type} );
		Tweener.addTween(bg, { _height:imageSize.y+2*XYGAP, time:$time, transition:$type ,onComplete:Delegate.create(this,runInEffectFunction)} );
	}
	/**
	 * set the image loader ui size and position
	 */
	private function setLoaderSize():Void
	{
		var w:Number = imageSize.x;
		var h:Number = imageSize.y;
		//mask
		imageMask._width = w;
		imageMask._height = h;
		//
		//container;
		container._x = -w / 2;
	    container._y = -h / 2;
		//
		//loadingText._x = -loadingCircle._width / 2;
		//loadingText._y = -loadingCircle._height / 2+1;
		loadingText._x = - loadingText._width / 2;
		loadingText._y = -loadingText._height / 2-2;
		//
	}
	/**
	 * set the description text.
	 */
	public function setText():Void
	{
		var s:String = this.image.description;
		if (s.length<1) {
			desText.hide();
			return;
		}else {
			desText.show();
		}
		var w:Number = imageSize.x;
		var h:Number = imageSize.y;
		var x:Number = w / 2;
		desText.setText(s, true, imageSize.x);
		var _h:Number = desText.getTarget()._height;
		desTextMask._y = h / 2 - _h;
		desTextMask._x=-w/2
		desTextMask._height = _h;
		desTextMask._width = w;
		desText['bg']._width = w+2;
		desText.getTarget()._x = desTextMask._x;
		//
		desText.getTarget()._y = h / 2;
		desText.show();
		if (autoShowDescriptionText!=true || s.length<1)
		{
			return;
		}
		textMoveIn();
	}
	/**
	 * show the text.
	 */
	public function textMoveIn():Void
	{
		var $time:Number = 0.5
		var $type:String = "easeOutCirc";
		var goalY:Number = imageSize.y / 2 - desText.getTarget()._height;
		Tweener.removeTweens(desText.getTarget());
		Tweener.addTween(desText.getTarget(), { _y:goalY, time:$time, transition:$type } );
	}
	/**
	 * hide the text
	 */
	public function textMoveOut():Void
	{
		var $time:Number = 0.5
		var $type:String = "easeOutCirc";
		var goalY:Number = imageSize.y / 2;
		Tweener.removeTweens(desText.getTarget());
		Tweener.addTween(desText.getTarget(), { _y:goalY, time:$time, transition:$type } );
	}
	/**
	 * on fade complete.
	 * @return void
	 */
	public function onFadeInComplete():Void {
		super.onFadeInComplete();
		dispatchEvent( { target:this, type:ON_FADE_IN_COMPLETE } );
		if(moveOverDescriptionText==true){
			/*bg.enabled = true;
			bg.useHandCursor = false;
			bg.onRollOver = Delegate.create(this, textMoveIn);
			bg.onRollOut = Delegate.create(this, textMoveOut);*/
			hitBackground();
		}
		if (canLinkTo==true)
		{
			if (image.link.target!="" && image.link.url!="")
			{
				container.enabled = true;
				container.onRelease = Delegate.create(this, linkTo);
			}
		}
	}
	private function linkTo():Void
	{
		var __url:String = image.link.url;
		var __target:String = image.link.target;
		getURL(__url, __target);
	}
	/**
	 * set auto show the description text.looks good.
	 * @param	b
	 */
	public function setAutoShowText(b:Boolean):Void
	{
		autoShowDescriptionText = b;
	}
	/**
	 * when mose over show the description .
	 * @param	b
	 */
	public function setMoveOverDescriptionText(b:Boolean):Void
	{
		moveOverDescriptionText = b;
	}
	private function hitBackground():Void
	{
		var o:SmartSizeImageLoader = this;
		bg.onEnterFrame = function()
		{
			if (o.moveOverDescriptionText!=true)
			{
				delete this.onEnterFrame;
				return;
			}
			if (o.bg.hitTest(_level0._xmouse,_level0._ymouse)==true)
			{
				o.textMoveIn();
			}else
			{
			    o.textMoveOut();
			}
		}
	}
	public function getDescriptionText():DescriptionText {
		return desText;
	}
}