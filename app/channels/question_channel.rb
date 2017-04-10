class QuestionChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "answers_to_#{data['question_id']}"
    stream_from "comments_to_#{data['question_id']}"
  end

  def unfollow
    stop_all_streams
  end
end