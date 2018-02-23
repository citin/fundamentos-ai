class HomeController < ApplicationController

  NUMBER_OF_SUGGESTIONS = 5
  MAX_RANKING = 50

  skip_before_action :verify_authenticity_token

  def index
  end

  def find_suggestions
    query = params[:search]
    # sanitize query
    query.downcase!
    query = I18n.transliterate(query)
    # find similar words 
    unprocessed_suggestions = Search.where("searches.text LIKE :query", {:query => "%#{query}%"})
    # score, sort and limit results
    top_ten_suggestions = unprocessed_suggestions.sort {|min, max| max.score <=> min.score}.first(NUMBER_OF_SUGGESTIONS)
    # build json response
    results_list = []
    top_ten_suggestions.each do |word|
      results_list << {id: word.text, text: word.text}
    end

    render json: {"results": results_list}
  end

  def search
    query = params[:search_input]
    # sanitize query
    query.downcase!
    query = I18n.transliterate(query)
    # process search
    increase_hits(query) || Search.create(text: query)

    render js: "alert('Buscaste: #{params[:search_input]}');"
  end

  def increase_hits(query)
    search = Search.find_by_text(query)
    if search
      search.increment(:hits).save
    else
      false
    end
  end
end
