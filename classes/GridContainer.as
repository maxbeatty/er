/**
* ...
* @author ...
*/

class GridContainer extends Component
{
	private var container:MovieClip;
	/**
	 * Cons..
	 * @param	container
	 */
	public function GridContainer(container:MovieClip)
	{
		super();
		this.container = container;
	}
	/**
	 * attach item to a grid container...
	 * @param	link_id   item link id
	 * @param	total total of items
	 * @param	row  
	 * @param	col
	 * @param	width  grid width
	 * @param	height grid height
	 * @param	xgap x gap
	 * @param	ygap y gap
	 * @param	putAll put total item to the grid container..
	 * @return  array [MovieClip,MovieClip,MovieClip,....]
	 */ 
	public function attachItems(link_id:String,total:Number,row:Number,col:Number,width:Number,height:Number,xgap:Number,ygap:Number,putAll:Boolean,xOffset:Number,yOffset:Number):Array {
		removeAll();
		var items:Array = new Array();
		putAll = (putAll == undefined)?false:putAll;
		var max:Number = (putAll == true)?total:(row * col);
		max = (max > total)?total:max;
		xOffset = (xOffset == undefined)?0:xOffset;
		yOffset = (yOffset == undefined)?0:yOffset;
		//get the grid potitions.
		var pos:Array = GridLayOutManager.getPosition(max, row, width, height,xgap, ygap);
		//
		for (var i:Number = 0; i < max;i++ ) {
			var xyPos:Object = pos[i];
			var item:MovieClip=container.attachMovie(link_id, link_id + "_" + i, i);
			item._x = xyPos.x+xOffset;
			item._y = xyPos.y+yOffset;
			items.push(item);
		}
		return items;
	}
	/**
	 * remove all items in container..
	 * @return void
	 */
	private function removeAll():Void {
		for (var i in container) {
			var item:MovieClip = container[i];
			item._visible = false;
			item.removeMovieClip();
		}
	}
	/**
	 * Cons..
	 * @return
	 */
	public function getTarget():MovieClip {
		return container;
	}
	
}