class AddUserIdToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :answers, :user
  end
end
