/**
* mask controller , when you want to show a item ,mask all other item in background
* @author Shuhan Kuang  {shuhankuang[at]gmail.com}
*/
import caurina.transitions.Tweener;
//
class MaskController extends Component {
	static public var MASK_ID:Number = 0;
    static public var ON_CLICK:String = 'onclick';
	//Mask alpha event.
	static public var FADE_IN_DONE_EVETN:String="fadein"
	static public var FADE_OUT_DONE_EVETN:String = "fadeout"
	//mask movieclip
	private var target:MovieClip;
	//current event.
	private var event:String;
	//tween time
	private var time:Number = 1;
	private var xdis:Number = 0;
	private var ydis:Number = 0;
	//
	/**
	 * Cons 
	 * @param	target
	 */
	public function MaskController(target:MovieClip) {
		super();
		this.target = target;
		this.target._alpha = 0;
		this.target.onRelease = function() { };
		this.target.enabled = false;
		hide();
		MASK_ID ++;
		StageController.getInstance().addObj(this,'MaskController'+MASK_ID);
		resize();
	}
	public function setPressAbled(b:Boolean):Void {
		var o:MaskController = this;
		this.target.onRelease = function() { 
		    o.dispatchEvent( { type:MaskController.ON_CLICK, target:o} );
		};
		this.target.enabled = b;
		this.target.useHandCursor = b;
		
	}
	/**
	 * mask fade in 
	 * @param	maxAlpha
	 */
	public function fadeIn(maxAlpha:Number):Void {
		var alpha:Number = 100;
		event = FADE_IN_DONE_EVETN;
		alpha=(maxAlpha==undefined)?alpha:maxAlpha
		show();
		if (this.target._alpha==100){
			onMotionFinished();
			return;
		}
		/*var alphatween : Tween = new Tween(this.target, "_alpha", null, this.target._alpha, alpha, time, true);
		alphatween.addListener(this);*/
		Tweener.addTween(target, { _autoAlpha:alpha, time:time, transition:'linear',onComplete:Delegate.create(this,onMotionFinished) } );
	}
	/**
	 * mask fade out
	 * @param	minAlpha
	 */
	public function fadeOut(minAlpha:Number):Void {
		var alpha:Number = 0;
		alpha=(minAlpha==undefined)?alpha:minAlpha
		event = FADE_OUT_DONE_EVETN;
		/*var alphatween : Tween = new Tween(this.target, "_alpha", null, this.target._alpha, alpha, time, true);
		alphatween.addListener(this);*/
		Tweener.addTween(target, { _autoAlpha:alpha, time:time, transition:'linear',onComplete:Delegate.create(this,onMotionFinished) } );
	}
	/**
	 * when fade in or out complete.
	 * @param	e
	 */
	public function onMotionFinished(e):Void {
		dispatchEvent( { target:this, type:event } )
		if (event==FADE_OUT_DONE_EVETN) {
			hide();
		}
	}
	/**
	 * set the mask visible
	 * @param	b
	 */
	private function setVisible(b:Boolean):Void {
		this.target._visible = b;
	}
	/**
	 * shoe the mask
	 */
	public function show():Void {
		setVisible(true);
	}
	/**
	 * hide the mask
	 */
	public function hide():Void {
		setVisible(false);
	}
	/**
	 * run the funciton , when stage resize.
	 * @return void
	 */
	public function resize():Void {
		var size:Object = StageController.getInstance().getSize() ;
		this.target._width = size.w+xdis;
		this.target._height = size.h + ydis;
	}
	/**
	 * set x and y position.
	 * @param	_xdis
	 * @param	_ydis
	 */
	public function setXYDis(_xdis:Number,_ydis:Number):Void {
		this.xdis = _xdis;
		this.ydis = _ydis;
		resize();
	}
	public function getTarget():MovieClip {
		return target;
	}
	
}