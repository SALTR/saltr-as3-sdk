/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */
package saltr.utils.commands {

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

/**
 * @author asar
 */
public class CommandController {

    public static const EVENT_DONE:String = "done";
    protected var _commands:Vector.<ICommand>;

    public static const commonControllerId:String = "common";
    private static var controllers:Dictionary;

    {
        controllers = new Dictionary();
        controllers[commonControllerId] = new CommandController();
    }

    public static function getInstance():CommandController {
        return controllers[commonControllerId];
    }

    public static function getCustomController(id:String):CommandController {
        if (!controllers.hasOwnProperty(id)) {
            throw new Error("[CommandController] cannot find custom controller with id = " + id);
        }
        return controllers[id];
    }

    public static function registerCustomController(id:String):void {
        if (id == commonControllerId) {
            throw new Error("[CommandController registerCustomController] cannot use '" + id + "' as custom controller id");
        }
        controllers[id] = new CommandController();
    }

    public function CommandController() {
        _commands = new Vector.<ICommand>();
    }

    public function add(command:ICommand):void {
        _commands.push(command);
        if (_commands.length == 1) {
            EventDispatcher(command).addEventListener(EVENT_DONE, commandDoneHandler);
            command.execute();
        }
    }

    public function commandDoneHandler(event:Event = null):void {
        var command:ICommand = _commands[0];
        EventDispatcher(command).removeEventListener(EVENT_DONE, commandDoneHandler);
        _commands.removeAt(0);
        if (_commands.length > 0) {
            command = _commands[0];
            EventDispatcher(command).addEventListener(EVENT_DONE, commandDoneHandler);
            command.execute();
        }
    }
}
}
