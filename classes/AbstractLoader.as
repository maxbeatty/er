/**
* Just an empty movieclip , be used contain swf , image ,png and so on.
* @author ShuhanKuang {shuhankuang@gmail.com}
*/
class AbstractLoader extends Component
{
	private var container:MovieClip;
	//
	static public var ON_LOAD_START:String = "onloadstart";
	static public var ON_LOAD_INIT:String = "onloadinit";
	static public var ON_LOAD_PROGRESS:String = "onloadprogress";
	//
	private var $url:String;
	private var $loader:MovieClipLoader;
	private var percent:Number = 0;
	/**
	 * Cons..
	 * @param	contaienr
	 */
	public function AbstractLoader(container:MovieClip) 
	{
		super();
		this.container = container;
		this.container._lockroot = true;
	}
	public function getContainer():MovieClip
	{
		return container;
	}
	/**
	 * Load the swf file.
	 * @param	url
	 */
	public function load(url:String):Void
	{
		this.$url = (url == undefined)?this.$url:url;
		unLoad();
		_load();
	}
	public function setURL(url:String):Void {
		this.$url = url;
	}
	private function _load():Void
	{
		//some bug about the movieClipLoader,i can't  fit it. :-(
		percent = 0;
		$loader.unloadClip();
		$loader.removeListener(this);
		$loader = undefined;
		$loader = new MovieClipLoader();
		$loader.addListener(this);
		$loader.loadClip(this.$url, container);
		dispatchEvent( { target:this, type:ON_LOAD_START } );
	}
	/**
	 * loading funcitoin
	 * @param	target_mc
	 */
	private function onLoadInit(target_mc:MovieClip):Void {
		dispatchEvent( { target:this, type:ON_LOAD_INIT } );
	}
	private function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void
	{
		if (bytesLoaded>0 && bytesTotal>4)
		{
			percent = Math.floor(bytesLoaded * 100 / bytesTotal);
			
		}else{
			percent = 0;
		}
		dispatchEvent( { target:this, type:ON_LOAD_PROGRESS } );
	}
	/**
	 * un load
	 */
	public function unLoad():Void
	{
		container.unloadMovie();
	    $loader.unloadClip();
	}
	/**
	 * get loading percent.
	 * @return
	 */
	public function getPercent():Number
	{
		return percent;
	}
	/**
	 * get target (movieclip)
	 * @return
	 */
	public function getTarget():MovieClip
	{
		return container;
	}
	public function show():Void
	{
		this.container._visible = true;
	}
	public function hide():Void
	{
		this.container._visible = false;
	}
	public function getURL():String {
		return $url;
	}
}