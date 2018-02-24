class Search < ApplicationRecord
  def score
    hits * 0.8 + 1 / (0.1 + elapsed_days)
  end

  def elapsed_days
    (Search.last.updated_at.to_date - Date.today).to_i
  end
end
