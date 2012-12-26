import com.shuhanarts.components.IThumbnailsUI;
import org.puremvc.as2.interfaces.INotification;
import org.puremvc.as2.patterns.mediator.Mediator;
import com.shuhanarts.model.GalleryImagesProxy;
/**
* ...
* @author ShuhanKuang {shuhankuang@gmail.com}
*/

class com.shuhanarts.view.ThumbnailsUIMediator extends Mediator
{
	static public var NAME:String = 'ThumbnailsUIMediator';
	//
	private var thumbnailUI:IThumbnailsUI;
	/**
	 * cons..
	 * @param	mediatorName
	 * @param	viewComponent
	 */
	public function ThumbnailsUIMediator(mediatorName:String, viewComponent : IThumbnailsUI) 
	{
		super(NAME, viewComponent);
		thumbnailUI = viewComponent;
		thumbnailUI.addEventListener(GalleryApp.ON_CHANGE_IMAGE, Delegate.create(this, changeImage));
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
		GalleryApp.ON_IMAGES_DATA_LOAD_START,
		GalleryApp.ON_CHANGE_CATEGORY];
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
			//
			break;
			case GalleryApp.ON_IMAGES_DATA_LOAD_INIT :
			    thumbnailUI.initUI(body);
			break;
			case GalleryApp.ON_IMAGES_DATA_LOAD_START :
			//
			break;
			case GalleryApp.ON_CHANGE_CATEGORY :
			    
			break;
			case GalleryApp.ON_CHANGE_IMAGE :
			     //
			break;
			default :
			//
			break;
		}
	}
	private function changeImage(e:Object):Void {
		var images:Array = facade.retrieveProxy(GalleryImagesProxy.NAME).getData().images.concat();
		var index:Number = e.index;
		var image:Image = images[index];
		sendNotification(GalleryApp.ON_CHANGE_IMAGE, image);
	}
}