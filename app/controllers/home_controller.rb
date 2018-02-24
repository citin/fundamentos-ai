class HomeController < ApplicationController

  NUMBER_OF_SUGGESTIONS = 5
  MAX_RANKING = 50

  def index
  end

  def find_suggestions
    query = sanitize(params[:search])
    top_ten_suggestions = find_top_ten(query)

    render json: build_json_response(top_ten_suggestions) 
  end

  def search
    @query = sanitize(params[:search_input])
    @top_ten_suggestions = find_top_ten(@query)

    # process search
    increase_hits(@query) || Search.create(text: @query)
  end

  private

  def increase_hits(query)
    search = Search.find_by_text(query)
    if search
      search.increment(:hits).save
    else
      false
    end
  end

  def sanitize(query)
    # sanitize query
    query.downcase!
    I18n.transliterate(query)
  end

  def find_top_ten(query)
    # find similar words 
    unprocessed_suggestions = Search.where("text LIKE :query", {:query => "%#{query}%"})
    # score, sort and limit results
    unprocessed_suggestions.sort {|min, max| max.score <=> min.score}.first(NUMBER_OF_SUGGESTIONS)
  end

  def build_json_response(results)
    results_list = []
    results.each do |word|
      results_list << {id: word.text, text: word.text}
    end
    {"results": results_list}
  end
end
