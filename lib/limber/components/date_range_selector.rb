module Limber
  module Components
    class DateRangeSelector < FlexMxmlComponent
      
      def initialize(collection, *args)
        @collection = collection
        options = args[0] || {}
        @resource_scope = options[:scope] || "[]"
      end

      def custom_action_script
        return <<-END_AS
          import mx.collections.ArrayCollection;

          private function isLeapYear(date:Date):Boolean {
            var year:Number = date.getFullYear();
            return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0))
          }

          private function oneMonthBefore(date:Date):Date {
            var year:Number = date.getFullYear();
            var month:Number = date.getMonth();
            var day:Number = date.getDay();
            if(month == 0) {
              year = year-1;
              month = 12;
            } else {
              month = month - 1;
            }
            if(month == 1 && day > 28) {
              day = isLeapYear(date) ? 29 : 28;
            }
            return new Date(year, month, day)
          }

          private function beginningOfMonth(date:Date):Date {
            return new Date(date.getFullYear(), date.getMonth(), 1);
          }

          private var today:Date = new Date();
          private var oneDay:int = 1000*60*60*24;

          [Bindable]
          private var beginningOfThisMonth:Date = beginningOfMonth(today);
          [Bindable]
          private var beginningOfLastMonth:Date = beginningOfMonth(oneMonthBefore(today));

          private function dateRangeQueryParameters(pathParams:Array = null):Array {
            if(pathParams == null) pathParams = #{@resource_scope};
            pathParams.push({from:dateFormatter.format(fromDate.selectedDate)});
            pathParams.push({to:dateFormatter.format(toDate.selectedDate)});
            return pathParams;
          }
          
          private function buildUrlPath():String {
            var scope:Array = #{@resource_scope};
            if(scope.length == 0) {
              return '/#{@collection.to_s}.csv'
            } else {
              var nestedPath:String = '';
      				var queryParameters:String = '';
      				var action:String = '#{@collection.to_s}';
    					for each (var parameter:Object in scope) {
      					for (var nesting:String in parameter) {
      						switch(nesting) {
      							case 'page':
      							case 'filter':
      							case 'from':
      							case 'to':
      								//not happy with using query parameters for filtering
      								//it is not RESTful.  TODO: fix
      								if(queryParameters != '') { queryParameters += "&"; }
      								queryParameters += nesting+'='+parameter[nesting];
      								break;
      							default:
      								if(parameter[nesting] != null && parameter[nesting] != '') {
      									nestedPath += '/'+nesting+'/'+parameter[nesting];
      								}
      								break;
      						}
      					}
	            }
      				if(queryParameters != '') { 
      				  queryParameters = '?'+queryParameters; 
      				}
	            return nestedPath+"/"+action+".csv"+queryParameters;
            }
    			
          }

        END_AS
      end    
      
      def to_mxml
        date_formatter :format_string => "YYYY-MM-DD"

        h_box {
          label :text => "From:"
          date_field :fromDate, :selected_date => '{beginningOfLastMonth}',
                     :change => list_event(@collection, 'dateRangeQueryParameters()').dispatch
          label :text => "To:"
          date_field :toDate, :selected_date => '{beginningOfThisMonth}',
                     :change => list_event(@collection, 'dateRangeQueryParameters()').dispatch
        }
      end
    end
  end
end





