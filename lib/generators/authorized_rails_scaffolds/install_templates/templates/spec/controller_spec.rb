require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

<% module_namespacing do -%>
<%-

#
# Available properties:
# 
#   class_name
#   controller_class_name
#   singular_table_name
#   file_name
#   human_name
#   attributes
#

t_helper = AuthorizedRailsScaffolds::RSpecScaffoldControllerHelper.new(
  :class_name => class_name,
  :controller_class_name => controller_class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name,
  :human_name => human_name,
  :attributes => attributes
)

resource_class = t_helper.resource_class
resource_human_name = t_helper.resource_human_name
resource_var = t_helper.resource_var
resource_symbol = t_helper.resource_symbol
resource_test_var = t_helper.resource_test_var
resource_table_name = t_helper.resource_table_name

parent_model_tables = t_helper.parent_model_tables

-%>
describe <%= t_helper.controller_class_name %> do

  # This should return the minimal set of attributes required to create a valid
  # <%= resource_class %>.
  def valid_create_attributes
    FactoryGirl.attributes_for(<%= resource_symbol %>)
  end

  # This should return the minimal set of attributes required to update a valid
  # <%= resource_class %>.
  def valid_update_attributes
    FactoryGirl.attributes_for(<%= resource_symbol %>)
  end

<%- if parent_model_tables.any? -%>
<%- parent_model_tables.each do |parent_model| -%>
  let(<%= t_helper.references_test_sym(parent_model) %>) { <%= t_helper.create_parent_resource_from_factory parent_model %> }
<%- end -%>

<%- end -%>
<% unless options[:singleton] -%>
  describe "GET index" do
    context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
      <%- t_helper.parent_models.each do |parent_model| -%>
      grant_ability :read, <%= parent_model.classify %>
      <%- end -%>

      context 'without a user session' do
        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :index, {<%= t_helper.build_example_request_params %>}
          end
          it { should redirect_to(new_user_session_path) }
          it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
        end
      end
      context 'as an unauthorized user' do
        login_unauthorized_user

        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :index, {<%= t_helper.build_example_request_params %>}
          end
          it { should redirect_to(root_url) }
          it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
        end
      end
      context 'as user with read ability' do
        login_user_with_ability :read, <%= resource_class %>

        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :index, {<%= t_helper.build_example_request_params %>}
          end
          it { should respond_with(:success) }
          it { should render_template(:index) }
          it { should render_with_layout(:application) }
          it "assigns all <%= t_helper.resource_plural_name %> as <%= t_helper.resource_array_var %>" do
            assigns(<%= t_helper.resource_array_sym %>).should eq([<%= resource_test_var %>])
          end
        end
      end
    end
  end

<% end -%>
  describe "GET show" do
    context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
      <%- parent_model_tables.each do |parent_model| -%>
      grant_ability :read, <%= parent_model.classify %>
      <%- end -%>

      context 'without a user session' do
        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :show, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should redirect_to(new_user_session_path) }
          it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
        end
      end
      context 'as an unauthorized user' do
        login_unauthorized_user

        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :show, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should redirect_to(<%= t_helper.controller_index_route %>) }
          it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
        end
      end
      context 'as user with read ability' do
        login_user_with_ability :read, <%= resource_class %>

        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :show, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should respond_with(:success) }
          it { should render_template(:show) }
          it { should render_with_layout(:application) }
          it "assigns the requested <%= resource_table_name %> as <%= resource_var %>" do
            assigns(<%= resource_symbol %>).should eq(<%= resource_test_var %>)
          end
        end
      end
    end
  end

  describe "GET new" do
    context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
      <%- parent_model_tables.each do |parent_model| -%>
      grant_ability :read, <%= parent_model.classify %>
      <%- end -%>

      context 'without a user session' do
        describe 'with valid request' do
          before(:each) do
            get :new, {<%= t_helper.build_example_request_params %>}
          end
          it { should redirect_to(new_user_session_path) }
          it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
        end
      end
      context 'as an unauthorized user' do
        login_unauthorized_user

        describe 'with valid request' do
          before(:each) do
            get :new, {<%= t_helper.build_example_request_params %>}
          end
          it { should redirect_to(<%= t_helper.controller_index_route %>) }
          it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
        end
      end
      context 'as user with create ability' do
        login_user_with_ability :create, <%= resource_class %>

        describe 'with valid request' do
          before(:each) do
            get :new, {<%= t_helper.build_example_request_params %>}
          end
          it { should respond_with(:success) }
          it { should render_template(:new) }
          it { should render_with_layout(:application) }
          it "assigns a new <%= resource_table_name %> as <%= resource_var %>" do
            assigns(<%= resource_symbol %>).should be_a_new(<%= resource_class %>)
          end
        end
      end
    end
  end

  describe "GET edit" do
    context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
      <%- parent_model_tables.each do |parent_model| -%>
      grant_ability :read, <%= parent_model.classify %>
      <%- end -%>

      context 'without a user session' do
        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :edit, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should redirect_to(new_user_session_path) }
          it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
        end
      end
      context 'as an unauthorized user' do
        login_unauthorized_user

        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :edit, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should redirect_to(<%= t_helper.controller_index_route %>) }
          it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
        end
      end
      context 'as user with update ability' do
        login_user_with_ability :update, <%= resource_class %>

        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            get :edit, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should respond_with(:success) }
          it { should render_template(:edit) }
          it { should render_with_layout(:application) }
          it "assigns the requested <%= resource_table_name %> as <%= resource_var %>" do
            assigns(<%= resource_symbol %>).should eq(<%= resource_test_var %>)
          end
        end
      end
    end
  end

  describe "POST create" do
    context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
      <%- parent_model_tables.each do |parent_model| -%>
      grant_ability :read, <%= parent_model.classify %>
      <%- end -%>

      context 'without a user session' do
        describe 'with valid params' do
          before(:each) do
            post :create, {<%= t_helper.build_example_request_params "#{resource_symbol} => valid_update_attributes" %>}
          end
          it { should redirect_to(new_user_session_path) }
          it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
        end
      end
      context 'as an unauthorized user' do
        login_unauthorized_user

        describe "with valid params" do
          before(:each) do
            post :create, {<%= t_helper.build_example_request_params "#{resource_symbol} => valid_update_attributes" %>}
          end
          it { should redirect_to(<%= t_helper.controller_index_route %>) }
          it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
        end
      end
      context 'as user with create ability' do
        login_user_with_ability :create, <%= resource_class %>

        describe "with valid params" do
          it "creates a new <%= resource_class %>" do
            expect {
              post :create, {<%= t_helper.build_example_request_params "#{resource_symbol} => valid_update_attributes" %>}
            }.to change(<%= resource_class %>, :count).by(1)
          end
        end
        describe 'with valid params' do
          before(:each) do
            post :create, {<%= t_helper.build_example_request_params "#{resource_symbol} => valid_update_attributes" %>}
          end
          it "assigns a newly created <%= resource_table_name %> as <%= resource_var %>" do
            assigns(<%= resource_symbol %>).should be_a(<%= resource_class %>)
            assigns(<%= resource_symbol %>).should be_persisted
          end
<% if parent_model_tables.any? -%>
          it "assigns the parent <%= t_helper.parent_models[-1] %> to <%= resource_table_name %>" do
            assigns(<%= resource_symbol %>).<%= parent_model_tables[-1] %>.should eq(<%= t_helper.references_test_property(parent_model_tables[-1]) %>)
          end
<% end -%>
          it { should set_the_flash[:notice].to('<%= resource_human_name %> was successfully created.') }
          it "redirects to the created <%= resource_table_name %>" do
            response.should redirect_to(<%= t_helper.controller_show_route "#{resource_class}.last" %>)
          end
        end
        describe "with invalid params" do
          before(:each) do
            # Trigger the behavior that occurs when invalid params are submitted
            <%= resource_class %>.any_instance.stub(:save).and_return(false)
            post :create, {<%= t_helper.build_example_request_params "#{resource_symbol} => #{formatted_hash(example_invalid_attributes)}" %>}
          end
          it { should render_template(:new) }
          it { should render_with_layout(:application) }
          it "assigns a newly created but unsaved <%= resource_table_name %> as <%= resource_var %>" do
            assigns(<%= resource_symbol %>).should be_a_new(<%= resource_class %>)
          end
        end
      end
    end
  end

  describe "PUT update" do
    context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
      <%- parent_model_tables.each do |parent_model| -%>
      grant_ability :read, <%= parent_model.classify %>
      <%- end -%>

      context 'without a user session' do
        describe 'with valid params' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            put :update, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param", "#{resource_symbol} => valid_update_attributes" %>}
          end
          it { should redirect_to(new_user_session_path) }
          it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
        end
      end
      context 'as an unauthorized user' do
        login_unauthorized_user

        describe "with valid params" do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            put :update, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param", "#{resource_symbol} => valid_update_attributes" %>}
          end
          it { should redirect_to(<%= t_helper.controller_index_route %>) }
          it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
        end
      end
      context 'as user with update ability' do
        login_user_with_ability :update, <%= resource_class %>

        describe "with valid params" do
          it "updates the requested <%= resource_table_name %>" do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            # Assuming there are no other <%= resource_table_name %> in the database, this
            # specifies that the <%= resource_class %> created on the previous line
            # receives the :update_attributes message with whatever params are
            # submitted in the request.
            <%- if Rails.version >= '4' -%>
            <%= resource_class %>.any_instance.should_receive(:update).with(<%= formatted_hash(example_params_for_update) %>)
            <%- else -%>
            <%= resource_class %>.any_instance.should_receive(:update_attributes).with(<%= formatted_hash(example_params_for_update) %>)
            <%- end -%>
            put :update, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param", "#{resource_symbol} => #{formatted_hash(example_params_for_update)}" %>}
          end
        end
        describe "with valid params" do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            put :update, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param", "#{resource_symbol} => valid_update_attributes" %>}
          end
          it "assigns the requested <%= resource_table_name %> as <%= resource_var %>" do
            assigns(<%= resource_symbol %>).should eq(<%= resource_test_var %>)
          end
          it { should set_the_flash[:notice].to('<%= resource_human_name %> was successfully updated.') }
          it "redirects to the <%= resource_table_name %>" do
            response.should redirect_to(<%= t_helper.controller_show_route resource_test_var %>)
          end
        end
        describe "with invalid params" do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            # Trigger the behavior that occurs when invalid params are submitted
            <%= resource_class %>.any_instance.stub(:save).and_return(false)
            put :update, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param", "#{resource_symbol} => #{formatted_hash(example_invalid_attributes)}" %>}
          end
          it { should render_template(:edit) }
          it { should render_with_layout(:application) }
          it "assigns the <%= resource_table_name %> as <%= resource_var %>" do
            assigns(<%= resource_symbol %>).should eq(<%= resource_test_var %>)
          end
        end
      end
    end
  end

  describe "DELETE destroy" do
    context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
      <%- parent_model_tables.each do |parent_model| -%>
      grant_ability :read, <%= parent_model.classify %>
      <%- end -%>

      context 'without a user session' do
        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            delete :destroy, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should redirect_to(new_user_session_path) }
          it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
        end
      end
      context 'as an unauthorized user' do
        login_unauthorized_user

        describe "with valid request" do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            delete :destroy, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should redirect_to(<%= t_helper.controller_index_route %>) }
          it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
        end
      end
      context 'as user with destroy ability' do
        login_user_with_ability :destroy, <%= resource_class %>

        it "destroys the requested <%= resource_table_name %>" do
          <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
          expect {
            delete :destroy, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          }.to change(<%= resource_class %>, :count).by(-1)
        end
        describe 'with valid request' do
          before(:each) do
            <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
            delete :destroy, {<%= t_helper.build_example_request_params ":id => #{resource_test_var}.to_param" %>}
          end
          it { should set_the_flash[:notice].to('<%= resource_human_name %> was successfully deleted.') }
          it "redirects to the <%= resource_table_name %> list" do
            response.should redirect_to(<%= t_helper.controller_index_route %>)
          end
        end
      end
    end
  end

end
<% end -%>