/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/

class Image {
	//file types..
	static public var FLV:String = 'flv';
	static public var PIC:String = 'pic';
	static public var SWF:String = 'swf';
	//some value..
	public var id:Number = -1;
	//image name
	public var name:String = "default"
	//image description
	public var description:String = "<font color='#cc3399'>description</font>";
	//image url
	public var imageurl:String = "default.jpg";
	//thumbnail url
	public var thumbnailurl:String="default.jpg"
	//file type.
	public var fileType:String = PIC;
	//image link
	public var link:Link;
	//
	public var size:Vector;
	/**
	 * Cons..
	 * use in image imageloader
	 */
	public function Image() {
		link = new Link();
		//fileType = [FLV, PIC, SWF][random(3)];
	}
}