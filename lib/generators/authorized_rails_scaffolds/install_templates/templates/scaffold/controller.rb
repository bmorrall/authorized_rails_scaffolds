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
#   orm_instance
#   route_url
#

t_helper = AuthorizedRailsScaffolds::RailsScaffoldControllerHelper.new(
  :class_name => class_name,
  :controller_class_name => controller_class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name
)

resource_class = t_helper.resource_class # Non-Namespaced class name
resource_symbol = t_helper.resource_symbol
resource_table_name = t_helper.resource_table_name
resource_var = t_helper.resource_var
resources_var = t_helper.resources_var # Pluralized non-namespaced variable name

example_controller_path = t_helper.example_controller_path

# Override default orm instance
orm_instance = Rails::Generators::ActiveModel.new resource_table_name

-%>
<% module_namespacing do -%>
class <%= t_helper.controller_class_name %> < <%= t_helper.application_controller_class %>
  <%- AuthorizedRailsScaffolds.config.parent_models.each_with_index do |model, model_index| -%>
  load_and_authorize_resource :<%= model.underscore %><% if model_index > 0 %>, :through => :<%= AuthorizedRailsScaffolds.config.parent_models[model_index - 1].underscore %><% end %>
  <%- end -%>
  load_and_authorize_resource :<%= t_helper.resource_table_name %><% if t_helper.parent_models.any? %>, :through => :<%= t_helper.parent_models.last.underscore %><% end %>

  # before_filter do
<%- t_helper.parent_model_tables.each do |model| -%>
  #   <%% if <%= t_helper.parent_variable(model) %> %>
  #     add_breadcrumb <%= t_helper.parent_sym(model) %>, <%= t_helper.reference_index_path(model) %>
  #     add_breadcrumb <%= t_helper.parent_variable(model) %>.to_s, <%= t_helper.reference_path(model) %>
  #   <%% end %>
<%- end -%>
  #   add_breadcrumb :index, <%= t_helper.controller_index_path %>
  # end

  # GET <%= example_controller_path %>
  # GET <%= example_controller_path %>.json
  def index
    # <%= resources_var %> = <%= orm_class.all(resource_class) %>
    # <%= resources_var %> = <%= resources_var %>.page(params[:page] || 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render <%= key_value :json, resources_var %> }
    end
  end

  # GET <%= example_controller_path %>/1
  # GET <%= example_controller_path %>/1.json
  def show
    # <%= resource_var %> = <%= orm_class.find(resource_class, "params[:id]") %>
    # add_breadcrumb <%= resource_var %>.to_s, <%= t_helper.controller_show_route resource_var %>

    respond_to do |format|
      format.html # show.html.erb
      format.json { render <%= key_value :json, resource_var %> }
    end
  end

  # GET <%= example_controller_path %>/new
  # GET <%= example_controller_path %>/new.json
  def new
    # <%= resource_var %> = <%= orm_class.build(resource_class) %>
    # add_breadcrumb :new, new_<%= t_helper.controller_show_route %>

    respond_to do |format|
      format.html # new.html.erb
      format.json { render <%= key_value :json, resource_table_name %> }
    end
  end

  # GET <%= example_controller_path %>/1/edit
  def edit
    # <%= resource_var %> = <%= orm_class.find(resource_class, "params[:id]") %>
    # add_breadcrumb <%= resource_var %>.to_s, <%= t_helper.controller_show_route resource_var %>
    # add_breadcrumb :edit, edit_<%= t_helper.controller_show_route resource_var %>
  end

  # POST <%= example_controller_path %>
  # POST <%= example_controller_path %>.json
  def create
    # <%= resource_var %> = <%= orm_class.build(resource_class, "params[#{resource_symbol}]") %>
    # add_breadcrumb :new, new_<%= t_helper.controller_show_route %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to <%= t_helper.controller_show_route(resource_var) %>, <%= key_value :notice, "'#{human_name} was successfully created.'" %> }
        format.json { render <%= key_value :json, resource_var %>, <%= key_value :status, ':created' %>, <%= key_value :location, t_helper.controller_show_route(resource_var) %> }
      else
        format.html { render <%= key_value :action, '"new"' %> }
        format.json { render <%= key_value :json, "@#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # PUT <%= example_controller_path %>/1
  # PUT <%= example_controller_path %>/1.json
  def update
    # <%= resource_var %> = <%= orm_class.find(resource_class, "params[:id]") %>
    # add_breadcrumb <%= resource_var %>.to_s, <%= t_helper.controller_show_route resource_var %>
    # add_breadcrumb :edit, edit_<%= t_helper.controller_show_route resource_var %>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[#{resource_symbol}]") %>
        format.html { redirect_to <%= t_helper.controller_show_route resource_var %>, <%= key_value :notice, "'#{human_name} was successfully updated.'" %> }
        format.json { head :no_content }
      else
        format.html { render <%= key_value :action, '"edit"' %> }
        format.json { render <%= key_value :json, "@#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # DELETE <%= example_controller_path %>/1
  # DELETE <%= example_controller_path %>/1.json
  def destroy
    # <%= resource_var %> = <%= orm_class.find(resource_class, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%= t_helper.controller_index_route %> }
      format.json { head :no_content }
    end
  end

  protected

  # Capture any access violations, ensure User isn't unnessisarily redirected to root
  rescue_from CanCan::AccessDenied do |exception|
    if params[:action] == 'index'
      redirect_to root_url, :alert => exception.message
    else
      redirect_to <%= t_helper.controller_index_route %>, :alert => exception.message
    end
  end

end
<% end -%>
