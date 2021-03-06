require 'test_helper'

class My::WordsControllerTest < ActionController::TestCase

  def setup
    @user = users(:simple_user)
    @word = words(:noun)
    @other_user_word = Verb.create(foreign_form: 'loeshen', known_form: 'delete')

    @user.words << @word
    @user.save!
  end

  test "renders the index page" do
    login_as(@user)
    get :index
    assert_response :success
  end

  test "should redirect to login page if not logged in" do
    get :index
    assert_redirected_to new_session_path(referrer: my_words_path)
  end

  test "renders the new page" do
    login_as(@user)
    get :new, type: @word.class
    assert_response :success
  end

  test "redirect to the words index if no word type specified" do
    skip
  end

  test "redirect to the words index if word type doesn't exist" do
    skip
  end

  test "renders show" do
    login_as(@user)
    get :show, { id: @word.id }
    assert_response :success
  end

  test "create new word" do
    login_as(@user)
    assert_difference('Word.count', 1) do
      post :create, { word: { known_form: 'man', foreign_form: 'Mann', type: 'Noun', user_id: @user.id } }
    end
    assert_redirected_to my_words_path
    assert flash[:notice].present?
  end

  test "renders edit page" do
    login_as(@user)
    get :edit, { id: @word.id }
    assert_response :success
  end

  test "updates a word" do
    login_as(@user)
    patch :update, { id: @word.id, word: { known_form: 'new_known_form', foreign_form: 'new_foreign_form' } }
    assert flash[:notice].present?
    assert_redirected_to my_words_path
  end

  test "destroys a word" do
    login_as(@user)

    assert_difference('Word.count', -1) do
      delete :destroy, { id: @word.id }
    end

    assert flash[:notice].present?
    assert_redirected_to my_words_path
  end

  test "doesn't destroy a word if it doesn't belong to a user" do
    login_as(@user)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete :destroy, { id: @other_user_word.id }
    end

  end

end