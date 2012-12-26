/**
* Use in a flash gallery , some normal value
* @author shuhankuang[at]gmail.com
*/

class Category {
	//some data for gallery..
	//name
	public var name:String = "category";
	//category description
	public var description:String = "description.";
	//long description for the category
	public var fullDescription:String = "category fulldescription."
	//total number of the category.
    public var totalFile:Number = 20;
	//images in the cagegory
	public var images:Array;
	/**
	 * cons..
	 */
	public function Category() {
		images = new Array();
	}
	
}