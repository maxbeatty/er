﻿/*
PureMVC AS2 Port by Pedr Browne <pedr.browne@puremvc.org>
PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
import org.puremvc.as2.core.*;
import org.puremvc.as2.interfaces.*;
import org.puremvc.as2.patterns.observer.Observer;

/**
 * A Singleton <code>IController</code> implementation.
 * 
 * <P>
 * In PureMVC, the <code>Controller</code> class follows the
 * 'Command and Controller' strategy, and assumes these 
 * responsibilities:
 * <UL>
 * <LI> Remembering which <code>ICommand</code>s 
 * are intended to handle which <code>INotifications</code>.</LI>
 * <LI> Registering itself as an <code>IObserver</code> with
 * the <code>View</code> for each <code>INotification</code> 
 * that it has an <code>ICommand</code> mapping for.</LI>
 * <LI> Executing a cached instance of the proper <code>ICommand</code>
 * to handle a given <code>INotification</code> when notified by the 
 * <code>View</code>.</LI>
 * <LI> Calling the <code>ICommand</code>'s <code>execute</code>
 * method, passing in the <code>INotification</code>.</LI> 
 * </UL>
 * 
 * <P>
 * Your application must register <code>ICommands</code> with the 
 * Controller.
 * <P>
 * The simplest way is to subclass </code>Facade</code>, 
 * and use its <code>initializeController</code> method to add your 
 * registrations. 
 * 
 * @see org.puremvc.as2.core.view.View View
 * @see org.puremvc.as2.patterns.observer.Observer Observer
 * @see org.puremvc.as2.patterns.observer.Notification Notification
 * @see org.puremvc.as2.patterns.command.SimpleCommand SimpleCommand
 * @see org.puremvc.as2.patterns.command.MacroCommand MacroCommand
 */
class org.puremvc.as2.core.Controller implements IController
{

    /**
     * Constructor. 
     * 
     * <P>
     * This <code>IController</code> implementation is a Singleton, 
     * so you should not call the constructor 
     * directly, but instead call the static Singleton 
     * Factory method <code>Controller.getInstance()</code>
     * 
     * @throws Error Error if Singleton instance has already been constructed
     * 
     */
    public function Controller( ) {
        if (instance != null) throw Error(SINGLETON_MSG);
        instance = this;
        commandMap = new Array();	
        initializeController();	
    }

    
    /**
     * Initialize the Singleton <code>Controller</code> instance.
     * 
     * <P>Called automatically by the constructor.</P> 
     * 
     * <P>Note that if you are using a subclass of <code>View</code>
     * in your application, you should <i>also</i> subclass <code>Controller</code>
     * and override the <code>initializeController</code> method in the 
     * following way:</P>
     * 
     * <listing>
     *		// ensure that the Controller is talking to my IView implementation
     *		override public function initializeController(  ) : Void 
     *		{
     *			view = MyView.getInstance();
     *		}
     * </listing>
     * 
     * @return Void
     */
    private function initializeController(  ): Void {
        view = View.getInstance();
    }

    
    /**
     * <code>Controller</code> Singleton Factory method.
     * 
     * @return the Singleton instance of <code>Controller</code>
     */
    public static function getInstance(): IController {
        if ( instance == null ) instance = new Controller();
        return instance;
    }

    
    /**
     * If an <code>ICommand</code> has previously been registered 
     * to handle a the given <code>INotification</code>, then it is executed.
     *
     * @param note an <code>INotification</code>
     */
    public function executeCommand( note: INotification ): Void {
        var commandClassRef: Function = commandMap[ note.getName() ];
        if ( commandClassRef == undefined || commandClassRef == null) return;
		
        var commandInstance: ICommand = new commandClassRef();
        commandInstance.execute(note);
    }

    
    /**
     * Register a particular <code>ICommand</code> class as the handler 
     * for a particular <code>INotification</code>.
     * 
     * <P>
     * If an <code>ICommand</code> has already been registered to 
     * handle <code>INotification</code>s with this name, it is no longer
     * used, the new <code>ICommand</code> is used instead.</P>
     *
     * The Observer for the new ICommand is only created if this the 
     * first time an ICommand has been regisered for this Notification name.
     * 
     * @param notificationName the name of the <code>INotification</code>
     * @param command the <code>ICommand</code>
     */
    public function registerCommand( notificationName: String, commandClassRef: Function): Void {
        if(commandMap[ notificationName ] == undefined || commandMap[ notificationName ] == null) {
            view.registerObserver(notificationName, new Observer(executeCommand, this));
        }
        commandMap[ notificationName ] = commandClassRef;
    }

    
    /**
     * Check if a Command is registered for a given Notification 
     * 
     * @param notificationName
     * @return whether a Command is currently registered for the given <code>notificationName</code>.
     */
    public function hasCommand( notificationName: String ): Boolean {
        return commandMap[ notificationName ] != null;
    }

    
    /**
     * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping.
     * 
     * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
     */
    public function removeCommand( notificationName: String ): Void {
		
        // if the Command is registered...
        if ( hasCommand(notificationName) ) {
            // remove the observer
            view.removeObserver(notificationName, this);
							
            // remove the command
            commandMap[ notificationName ] = null;
        }
    }

    // Local reference to View 
    private var view: IView;

    // Mapping of Notification names to Command Class references
    private var commandMap: Array;

    // Singleton instance
    private static var instance: IController;

    // Message Constants
    private var SINGLETON_MSG: String = "Controller Singleton already constructed!";
}