/**
* prev and next controller , easy to use
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/
import caurina.transitions.Tweener;
class PrevAndNextController extends Component
{
	//Event.
	static private var NAME:String = "PrevAndNextController";
	static public var NEXT_EVENT:String = "next_event";
	static public var PREV_EVENT:String = "prev_event";
	static public var ON_CHANGE:String = 'onchange';
	static public var ALPHA_TYPE:String = "alpha_type";
	static public var VISIBLE_TYPE:String = "visible_type";
	static public var IS_FIRST_PAGE:String = 'is_first_page'
	static public var IS_END_PAGE:String='is_end_page'
	static public var ENABLED_ALPHA:Number = 50;
	static public var MAX_ALPHA:Number = 100;
	//UI..
	private var prevBtn:Button;
	private var nextBtn:Button;
	//text field to show the page..
	private var pageText:TextField;
	//total page
	private var totalPage:Number = 1;
	//current page..
	private var currentPage:Number = 1;
	private var beShow:Boolean = true;
	private var pageDis:Number = 1;
	public var buttonType:String = VISIBLE_TYPE;
	private var _time:Number = 0.3;
	private var _type:String = "linear";
	private var isFade:Boolean = false;
	//
	private var pageTextType:String='page:'
	/**
	 * Cons..
	 * @param	currentPage
	 * @param	totalPage
	 * @param	prevButton
	 * @param	nextButton
	 * @param	pageText
	 */
	public function PrevAndNextController(currentPage:Number,totalPage:Number,prevButton:Button,nextButton:Button,pageText:TextField) 
	{
		this.totalPage = totalPage;
		this.currentPage = currentPage;
		prevBtn = prevButton;
		nextBtn = nextButton;
		this.pageText = pageText;
		//
		//trace([this.prevBtn,this.nextBtn])
		init();
		//
		prevBtn.onRelease = Delegate.create(this, prev,currentPage,totalPage);
		nextBtn.onRelease = Delegate.create(this, next,currentPage,totalPage);
		//
	}
	private function init():Void
	{
		changeState();
	}
	/**
	 * change page txt
	 */
	private function changePageText():Void
	{
		var s:String = pageTextType+currentPage + "/" + totalPage;
		if (totalPage==1)
		{
			s = "";
		}
		pageText.text = s;
	}
	/**
	 * change State  , when you press prev or next button
	 * @return void
	 */
	public function changeState():Void
	{
		//log.debug(currentPage+","+totalPage);
		//log.debug(buttonType)
		Tweener.removeTweens(prevBtn);
		Tweener.removeTweens(nextBtn);
		if (buttonType==VISIBLE_TYPE)
		{
			changeVisibleState();
		}else
		{
			changeAlphaState();
		}
		//log.debug([currentPage,totalPage])
	}
	/**
	 * Show buttons or not base on current page..
	 * @return void
	 */
	public function changeVisibleState():Void
	{
		if (beShow==false)
		{
			return;
		}
		prevBtn._visible = true;
		nextBtn._visible = true;
		prevBtn.enabled = true;
		nextBtn.enabled = true;
		prevBtn.useHandCursor = true;
		nextBtn.useHandCursor = true;
		changePageText();
		//
		if(totalPage == 1) {
			prevBtn._visible = false;
			nextBtn._visible = false;
			return;
		}
		if(currentPage == 1) {
			prevBtn._visible = false;
		}
		if(currentPage > 1) {
			prevBtn._visible = true;
		}
		if(currentPage >= totalPage) {
			nextBtn._visible = false;
		}
	}
	/**
	 * change alpha state
	 */
	public function changeAlphaState():Void
	{
		if (beShow==false)
		{
			return;
		}
		prevBtn._visible = true;
		nextBtn._visible = true;
		prevBtn.enabled = true;
		nextBtn.enabled = true;
		prevBtn.useHandCursor = true;
		nextBtn.useHandCursor = true;
		prevBtn._alpha = MAX_ALPHA;
		nextBtn._alpha = MAX_ALPHA;
		changePageText();
		//log.debug("currentPage=" + currentPage + ",totalPage=" + totalPage);
		//
		if(totalPage == 1) {
			prevBtn._visible = false;
			nextBtn._visible = false;
			return;
		}
		if(currentPage == 1) {
			//prevBtn._visible = false;
			prevBtn.enabled = false;
			prevBtn.useHandCursor = false;
			prevBtn._alpha = ENABLED_ALPHA;
		}
		if(currentPage > 1) {
			//prevBtn._visible = true;
			prevBtn._alpha = MAX_ALPHA;
			prevBtn.enabled = true;
			
		}
		if(currentPage >= totalPage) {
			//nextBtn._visible = false;
			nextBtn.enabled = false;
			nextBtn.useHandCursor = false;
			nextBtn._alpha = ENABLED_ALPHA;
		}
	}
	/**
	 * press next
	 * @return void
	 */
	public function next():Void
	{
		if (currentPage>=totalPage)
		{
			dispatchEvent({type:IS_END_PAGE, target:this,currentPage:currentPage,prevPage:prevPage, totalPage:totalPage});
			return;
		}
		var prevPage:Number = currentPage;
		currentPage++;
		changeState();
		//change , send the value to listeners..(currentPage , totalPage)
		dispatchEvent({type:NEXT_EVENT, target:this,currentPage:currentPage,prevPage:prevPage,totalPage:totalPage});
	}
	/**
	 * press prev
	 * @return void
	 */
	public function prev():Void
	{
		if (currentPage<=1)
		{
			dispatchEvent({type:IS_FIRST_PAGE, target:this,currentPage:currentPage,prevPage:prevPage, totalPage:totalPage});
			return;
		}
		var prevPage:Number = currentPage;
		currentPage--;
		changeState();
		//change , send the value to listeners..(currentPage , totalPage)
		dispatchEvent({type:PREV_EVENT, target:this,currentPage:currentPage,prevPage:prevPage, totalPage:totalPage});
	}
	public function changeEnabled():Void
	{
		//
	}
	/**
	 * show the controller
	 * @return void
	 */
	public function show():Void
	{
		beShow = true;
		changeState();
		changePageText();
		fadeIn();
	}
	/**
	 * hide the controller
	 * @return void
	 */
	public function hide():Void
	{
		beShow = false;
		nextBtn._visible = false;
		prevBtn._visible = false;
		pageText.text = '';
	}
	/**
	 * set current page
	 * @param	cPage
	 * @param	tPage
	 */
	public function setCurrentPage(cPage:Number,tPage:Number):Void
	{
		currentPage = cPage;
		totalPage = (tPage == undefined)?this.totalPage:tPage;
		changeState();
		dispatchEvent({type:ON_CHANGE, target:this,currentPage:currentPage, totalPage:totalPage});
	}
	/**
	 * set the prev and next button size
	 * @param	w
	 * @param	h
	 */
	public function setWHSize(w:Number,h:Number):Void
	{
		prevBtn._width = w;
		nextBtn._width = w;
		prevBtn._height = h;
		nextBtn._height = h;
	}
	/**
	 * Only work with visible type..
	 */
	private function fadeIn():Void
	{
		//log.debug("fadein")
		if (isFade==false || buttonType!=VISIBLE_TYPE)
		{
			return;
		}
		if (prevBtn._visible==true)
		{
			prevBtn._alpha = 0;
			Tweener.addTween(prevBtn,{_autoAlpha:MAX_ALPHA,time:_time,transition:_type})
		}
		if (nextBtn._visible==true)
		{
			nextBtn._alpha = 0;
			Tweener.addTween(nextBtn,{_autoAlpha:MAX_ALPHA,time:_time,transition:_type})
		}
	}
	private function fadeOut():Void
	{
		//
	}
	/**
	 * set button enabled
	 * @param	b
	 */
	public function setEnabled(b:Boolean):Void {
		if(b==false){
			prevBtn.enabled = b;
			nextBtn.enabled = b;
		}
		if (b==false) {
			changeState();
		}
	}
	/**
	 * set the page txt type (Page:1/2  or Index: 1/2 , and so on)
	 * @param	s
	 */
	public function setPageTextType(s:String):Void {
		pageTextType = s;
		changePageText();
	}
	/**
	 * get current page
	 * @return
	 */
	public function getCurrentPage():Number {
		return currentPage;
	}
	public function getTotalPage():Number {
		return totalPage;
	}
}