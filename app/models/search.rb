# frozen_string_literal: true

class Search
  attr_reader :query, :user

  def initialize(query:, user:)
    @user = user
    @query = parse_query!(query)
  end

  def run
    res = user.stories
    res = res.where("read_at IS #{query[:read] ? "NOT" : ""} NULL") if query.key?(:read)
    res = res.where("items.feed_id = ?", query[:feed]) if query.key?(:feed)
    res = res.where("items.title ILIKE ?", "%#{query[:search]}%") unless query[:search].blank?
    res = res.where("? = ANY(stories.tags)", query[:tag]) if query.key?(:tag)

    include!(sort!(res))
  end

  private

  def sort!(scope)
    scope.order("items.published_at DESC")
  end

  def include!(scope)
    scope.includes(item: :feed)
  end

  def parse_query!(query)
    return {} if query.blank?
    search = []

    params = query.split(" ").map do |d|
      next if d.blank?
      if !d.match?(/:/)
        search << d
        next
      end

      k = d.split(":")
      k[0] = k[0].to_sym

      k[1] = case k[1]
             when "true"; true
             when "false"; false
             else; k[1]
             end

      k
    end.compact.to_h

    params.merge(search: search.join(" "))
  end
end
