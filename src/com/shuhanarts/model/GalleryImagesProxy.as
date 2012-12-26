import org.puremvc.as2.patterns.proxy.Proxy;
/**
* ...
* @author ShuhanKuang {shuhankuang@gmail.com}
*/

class com.shuhanarts.model.GalleryImagesProxy extends Proxy
{
	//
	static public var NAME:String = 'GalleryImagesProxy';
	//
	private var xmlLoader:XMLLoader;
	/**
	 * cons..
	 */
	public function GalleryImagesProxy()
	{
		super(NAME, new Object());
		xmlLoader = new XMLLoader(_root);
		xmlLoader.addEventListener(XMLLoader.ON_LOAD_INIT, Delegate.create(this, parse));
	}
	public function loadsource(source:String ):Void {
		sendNotification(GalleryApp.ON_IMAGES_DATA_LOAD_START);
		xmlLoader.load(source);
	}
	/**
	 * parse the xml data..
	 * @return void
	 */
	private function parse():Void {
		var asObj:Object = xmlLoader.getASObj();
		data.images = new Array();
		var imgs:Array = asObj.data.image;
		if (imgs.length==undefined) {
			imgs = [asObj.data.image];
		}
		var t:Number = imgs.length;
		for (var i :Number = 0; i < t;i++ ) {
			var img:Object = imgs[i];
			var image:Image = new Image();
			//set the image path..
			image.thumbnailurl = ''+String(img.attributes.thumburl);
			image.imageurl = '' + String(img.attributes.imageurl);
			//
			var link:Array = String(img.attributes.link).split(',');
			image.link.target = link[1];
			image.link.url = link[0];
			image.description = String(img.data);
			image.id = i;
			data.images.push(image);
		}
		sendNotification(GalleryApp.ON_IMAGES_DATA_LOAD_INIT, data);
	}
	
}