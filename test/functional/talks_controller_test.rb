require 'test_helper'

class TalksControllerTest < ActionController::TestCase
  context "the index action" do
    should "respond successfully" do
      get :index
      assert_response :success
    end

    should "render the talks/index template" do
      get :index
      assert_template 'talks/index'
    end

    should "prepare a list of talks in most recently updated first order" do
      talk_1 = Factory.create(:talk, :created_at => 10.days.ago, :updated_at => 9.days.ago)
      talk_2 = Factory.create(:talk, :created_at => 1.minute.ago, :updated_at => 1.minute.ago)
      talk_3 = Factory.create(:talk, :created_at => 10.minutes.ago, :updated_at => 10.minutes.ago)
      talk_4 = Factory.create(:talk, :created_at => 4.days.ago, :updated_at => 2.minutes.ago)
      get :index
      assert_in_order assigns['talks'], talk_2, talk_4, talk_3, talk_1
    end

    should "respond to '/'" do
      assert_recognizes({:controller => 'talks', :action => 'index'}, '/')
    end
  end

  context "the show action" do
    setup do
      @talk = Factory.create(:talk)
    end

    should "respond successfully" do
      get :show, :id => @talk.to_param
      assert_response :success
    end

    should "render the talks/show template" do
      get :show, :id => @talk.to_param
      assert_template 'talks/show'
    end

    should "fetch the requested talk" do
      get :show, :id => @talk.to_param
      assert_equal @talk, assigns['talk']
    end

    should "prepare a fresh feedback object as @new_feedback owned by this talk" do
      get :show, :id => @talk.to_param
      assert assigns['new_feedback'].new_record?
      assert_equal @talk, assigns['new_feedback'].talk
    end
  end

  context "the new action" do
    should "respond scuccessfully" do
      get :new
      assert_response :success
    end

    should "render the talks/new template" do
      get :new
      assert_template 'talks/new'
    end

    should "prepare a fresh, unsaved talk object" do
      get :new
      assert assigns['talk'].new_record?
    end
  end

  context "the create action" do
    setup do
      @some_params = {'what' => 'ever'}
      @talk = Factory.build(:talk)
      Talk.expects(:new).with(@some_params).returns(@talk)
    end

    context "when valid data is provided" do
      setup do
        @talk.expects(:save).returns(true)
      end

      should "redirect to the index page" do
        post :create, :talk => @some_params
        assert_redirected_to talks_path
      end
    end

    context "when invalid data is provided" do
      setup do
        @talk.expects(:save).returns(false)
      end

      should "render the talks/new template" do
        post :create, :talk => @some_params
        assert_template 'talks/new'
      end

      should "make the invalid talk object available as @talk" do
        post :create, :talk => @some_params
        assert_equal @talk, assigns['talk']
      end
    end
  end

  context "the edit action" do
    setup do
      @talk = Factory.create(:talk)
    end

    should "respond successfully" do
      get :edit, :id => @talk.to_param
      assert_response :success
    end

    should "render the talks/show template" do
      get :edit, :id => @talk.to_param
      assert_template 'talks/edit'
    end

    should "fetch the requested talk" do
      get :edit, :id => @talk.to_param
      assert_equal @talk, assigns['talk']
    end
  end

  context "the update action" do
    setup do
      @some_params = {'what' => 'ever'}
      @talk = Factory.create(:talk)
      @talk.expects(:attributes=).with(@some_params)
      Talk.expects(:find).with(@talk.to_param.to_s).returns(@talk)
    end

    context "when valid data is provided" do
      setup do
        @talk.expects(:save).returns(true)
      end

      should "redirect to the show page for the talk" do
        put :update, :id => @talk.to_param, :talk => @some_params
        assert_redirected_to talk_path(@talk)
      end
    end

    context "when invalid data is provided" do
      setup do
        @talk.expects(:save).returns(false)
      end

      should "render the talks/edit template" do
        put :update, :id => @talk.to_param, :talk => @some_params
        assert_template 'talks/edit'
      end

      should "make the invalid talk object available as @talk" do
        put :update, :id => @talk.to_param, :talk => @some_params
        assert_equal @talk, assigns['talk']
      end
    end
  end

end