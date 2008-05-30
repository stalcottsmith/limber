#  Dummy Module - Really we are adding one method to ActionController
      
require 'fastercsv'
      
module ScaffoldLimberResource
  
  ActionController::Base.extend ClassMethods
  
  module ClassMethods
    HTML_FORMAT_NOT_SUPPORTED = 'scaffold_limber_resource: HTML format not supported.'


    def scaffold_limber_resource(model_id, options = {})
      options.assert_valid_keys(:class_name, :suffix, :per_page, :only,
                                :to_xml, :find, :paginate, :scope, 
                                :open_scope, :offset_scope, :offer_csv,
                                :csv_file_name)

      singular_name = model_id.to_s
      class_name    = options[:class_name] || singular_name.camelize
      per_page      = options[:per_page] || 20
      only_actions  = options[:only]
      plural_name   = singular_name.pluralize
      suffix        = options[:suffix] ? "_#{singular_name}" : ""
      paginate      = options[:paginate].nil? ? true : options[:paginate]
      find_opts     = options[:find]
      scope_values  = options[:scope].nil? ? nil : (options[:scope].is_a?(Array) ? options[:scope] : [options[:scope]])
      # kinda like an outer join... will include null values
      open_scope_values = options[:open_scope].nil? ? nil : (options[:open_scope].is_a?(Array) ? options[:open_scope] : [options[:open_scope]])
      offset_scope_values = options[:offset_scope].nil? ? nil : (options[:offset_scope].is_a?(Array) ? options[:offset_scope] : [options[:offset_scope]])
      to_xml_opts   = options[:to_xml] || {}
      to_xml_opts.merge!(:dasherize => false)
      model_class   = class_name.constantize
      to_xml_opts.merge!(:methods => model_class.methods_to_serialize.collect(&:name)) if model_class.respond_to?(:methods_to_serialize)
      to_xml_opts.merge!(:except => model_class.methods_to_hide.collect(&:name)) if model_class.respond_to?(:methods_to_hide)
      logger.info "to_xml_opts = "+to_xml_opts.inspect
      logger.info "only_actions = #{only_actions.inspect}"
      
      offer_csv     = options[:offer_csv] ? true : false
      

      find_method = paginate ? 'paginate' : 'find'
      pagination_params = paginate ? ", :page => params[:page], :per_page => #{per_page}" : ''
      pagination_params += ', '+find_opts.to_a.collect {|k,v| ":#{k} => '#{v}'" }.join(', ') if find_opts.is_a?(Hash)
      

      unless scope_values.nil?
        scope_values.each do |scope_value|
          module_eval <<-"end_eval", __FILE__, __LINE__
            around_filter do |controller, action|
              klass = #{class_name}
              unless controller.params['#{scope_value.to_s}'].nil?
                scope_conditions = {:#{scope_value} => controller.params['#{scope_value.to_s}']}
                klass.with_scope(:find => {:conditions => scope_conditions}, :create => scope_conditions) { action.call }
              else
                action.call
              end
            end
          end_eval
        end
      end
      
      unless open_scope_values.nil?
        open_scope_values.each do |open_scope_value|
          module_eval <<-"end_eval", __FILE__, __LINE__
            around_filter do |controller, action|
              klass = #{class_name}
              unless controller.params['#{open_scope_value.to_s}'].nil?
                scope_conditions = "(#{open_scope_value} = \#{controller.params[open_scope_value.to_s]} OR #{open_scope_value} IS NULL)"
                klass.with_scope(:find => {:conditions => scope_conditions}, :create => scope_conditions) { action.call }
              else
                action.call
              end
            end
          end_eval
        end
      end

      unless offset_scope_values.nil?
        offset_scope_values.each do |offset_scope_value|
          module_eval <<-"end_eval", __FILE__, __LINE__
            around_filter do |controller, action|
              logger.info "offset_scope_value: "+offset_scope_value.to_s
              klass = #{class_name}
              unless controller.params['#{offset_scope_value.to_s}'].nil?
                scope_conditions = "(id >= \#{controller.params[offset_scope_value.to_s]})"
                logger.info "using scope_conditions: "+scope_conditions
                klass.with_scope(:find => {:conditions => scope_conditions}, :create => scope_conditions) { action.call }
              else
                action.call
              end
            end
          end_eval
        end
      end

      if only_actions.nil? or only_actions.include?(:index)
        unless options[:suffix]
          module_eval <<-"end_eval", __FILE__, __LINE__
        
          def index
            @#{plural_name} = #{class_name}.#{find_method} :all#{pagination_params}
            to_xml_opts = #{to_xml_opts.inspect}
            respond_to do |format|
              format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
              format.xml  { render :xml => @#{plural_name}.to_xml(to_xml_opts) }
              format.csv  { stream_csv {|csv_stream| build_csv(csv_stream)} } if #{offer_csv}
            end
          end
          end_eval
        end
      end

      if only_actions.nil? or only_actions.include?("list#{suffix}".to_sym)
      
        module_eval <<-"end_eval", __FILE__, __LINE__
          def list#{suffix}
            @#{plural_name} = #{class_name}.#{find_method} :all#{pagination_params}
            to_xml_opts = #{to_xml_opts.inspect}
            respond_to do |format|
              format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
              format.xml  { render :xml => @#{plural_name}.to_xml(to_xml_opts) }
              format.csv  { stream_csv {|csv_stream| build_csv(csv_stream)} } if #{offer_csv}
            end
          end
        end_eval
      end
      
      if only_actions.nil? or only_actions.include?(:show)
        module_eval <<-"end_eval", __FILE__, __LINE__
          def show
            @#{singular_name} =  #{class_name}.find(params[:id])
            to_xml_opts = #{to_xml_opts.inspect}
            respond_to do |format|
              format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
              format.xml  { render :xml => @#{singular_name}.to_xml(to_xml_opts) }
            end
          end
        end_eval
      end
      
      if only_actions.nil? or only_actions.include?(:new)
        module_eval <<-"end_eval", __FILE__, __LINE__
          def new
            @#{singular_name} = #{class_name}.new
            to_xml_opts = #{to_xml_opts.inspect}
            respond_to do |format|
              format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
              format.xml  { render :xml => @#{singular_name}.to_xml(to_xml_opts) }
            end
          end
        end_eval
      end
      
      if only_actions.nil? or only_actions.include?(:destroy)
        module_eval <<-"end_eval", __FILE__, __LINE__
          def destroy
            @#{singular_name} = #{class_name}.find(params[:id])
            @#{singular_name}.destroy
        
            respond_to do |format|
              format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
              format.xml  { head :ok }
            end
          end
        end_eval
      end
      
      
        # NOTE: Due to the brokenness of IE6/7 with respect to the handling of 2XX HTTP
        # return codes, we have to return a 200 in order for Flex applications to inteperate
        # the result correctly.  This deviates from the RESTful ideal of close adherence
        # to the full HTTP spec.
        # Consider using: http://pubflex.googlecode.com/svn/trunk/src/main/flex/org/pubflex/SocketURLLoader.as
        # on the client.
        
      if only_actions.nil? or only_actions.include?(:create)
        module_eval <<-"end_eval", __FILE__, __LINE__
          def create
            @#{singular_name} = #{class_name}.new(params[:#{singular_name}])
      
            respond_to do |format|
              if @#{singular_name}.save
                format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
                # format.xml  { render :xml => @#{singular_name}, :status => :created, :location => @#{singular_name} }
                format.xml  { render :xml => @#{singular_name}, :status => 200, :location => @#{singular_name} }
              else
                format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
                format.xml  { render :xml => @#{singular_name}.errors, :status => :unprocessable_entity }
              end
            end
          end
        end_eval
      end
         
      if only_actions.nil? or only_actions.include?(:update)
        module_eval <<-"end_eval", __FILE__, __LINE__
          def update
            @#{singular_name} = #{class_name}.find(params[:id])
        
            respond_to do |format|
              if @#{singular_name}.update_attributes(params[:#{singular_name}].reject{|k,v| k.eql?('id')})
                format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
                format.xml  { head :ok }
              else
                format.html { render :text => HTML_FORMAT_NOT_SUPPORTED }
                format.xml  { render :xml => @#{singular_name}.errors, :status => :unprocessable_entity }
              end
            end
          end
        end_eval
      end

      module_eval <<-"end_eval", __FILE__, __LINE__
        
        private
          def build_csv(csv_stream)
            ignore_columns = #{class_name}.respond_to?(:methods_to_hide_from_csv) ? #{class_name}.methods_to_hide_from_csv : []
            columns = #{class_name}.columns.reject {|c| ignore_columns.collect(&:name).include?(c.name)}
            csv_stream << columns.collect {|c| c.name.titleize}
            @#{plural_name}.each do |#{singular_name}|
              csv_stream << columns.collect {|c| #{singular_name}.send(c.name)}
            end
          end
          
          def csv_file_name
            params[:action]
          end
        
          def stream_csv
             filename = csv_file_name + ".csv"

             #this is required if you want this to work with IE        
             if request.env['HTTP_USER_AGENT'] =~ /msie/i
               headers['Pragma'] = 'public'
               headers["Content-type"] = "text/plain" 
               headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
               headers['Content-Disposition'] = "attachment; filename=\"\#{filename}\"" 
               headers['Expires'] = "0" 
             else
               headers["Content-Type"] ||= 'text/csv'
               headers["Content-Disposition"] = "attachment; filename=\"\#{filename}\"" 
             end

            render :text => Proc.new { |response, output|
              csv = FasterCSV.new(output, :row_sep => "\r\n") 
              yield csv
            }
          end
        
      end_eval
    end
        
  end
end