module PostsHelper
  def tags_to_str post
    raw tags_to_ary( post ).join ', '
  end

  def tags_to_ary post
    AppConfig.tag_contexts.inject([]){ |o, v| o += tag_inline_links( post, v )}
  end
  
  def tags_by_context post, context
    raw tag_inline_links( post, context ).join ', '
  end

  # private

  def tag_inline_links post, context
    post.send( "inline_#{ context }_tags" ).split(', ').map do |tag|
      link_to tag, tag_url(tag)
    end
  end
end
