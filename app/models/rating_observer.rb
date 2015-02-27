class RatingObserver < ActiveRecord::Observer
  observe :vote, :answer

  def after_create(record)
    if record.is_a?(Vote) && record.votable.is_a?(Question)
      update_rating(record.votable.user, 2*record.points)
    end

    if record.is_a?(Vote) && record.votable.is_a?(Answer)
      update_rating(record.votable.user, 1*record.points)
    end

    if record.is_a?(Answer)
      if record.user == record.question.user
        handle_answer_to_own_question(record)
      else
        handle_answer_to_others_question(record)
      end
    end
  end

  def handle_answer_to_own_question(answer)
    if is_first_answer?(answer)
      update_rating(answer.user, 3)
    else
      update_rating(answer.user, 2)
    end
  end

  def handle_answer_to_others_question(answer)
    if is_first_answer?(answer)
      update_rating(answer.user, 2)
    else
      update_rating(answer.user, 1)
    end
  end

  def is_first_answer?(answer)
    answer.question.answers.minimum(:created_at) == answer.created_at
  end

  def update_rating(user, points)
    user = User.find(user)
    rating = user.rating
    user.update_attribute(:rating, rating + points)
  end
end