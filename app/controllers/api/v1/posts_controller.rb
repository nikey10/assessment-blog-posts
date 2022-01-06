class Api::V1::PostsController < ApplicationController
  def index
    return render_by_key('TAGS_REQUIRED') if request.query_parameters['tags'].nil?

    tags = request.query_parameters['tags'].downcase.split(',').uniq
    
    return render_by_key('TAGS_REQUIRED') if tags.length.zero?

    return render_by_key('SORTBY_INVALID') unless is_valid_param?(request.query_parameters, 'sortBy', ['id', 'reads', 'likes', 'popularity'])

    return render_by_key('DIRECTION_INVALID') unless is_valid_param?(request.query_parameters, 'direction', ['asc', 'desc'])

    posts = []
    uncached_tags = []
    
    tags.each do |tag|
      post = Rails.cache.read(tag)

      if post.nil?
        uncached_tags << tag
      else
        # Rails.logger.warn "cached tag=#{tag}"
        posts += post
      end
    end

    posts += concurrent_crawl(uncached_tags)

    posts.uniq! { |el| el['id'] }

    puts posts.length

    sort_by = request.query_parameters['sortBy'] || 'id'
    direction = request.query_parameters['direction'] || 'asc'
    # Rails.logger.warn "sort_by=#{sortBy}"
    # Rails.logger.warn "direction=#{direction}"

    if direction == 'asc'
      posts.sort! { |a, b| a[sort_by] <=> b[sort_by]}
    else
      posts.sort! { |a, b| b[sort_by] <=> a[sort_by]}
    end

    render_json({'posts' => posts})
  end

  private

  def is_valid_param?(params, param, available)
    return true if params[param].nil?

    available.include?(params[param])
  end

  def concurrent_crawl(uncached_tags)
    hydra = Typhoeus::Hydra.hydra
  
    tags_and_requests = uncached_tags.map do |tag|
      # Rails.logger.warn "unchaced tag=#{tag}"
      request = Typhoeus::Request.new('https://api.hatchways.io/assessment/blog/posts?tag=' + tag)
      hydra.queue(request)
      [tag, request]
    end
    hydra.run

    new_posts = []

    tags_and_requests.each do |pair|
      body = JSON.parse(pair[1].response.body)   # pair[1] is reaquest
      Rails.cache.write(pair[0], body['posts'])  # pair[0] is tag
      # Rails.logger.warn "  unchaced tag=#{pair[0]}"
      # Rails.logger.warn "  unchaced post=#{body['posts']}"
      new_posts += body['posts']
    end

    new_posts
  end
end
