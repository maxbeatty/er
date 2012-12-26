import com.shuhanarts.components.IThumbnailsUI;
/**
* ...
* @author ShuhanKuang {shuhankuang@gmail.com}
*/

class com.shuhanarts.components.AbstractThumbnailsUI extends Component implements IThumbnailsUI
{
	static public var ON_CHANGE_IMAGE:String = 'onchangeimage';
	//
	private var container:MovieClip;
	private var data:Object;
	private var images:Array;
	/**
	 * Cons..
	 * @param	container
	 */
	public function AbstractThumbnailsUI(container:MovieClip) 
	{
		super();
		this.container = container;
		
	}
	public function initUI(data:Object):Void {
		this.data = data;
		images=new Array();
		images = this.data.images;
		//
		/*log.log('thumbnails select index : 0');
		setSelectedIndex(0);*/
	}
	public function getContainer():MovieClip {
		return container;
	}
	public function show():Void {
		getContainer()._visible = true;
	}
	public function hide():Void {
		getContainer()._visible = false;
	}
	public function selectImage():Void {
		//
	}
	public function setSelectedIndex(index:Number):Void {
		var image:Image = images[index];
		var id:Number = image.id;
		dispatchEvent( { target:this, type:ON_CHANGE_IMAGE, index:id } );
	}
}