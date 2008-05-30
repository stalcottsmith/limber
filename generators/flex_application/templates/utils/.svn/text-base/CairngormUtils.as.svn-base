// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.util {
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.adobe.cairngorm.control.CairngormEventDispatcher;

    public class CairngormUtils {
        public static function dispatchEvent(
            eventName:String, data:Object = null):void
        {
            var event : CairngormEvent =
                new CairngormEvent(eventName);
            event.data = data;
            event.dispatch();
        }
    }
}
