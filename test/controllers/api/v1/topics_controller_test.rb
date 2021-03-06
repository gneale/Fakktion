require 'test_helper'

class Api::V1::TopicsControllerTest < ActionController::TestCase
  # Called before every test
  setup do
    @request.headers["Content-Type"] = "application/json; charset=utf-8"
    @testTopic = Topic.new(name: 'Testing Topic', eligibility_counter: 0, posts_count: 0)
    @testTopic.save
    @user = User.first
    @user.reputation = 1500
    @user.save
    sign_in @user
  end
  # Called after test
  def teardown
    @testTopic = nil
    @apiTopic = nil
    @TopicSerializer = nil
  end
  test "Topics - API - Get Index" do
    get :index
    assert_response_schema('topics/index.json')
  end
  test "Topics - API - Serializer Validation" do
    sampleTopic = Topic.new
    serializer = ActiveModel::Serializer.serializer_for(sampleTopic)
    assert_equal TopicSerializer, serializer
  end
  test "Topics - API - Create 200" do
    apiTopic = Topic.new(name: 'testng123', eligibility_counter: 0, posts_count: 0)
    assert_difference('Topic.count', +1) do
      post :create, ActiveModelSerializers::SerializableResource.new(apiTopic).as_json
    end
  end
  test "Topics - API - Create 401" do
    sign_out @user
    post :create, ActiveModelSerializers::SerializableResource.new(@testTopic).as_json
    assert_response(401)
  end
  test "Topics - API - Create 403" do
    @user = User.find_by_email('user@user.com')
    @user.reputation = -1500
    @user.save
    sign_in @user
    post :create, ActiveModelSerializers::SerializableResource.new(@testTopic).as_json
    assert_response(403)
  end
  test "Topics - API - Create 422" do
    post :create, ActiveModelSerializers::SerializableResource.new(@testTopic).as_json
    assert_response(422)
  end
  test "Topics - API - SHOW 200" do
    get :show, id: @testTopic
    assert_response_schema('topics/show.json')
  end
  test "Topics - API - UPDATE 200" do
    topic = Topic.find_by name: 'testing topic'
    topic.name = "mikuchan"
    tempTopic = ActiveModelSerializers::SerializableResource.new(topic).serializable_hash
    post :update, tempTopic.merge(id: topic)
    topicUpdated = Topic.find_by name: 'mikuchan'
    assert_response :success, topicUpdated
  end
  test "Topics - API - UPDATE 401" do
    sign_out @user
    topic = Topic.find_by name: 'vocaloid'
    topic1 = Topic.find_by name: 'action'
    topic.name = "mikuchan"
    topic1.name = "mikuchan"
    tempTopic = ActiveModelSerializers::SerializableResource.new(topic).serializable_hash
    tempTopic1 = ActiveModelSerializers::SerializableResource.new(topic1).serializable_hash
    post :update, tempTopic.merge(id: topic)
    post :update, tempTopic1.merge(id: topic1)
    assert_response(401)
  end
  test "Topics - API - UPDATE 403" do
    @user = User.find_by_email('user@user.com')
    @user.reputation = -1500
    @user.save
    sign_in @user
    topic = Topic.find_by name: 'vocaloid'
    topic1 = Topic.find_by name: 'action'
    topic.name = "mikuchan"
    topic1.name = "mikuchan"
    tempTopic = ActiveModelSerializers::SerializableResource.new(topic).serializable_hash
    tempTopic1 = ActiveModelSerializers::SerializableResource.new(topic1).serializable_hash
    post :update, tempTopic.merge(id: topic)
    post :update, tempTopic1.merge(id: topic1)
    assert_response(403)
  end
  test "Topics - API - UPDATE 422" do
    topic = Topic.find_by name: 'vocaloid'
    topic1 = Topic.find_by name: 'action'
    topic.name = "mikuchan"
    topic1.name = "mikuchan"
    tempTopic = ActiveModelSerializers::SerializableResource.new(topic).serializable_hash
    tempTopic1 = ActiveModelSerializers::SerializableResource.new(topic1).serializable_hash
    post :update, tempTopic.merge(id: topic)
    post :update, tempTopic1.merge(id: topic1)
    assert_response(422)
  end
  test "Topics - API - DELETE 200" do
    assert_difference('Topic.count', 0) do
      delete :destroy, id: @testTopic
    end
  end
  test "Topics - API - DELETE 405" do
    topic = Topic.find_by name: 'vocaloid'
    post = Post.first
    post.topic = topic
    post.save
    delete :destroy, id: topic
    assert_response(405)
  end
  test "Topics - ACTIVE RECORD - CAN DELETE" do
    assert_difference('Topic.count', -1) do
      @testTopic.destroy
    end
  end
  test "Topics - ACTIVE RECORD - CANNOT DELETE" do
    topic = Topic.first
    factType = FactType.first
    category = Category.first
    testPost = Post.new(user: @user,
    category: category,
    fact_type: factType,
    topic: topic,
    views_count: 0,
    comments_count: 0,
    fact_link: "https://www.google.com",
    fiction_link: "https://www.google.com",
    title: "THis is a testing title for the sake of testing the title",
    text: "test text for testing text so that I can test out the backend text............................................................")
    testPost.save
    assert_difference('Topic.count', 0) do
      topic.destroy
    end
  end
end
