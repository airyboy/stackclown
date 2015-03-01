class RatingObserver < ActiveRecord::Observer
  observe :vote, :answer

  def after_create(record)
    if record.is_a?(Vote) && record.votable.is_a?(Question)
      record.votable.user.update_rating(2*record.points)
    end

    if record.is_a?(Vote) && record.votable.is_a?(Answer)
      record.votable.user.update_rating(1*record.points)
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
      answer.user.update_rating(3)
    else
      answer.user.update_rating(2)
    end
  end

  def handle_answer_to_others_question(answer)
    if is_first_answer?(answer)
      answer.user.update_rating(2)
    else
      answer.user.update_rating(1)
    end
  end

  def is_first_answer?(answer)
    answer.question.answers.minimum(:created_at) == answer.created_at
  end
end