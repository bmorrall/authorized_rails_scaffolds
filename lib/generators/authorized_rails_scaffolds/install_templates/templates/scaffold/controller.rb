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
#

t_helper = AuthorizedRailsScaffolds::RailsScaffoldControllerHelper.new(
  :class_name => class_name,
  :controller_class_name => controller_class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name
)

local_class_name = t_helper.local_class_name # Non-Namespaced class name
var_name = t_helper.var_name # Non-namespaced variable name
plural_var_name = t_helper.plural_var_name # Pluralized non-namespaced variable name

# Override default orm instance
orm_instance = Rails::Generators::ActiveModel.new var_name

-%>
<% module_namespacing do -%>
class <%= t_helper.controller_class_name %> < <%= t_helper.application_controller_class %>
  <%- AuthorizedRailsScaffolds.config.parent_models.each_with_index do |model, model_index| -%>
  load_and_authorize_resource :<%= model.underscore %><% if model_index > 0 %>, :through => :<%= AuthorizedRailsScaffolds.config.parent_models[model_index - 1].underscore %><% end %>
  <%- end -%>
  load_and_authorize_resource :<%= var_name%><% if AuthorizedRailsScaffolds.config.parent_models.any? %>, :through => :<%= AuthorizedRailsScaffolds.config.parent_models.last.underscore %><% end %>

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
        format.html { redirect_to <%= t_helper.controller_show_route("@#{var_name}") %>, <%= key_value :notice, "'#{human_name} was successfully created.'" %> }
        format.json { render <%= key_value :json, "@#{var_name}" %>, <%= key_value :status, ':created' %>, <%= key_value :location, t_helper.controller_show_route("@#{var_name}") %> }
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
        format.html { redirect_to <%= t_helper.controller_show_route "@#{var_name}" %>, <%= key_value :notice, "'#{human_name} was successfully updated.'" %> }
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
