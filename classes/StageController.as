/**
* stage controller
* @author Shuhan Kuang
* @version 0.1
*/
import mx.events.EventDispatcher;
class StageController {
	//resize event.
	static public var ON_RESIZE:String = "onresize";
	//
	static public var instance:StageController;
	//
	//EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	//
    private var listaners:Array;
	private var names:Array;
	private var hasGradient:Boolean = false;
	private var gradientContainer:MovieClip;
	private var gradientObject:Object;
	/**
	 * cons...
	 */
	private function StageController() {
		EventDispatcher.initialize(this)
		Stage.scaleMode = "noScale"
		Stage.align = "LT";
		Stage.addListener(this)
		listaners = new Array();
		names = new Array();
		gradientObject = { c1:0xcccccc, c2:0x333333, a1:0, a2:80 };
		addEventListener(ON_RESIZE, Delegate.create(this, resizeGradient));

	}
	static public function getInstance():StageController {
		if (instance == null) {
			instance = new StageController();
        }
		return instance;
	}
	/**
	 * add a object to the listaners
	 * @param	obj
	 */
	public function addObj(obj:Object, name:String):Void {
		//removeObjByName(name);
		listaners.push(obj);
		names.push(name);
	}
	public function removeObjByName(name:String):Void {
		var t:Number=listaners.length
		for (var i:Number = 0; i < t;i++ ) {
			var $name:String = names[i];
			if ($name==name) {
				listaners.splice(i, 1);
				names.splice(i, 1);
				return;
			}
		}
	}
	private function onResize():Void {
		update();
		dispatchEvent( { target:this, type:ON_RESIZE } );
	}
	/**
	 * tell all listaners to run resize();
	 * @return void
	 */
	private function update():Void {
		for (var i :Number = 0; i < listaners.length;i++ ) {
			listaners[i].resize();
		}
	}
	public function remove():Void {
		//
	}
	public function fire():Void {
		instance = null;
	}
	/**
	 * get the stage size.
	 * @return Object   {w:0,h:0}
	 */
	public function getSize():Object {
		return {w:Stage.width,h:Stage.height}
	}
	/**
	 * set the application full screen..
	 * @return void
	 */
	public function goToFullScreen():Void
	{
		if (Stage["displayState"] == "normal") {
			Stage["displayState"] = "fullScreen";
		} else {
			Stage["displayState"] = "normal";
		}
	}
	/**
	 * add the fullscreen label to right key
	 * @return void
	 */
	public function setFullScreenRightKey() : Void
	{
		var r : RightKeyMaker = RightKeyMaker.getInstance();
		var f : Function = Delegate.create(this, goToFullScreen);
		r.addLabel("Fullscreen / Normal", f);
		r.reset();
	}
	private function resizeGradient():Void {
		createGradient();
	}
	/**
	 * Create gradient in stage..
	 * @param	container
	 */
	public function createGradient(container:MovieClip,obj:Object):Void {
		if (gradientContainer==undefined) {
			gradientContainer = container;
		}else {
			//
		}
		gradientObject = (obj == undefined)?gradientObject:obj;
		if (hasGradient==false) {
			hasGradient = true;
		}
		var _bgMC:MovieClip = gradientContainer.createEmptyMovieClip("bgmc", 10);
		//
		var color1 = gradientObject.c1;
		var color2 = gradientObject.c2;
		var alpha1 = gradientObject.a1;
		var alpha2 = gradientObject.a2;
		var startGrad = 0;
		var endGrad = 255;
		var gradDegrees = 90;
		var gradType = "radial";
		var xOffset = 0;
		var yOffset = 0;
		//
		var gradAngle = ((Math.PI*gradDegrees)/180);
		var colorArray = new Array(color1, color2);
		var alphaArray = new Array(alpha1, alpha2);
		var ratioArray = new Array(startGrad, endGrad);
		//gradient_mc.createEmptyMovieClip("background_mc", 101);
		var _w = Stage.width;
		var _h = Stage.height;
		var _obj = {matrixType:"box", x:xOffset, y:yOffset, w:_w, h:_h, r:gradAngle};
		_bgMC.beginGradientFill(gradType, colorArray, alphaArray, ratioArray, _obj);
		_bgMC.moveTo(0, 0);
		_bgMC.lineTo(0, _h);
		_bgMC.lineTo(_w, _h);
		_bgMC.lineTo(_w, 0);
		_bgMC.lineTo(0, 0);
		_bgMC.endFill();
	}
}