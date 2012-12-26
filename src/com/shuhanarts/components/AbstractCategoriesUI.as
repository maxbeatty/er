import com.shuhanarts.components.ICategoriesUI;
/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/

class com.shuhanarts.components.AbstractCategoriesUI extends Component implements ICategoriesUI
{
	static public var ON_CHANGE_CATEGORY:String='onchangecategory'
	//
	public var data:Object;
	private var container:MovieClip;
	/**
	 * Cons..
	 * @param	container
	 */
	public function AbstractCategoriesUI(container:MovieClip)
	{
		super();
		this.container = container;
		//
		
	}
	public function initUI(data:Object):Void {
		this.data = data;
		/*log.log('category select index : 0');
		change(5);*/
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
	/**
	 * Change the category..
	 * @param	index
	 */
	public function change(index:Number):Void {
		dispatchEvent( { target:this, type:ON_CHANGE_CATEGORY, index:index } );
	}
}