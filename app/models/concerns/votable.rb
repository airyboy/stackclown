module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def upvote
    vote(1)
  end

  def downvote
    vote(-1)
  end

  def total_points
    Vote.where(votable: self).sum(:points)
  end

  private

  def vote(points)
    the_vote = Vote.find_or_initialize_by(votable: self, user: self.user)
    the_vote.points = points
    the_vote.save
    the_vote
  end
end