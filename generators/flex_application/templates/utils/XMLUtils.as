// This file generated on <%= Date.today %>, by <%= ENV['USER'] %>
// using the Limber plugin via: script/generate flex_application 
package com.<%= file_name %>.util {      
    public class XMLUtils {
        /**
         * Return true if the toString() is "true", false
         * otherwise. This is necessary since Boolean("false")
         * is true.
         */
        public static function xmlListToBoolean(
        xmlList:XMLList):Boolean {
            return xmlList.toString() == "true";
        }
    }
}