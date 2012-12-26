/**
 * ...
 * @author Shuhan Kuang
 * @email shuhankuang@gmail.com
 */
import caurina.transitions.Tweener;
import com.shuhanarts.components.CategoriesUI;
import com.shuhanarts.components.ThumbnailsUI;
class com.shuhanarts.components.GalleryBackgourndController extends Component
{
	static private var instance:GalleryBackgourndController;
	/**
	 * cons..
	 */
	private function GalleryBackgourndController()
	{
		super();
		_time = _global.buttontweentime
		_type = _global.buttontweentype;
	}
	static public function getInstance():GalleryBackgourndController {
		if (instance==null) {
			instance = new GalleryBackgourndController();
		}
		return instance;
	}
	public function resetSize(root:MovieClip, w:Number, h:Number, cf:Function):Void {
		
		var bg:MovieClip = root.bg;
		var prevbtn:Button = root.prevbtn;
		var nextbtn:Button = root.nextbtn;
		var closebtn:Button = root.closebtn;
		var update:Function = Delegate.create(this, resetBTNSPosition,root);
		Tweener.addTween(bg, { _width:w, _height:h, time:_global.bgtweentime, transition:_global.bgtweentype, onComplete:cf} );
	}
	private function resetBTNSPosition(root:MovieClip):Void {
		var bg:MovieClip = root.bg;
		var prevbtn:Button = root.prevbtn;
		var nextbtn:Button = root.nextbtn;
		var closebtn:Button = root.closebtn;
		//var x = int(bg._width / 2);
		//prevbtn._x = -x - gap;
		//nextbtn._x = x + gap;
	}
	private function endPageUI(root:MovieClip):Void {
		var bg:MovieClip = root.bg;
		var prevbtn:Button = root.prevbtn;
		var nextbtn:Button = root.nextbtn;
		Tweener.addTween(nextbtn, { _x:0, time:_time, transition:_type } );
	}
	private function firstPageUI(root:MovieClip):Void {
		var bg:MovieClip = root.bg;
		var prevbtn:Button = root.prevbtn;
		var nextbtn:Button = root.nextbtn;
		Tweener.addTween(prevbtn, { _x:0, time:_time, transition:_type } );
	}
	public function changePageButtonsUI(root:MovieClip,currentPage:Number,totalPage:Number,showClose:Boolean):Void {
		
		var bg:MovieClip = root.bg;
		var prevbtn:Button = root.prevbtn;
		var nextbtn:Button = root.nextbtn;
		var closebtn:Button = root.closebtn;
		closebtn._alpha = 100;
		var gap:Number = 16;
		var x = int(bg._width / 2);
		var y = int(bg._height / 2);
		if (showClose == true) {
			closebtn._visible = true;
			Tweener.addTween(closebtn, { _y:y+gap , time:_time, transition:_type } );
		}else {
			//closebtn._visible=false
		}
		
		if (totalPage==1) {
			prevbtn._x = nextbtn._x = 0;
			return;
		}
       
		Tweener.addTween(prevbtn, { _x:-x - gap, time:_time, transition:_type } );
		Tweener.addTween(nextbtn, { _x:x + gap, time:_time, transition:_type } );
		if (currentPage == 1) {
			Tweener.removeTweens(prevbtn);
			firstPageUI(root);
		}
		if (currentPage == totalPage) {
			Tweener.removeTweens(nextbtn);
			endPageUI(root);
		}
		
		//trace('-->'+[currentPage,totalPage])
	}
	public function hidePageButtonsUI(root:MovieClip,cf:Function):Void {
		var bg:MovieClip = root.bg;
		var prevbtn:Button = root.prevbtn;
		var nextbtn:Button = root.nextbtn;
		Tweener.addTween(prevbtn, { _x:0, time:_time, transition:_type } );
		Tweener.addTween(nextbtn, { _x:0, time:_time, transition:_type } );
	}
	public function showCloseBtn(root:MovieClip):Void {
		var bg:MovieClip = root.bg;
		var prevbtn:Button = root.prevbtn;
		var nextbtn:Button = root.nextbtn;
		var closebtn:Button = root.closebtn;
		var x = int(bg._width / 2);
		var y = int(bg._height / 2);
		//if (showClose == true) {
			//closebtn._visible = true;
			//Tweener.addTween(closebtn, { _y:y , time:_time, transition:_type } );
		//}else {
			//closebtn._visible=false
		//}
	}
	public function hideCloseBtn(root:MovieClip):Void {
		var categoriesUI:CategoriesUI = root['categoriesUI'];
		var thumbnailsUI:ThumbnailsUI = root['thumbnailsUI'];
		var bg:MovieClip = root.bg;
		var prevbtn:Button = root.prevbtn;
		var nextbtn:Button = root.nextbtn;
		var closebtn:Button = root.closebtn;
		var x = int(bg._width / 2);
		var y = int(bg._height / 2);
		closebtn._alpha = PrevAndNextController.ENABLED_ALPHA;
		Tweener.addTween(closebtn, { _y:0 , time:_time, transition:_type } );
		categoriesUI.bgFitSize();
		categoriesUI.initPNController(categoriesUI.data.categories.length);
		hidePageButtonsUI()
	}
}