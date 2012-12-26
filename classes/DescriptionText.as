/**
* movieclip with text and background,like a textfiele
* @author shuhankuang[at]gmail.com
*/
import caurina.transitions.Tweener;
//
class DescriptionText extends Component {
	//Button events..
	static public var ON_SELECT:String = "onselect";
	static public var ON_ROLL_OVER:String = "onrollover";
	static public var ON_PRESS:String = "onpress";
	static public var ON_ROLL_OUT:String = "onrollout";
	static public var ON_RELEASE_OUT:String = "onreleaseout";
	static public var LINK_ID:String = 'destext';
	//events.
	static public var ON_CHANGE:String="onchange"
	//text component.
	private var target:MovieClip
	//text 
	private var txt:TextField;
	//background of the text.
	private var bg:MovieClip;
	//string of the text
	private var des:String = '';
	private var pressAbled:Boolean = false;
	//xy gap..
	public var dis:Number = 2;
	public var align:String =LEFT
	public var index:Number = 0;
	/**
	 * Cons..
	 * @param	target
	 */
	public function DescriptionText(target:MovieClip) {
		super();
		this.target = target;
		//trace('this.target='+this.target)
		txt = this.target.txt;
		//txt.autoSize = true;
		txt.multiline = true;
		txt.html = true;
		txt.wordWrap = true;
		bg = this.target.bg;
		//bg._alpha = 30;
	}
	/**
	 * set the text file..
	 * @param	s
	 * @param	autoSize
	 * @param	width
	 * @param	height
	 */
	public function setText(s:String, autoSize:Boolean, width:Number, height:Number):Void {
		des = s;
		txt._x = dis;
		//var tf:TextFormat = new TextFormat();
		//tf.align = align;
		txt.autoSize = autoSize;
		if(width!=undefined){
			txt._width = width - dis;
		}
		//txt.setTextFormat(tf);
		if (height!=undefined)
		{
			txt._height = height;
		}
		txt.htmlText = s;
		txt.htmlText = txt.htmlText;
		//txt.text = s;
		var w:Number = txt._width
		var h:Number = txt._height;
		if (width == undefined) {
			width = txt._width + dis * 2;
			trace('width='+width)
		}
		bg._width = width;
		bg._height = h + dis;
		//txt.setNewTextFormat(tf);
		//dispatchEvent( { target:this, type:ON_CHANGE } );
		//setPressAbled(pressAbled)
	}
	/**
	 * if not use htmltext ,it'll work.
	 * @param	font
	 * @param	size
	 * @param	color
	 */
	/*public function setDescriptionTextFormat(font:String,size:Number,color:Number):Void
	{
		var tf:TextFormat = new TextFormat();
		tf.font = font;
		tf.size = size;
		tf.color = color;
		txt.setTextFormat(tf);
	}*/
	public function setPressAbled(b:Boolean):Void
	{
		pressAbled = b;
		if (pressAbled == true) {
			bg.enabled = true;
			bg.useHandCursor = true;
			bg.onRelease = Delegate.create(this, onRelease);
			bg.onRollOut = Delegate.create(this, onRollOut);
			bg.onRollOver = Delegate.create(this, onRollOver);
			bg.onReleaseOutside = Delegate.create(this, onReleaseOutside);
		}else {
			bg.onRelease = new Function();
			bg.enabled = false;
			bg.useHandCursor = false;
		}
	}
	/**
	 * buttons functions.
	 */
	public function onRollOver():Void {
		dispatchEvent( { target:this, type:ON_ROLL_OVER } );
	}
	public function onRelease():Void {
		dispatchEvent( { target:this, type:ON_SELECT } );
	}
	public function onRollOut():Void {
		dispatchEvent( { target:this, type:ON_ROLL_OUT } );
	}
	public function onReleaseOutside():Void {
		onRelease();
	}
	public function getTarget():MovieClip {
		return target;
	}
	private function setVisible(b:Boolean):Void
	{
		getTarget()._visible = b;
	}
	/**
	 * show the text 
	 */
	public function show():Void
	{
		setVisible(true)
	}
	/**
	 * hide the text.
	 */
	public function hide():Void
	{
		setVisible(false)
	}
	public function getDescription():String
	{
		return des;
	}
}