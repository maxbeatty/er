import caurina.transitions.AuxFunctions;
import caurina.transitions.Tweener;
import com.shuhanarts.components.AbstractCategoriesUI;
import com.shuhanarts.model.CategoryVO;
import com.shuhanarts.components.GalleryBackgourndController
/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/

class com.shuhanarts.components.CategoriesUI extends AbstractCategoriesUI
{
	static private var CATEGORY_LABEL_LINK_ID:String = 'category_label';
	static private var MAX_PER_PAGE:Number = 5;
	//over and out text color
	private var overTextColor:Number = 0xffffff;
	private var outTextColor:Number = 0x333333;
	private var root:MovieClip;
	private var rootBG:MovieClip;
	//the border
	private var xyGap:Number = 10;
	private var maxHeight:Number;
	//
	private var labelsContainer:MovieClip;
	private var mask:MovieClip;
	//prev and next controller
	public var currentPage:Number = 1;
	public var totalPage:Number = 1;
	public var pnController:PrevAndNextController;
	private var nextbtn:Button;
	private var prevbtn:Button;
	/**
	 * Cons..
	 * @param	container
	 */
	public function CategoriesUI(container:MovieClip) 
	{
		super(container);
		//
		LogClear()
		StageController.getInstance().removeObjByName('CategoriesUI');
		StageController.getInstance().addObj(this, 'CategoriesUI');
		root = this.container._parent;
		rootBG = root.bg;
		mask = root.cmask;
		container.setMask(mask)
		nextbtn = root.nextbtn;
		prevbtn = root.prevbtn;
		root['categoriesUI'] = this;
		//
		nextbtn._visible = prevbtn._visible = false;
		resize();
	}
	public function initUI(data:Object):Void {
		super.initUI(data);
		MAX_PER_PAGE = _global.menumaxperpage;
		overTextColor = _global.textovercolor;
		outTextColor = _global.textnormalcolor;
		buildCategories();
		
		//change(0);
	}
	/**
	 * run the resize when stage resize.
	 */
	private function resize():Void {
		var size:Object = StageController.getInstance().getSize();
		var w:Number = size.w;
		var h:Number = size.h;
		root._x = w / 2
		root._y = h / 2;
	}
	
	private function buildCategories():Void {
		var cts:Array = data.categories.concat();
		var len:Number = cts.length;
		labelsContainer=container.createEmptyMovieClip('labelsContainer',10)
		for (var i:Number = 0; i < len;i++ ) {
			var label:MovieClip = labelsContainer.attachMovie(CATEGORY_LABEL_LINK_ID, CATEGORY_LABEL_LINK_ID + "_" + i, i);
			var lbg:MovieClip = label.bg;
			var line:MovieClip = label.line;
			if (((i+1)%MAX_PER_PAGE==0 || i==len-1) && i>0) {
				line._visible = false;
			}
			lbg._alpha = 0;
			var h:Number = label.bg._height;
			var c:CategoryVO = cts[i];
			label._y = h * i;
		    var text:TextField = label.labelTxt;
			text.text = c.name;
			lbg.onRollOver=Delegate.create(this,onOver,lbg)
			lbg.onRollOut = Delegate.create(this, onOut, lbg)
			Tweener.addTween(text, { _text_color:outTextColor } );
			lbg.onRelease = Delegate.create(this, select, i);
		}
		maxHeight = MAX_PER_PAGE * h;
		hide();
		bulidToolBar(len);
		if (_global.selectedindex>=0) {
			select(_global.selectedindex);
			return;
		}else {
			root.dataloading._visible = false;
		}
		bgFitSize()
	}
	private function bulidToolBar(len:Number,height:Number):Void {
		if (len<MAX_PER_PAGE) {
			return;
		}
		var maxDepth:Number = 1000;
		initPNController(len);
	}
	public function initPNController(len:Number):Void {
		totalPage = Math.ceil(len / MAX_PER_PAGE);
		pnController = new PrevAndNextController(currentPage, totalPage, prevbtn, nextbtn, null);
		pnController.setPageTextType('');
		pnController.setCurrentPage(currentPage, totalPage);
		pnController.addEventListener(PrevAndNextController.NEXT_EVENT, Delegate.create(this, next));
		pnController.addEventListener(PrevAndNextController.PREV_EVENT, Delegate.create(this, prev));
		pnController.hide();
		pnController.buttonType = PrevAndNextController.ALPHA_TYPE;
	}
	private function next(e:Object):Void {
		var cp:Number = e.currentPage-1;
		var y:Number = 0 - cp * maxHeight;
		currentPage = e.currentPage
		Tweener.addTween(labelsContainer, { _y:y, time:_global.menutweentime, transition:_global.menutweentype } );
		GalleryBackgourndController.getInstance().changePageButtonsUI(root, currentPage, totalPage);
	}
	private function prev(e:Object):Void {
		var cp:Number = e.currentPage-1;
		var y:Number = 0 - cp * maxHeight;
		currentPage = e.currentPage
		Tweener.addTween(labelsContainer, { _y:y, time:_global.menutweentime, transition:_global.menutweentype } );
		GalleryBackgourndController.getInstance().changePageButtonsUI(root, currentPage, totalPage);
	}
	/**
	 * background fit the size.
	 */
	public function bgFitSize():Void {
		var w:Number = container._width+2*xyGap;
		var h:Number = maxHeight + 2 * xyGap
		var f:Function = Delegate.create(this, bgFitSizeDone);
		//Tweener.addTween(rootBG, { _width:w, _height:h, time:_time, transition:_type, onComplete:f } );
		GalleryBackgourndController.getInstance().resetSize(root, w, h, f);
		//
		var x:Number = w / 2-xyGap;
		var y:Number = (maxHeight) /2;
		container._x = mask._x = -x;
		container._y = mask._y = -y;
		
		mask._width = w-xyGap*2;
		mask._height = h-xyGap*2;
	}
	/**
	 * button function
	 * @param	target
	 */
	private function onOver(target:MovieClip):Void {
		Tweener.addTween(target, { _alpha:100, time:_time, transition:'linear' } );
		Tweener.addTween(target._parent.labelTxt, { _text_color:overTextColor, time:_time, transition:'linear' } );
	}
	private function onOut(target:MovieClip):Void {
		Tweener.addTween(target, { _alpha:0, time:_time, transition:'linear' } );
		Tweener.addTween(target._parent.labelTxt, { _text_color:outTextColor, time:_time, transition:'linear' } );
	}
	/**
	 * fit the size complete
	 */
	private function bgFitSizeDone():Void {
		show();
		labelsContainer._alpha = 0;
		container._alpha = 100;
		unSelect()
		pnController.show();
		nextbtn._alpha = prevbtn._alpha = 0;
		Tweener.addTween(labelsContainer, { _alpha:100, time:_time, transition:'linear' } );
		Tweener.addTween(prevbtn, { _alpha:100, time:_time, transition:'linear' } );
		Tweener.addTween(nextbtn, { _alpha:100, time:_time, transition:'linear' } );
		GalleryBackgourndController.getInstance().changePageButtonsUI(root, currentPage, totalPage);
	}
	private function select(index:Number):Void {
		//change(index);
		
		container.onRelease = new Function();
		container.enabled = false;
		//var f:Function = Delegate.create(this, change, index);
		var f:Function = function() {
			root.dataloading._visible = true;
			change(index);
		}
		GalleryBackgourndController.getInstance().hidePageButtonsUI(root);
		Tweener.addTween(container, { _alpha:0, time:_time, transition:_type, onComplete:Delegate.create(this,f) } );
	}
	private function unSelect():Void {
		container.onRelease = null;
		delete container.onRelease;
	}
	private function change(index:Number):Void {
		super.change(index);
		hide();
	}
}