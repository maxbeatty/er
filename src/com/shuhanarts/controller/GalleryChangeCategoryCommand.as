import com.shuhanarts.model.CategoryVO;
import com.shuhanarts.model.GalleryImagesProxy;
import org.puremvc.as2.interfaces.INotification;
import org.puremvc.as2.interfaces.IProxy;
import org.puremvc.as2.patterns.command.SimpleCommand;
import com.shuhanarts.model.GalleryCategoryProxy
/**
* ...
* @author ShuhanKuang {shuhankuang@gmail.com}
*/

class com.shuhanarts.controller.GalleryChangeCategoryCommand extends SimpleCommand
{
	
	public function execute( notification:INotification ) : Void
	{
		//category index..
		var index:Number = Number(notification.getBody());
		var categoryProxy:IProxy= facade.retrieveProxy(GalleryCategoryProxy.NAME);
		var cs:Array = categoryProxy.getData().categories;
		var c:CategoryVO = cs[index];
		var source:String = c.souce;
		//get category images.
		var proxy:GalleryImagesProxy = new GalleryImagesProxy();
		facade.registerProxy(proxy);
		//load the source
		proxy.loadsource(source);
	}
	
}