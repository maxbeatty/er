/**
* stack loader (load the image step by step)
* @author ShuhanKuang {shuhankuang@gmail.com}
*/

class StackLoader extends Component
{
	//
	static public var ON_LOAD_NEXT:String = 'onloadnext';
	static public var ON_LOAD_END:String = 'onloadend';
	//
	private var loaders:Array;
	private var copyLoaders:Array;
	private var urls:Array;
	private var copyurls:Array;
	private var _total:Number = 0;
	private var _currentIndex:Number = 0;
	private var _currentLoader:Object;
	/**
	 * Cons..
	 */
	public function StackLoader() 
	{
		super();
		clear();
	}
	public function clear():Void {
		loaders = new Array();
		urls = new Array();
		resetCopyArray();
		_total = 0;
		_currentIndex = -1;
	}
	private function resetCopyArray():Void {
		copyLoaders = new Array();
		copyurls = new Array();
		copyLoaders = loaders.concat();
		copyurls = urls.concat();
	}
	/**
	 * loader.load(obj);
	 * @param	loader (imageloader or swfloader..)
	 * @param	obj  (may be Image or url 'string')
	 */
	public function addLoader(loader:Object,obj:Object):Void {
		loaders.push(loader);
		urls.push(obj);
		resetCopyArray();
	}
	public function getLoaderByIndex(index:Number):Object {
		return loaders[index];
	}
	private function loadNext():Void {
		if (copyLoaders.length<=0) {
			dispatchEvent( { target:this, type:ON_LOAD_END } );
			return;
		}
		_currentIndex = _total - copyLoaders.length;
		var loader:Object = copyLoaders.shift();
		var obj:Object = copyurls.shift();
		loader.addEventListener(AbstractLoader.ON_LOAD_INIT, Delegate.create(this, loadNext));
		loader.load(obj);
		dispatchEvent( { target:this, type:ON_LOAD_NEXT,currentIndex:getCurrentIndex()} );
		_currentLoader = loader;
	}
	/**
	 * start to load
	 * @return void
	 */
	public function loadStart():Void {
		_currentIndex = 0;
		_total = loaders.length;
		loadNext();
	}
	/**
	 * get current loaded index
	 * @return
	 */
	public function getCurrentIndex():Number { 
		return _currentIndex; 
	}
	/**
	 * get total image
	 * @return
	 */
	public function getTotal():Number { 
		_total = loaders.length;
		return _total; 
	}
	/**
	 * get current loader
	 * @return
	 */
	public function getCurrentLoader():Object { 
		return _currentLoader; 
	}
	/**
	 * get all loaders
	 * @return
	 */
	public function getLoaders():Array {
		return loaders.concat();
	}
}