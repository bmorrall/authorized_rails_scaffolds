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

local_class_name = class_name.split('::')[-1] # Non-Namespaced class name
var_name = file_name # Non-namespaced variable name
plural_var_name = var_name.pluralize # Pluralized non-namespaced variable name

# Determine namespace prefix i.e awesome_
namespace_prefix = singular_table_name[0..-(file_name.length + 1)]

# Determine Parent Prefix i.e. user_company
parent_prefix = AuthorizedRailsScaffolds::PARENT_MODELS.collect{ |x| x.underscore }.join('_')
parent_prefix = "#{parent_prefix}_" unless parent_prefix.blank?

# Route Prefix i.e. awesome_user_company
route_prefix = namespace_prefix + parent_prefix

parent_variables = AuthorizedRailsScaffolds::PARENT_MODELS.collect{ |x| "@#{x.underscore}" }.join(', ')

# Route Helpers
route_params_prefix = parent_variables.blank? ? "" : "#{parent_variables}, "
index_path_prefix = "#{route_prefix}#{plural_var_name}"
single_path_prefix = "#{route_prefix}#{var_name}"
controller_index_route = "#{index_path_prefix}_url(#{parent_variables})"

# call arguments
index_params = AuthorizedRailsScaffolds::PARENT_MODELS.any? ? AuthorizedRailsScaffolds::PARENT_MODELS.collect{|x| ":#{x.underscore}_id => @#{x.underscore}.to_param"}.join(', ') : ""
action_params = index_params.blank? ? '' : "#{index_params}, "

-%>
describe <%= controller_class_name %>Controller do

  # This should return the minimal set of attributes required to create a valid
  # <%= local_class_name %>.
  def valid_create_attributes
    FactoryGirl.attributes_for(:<%= var_name %>)
  end

  # This should return the minimal set of attributes required to update a valid
  # <%= local_class_name %>.
  def valid_update_attributes
    FactoryGirl.attributes_for(:<%= var_name %>)
  end

<%- if AuthorizedRailsScaffolds::PARENT_MODELS.any? -%>
  before(:each) do
    <%- AuthorizedRailsScaffolds::PARENT_MODELS.each do |model| -%>
    @<%= model.underscore %> = FactoryGirl.create(:<%= model.underscore %>)
    <%- end -%>
  end

  <%- end -%>
<% unless options[:singleton] -%>
  describe "GET index" do
    context 'without a user' do
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :index, {<%= index_params %>}
        end
        it { should redirect_to(new_user_session_path) }
        it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
      end
    end
    context 'as an unauthorized user' do
      login_unauthorized_user
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :index, {<%= index_params %>}
        end
        it { should redirect_to(root_url) }
        it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
      end
    end
    context 'as user with read ability' do
      login_user_with_ability :read, <%= local_class_name %>
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :index, {<%= index_params %>}
        end
        it { should respond_with(:success) }
        it { should render_template(:index) }
        it { should render_with_layout(:application) }
        it "assigns all <%= plural_var_name %> as @<%= plural_var_name %>" do
          assigns(:<%= plural_var_name %>).should eq([@<%= var_name %>])
        end
      end
    end
  end

<% end -%>
  describe "GET show" do
    context 'without a user' do
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :show, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it { should redirect_to(new_user_session_path) }
        it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
      end
    end
    context 'as an unauthorized user' do
      login_unauthorized_user
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :show, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it { should redirect_to(<%= controller_index_route %>) }
        it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
      end
    end
    context 'as user with read ability' do
      login_user_with_ability :read, <%= local_class_name %>
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :show, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it { should respond_with(:success) }
        it { should render_template(:show) }
        it { should render_with_layout(:application) }
        it "assigns the requested <%= var_name %> as @<%= var_name %>" do
          assigns(:<%= var_name %>).should eq(@<%= var_name %>)
        end
      end
    end
  end

  describe "GET new" do
    context 'without a user' do
      describe 'with valid request' do
        before(:each) do
          get :new, {<%= index_params %>}
        end
        it { should redirect_to(new_user_session_path) }
        it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
      end
    end
    context 'as an unauthorized user' do
      login_unauthorized_user
      describe 'with valid request' do
        before(:each) do
          get :new, {<%= index_params %>}
        end
        it { should redirect_to(<%= controller_index_route %>) }
        it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
      end
    end
    context 'as user with create ability' do
      login_user_with_ability :create, <%= local_class_name %>
      describe 'with valid request' do
        before(:each) do
          get :new, {<%= index_params %>}
        end
        it { should respond_with(:success) }
        it { should render_template(:new) }
        it { should render_with_layout(:application) }
        it "assigns a new <%= var_name %> as @<%= var_name %>" do
          assigns(:<%= var_name %>).should be_a_new(<%= local_class_name %>)
        end
      end
    end
  end

  describe "GET edit" do
    context 'without a user' do
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :edit, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it { should redirect_to(new_user_session_path) }
        it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
      end
    end
    context 'as an unauthorized user' do
      login_unauthorized_user
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :edit, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it { should redirect_to(<%= controller_index_route %>) }
        it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
      end
    end
    context 'as user with update ability' do
      login_user_with_ability :update, <%= local_class_name %>
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          get :edit, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it { should respond_with(:success) }
        it { should render_template(:edit) }
        it { should render_with_layout(:application) }
        it "assigns the requested <%= var_name %> as @<%= var_name %>" do
          assigns(:<%= var_name %>).should eq(@<%= var_name %>)
        end
      end
    end
  end

  describe "POST create" do
    context 'without a user' do
      describe 'with valid params' do
        before(:each) do
          post :create, {<%= action_params %>:<%= var_name %> => valid_create_attributes}
        end
        it { should redirect_to(new_user_session_path) }
        it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
      end
    end
    context 'as an unauthorized user' do
      login_unauthorized_user
      describe "with valid params" do
        before(:each) do
          post :create, {<%= action_params %>:<%= var_name %> => valid_create_attributes}
        end
        it { should redirect_to(<%= controller_index_route %>) }
        it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
      end
    end
    context 'as user with create ability' do
      login_user_with_ability :create, <%= local_class_name %>
      describe "with valid params" do
        it "creates a new <%= local_class_name %>" do
          expect {
            post :create, {<%= action_params %>:<%= var_name %> => valid_create_attributes}
          }.to change(<%= local_class_name %>, :count).by(1)
        end
      end
      describe 'with valid params' do
        before(:each) do
          post :create, {<%= action_params %>:<%= var_name %> => valid_create_attributes}
        end
        it "assigns a newly created <%= var_name %> as @<%= var_name %>" do
          assigns(:<%= var_name %>).should be_a(<%= local_class_name %>)
          assigns(:<%= var_name %>).should be_persisted
        end
        it "redirects to the created <%= var_name %>" do
          response.should redirect_to(<%= single_path_prefix %>_path(<%= route_params_prefix %><%= local_class_name %>.last))
        end
      end
      describe "with invalid params" do
        before(:each) do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= local_class_name %>.any_instance.stub(:save).and_return(false)
          post :create, {<%= action_params %>:<%= var_name %> => <%= formatted_hash(example_invalid_attributes) %>}
        end
        it { should render_template(:new) }
        it { should render_with_layout(:application) }
        it "assigns a newly created but unsaved <%= var_name %> as @<%= var_name %>" do
          assigns(:<%= var_name %>).should be_a_new(<%= local_class_name %>)
        end
      end
    end
  end

  describe "PUT update" do
    context 'without a user' do
      describe 'with valid params' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          put :update, {<%= action_params %>:id => @<%= var_name %>.to_param, :<%= var_name %> => valid_update_attributes}
        end
        it { should redirect_to(new_user_session_path) }
        it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
      end
    end
    context 'as an unauthorized user' do
      login_unauthorized_user
      describe "with valid params" do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          put :update, {<%= action_params %>:id => @<%= var_name %>.to_param, :<%= var_name %> => valid_update_attributes}
        end
        it { should redirect_to(<%= controller_index_route %>) }
        it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
      end
    end
    context 'as user with update ability' do
      login_user_with_ability :update, <%= local_class_name %>
      describe "with valid params" do
        it "updates the requested <%= var_name %>" do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          # Assuming there are no other <%= var_name %> in the database, this
          # specifies that the <%= local_class_name %> created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          <%- if Rails.version >= '4' -%>
          <%= local_class_name %>.any_instance.should_receive(:update).with(<%= formatted_hash(example_params_for_update) %>)
          <%- else -%>
          <%= local_class_name %>.any_instance.should_receive(:update_attributes).with(<%= formatted_hash(example_params_for_update) %>)
          <%- end -%>
          put :update, {<%= action_params %>:id => @<%= var_name %>.to_param, :<%= var_name %> => <%= formatted_hash(example_params_for_update) %>}
        end
      end
      describe "with valid params" do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          put :update, {<%= action_params %>:id => @<%= var_name %>.to_param, :<%= var_name %> => valid_update_attributes}
        end
        it "assigns the requested <%= var_name %> as @<%= var_name %>" do
          assigns(:<%= var_name %>).should eq(@<%= var_name %>)
        end
        it "redirects to the <%= var_name %>" do
          response.should redirect_to(<%= single_path_prefix %>_path(<%= route_params_prefix %>@<%= var_name %>))
        end
      end
      describe "with invalid params" do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          # Trigger the behavior that occurs when invalid params are submitted
          <%= local_class_name %>.any_instance.stub(:save).and_return(false)
          put :update, {<%= action_params %>:id => @<%= var_name %>.to_param, :<%= var_name %> => <%= formatted_hash(example_invalid_attributes) %>}
        end
        it { should render_template(:edit) }
        it { should render_with_layout(:application) }
        it "assigns the <%= var_name %> as @<%= var_name %>" do
          assigns(:<%= var_name %>).should eq(@<%= var_name %>)
        end
      end
    end
  end

  describe "DELETE destroy" do
    context 'without a user' do
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          delete :destroy, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it { should redirect_to(new_user_session_path) }
        it { should set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
      end
    end
    context 'as an unauthorized user' do
      login_unauthorized_user
      describe "with valid request" do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          delete :destroy, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it { should redirect_to(<%= controller_index_route %>) }
        it { should set_the_flash[:alert].to("You are not authorized to access this page.") }
      end
    end
    context 'as user with destroy ability' do
      login_user_with_ability :destroy, <%= local_class_name %>
      it "destroys the requested <%= var_name %>" do
        @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
        expect {
          delete :destroy, {<%= action_params %>:id => @<%= var_name %>.to_param}
        }.to change(<%= local_class_name %>, :count).by(-1)
      end
      describe 'with valid request' do
        before(:each) do
          @<%= var_name %> = FactoryGirl.create(:<%= var_name %>)
          delete :destroy, {<%= action_params %>:id => @<%= var_name %>.to_param}
        end
        it "redirects to the <%= var_name %> list" do
          response.should redirect_to(<%= controller_index_route %>)
        end
      end
    end
  end

end
<% end -%>