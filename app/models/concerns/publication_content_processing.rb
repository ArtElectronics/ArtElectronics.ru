module PublicationContentProcessing
  def content_processing_for current_user
    return unless current_user

    self.title   = title.squish.strip
    self.intro   = process_content(raw_intro,   current_user)
    self.content = process_content(raw_content, current_user)
  end

  def process_content txt, current_user
    txt = txt.to_s
    al_helper = ::AutoLink.new

    txt = sanitize_for(txt, current_user)
    txt = txt.empty_p2br

    txt = al_helper.auto_link(txt, sanitize: false, html: { target: :_blank, rel: :nofollow })
    txt = txt.add_nofollow_to_links if !current_user.has_role?(:content_processor, :skip_auto_nofollow)
    txt = txt.wrap_nofollow_links_with_noindex

    txt.strip
  end

  def sanitize_for txt, current_user
    if current_user.admin?
      txt
    else
      Sanitize.fragment(txt, blogger_html_tags)
    end
  end

  ########################################
  # Sanitize Rules
  ########################################

  def blogger_html_tags
    {
      elements: %w[
        h2 h3 h4
        a img br

        strong b i em u s sub sup
        font span div p  pre blockquote

        table th tr td
        ul ol li
      ],
      :attributes => {
        'img' => %w[ src title alt width height style ],
        'a'   => %w[ href rel title ],
        'blockquote' => %w[ cite ],
        'table' => %w[ border cellpadding cellspacing width style ],
        'td'    => %w[ align colspan headers rowspan valign width ],
        'th'    => %w[ align colspan headers rowspan valign width ]
      },
      # :add_attributes => {
      #   'a' => { 'rel' => 'nofollow' }
      # },
      :css => {
        :properties => %w[ color margin padding width height ]
      },
      :protocols => {
        'a' => { 'href' => [ 'ftp', 'http', 'https', 'mailto', :relative ] },
        'blockquote' => { 'cite' => [ 'http', 'https', :relative ] }
      }
    }
  end
end
