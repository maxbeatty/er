import com.shuhanarts.components.AbstractCategoriesUI;
import com.shuhanarts.components.ICategoriesUI;
import org.puremvc.as2.interfaces.INotification;
import org.puremvc.as2.patterns.mediator.Mediator;
/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/

class com.shuhanarts.view.CategoriesUIMediator extends Mediator
{
	static public var NAME:String = 'CategoriesUIMediator';
	//
	private var categoriesUI:ICategoriesUI;
	/**
	 * Cons..
	 * @param	mediatorName
	 * @param	viewComponent
	 */
	public function CategoriesUIMediator(mediatorName:String, viewComponent : ICategoriesUI) 
	{
		super(NAME, viewComponent);
		categoriesUI = viewComponent;
		categoriesUI.addEventListener(AbstractCategoriesUI.ON_CHANGE_CATEGORY, Delegate.create(this, changeCategory));
	}
	public function listNotificationInterests() : Array 
	{
		return [
		GalleryApp.ON_CATEGORY_DATA_LOAD_INIT,
		GalleryApp.ON_CATEGORY_DATA_LOAD_START,
		GalleryApp.ON_IMAGE_LOAD_INIT,
		GalleryApp.ON_IMAGE_LOAD_START,
		GalleryApp.ON_CHANGE_IMAGE,
		GalleryApp.ON_IMAGES_DATA_LOAD_INIT,
		GalleryApp.ON_IMAGES_DATA_LOAD_START];
	}
	public function handleNotification( notification:INotification ) : Void {
		//value from notification..
		var eventName:String = notification.getName();
		var body:Object = notification.getBody();
		//
		switch(eventName) {
			case GalleryApp.ON_CATEGORY_DATA_LOAD_INIT :
			    categoriesUI.initUI(body);
			break;
			case GalleryApp.ON_CATEGORY_DATA_LOAD_START :
			//
			break;
			case GalleryApp.ON_IMAGE_LOAD_INIT :
			//
			break;
			case GalleryApp.ON_IMAGE_LOAD_START :
			//
			break;
			case GalleryApp.ON_IMAGES_DATA_LOAD_INIT :
			//
			break;
			case GalleryApp.ON_IMAGES_DATA_LOAD_START :
			//
			break;
			case GalleryApp.ON_CHANGE_IMAGE :
			     ///
			break;
			default :
			//
			break;
		}
	}
	private function changeCategory(e:Object):Void {
		//category index , from data.categories[index];
		var index:Number = e.index;
		sendNotification(GalleryApp.ON_CHANGE_CATEGORY, index);
	}
}