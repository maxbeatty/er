/**
* A rectangle , with some sweet motion
* @author ShuhanKuang {shuhankuang@gmail.com}
*/
import caurina.transitions.Tweener;
class MotionRectangle extends Component
{
	//motino position move out..
	static public var LEFT:String = 'LEFT';
	static public var RIGHT:String = 'RIGHT';
	static public var BOTTOM:String = 'BOTTOM';
	static public var TOP:String = 'TOP';
	//
	static public var TO_MIN_SIZE_START:String = 'tominsizestart';
	static public var TO_MIN_SIZE_DONE:String = 'tominsizedone';
	static public var TO_MAX_SIZE_START:String = 'tomaxsizestart';
	static public var TO_MAX_SIZE_DONE:String = 'tomaxsizedone';
	//
	public var color:Number = 0xF8F8F8;
	public var defaultMotion:String = LEFT;
	public var isMaxSize:Boolean
	//
	private var container:MovieClip;
	private var mask:MovieClip;
	private var rec:MovieClip;
	private var size:Vector;
	//tweener pro..
	private var _time:Number = 0.3;
	private var _type:String = "easeOutQuart";
	/**
	 * Cons..
	 * @param	container
	 */
	public function MotionRectangle(container:MovieClip) 
	{
		super();
		defaultMotion = LEFT;
		this.container = container;
		mask = this.container.createEmptyMovieClip("mask", 1000);
		rec = this.container.createEmptyMovieClip("rec", 900);
	}
	private function init():Void
	{
		//
	}
	/**
	 * set the rectangle size
	 * @param	w
	 * @param	h
	 */
	public function setSize(w:Number,h:Number):Void
	{
		this.size = new Vector(w, h);
		rec.clear();
		mask.clear();
		rec._x = mask._x = 0;
		rec._y = mask._y = 0;
		_draw();
		//toMinSize();
	}
	/**
	 * draw the rectangle
	 * @return void
	 */
	private function _draw():Void
	{
		//rec
		rec.clear(0);
		rec.lineStyle(1, 0x000000, 0);
		rec.beginFill(color, 100);
		ExShape.drawRect(rec, 0, 0, size.x, size.y, 0);
		rec.endFill();
		//mask
		mask.lineStyle(1, 0x000000, 0);
		mask.beginFill(0x000000, 0);
		ExShape.drawRect(mask, 0, 0, size.x, size.y, 0);
		mask.endFill();
		//
		rec.setMask(mask);
	}
	/**
	 * run to min size
	 * @return void
	 */
	public function toMinSize():Void
	{
		isMaxSize = false;
		removeSizeTween();
	    var obj:Object = getMotionPro();
		var pro:String = obj.pro;
		var n:Number = -obj.n;
		var value = (pro == "_x")?size.x:size.y;
		if(pro=="_x"){
			Tweener.addTween(rec, { _x:value * n, time:_time, transition:_type,onComplete:Delegate.create(this,toMinSizeDone)} );
		}else{
			Tweener.addTween(rec, { _y:value * n, time:_time, transition:_type,onComplete:Delegate.create(this,toMinSizeDone) } );
		}
		dispatchEvent( { target:this, type:TO_MIN_SIZE_START } );
	}
	/**
	 * run to max size
	 * @return void
	 */
	public function toMaxSize():Void
	{
		isMaxSize = true;
		removeSizeTween();
		var obj:Object = getMotionPro();
		var pro:String = obj.pro;
		var n:Number = obj.n;
		var value =0// (pro == "_x")?size.x:size.y;
		if(pro=="_x"){
			Tweener.addTween(rec, { _x:value * n, time:_time, transition:_type ,onComplete:Delegate.create(this,toMaxSizeDone)} );
		}else{
			Tweener.addTween(rec, { _y:value * n, time:_time, transition:_type,onComplete:Delegate.create(this,toMaxSizeDone) } );
		}
		dispatchEvent( { target:this, type:TO_MAX_SIZE_START } );
	}
	/**
	 * take the rectangle to max size
	 * @return void
	 */
	public function setMaxSize():Void
	{
		isMaxSize = true;
		var obj:Object = getMotionPro();
		var pro:String = obj.pro;
		var n:Number = obj.n;
		var value =0// (pro == "_x")?size.x:size.y;
		if(pro=="_x"){
			Tweener.addTween(rec, { _x:value * n, time:0, transition:_type} );
		}else{
			Tweener.addTween(rec, { _y:value * n, time:0, transition:_type} );
		}
	}
	/**
	 * take the rectangle to min size
	 * @return void
	 */
	public function setMinSize():Void
	{
		isMaxSize = false;
		var obj:Object = getMotionPro();
		var pro:String = obj.pro;
		var n:Number = -obj.n;
		var value = (pro == "_x")?size.x:size.y;
		if(pro=="_x"){
			Tweener.addTween(rec, { _x:value * n, time:0, transition:_type} );
		}else{
			Tweener.addTween(rec, { _y:value * n, time:0, transition:_type} );
		}
	}
	/**
	 * remove tween
	 * @return void
	 */
	public function removeSizeTween():Void
	{
		Tweener.removeTweens(rec);
	}
	private function toMinSizeDone():Void
	{
		//trace("toMinSizeDone")
		//toMaxSize();
		isMaxSize = false;
		dispatchEvent({target:this,type:TO_MIN_SIZE_DONE})
	}
	private function toMaxSizeDone():Void
	{
		//trace("toMaxSizeDone");
		//toMinSize();
		isMaxSize = true;
		dispatchEvent( { target:this, type:TO_MAX_SIZE_DONE } );
	}
	/**
	 * get motion type
	 * @return
	 */
	private function getMotionPro():Object
	{
		var obj:Object = new Object();
		var pro:String = "";
		var n:Number = 0;
		if (defaultMotion==undefined)
		{
			defaultMotion = LEFT;
		}
		switch(defaultMotion)
		{
			case LEFT :
				n = 1;
				pro = "_x";
				break;
			case RIGHT :
				n = -1;
				pro = "_x";
				break;
			case TOP :
				n = -1;
				pro = "_y";
				break;
			case BOTTOM :
				n = 1;
				pro = "_y";
				break;
			default :
				trace("No motion Pro...");
				break;
		}
		obj.pro = pro;
		obj.n = n;
		return obj;
	}
	public function getTarget():MovieClip
	{
		return container;
	}
	/**
	 * show or hide the recangel
	 * @return void
	 */
	public function show():Void {
		this.container._visible = true;
	}
	public function hide():Void {
		this.container._visible = false;
	}
	public function resetColor(color:Number):Void {
		this.color = color;
		_draw();
	}
}