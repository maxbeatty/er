/**
* abstract class ,all my class extend the component.
* @author shuhan Kuang {shuhankuang[at]gmail.com}
 */
//import LuminicBox.Log.ConsolePublisher;
//import LuminicBox.Log.Logger;
import com.hexagonstar.util.debug.Debug;
//import mx.events.EventDispatcher;
//import LuminicBox.Log.Logger;
//import LuminicBox.Log.ConsolePublisher;
import caurina.transitions.properties.ColorShortcuts;
import caurina.transitions.properties.DisplayShortcuts;
import caurina.transitions.properties.FilterShortcuts;
import caurina.transitions.properties.TextShortcuts;
import caurina.transitions.Tweener;
//import caurina.transitions.properties.SoundShortcuts;
//
class Component implements IComponent {
	//some static value.
	static public var TOP:String='top'
	static public var BOTTOM:String = "bottom";
	static public var RIGHT:String = "right";
	static public var LEFT:String = "left";
	static public var CENTER:String = "center";
	//
	static public var DEFAULT_FONT:String = "PF Tempesta Five";
	static public var DEFAULT_FONT_SIZE:Number = 8;
	//basic event 
	static public var ON_CLICK_EVENT:String = "onclick";
	static public var ON_DOUBLECLICK_EVENT:String = "ondoubleclick";
	static public var ON_ENTERFRAME:String = "onenterframe";
	static private var DOUBLECLICKDELAY : Number = 300;
	//Button events..
	static public var ON_SELECT:String = "onselect";
	static public var ON_ROLL_OVER:String = "onrollover";
	static public var ON_PRESS:String = "onpress";
	static public var ON_ROLL_OUT:String = "onrollout";
	static public var ON_RELEASE_OUT:String = "onreleaseout";
	//EventDispatcher
	/*public function addEventListener():Void{};
	public function removeEventListener():Void{};
	public function dispatchEvent():Void{}
	public function eventListenerExists():Void{};
	public function removeAllEventListeners():Void{};*/
	public function addEventListener(p_event:String, p_obj:Object, p_function:String):Void{};
	public function removeEventListener(p_event:String, p_obj:Object, p_function:String):Void{};
	public function removeAllEventListeners(p_event:String):Void{};
	public function dispatchEvent(p_eventObj:Object):Void{};
	public function eventListenerExists(p_event:String, p_obj:Object, p_function:String):Boolean{return false};
	//use in doubleclick;
	private var __lastClickTime : Number = 0;
	//public var log:Logger;
	//
	private var _time:Number = 0.5;
	private var _type:String='easeInOutCirc'
	/**
	 * Cons..
	 */
	public function Component() {
		//EventDispatcher.initialize(this);
		GDispatcher.initialize(this);
		ColorShortcuts.init();
		FilterShortcuts.init();
		//SoundShortcuts.init();
		TextShortcuts.init();
		DisplayShortcuts.init();
		//log = new Logger("Logger");
		//add TracePublisher if you want to log to the Output window
		//log.addPublisher( new TracePublisher() );
		//add ConsolePublisher if you want to log to FlashInspector
		//log.addPublisher( new ConsolePublisher() );
	}
	public function getComponent():Component {
		return this;
	}
	/**
	 * Double click
	 * ....
	 */
	private function __doubleClick() : Void 
	{
		var thisClick : Number = getTimer();
		var delay : Number = thisClick - __lastClickTime;
		if(delay < DOUBLECLICKDELAY) 
		{
			//trace(ON_DOUBLECLICK_EVENT)
			dispatchEvent( { target:this, type:ON_DOUBLECLICK_EVENT } );
		}else 
		{
			//trace(ON_CLICK_EVENT)
			dispatchEvent( { target:this, type:ON_CLICK_EVENT } );
		}
		__lastClickTime = thisClick;
	}
	/**
	 * same buttons functions..with event dispatchevent.
	 */
	public function onRelease():Void {
		//__doubleClick();
	}
	public function onPress():Void {
		//
	}
	public function onRollOver():Void {
		//
	}
	public function onRollOut():Void {
		//
	}
	public function onReleaseOutside():Void {
		//
	}
	public function onEnterFrame():Void {
		dispatchEvent( { target:this, type:ON_ENTERFRAME } );
	}
	public function setSize():Void {
		//
	}
	public function setTextFieldColor(textField:TextField,color:Number):Void {
		var tf:TextFormat = new TextFormat();
		tf.color = color;
		textField.setNewTextFormat(tf);
		textField.setTextFormat(tf);
	}
	/**
	 * set the movieclip color
	 * @param	movieClip
	 * @param	color
	 */
	public function setMovieClipColor(movieClip:MovieClip,color:Number):Void
	{
		var c:Color = new Color(movieClip);
		c.setRGB(color)
	}
	/**
	 * set the movieclip size
	 * @param	movieClip
	 * @param	w
	 * @param	h
	 */
	public function setMovieClipSize(movieClip:MovieClip,w:Number,h:Number):Void
	{
		movieClip._width = w;
		movieClip._height = h;
	}
	/**
	 * fade in effect.
	 * @param	targets
	 * @param	inAlpha
	 * @param	outAlpha
	 * @param	callBack
	 */
	private function MovieClipFadeIn(targets:Array, inAlpha:Number, outAlpha:Number, callBack:Function):Void {
		var t:Number = targets.length;
		for (var i:Number = 0; i < t;i++ ) {
			var $target:MovieClip = targets[i];
			$target._alpha = inAlpha;
			Tweener.addTween($target, { _autoAlpha:outAlpha, time:1, transition:'linear', onComplete:callBack } );
		}
	}
	/**
	 * fade out effect..
	 * @param	targets
	 * @param	inAlpha
	 * @param	outAlpha
	 * @param	callBack
	 */
	private function MovieClipFadeOut(targets:Array, inAlpha:Number, outAlpha:Number, callBack:Function):Void {
		var t:Number = targets.length;
		for (var i:Number = 0; i < t;i++ ) {
			var $target:MovieClip = targets[i];
			$target._alpha = inAlpha;
			Tweener.addTween($target, { _autoAlpha:outAlpha, time:1, transition:'linear', onComplete:callBack } );
		}
	}
	private function removeAllChildren(container:MovieClip):Void {
		for (var i in container) {
			var mc:MovieClip = MovieClip(container[i]);
			mc.removeMovieClip();
		}
	}
	/**
	 * for debug..
	 */
	private function Log(o:Object):Void {
		Debug.trace(o);
	}
	private function LogObject(o:Object):Void {
		Debug.traceObj(o);
		Debug.inspect(o);
	}
	private function LogClear():Void {
		Debug.clear();
	}
}