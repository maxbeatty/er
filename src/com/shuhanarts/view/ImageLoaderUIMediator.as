import com.shuhanarts.components.AbstractImageLoaderUI;
import com.shuhanarts.components.IImageLoaderUI;
import org.puremvc.as2.interfaces.INotification;
import org.puremvc.as2.patterns.mediator.Mediator;
/**
* ...
* @author ShuhanKuang {shuhankuang@gmail.com}
*/

class com.shuhanarts.view.ImageLoaderUIMediator extends Mediator
{
	static public var NAME:String = 'ImageLoaderUIMediator';
	//
	private var imageLoaderUI:IImageLoaderUI;
	/**
	 * Cons..
	 * @param	mediatorName
	 * @param	viewComponent
	 */
	public function ImageLoaderUIMediator(mediatorName:String, viewComponent : IImageLoaderUI) 
	{
		super(NAME, viewComponent);
		imageLoaderUI = viewComponent
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
			    //
			break;
			case GalleryApp.ON_CATEGORY_DATA_LOAD_START :
			//
			break;
			case GalleryApp.ON_IMAGE_LOAD_INIT :
			//
			break;
			case GalleryApp.ON_IMAGE_LOAD_START :
			    
			break;
			case GalleryApp.ON_IMAGES_DATA_LOAD_INIT :
			    imageLoaderUI.initUI(body);
			break;
			case GalleryApp.ON_IMAGES_DATA_LOAD_START :
			     
			break;
			case GalleryApp.ON_CHANGE_IMAGE :
			     var image:Image = Image(body);
				 imageLoaderUI.load(image);
			break;
			default :
			//
			break;
		}
	}
	
}