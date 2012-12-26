import com.shuhanarts.components.AbstractThumbnailsUI;
import com.shuhanarts.components.GalleryBackgourndController;
import osimageloader.UDMotionRecImageLoader;
/**
* ...
* @author ShuhanKuang {shuhankuang@gmail.com}
*/
import caurina.transitions.Tweener;
class com.shuhanarts.components.ThumbnailsUI extends AbstractThumbnailsUI
{
	static private var THUMBNAIL_LINK_ID:String = UDMotionRecImageLoader.LINK_ID;
	//
	private var defaultLayout:Vector;
	private var layout:Vector;
	private var thumbSize:Vector;
	private var xygap:Vector;
	private var root:MovieClip;
	private var rootBG:MovieClip;
	private var loaders:Array;
	private var stack:StackLoader;
	//pncontroller
	private var pnController:PrevAndNextController;
	private var currentPage:Number = 1;
	private var totalPage:Number = 1;
	private var prevbtn:Button;
	private var nextbtn:Button;
	private var closetn:Button;
	//
	private var overColor:Number = 0x3333333;
	private var outColor:Number = 0xffffff;
	//
	/**
	 * Cons..
	 * @param	container
	 */
	public function ThumbnailsUI(container:MovieClip) 
	{
		super(container);
		root = this.container._parent;
		root['thumbnailsUI'] = this;
		rootBG = root.bg;
		//
	    nextbtn = root.nextbtn;
		prevbtn = root.prevbtn;
		closetn = root.closebtn;
		//
		closetn._x = closetn._y = 0;
		nextbtn._visible = prevbtn._visible = false;
		closetn.onRelease = Delegate.create(this, close);
	}
	public function initUI(data:Object):Void {
		super.initUI(data);
		overColor = _global.thumbovercolor;
		outColor = _global.thumbnormalcolor;
		thumbSize = new Vector(_global.thumbsize.x, _global.thumbsize.y);
		xygap = new Vector(_global.thumbborder, _global.thumbborder);
		defaultLayout = new Vector(_global.thumbslayout.x, _global.thumbslayout.y);
		currentPage = 1;
		layout = defaultLayout.getClone();
		buildThumbsGrid();
		initThumbsPage();
		initPNController();
		root.dataloading._visible = false;
		//setSelectedIndex(0);
	}
	/**
	 * build the thumbnail grid container
	 * @return void
	 */
	private function buildThumbsGrid():Void {
		//var len:Number = images.length;
		if (loaders!=null) {
			return;
		}
		var c:MovieClip = container;
		var t:Number = layout.x * layout.y;
		var pos:Array = GridLayOutManager.getPosition(t, layout.x, thumbSize.x + xygap.x*2, thumbSize.y + xygap.y*2, 0, 0);
        loaders = new Array();
		UDMotionRecImageLoader.XYGAP = _global.thumbborder
		for (var i:Number = 0; i <t ; i++) 
		{
			var thumbMC:MovieClip = c.attachMovie(THUMBNAIL_LINK_ID, THUMBNAIL_LINK_ID + "_" + i, i);
			thumbMC._x = pos[i].x;
			thumbMC._y = pos[i].y;
			var loader:UDMotionRecImageLoader = new UDMotionRecImageLoader(thumbMC, thumbSize);
			loader.smoothImage = false;
			loaders.push(loader);
			loader.index = i;
			var image:Image = images[i];
			loader.setPressAbled(true);
			loader.addEventListener(UDMotionRecImageLoader.ON_ROLL_OVER,Delegate.create(this,onOver,loader.getTarget()))
			loader.addEventListener(UDMotionRecImageLoader.ON_ROLL_OUT,Delegate.create(this,onOut,loader.getTarget()))
			loader.addEventListener(UDMotionRecImageLoader.ON_SELECT, Delegate.create(this, setSelectedIndex,loader));
		}
		hide();
	}
	/**
	 * build the thumbnail grid container
	 * @return void
	 */
	private function initThumbsPage():Void {
		uploadAll()
		var pages:Array = getPages().concat();
		totalPage = pages.length;
		var cp:Array = pages[currentPage-1];
		var t:Number = cp[2]
		stack = new StackLoader();
		var _lt:Number = loaders.length;
		var _si:Number = (currentPage-1) *(layout.x*layout.y)
		layout = new Vector(cp[0], cp[1]);
		for (var i:Number = 0; i < _lt; i++) 
		{
			var loader:UDMotionRecImageLoader = UDMotionRecImageLoader(loaders[i]);
			loader.smoothImage = true;
			var index:Number = i + _si;
			var image:Image = images[index];
			var img:Image = new Image();
			img.imageurl = image.thumbnailurl;
			var bg:MovieClip = loader['bg'];
			setMovieClipColor(bg, outColor);
			loader.getMotionRectangle().resetColor(outColor)
			loader.index = index;
			if (i>=t) {
				loader.hide()
			}else {
				loader.show();
				stack.addLoader(loader, img);
			}
			loader.index = index;
			//loader.addEventListener(UDMotionRecImageLoader.ON_SELECT, Delegate.create(this,setSelectedIndex,index));
			
		}
		var f:Function = Delegate.create(this, bgFitSize);
		Tweener.addCaller(this, { onComplete:f, time:0.1,count:0} );
	}
	public function setSelectedIndex(loader:Object):Void {
		var index:Number = loader.index;
		var image:Image = images[index];
		var id:Number = image.id;
		//trace([index,id])
		dispatchEvent( { target:this, type:ON_CHANGE_IMAGE, index:id } );
	}
	private function initPNController(len:Number):Void {
		//totalPage = Math.ceil(len / MAX_PER_PAGE);
		pnController = new PrevAndNextController(currentPage, totalPage, prevbtn, nextbtn, null);
		pnController.setPageTextType('');
		pnController.setCurrentPage(currentPage, totalPage);
		pnController.addEventListener(PrevAndNextController.NEXT_EVENT, Delegate.create(this, next));
		pnController.addEventListener(PrevAndNextController.PREV_EVENT, Delegate.create(this, prev));
		pnController.hide();
		pnController.buttonType = PrevAndNextController.ALPHA_TYPE;
	}
	public function resize():Void {
		var size:Object = StageController.getInstance().getSize();
		var w:Number = size.w;
		var h:Number = size.h;
	}
	private function bgFitSize():Void {
		var w:Number = layout.x * (thumbSize.x + xygap.x*2)+xygap.x*2;
		var h:Number = layout.y * (thumbSize.y + xygap.y*2)+xygap.y*2;
		var f:Function = Delegate.create(this, bgFitSizeDone);
		if (w==rootBG._width && h==rootBG._height) {
			bgFitSizeDone();
			return
		}
		//Tweener.addTween(rootBG, { _width:w, _height:h, time:_time, transition:_type, onComplete:f } );
		GalleryBackgourndController.getInstance().resetSize(root, w, h, f);
	}
	/**
	 * fit the size complete
	 */
	private function bgFitSizeDone():Void {
		var w:Number = rootBG._width;
		var h:Number = rootBG._height;
		var x:Number = w / 2;
		var y:Number = h / 2;
		container._x = -x+xygap.x;
		container._y = -y+xygap.y;
		show();
		pnController.show()
		stack.loadStart();
		GalleryBackgourndController.getInstance().changePageButtonsUI(root, currentPage, totalPage,true);
	}
	/**
	 * get the pages number
	 * @return
	 */
	private function getPages():Array {
		var len:Number = images.length;
		var max:Number = defaultLayout.x * defaultLayout.y;
		var tp:Number = Math.ceil(len / max);
		if (tp>=1) {
			var ep:Number = tp - 1;
			var n:Number = len - (tp - 1) * max;
			var y:Number = Math.ceil(n / layout.x);
			var x:Number = (n > defaultLayout.x)?defaultLayout.x:n;
			var endP:Array = [x,y,n];
		}
		var pages:Array = [];
		for (var i:Number = 0; i <tp-1 ; i++) 
		{
			pages.push([defaultLayout.x, defaultLayout.y, max]);
		}
		pages.push(endP);
		return pages;
	}
	private function onOver(target:MovieClip):Void {
		var bg:MovieClip = target.bg;
		target.swapDepths(container.getNextHighestDepth());
		Tweener.addTween(bg, { _color:overColor, time:_time, transition:'linear' } );
	}
	private function onOut(target:MovieClip):Void {
		var bg:MovieClip = target.bg;
		Tweener.addTween(bg, { _color:outColor, time:_time, transition:'linear' } );
	}
	/**
	 * next page
	 * @param	e
	 */
	private function next(e:Object):Void {
		//var cp:Number = e.currentPage-1;
		//var y:Number = 0 - cp * maxHeight;
		currentPage = e.currentPage
		//Tweener.addTween(container,{_alpha:0,time:_time})
		hide()
		GalleryBackgourndController.getInstance().changePageButtonsUI(root, currentPage, totalPage,true);
		//Tweener.addCaller(this,{onComplete:initThumbsPage,time:0.8,count:0})
		initThumbsPage();
	}
	/**
	 * next prev
	 * @param	e
	 */
	private function prev(e:Object):Void {
		//var cp:Number = e.currentPage-1;
		//var y:Number = 0 - cp * maxHeight;
		currentPage = e.currentPage
		initThumbsPage();
		hide()
		GalleryBackgourndController.getInstance().changePageButtonsUI(root, currentPage, totalPage,true);
		//Tweener.addCaller(this,{onComplete:initThumbsPage,time:0.8,count:0})
	}
	private function uploadAll():Void {
		for (var i in loaders) {
			var loader:UDMotionRecImageLoader = UDMotionRecImageLoader(loaders[i]);
			//loader.removeEventListener(UDMotionRecImageLoader.ON_SELECT, this, 'setSelectedIndex');
			loader.removeEventListener(UDMotionRecImageLoader.ON_ROLL_OVER,Delegate.create(this,onOver,loader.getTarget()))
			loader.removeEventListener(UDMotionRecImageLoader.ON_ROLL_OUT,Delegate.create(this,onOut,loader.getTarget()))
			loader.removeEventListener(UDMotionRecImageLoader.ON_SELECT, Delegate.create(this, setSelectedIndex,loader));
			loader.unLoad()
		}
		stack.clear();
	}
	/**
	 * back to categories UI
	 */
	private function close():Void {
		uploadAll();
		//removeAllChildren(container);
		hide();
		GalleryBackgourndController.getInstance().hideCloseBtn(root);
		
	}
}