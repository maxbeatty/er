/**
* Link
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/

class Link 
{
	//window target..
	static public var BLANK:String = "_blank";
	static public var TOP:String = "_top";
	static public var PARENT:String = "_parent";
	static public var SELF:String = "_self";
	//url and target
	public var url:String = "";
	public var target:String = "";
	//
	public function Link() 
	{
		//
	}
	public function toString():String
	{
	    return "url : " + url + ",target : " + target;
	}
	
}