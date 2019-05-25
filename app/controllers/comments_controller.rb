class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
   comment = Comment.create(user_id: current_user.id, review_id: params[:review_id],
                  content: params[:content])
   strhtml = render_to_string partial: '/restaurants/comment', locals: { comment: comment,
                           user: current_user}
   content = strhtml.html_safe
   render json: {status: true, content: content}

  end
end