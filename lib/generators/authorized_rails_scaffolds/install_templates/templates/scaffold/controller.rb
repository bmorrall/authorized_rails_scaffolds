<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<%-

#
# Available properties:
# 
#   class_name
#   controller_class_name
#   singular_table_name
#   file_name
#   human_name
#   orm_instance
#   route_url
#

t_helper = AuthorizedRailsScaffolds::RailsScaffoldControllerHelper.new(
  :class_name => class_name,
  :human_name => human_name,
  :controller_class_name => controller_class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name
)

resource_class = t_helper.resource_class # Non-Namespaced class name
resource_human_name = t_helper.resource_human_name
resource_symbol = t_helper.resource_symbol
resource_name = t_helper.resource_name
resource_array_name = t_helper.resource_array_name
resource_var = t_helper.resource_var
resource_array_var = t_helper.resource_array_var # Pluralized non-namespaced variable name

example_index_path = t_helper.example_index_path
example_show_path = t_helper.example_show_path

# Override default orm instance
orm_instance = Rails::Generators::ActiveModel.new resource_name

-%>
<% module_namespacing do -%>
class <%= t_helper.controller_class_name %> < <%= t_helper.application_controller_class %>
  <%- t_helper.parent_model_names.each_with_index do |model_name, model_index| -%>
  <%= t_helper.load_and_authorize_parent model_name %>
  <%- end -%>
  <%= t_helper.load_and_authorize_resource %>

  # GET <%= example_index_path %>
  # GET <%= example_index_path %>.json
  def index
    # <%= resource_array_var %> = <%= orm_class.all(resource_class) %>
    # <%= resource_array_var %> = <%= resource_array_var %>.page(params[:page] || 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render <%= key_value :json, "{ #{key_value(resource_array_name, resource_array_var)} }" %> }
    end
  end

  # GET <%= example_show_path %>
  # GET <%= example_show_path %>.json
  def show
    # <%= resource_var %> = <%= orm_class.find(resource_class, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.json { render <%= key_value :json, "{ #{key_value(resource_name, resource_var)} }" %> }
    end
  end

  # GET <%= example_index_path %>/new
  # GET <%= example_index_path %>/new.json
  def new
    # <%= resource_var %> = <%= orm_class.build(resource_class) %>

    respond_to do |format|
      format.html # new.html.erb
      format.json { render <%= key_value :json, "{ #{key_value(resource_name, resource_var)} }" %> }
    end
  end

  # GET <%= example_show_path %>/edit
  def edit
    # <%= resource_var %> = <%= orm_class.find(resource_class, "params[:id]") %>
  end

  # POST <%= example_index_path %>
  # POST <%= example_index_path %>.json
  def create
    # <%= resource_var %> = <%= orm_class.build(resource_class, "params[#{resource_symbol}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to <%= t_helper.controller_show_route(resource_var) %>, <%= key_value :notice, "'#{resource_human_name} was successfully created.'" %> }
        format.json { render <%= key_value :json, "{ #{key_value(resource_name, resource_var)} }" %>, <%= key_value :status, ':created' %>, <%= key_value :location, t_helper.controller_show_route(resource_var) %> }
      else
        format.html { render <%= key_value :action, '"new"' %> }
        format.json { render <%= key_value :json, "{ " + key_value('errors', "@#{orm_instance.errors}") + " }" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # PUT <%= example_show_path %>
  # PUT <%= example_show_path %>.json
  def update
    # <%= resource_var %> = <%= orm_class.find(resource_class, "params[:id]") %>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[#{resource_symbol}]") %>
        format.html { redirect_to <%= t_helper.controller_show_route resource_var %>, <%= key_value :notice, "'#{resource_human_name} was successfully updated.'" %> }
        format.json { head :no_content }
      else
        format.html { render <%= key_value :action, '"edit"' %> }
        format.json { render <%= key_value :json, "{ " + key_value('errors', "@#{orm_instance.errors}") + " }" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # DELETE <%= example_show_path %>
  # DELETE <%= example_show_path %>.json
  def destroy
    # <%= resource_var %> = <%= orm_class.find(resource_class, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%= t_helper.controller_index_route %>, <%= key_value :notice, "'#{resource_human_name} was successfully deleted.'" %> }
      format.json { head :no_content }
    end
  end

  protected

  # Capture any access violations, ensure User isn't unnessisarily redirected to root
  rescue_from CanCan::AccessDenied do |exception|
    if params[:action] == 'index'
      respond_to do |format|
        format.html { redirect_to root_url, :alert => exception.message }
        format.json { head :no_content, :status => :forbidden }
      end
    else
      respond_to do |format|
        format.html { redirect_to <%= t_helper.controller_index_route %>, :alert => exception.message }
        format.json { head :no_content, :status => :forbidden }
      end
    end
  end

end
<% end -%>
