class Comment < ActiveRecord::Base
  include TheNotification::LocalizedErrors
  include TheComments::Comment
  include CommonClassMethods

  def self.recent_five
    with_state(:published)
    .where(commentable_state: :published)
    .recent(:created_at)
    .limit(5)
  end

  def avatar_url
    return "/default_images/avatar/thumb/missing.png" unless user
    user.avatar.url(:thumb)
  end

  private

  def prepare_content
    txt = self.raw_content.to_s
    txt = txt.endl2br

    al_helper = ::AutoLink.new
    txt = al_helper.auto_link(txt, sanitize: false, html: { target: :_blank, rel: :nofollow })
    txt = txt.add_nofollow_to_links
    txt = txt.wrap_nofollow_links_with_noindex
    txt = sanitize_for(txt, nil)

    self.content = txt
  end

  def sanitize_for txt, current_user
    if current_user.try(:admin?)
      txt
    else
      Sanitize.clean(txt, simple_formatting)
    end
  end

  def simple_formatting
    {
      elements: %w[
        b i u s em strong
        a img br
      ],
      :attributes => {
        'a'   => %w[ href ],
        'img' => %w[ src ]
      },
      :add_attributes => {
        'a' => { 'rel' => 'nofollow' }
      },
      :protocols => {
        'a' => { 'href' => [ 'ftp', 'http', 'https', 'mailto', :relative ] }
      }
    }
  end
end
