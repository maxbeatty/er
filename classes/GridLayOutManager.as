/**
* gird layout manager , easy to use
* @author shuhankuang[at]gmail.com
*/

class GridLayOutManager {
	//
	static public var NAME:String = "GirdLayOutManager";
	//
	public function GridLayOutManager() {
		//
	}
	/**
	 * get the positions in the gird
	 * @param	total total item
	 * @param	row  row
	 * @param	width  item width
	 * @param	height item height
	 * @param	xgap  xgap
	 * @param	ygap ygap
	 * @return  Array
	 */
	static public function getPosition(total:Number, row:Number, width:Number, height:Number,xgap:Number,ygap:Number):Array {
		//defined the item per row..
		var r:Number = row;
		//image size..
		var imageSize:Vector = new Vector(width, height);
		var index:Number = 0;
		var rr:Number = 0;
		//
		var w:Number = imageSize.x+xgap
		var h:Number = imageSize.y+ygap;
		//
		var position:Array = new Array();
		//
		while (index < total) {
			if (index % r == 0 && index > 0) {
				rr++;
			}
			var __x:Number = w*(index%r);
			var __y:Number = rr*h;
			var pos:Object = { x:__x, y:__y }
			position.push(pos);
			index++;
		}
		rr = 0;
		return position;
	}
}