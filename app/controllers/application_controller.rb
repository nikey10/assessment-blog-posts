class ApplicationController < ActionController::API
  protected

  def render_json(response_object)
    render json: JSON.generate(response_object)
  end

  def render_by_key(key)
    result = 
      case key
      when 'GENERAL_SUCCESS'
        { 'success' => true }
      when 'TAGS_REQUIRED'
        {'error' => 'tags parameter is missing'}
      when 'SORTBY_INVALID'
        {'error' => 'sortBy or direction has an invalid value'}
      when 'DIRECTION_INVALID'
        {'error' => 'sortBy or direction has an invalid value'}
      else
        { 'success' => true }
      end
    render_json(result)
  end
end
