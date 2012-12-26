/**
* with in next and prev button, bottom description text..
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/
import caurina.transitions.Tweener
class PNSmartSizeImageLoader extends SmartSizeImageLoader
{
	static public var ON_CHANGE:String = "onchange";
	//
	private var nextAndPrevController:PrevAndNextController;
	private var currentIndex:Number = 1;
	private var total:Number = 1;
	private var images:Array;
	private var prevBtn:Button;
	private var nextBtn:Button

	/**
	 * Image loader with next and prev button..base on the image id..
	 */
	public function PNSmartSizeImageLoader(target:MovieClip,defalutSize:Vector) 
	{
		super(target, defalutSize);
		//
		prevBtn = target.prevbtn;
		nextBtn = target.nextbtn;
		setLoaderSize();
		smoothImage = false;
	}
	/**
	 * Must set all the images to the loader..
	 * @param	images
	 */
	public function setImages(images:Array):Void
	{
		this.images = images;
		total = this.images.length;
		nextAndPrevController = new PrevAndNextController(currentIndex, total, prevBtn, nextBtn);
		nextAndPrevController["buttonType"] = PrevAndNextController.VISIBLE_TYPE;
		nextAndPrevController['isFade'] = true;
		nextAndPrevController.addEventListener(PrevAndNextController.NEXT_EVENT, Delegate.create(this,nextImage));
		nextAndPrevController.addEventListener(PrevAndNextController.PREV_EVENT, Delegate.create(this,prevImage));
		nextAndPrevController.hide();
	}
	/**
	 * Load the image
	 * @param	image
	 */
	public function load(image:Image):Void
	{
		nextAndPrevController.hide();
		currentIndex = image.id;
		nextAndPrevController.setCurrentPage(currentIndex + 1);
		//trace("load Current Index = " + currentIndex);
        super.load(image);
	}
	/**
	 * next image
	 * @param	e
	 */
	private function nextImage(e:Object):Void
	{
		var totalPage:Number = e.totalPage;
		var currentPage:Number = e.currentPage;
		currentIndex = currentPage-1;
		//trace("load next Index = " + currentIndex);
		this.image= images[currentIndex];
		load(image);
		dispatchEvent({target:this,type:ON_CHANGE})
	}
	/**
	 * prev image
	 * @param	e
	 */
	private function prevImage(e:Object):Void
	{
		var totalPage:Number = e.totalPage;
		var currentPage:Number = e.currentPage;
		currentIndex = currentPage-1;
		//log.debug("load prev Index = "+currentIndex)
		this.image= images[currentIndex];
		load(image);
		dispatchEvent({target:this,type:ON_CHANGE})
		//trace("Prev Image   "+currentIndex)
	}
	/**
	 * prev and next controller
	 * @return
	 */
	public function getPrevAndNextController():PrevAndNextController
	{
		return nextAndPrevController;
	}
	/**
	 * fit the image size.
	 */
	public function fitSize():Void
	{
		setLoaderSize();
		Tweener.removeTweens(bg);
		var $time:Number = bgTweenTime
		var $type:String = bgTweenType;
		Tweener.addTween(bg, { _width:imageSize.x + 2 * XYGAP, time:$time, transition:$type, onUpdate:Delegate.create(this, resetUI) } );
		Tweener.addTween(bg, { _height:imageSize.y + 2 * XYGAP, time:$time, transition:$type , onComplete:Delegate.create(this, fadeIn) } );
		//super.fitSize();
	}
	/**
	 * set the target UI position
	 */
	private function setLoaderSize():Void
	{
		super.setLoaderSize();
		var w:Number = imageSize.x;
		var h:Number = imageSize.y;
		prevBtn._x = -w / 2;
		prevBtn._y = 0;
		nextBtn._x = w / 2;
		nextBtn._y = 0;
	}
	private function resetUI():Void
	{
		setLoaderSize();
	}
	/**
	 * on fade complete.
	 * @return void
	 */
	public function onFadeInComplete():Void {
		super.onFadeInComplete();
		//nextAndPrevController.setWHSize(30,imageSize.y)
		nextAndPrevController.show();
	}
	public function getCurrentIndex():Number
	{
		return currentIndex;
	}
}