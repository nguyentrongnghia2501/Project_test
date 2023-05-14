require 'rails_helper'

RSpec.describe PostsController, type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET #index" do
     context "when user is logged in" do
      before do
        sign_in user
        get posts_path
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @posts with user's posts" do
        expect(assigns(:posts)).to eq(user.posts)
      end
    end

    context "when user is not logged in" do
      before { get posts_path }

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is not logged in" do
      before { get posts_path }

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects back to posts after sign in" do
        user.confirm
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(posts_path)
        follow_redirect!
        expect(response).to have_http_status(:success)
      end

      context "when user is logged in after sign in" do
        before do
          user.confirm
          post user_session_path, params: { user: { email: user.email, password: user.password } }
          follow_redirect!
          # create some posts for the user
          FactoryBot.create_list(:post, 3, user: user)
          get posts_path
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "assigns @posts with all public and user's posts" do
          # xác thực user đã được xác thực trước khi truy xuất các bài viết
          expect(controller.current_user).to eq(user)
          # lấy tất cả các bài viết public
          public_posts = Post.where(status: nil)
          # lấy tất cả các bài viết của user
          user_posts = user.posts
          # gộp lại thành một ActiveRecord Relation
          expected_posts = public_posts.or(user_posts)
          expect(assigns(:posts)).to eq(expected_posts)
        end
      end
    end
  end
end
