import com.shuhanarts.components.AbstractCategoriesUI;
import com.shuhanarts.components.AbstractImageLoaderUI;
import com.shuhanarts.components.AbstractThumbnailsUI;
import com.shuhanarts.components.CategoriesUI;
import com.shuhanarts.components.ImageLoaderUI;
import com.shuhanarts.components.ThumbnailsUI;
import com.shuhanarts.model.GalleryImagesProxy;
import com.shuhanarts.model.GalleryCategoryProxy;
import com.shuhanarts.view.CategoriesUIMediator;
import com.shuhanarts.view.ThumbnailsUIMediator;
import com.shuhanarts.view.ImageLoaderUIMediator;
import org.puremvc.as2.interfaces.INotification;
import org.puremvc.as2.patterns.command.SimpleCommand;
/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/

class com.shuhanarts.controller.GalleryStartUPCommand extends SimpleCommand
{
	
	public function execute( notification:INotification ) : Void
	{
		var container:MovieClip = MovieClip(notification.getBody());
		//mediators..
		facade.removeMediator(CategoriesUIMediator.NAME);
		facade.removeMediator(ImageLoaderUIMediator.NAME);
		facade.removeMediator(ThumbnailsUIMediator.NAME);
		//proxies..
		facade.removeProxy(GalleryCategoryProxy.NAME);
		facade.removeProxy(ImageLoaderUIMediator.NAME);
		//view (change the UI classes)
		facade.registerMediator(new CategoriesUIMediator(null, new CategoriesUI(container.ccontainer)));
		facade.registerMediator(new ThumbnailsUIMediator(null, new ThumbnailsUI(container.tcontainer)));
		facade.registerMediator(new ImageLoaderUIMediator(null, new ImageLoaderUI(container.imgloader)));
		//proxy
		facade.registerProxy(new GalleryCategoryProxy());
		facade.registerProxy(new GalleryImagesProxy());
	}
	
}