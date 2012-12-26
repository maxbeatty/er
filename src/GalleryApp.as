import org.puremvc.as2.core.*;
import org.puremvc.as2.interfaces.*;
import org.puremvc.as2.patterns.observer.Notification;
import com.shuhanarts.controller.GalleryStartUPCommand;
import com.shuhanarts.controller.GalleryChangeCategoryCommand
/**
* ...
* @author Shuhan Kuang {shuhankuang[at]gmail.com}
*/
/**
* Test class for testing mtasc swf building in FlashDevelop.
* @mtasc -swf preview.swf  -main
*/
class GalleryApp
{
	//
	static public var START_UP:String = 'startup';
	//
	static public var CATEGORY_XML_FILE:String = 'category.xml';
	//category data event..
	static public var ON_CATEGORY_DATA_LOAD_START:String = 'oncategorydataloadstart';
	static public var ON_CATEGORY_DATA_LOAD_INIT:String = 'oncategorydataloadinit';
	//images data event
	static public var ON_IMAGES_DATA_LOAD_START:String = 'onimagesdataloadstart';
	static public var ON_IMAGES_DATA_LOAD_INIT:String = 'onimagesdataloadinit';
	//image load event
	static public var ON_IMAGE_LOAD_START:String = 'onimageloadstart';
	static public var ON_IMAGE_LOAD_INIT:String = 'onimageloadinit';
	//change category
	static public var ON_CHANGE_CATEGORY:String = 'onchangecategory';
	static public var ON_CHANGE_IMAGE:String = 'onchangeimage';
	//
	/**
	 * Facade Singleton Factory method
	 * 
	 * @return the Singleton instance of the Facade
	 */
	public static function getInstance() : GalleryApp {
		if (instance == null) instance = new GalleryApp( );
		return instance;
	}
	public function startUP(container:MovieClip,source:String):Void {
		initializeFacade();
		//
		removeCommand(START_UP);
		removeCommand(ON_CHANGE_CATEGORY)
		//
		registerCommand(START_UP, GalleryStartUPCommand);
		registerCommand(ON_CHANGE_CATEGORY, GalleryChangeCategoryCommand);
		CATEGORY_XML_FILE = source;
		sendNotification(START_UP, container);
	}
	///
	/////
	/**
	 * Initialize the Singleton <code>Facade</code> instance.
	 * 
	 * <P>
	 * Called automatically by the constructor. Override in your
	 * subclass to do any subclass specific initializations. Be
	 * sure to call <code>super.initializeFacade()</code>, though.</P>
	 */
	private function initializeFacade(  ) : Void {
		initializeModel();
		initializeController();
		initializeView();
	}
	/**
	 * Initialize the <code>Controller</code>.
	 * 
	 * <P>
	 * Called by the <code>initializeFacade</code> method.
	 * Override this method in your subclass of <code>Facade</code> 
	 * if one or both of the following are true:
	 * <UL>
	 * <LI> You wish to initialize a different <code>IController</code>.</LI>
	 * <LI> You have <code>Commands</code> to register with the <code>Controller</code> at startup.</code>. </LI>		  
	 * </UL>
	 * If you don't want to initialize a different <code>IController</code>, 
	 * call <code>super.initializeController()</code> at the beginning of your
	 * method, then register <code>Command</code>s.
	 * </P>
	 */
	private function initializeController( ) : Void {
		if ( controller != null ) return;
		controller = Controller.getInstance();
	}

	/**
	 * Initialize the <code>Model</code>.
	 * 
	 * <P>
	 * Called by the <code>initializeFacade</code> method.
	 * Override this method in your subclass of <code>Facade</code> 
	 * if one or both of the following are true:
	 * <UL>
	 * <LI> You wish to initialize a different <code>IModel</code>.</LI>
	 * <LI> You have <code>Proxy</code>s to register with the Model that do not 
	 * retrieve a reference to the Facade at construction time.</code></LI> 
	 * </UL>
	 * If you don't want to initialize a different <code>IModel</code>, 
	 * call <code>super.initializeModel()</code> at the beginning of your
	 * method, then register <code>Proxy</code>s.
	 * <P>
	 * Note: This method is <i>rarely</i> overridden; in practice you are more
	 * likely to use a <code>Command</code> to create and register <code>Proxy</code>s
	 * with the <code>Model</code>, since <code>Proxy</code>s with mutable data will likely
	 * need to send <code>INotification</code>s and thus will likely want to fetch a reference to 
	 * the <code>Facade</code> during their construction. 
	 * </P>
	 */
	private function initializeModel( ) : Void {
		if ( model != null ) return;
		model = Model.getInstance();
	}
	
	/**
	 * Initialize the <code>View</code>.
	 * 
	 * <P>
	 * Called by the <code>initializeFacade</code> method.
	 * Override this method in your subclass of <code>Facade</code> 
	 * if one or both of the following are true:
	 * <UL>
	 * <LI> You wish to initialize a different <code>IView</code>.</LI>
	 * <LI> You have <code>Observers</code> to register with the <code>View</code></LI>
	 * </UL>
	 * If you don't want to initialize a different <code>IView</code>, 
	 * call <code>super.initializeView()</code> at the beginning of your
	 * method, then register <code>IMediator</code> instances.
	 * <P>
	 * Note: This method is <i>rarely</i> overridden; in practice you are more
	 * likely to use a <code>Command</code> to create and register <code>Mediator</code>s
	 * with the <code>View</code>, since <code>IMediator</code> instances will need to send 
	 * <code>INotification</code>s and thus will likely want to fetch a reference 
	 * to the <code>Facade</code> during their construction. 
	 * </P>
	 */
	private function initializeView( ) : Void {
		if ( view != null ) return;
		view = View.getInstance();
	}

	/**
	 * Notify <code>Observer</code>s.
	 * 
	 * @param notification the <code>INotification</code> to have the <code>View</code> notify <code>Observers</code> of.
	 */
	public function notifyObservers ( notification:INotification ) : Void {
		if ( view != null ) view.notifyObservers( notification );
	}

	/**
	 * Register an <code>ICommand</code> with the <code>Controller</code> by Notification name.
	 * 
	 * @param notificationName the name of the <code>INotification</code> to associate the <code>ICommand</code> with
	 * @param commandClassRef the Class of the <code>ICommand</code>.
	 *
	 */
	public function registerCommand( notificationName:String, commandClassRef:Function ) : Void {
		controller.registerCommand( notificationName, commandClassRef);
	}

	/**
	 * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
	 * 
	 * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
	 */
	public function removeCommand( notificationName:String ):Void {
		controller.removeCommand( notificationName );
	}

	/**
	 * Check if a Command is registered for a given Notification 
	 * 
	 * @param notificationName
	 * @return whether a Command is currently registered for the given <code>notificationName</code>.
	 */
	public function hasCommand( notificationName:String ) : Boolean
	{
		return controller.hasCommand(notificationName);
	}
	
	/**
	 * Register an <code>IProxy</code> with the <code>Model</code> by name.
	 * 
	 * @param proxyName the name of the <code>IProxy</code>.
	 * @param proxy the <code>IProxy</code> instance to be registered with the <code>Model</code>.
	 */
	public function registerProxy ( proxy:IProxy ) : Void	{
		model.registerProxy ( proxy );	
	}
			
	/**
	 * Retrieve an <code>IProxy</code> from the <code>Model</code> by name.
	 * 
	 * @param proxyName the name of the proxy to be retrieved.
	 * @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
	 */
	public function retrieveProxy ( proxyName:String ):IProxy {
		return model.retrieveProxy ( proxyName );	
	}

	/**
	 * Remove an <code>IProxy</code> from the <code>Model</code> by name.
	 *
	 * @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
	 * @return the <code>IProxy</code> that was removed from the <code>Model</code>
	 */
	public function removeProxy ( proxyName:String ) : IProxy {
		var proxy:IProxy;
		if ( model != null ) proxy = model.removeProxy ( proxyName );	
		return proxy;
	}
	
	/**
	 * Check if a Proxy is registered
	 * 
	 * @param proxyName
	 * @return whether a Proxy is currently registered with the given <code>proxyName</code>.
	 */
	public function hasProxy( proxyName:String ) : Boolean
	{
		return model.hasProxy( proxyName );
	}


	/**
	 * Register a <code>IMediator</code> with the <code>View</code>.
	 * 
	 * @param mediatorName the name to associate with this <code>IMediator</code>
	 * @param mediator a reference to the <code>IMediator</code>
	 */
	public function registerMediator( mediator:IMediator ) : Void {
		if ( view != null ) view.registerMediator( mediator );
	}

	/**
	 * Retrieve an <code>IMediator</code> from the <code>View</code>.
	 * 
	 * @param mediatorName
	 * @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
	 */
	public function retrieveMediator( mediatorName:String ) : IMediator {
		return IMediator(view.retrieveMediator( mediatorName ));
	}

	/**
	 * Remove an <code>IMediator</code> from the <code>View</code>.
	 * 
	 * @param mediatorName name of the <code>IMediator</code> to be removed.
	 * @return the <code>IMediator</code> that was removed from the <code>View</code>
	 */
	public function removeMediator( mediatorName:String ) : IMediator {
		var mediator:IMediator;
		if ( view != null ) mediator = view.removeMediator( mediatorName );			
		return mediator;
	}

	/**
	 * Check if a Mediator is registered or not
	 * 
	 * @param mediatorName
	 * @return whether a Mediator is registered with the given <code>mediatorName</code>.
	 */
	public function hasMediator( mediatorName:String ) : Boolean
	{
		return view.hasMediator( mediatorName );
	}
	
	/**
	 * Create and send an <code>INotification</code>.
	 * 
	 * <P>
	 * Keeps us from having to construct new notification 
	 * instances in our implementation code.
	 * @param notificationName the name of the notiification to send
	 * @param body the body of the notification (optional)
	 * @param type the type of the notification (optional)
	 */ 
	public function sendNotification( notificationName:String, body:Object, type:String) : Void 
	{
		notifyObservers( new Notification( notificationName, body, type ) );
	}
	
	// Private references to Model, View and Controller
	private var controller : IController;
	private var model		 : IModel;
	private var view		 : IView;
	
	// The Singleton Facade instance.
	private static var instance : GalleryApp; 
	
	// Message Constants
	private var SINGLETON_MSG	: String = "GalleryApp Singleton already constructed!";
}