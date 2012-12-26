import it.sephiroth.XML2Object;
import com.hexagonstar.util.debug.Debug;
/**
* xml loader use XML2Object
* @author Shuhan Kuang  {shuhankuang[at]gmail.com}
*/
class XMLLoader extends Component {
	//
	static public var NAME:String = "XMLLOADER V1.0";
	static public var ON_LODA_INIT_EVENT:String = "onloadinit";
	static public var ON_LOAD_INIT:String = 'onloadinit';
	//
	private var xml:XML;
	private var timeline:MovieClip;
	private var xml2Object:XML2Object;
	private var asObj:Object;
	/**
	 * Cons..
	 */
	public function XMLLoader(timeline:MovieClip) {
		this.timeline = timeline;
	}
	/**
	 * 
	 * @param	url
	 * @param	type MENU_TYPE OR GALLRY_TYPE
	 */
	public function load(url:String):Void {
		xml2Object = new XML2Object();
		xml = new XML();
		xml.ignoreWhite = true;
		xml.onLoad = Delegate.create(this, onLoad);
		xml.load(url);
		//
	}
	private function onLoad(success):Void {
		if (success) {
			parseXML()
			dispatchEvent( { type:ON_LODA_INIT_EVENT, target:this } );
		}
	}
	/**
	 * Parse the data for the xml..
	 * @param	xml
	 */
	private function parseXML():Void {
		var xml:XML = getXML();
		asObj = new Object();
		asObj=xml2Object.parseXML(xml);
	}
	public function getXML():XML {
		return xml;
	}
	public function getASObj():Object {
		return asObj;
	}
	
}