<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<%-

PARENT_MODEL = [] # i.e. ['User', 'Category'] for user_category_examples_path(@user, @category)

local_class_name = local_class_name = class_name.split("::")[-1] # Non-Namespaced class name
var_name = file_name # Non-namespaced variable name
plural_var_name = var_name.pluralize # Pluralized non-namespaced variable name

orm_instance = Rails::Generators::ActiveModel.new var_name

# Determine namespcae prefix i.e awesome_
namespace_prefix = singular_table_name[0..-(file_name.length + 1)]

# Determine Parent Prefix i.e. user_company
parent_prefix = PARENT_MODEL.collect{ |x| x.underscore }.join('_')
parent_prefix = "#{parent_prefix}_" unless parent_prefix.blank?

# Route Prefix i.e. awesome_user_company
route_prefix = namespace_prefix + parent_prefix

parent_variables = PARENT_MODEL.collect { |x| "@#{x.underscore}" }.join(', ')

# Route Helpers
route_params_prefix = parent_variables.blank? ? "" : "#{parent_variables}, "
index_path_prefix = "#{route_prefix}#{plural_var_name}"
single_path_prefix = "#{route_prefix}#{var_name}"
controller_index_route = "#{index_path_prefix}_url(#{parent_variables})"

-%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
    <%- PARENT_MODEL.each_with_index do |model, model_index| -%>
  load_and_authorize_resource :<%= model.underscore %><% if model_index > 0 %> :through => :<%= PARENT_MODEL[model_index - 1].underscore %><% end %>
  <%- end -%>
  load_and_authorize_resource :<%= var_name%><% if PARENT_MODEL.any? %> :through => :<%= PARENT_MODEL.last.underscore %><% end %>

  # GET <%= route_url %>
  # GET <%= route_url %>.json
  def index
    # @<%= plural_var_name %> = <%= orm_class.all(local_class_name) %>

    respond_to do |format|
      format.html # index.html.erb
      format.json { render <%= key_value :json, "@#{plural_var_name}" %> }
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.json
  def show
    # @<%= var_name %> = <%= orm_class.find(local_class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.json { render <%= key_value :json, "@#{var_name}" %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.json
  def new
    # @<%= var_name %> = <%= orm_class.build(local_class_name) %>

    respond_to do |format|
      format.html # new.html.erb
      format.json { render <%= key_value :json, "@#{var_name}" %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    # @<%= var_name %> = <%= orm_class.find(local_class_name, "params[:id]") %>
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    # @<%= var_name %> = <%= orm_class.build(local_class_name, "params[:#{var_name}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to <%= "#{single_path_prefix}_path(#{route_params_prefix}@#{var_name})" %>, <%= key_value :notice, "'#{human_name} was successfully created.'" %> }
        format.json { render <%= key_value :json, "@#{var_name}" %>, <%= key_value :status, ':created' %>, <%= key_value :location, "#{single_path_prefix}_path(#{route_params_prefix}@#{var_name})" %> }
      else
        format.html { render <%= key_value :action, '"new"' %> }
        format.json { render <%= key_value :json, "@#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.json
  def update
    # @<%= var_name %> = <%= orm_class.find(local_class_name, "params[:id]") %>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{var_name}]") %>
        format.html { redirect_to <%= "#{single_path_prefix}_path(#{route_params_prefix}@#{var_name})" %>, <%= key_value :notice, "'#{human_name} was successfully updated.'" %> }
        format.json { head :no_content }
      else
        format.html { render <%= key_value :action, '"edit"' %> }
        format.json { render <%= key_value :json, "@#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    # @<%= var_name %> = <%= orm_class.find(local_class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%= controller_index_route %> }
      format.json { head :no_content }
    end
  end

  protected

  # Capture any access violations, ensure User isn't unnessisarily redirected to root
  rescue_from CanCan::AccessDenied do |exception|
    if params[:action] == 'index'
      redirect_to root_url, :alert => exception.message
    else
      redirect_to <%= controller_index_route %>, :alert => exception.message
    end
  end

end
<% end -%>
