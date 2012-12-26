import com.shuhanarts.model.CategoryVO;
import org.puremvc.as2.patterns.proxy.Proxy;
/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/

class com.shuhanarts.model.GalleryCategoryProxy extends Proxy
{
	static public var NAME:String = 'GalleryCategoryProxy';
	//
	private var xmlLoader:XMLLoader;
	/**
	 * cons..
	 */
	public function GalleryCategoryProxy() 
	{
		super(NAME, new Object());
		xmlLoader = new XMLLoader(_root);
		xmlLoader.addEventListener(XMLLoader.ON_LOAD_INIT, Delegate.create(this, parse));
		sendNotification(GalleryApp.ON_CATEGORY_DATA_LOAD_START);
		xmlLoader.load(GalleryApp.CATEGORY_XML_FILE);
	}
	/**
	 * parse the xml data..
	 * @return void
	 */
	private function parse():Void {
		var asObj:Object = xmlLoader.getASObj();
		data.categories = new Array();
		var cs:Array = asObj.data.category;
		if (cs.length==undefined) {
			cs = [asObj.data.category];
		}
		//
		_global.thumbsize = StringUtil.toVector(String(asObj.data.thumbsize.data));
		_global.thumbslayout = StringUtil.toVector(String(asObj.data.thumbslayout.data));
		_global.textnormalcolor = Number(String(asObj.data.textnormalcolor.data));
		_global.textovercolor = Number(String(asObj.data.textovercolor.data));
		_global.thumbnormalcolor = Number(String(asObj.data.thumbnormalcolor.data));
		_global.thumbovercolor = Number(String(asObj.data.thumbovercolor.data));
		_global.thumbborder = Number(String(asObj.data.thumbborder.data));
		_global.bgtweentype = (String(asObj.data.bgtweentype.data));
		_global.bgtweentime = Number(String(asObj.data.bgtweentime.data));
		_global.menutweentype = (String(asObj.data.menutweentype.data));
		_global.menutweentime = Number(String(asObj.data.menutweentime.data));
		_global.menumaxperpage = Number(String(asObj.data.menumaxperpage.data));
		_global.buttontweentype = (String(asObj.data.buttontweentype.data));
		_global.buttontweentime = Number(String(asObj.data.buttontweentime.data));
		_global.imgtweentype = (String(asObj.data.imgtweentype.data));
		_global.imgtweentime = Number(String(asObj.data.imgtweentime.data));
		_global.imgborder = Number(String(asObj.data.imgborder.data));
		_global.selectedindex = Number(String(asObj.data.selectedindex.data));
		//
		var t:Number = cs.length;
		for (var i :Number = 0; i < t;i++ ) {
			var obj:Object = cs[i];
			var c:CategoryVO = new CategoryVO();
			c.name = String(obj.attributes.name);
			c.description = String(obj.attributes.description);
			c.fullDescription = String(obj.data);
			c.souce = ''+String(obj.attributes.source);
			c.cover = ''+String(obj.attributes.cover);
			data.categories.push(c);
		}
		sendNotification(GalleryApp.ON_CATEGORY_DATA_LOAD_INIT, data);
	}
}