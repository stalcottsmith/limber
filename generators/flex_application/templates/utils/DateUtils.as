package com.<%= file_name %>.util
{
  public class DateUtils
  {

    public static function toASDate(s:String):Date {
      //String in is format YYYY-MM-DD
      //extract YYYY, MM, DD and make an AS date with no time
      if (s != "" && s != null) {
        return new Date(parseInt(s.substr(0,4)), parseInt(s.substr(5,2)) - 1, parseInt(s.substr(8,2)));
      } else {
        return null;
      }
    }

    public static function toASDateTime(s:String):Date {
      //String in is format YYYY-MM-DD HH:MM:SS
      //extract YYYY, MM, DD HH MM SS and make an AS date
      if (s != "" && s != null) {
        return new Date(parseInt(s.substr(0,4)), parseInt(s.substr(5,2)) - 1, parseInt(s.substr(8,2)),
                        parseInt(s.substr(11,2)), parseInt(s.substr(14,2)), parseInt(s.substr(17,2)));
      } else {
        return null;
      }
    }
  }
}