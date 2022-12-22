module TagsHelper
  def tags_to_str post
    raw tags_to_ary( post ).join ', '
  end

  def tags_to_ary post
    AppConfig.tag_contexts.inject([]){ |ary, context| ary += tag_inline_links(post, context) }
  end

  def tags_by_context post, context
    tag_inline_links(post, context)
  end

  def tag_inline_links post, context
    post.send("inline_#{ context }_tags").split(', ').map do |tag|
      link_to tag, tag_url(tag)
    end
  end
end
