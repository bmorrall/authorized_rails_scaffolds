<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<%- singular_var_name = file_name -%>
<%- plural_var_name = file_name.pluralize -%>
<%- local_class_name = class_name.split("::")[-1] -%>
<%- orm_instance = Rails::Generators::ActiveModel.new singular_var_name -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  load_and_authorize_resource

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
    # @<%= singular_var_name %> = <%= orm_class.find(local_class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.json { render <%= key_value :json, "@#{singular_var_name}" %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.json
  def new
    # @<%= singular_var_name %> = <%= orm_class.build(local_class_name) %>

    respond_to do |format|
      format.html # new.html.erb
      format.json { render <%= key_value :json, "@#{singular_var_name}" %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    # @<%= singular_var_name %> = <%= orm_class.find(local_class_name, "params[:id]") %>
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    # @<%= singular_var_name %> = <%= orm_class.build(local_class_name, "params[:#{singular_var_name}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to <%= singular_table_name %>_path(@<%= singular_var_name %>), <%= key_value :notice, "'#{human_name} was successfully created.'" %> }
        format.json { render <%= key_value :json, "@#{singular_var_name}" %>, <%= key_value :status, ':created' %>, <%= key_value :location, "#{singular_table_name}_path(@#{singular_var_name})" %> }
      else
        format.html { render <%= key_value :action, '"new"' %> }
        format.json { render <%= key_value :json, "@#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.json
  def update
    # @<%= singular_var_name %> = <%= orm_class.find(local_class_name, "params[:id]") %>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_var_name}]") %>
        format.html { redirect_to <%= singular_table_name %>_path(@<%= singular_var_name %>), <%= key_value :notice, "'#{human_name} was successfully updated.'" %> }
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
    # @<%= singular_var_name %> = <%= orm_class.find(local_class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url }
      format.json { head :no_content }
    end
  end

  protected

  # Capture any access violations, ensure User isn't unnessisarily redirected to root
  rescue_from CanCan::AccessDenied do |exception|
    if params[:action] == 'index'
      redirect_to root_url, :alert => exception.message
    else
      redirect_to <%= index_helper %>_url, :alert => exception.message
    end
  end

end
<% end -%>
