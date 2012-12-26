/**
* ...
* @author shuhan Kuang {shuhankuang[at]gmail.com}
*/
//interface..
interface IComponent {
	//
	public function addEventListener(p_event:String, p_obj:Object, p_function:String):Void;
	public function removeEventListener(p_event:String, p_obj:Object, p_function:String):Void;
	public function removeAllEventListeners(p_event:String):Void;
	public function dispatchEvent(p_eventObj:Object):Void;
	public function eventListenerExists(p_event:String, p_obj:Object, p_function:String):Boolean;
	//
	//public function getComponent():Component;
}