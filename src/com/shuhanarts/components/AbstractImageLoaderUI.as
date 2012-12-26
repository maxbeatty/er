import com.shuhanarts.components.IImageLoaderUI;
/**
* ...
* @author ShuhanKuang {shuhankuang@gmail.com}
*/

class com.shuhanarts.components.AbstractImageLoaderUI extends Component implements IImageLoaderUI
{
	//image load event
	static public var ON_IMAGE_LOAD_START:String = 'onimageloadstart';
	static public var ON_IMAGE_LOAD_INIT:String = 'onimageloadinit';
	//
	private var target:MovieClip;
	private var data:Object;
	private var image:Image;
	/**
	 * Cons..
	 * @param	target
	 */
	public function AbstractImageLoaderUI(target:MovieClip)
	{
		super();
		this.target = target;
		//
		
	}
	public function initUI(data:Object):Void {
		this.data = data;
	}
	public function getTarget():MovieClip {
		return target;
	}
	public function show():Void {
		getTarget()._visible = true;
	}
	public function hide():Void {
		getTarget()._visible = false;
	}
	public function load(image:Image):Void {
		this.image = image;
		dispatchEvent( { target:this, type:ON_IMAGE_LOAD_START } );
	}
	public function onLoadInit(e:Object):Void {
		dispatchEvent( { target:this, type:ON_IMAGE_LOAD_INIT } );
	}
}