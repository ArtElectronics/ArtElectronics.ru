xml.instruct! :xml, version: "1.0"
xml.rss(
  version: '2.0',
  'xmlns:rambler' => 'http://news.rambler.ru'
){
  xml.channel do
    xml.title "ArtElectronics: Публикации"
    xml.link  "http://artelectronics.ru"
    xml.description "Интернет-журнал о самых обсуждаемых трендах будущего: освоении космоса, искусственном разуме и новейших технологиях"

    @posts.each do |post|
      xml.item do
        xml.title   post.title
        xml.link    polymorphic_url(post)
        xml.pubDate post.created_at.to_s(:rfc822)

        guid = Digest::MD5.hexdigest(post.id.to_s).slice(0, 8)
        xml.guid guid, isPermaLink: false

        xml.description Sanitize.clean(post.intro,     elements: [])
        xml.category    Sanitize.clean(post.hub.title, elements: [])

        xml.tag! "rambler:full-text" do
          text = post.intro + post.content
          xml.text! Sanitize.clean(text, :elements => [])
        end

        if post.respond_to?(:authors)
          authors = post.authors.map(&:name).join ?,
          xml.author authors.blank? ? 'artelectronics.ru' : authors
        end

        if (img = post.main_image).present?
          _img = img.url(:base, timestamp: false)
          xml.enclosure url: image_url(_img), type: img.content_type
        end
      end
    end
  end
}

# xml.instruct! :xml, version: "1.0"

# xml.rss(version: "2.0" ,
#   "xmlns:content"=> "http://purl.org/rss/1.0/modules/content/",
#   "xmlns:media"  => "http://search.yahoo.com/mrss/",
#   "xmlns:wfw"    => "http://wellformedweb.org/CommentAPI/",
#   "xmlns:dc"     => "http://purl.org/dc/elements/1.1/"
# ){
#   xml.channel do
#     xml.title "ArtElectronics, RSS feed"
#     xml.description "ArtElectronics.ru — это интернет-журнал о самых обсуждаемых трендах будущего: освоении космоса, искусственном разуме и новейших технологиях."
#     xml.link "http://artelectronics.ru"

#     @posts.each do |post|
#       xml.item do
#         xml.title post.title
#         xml.description Sanitize.clean(post.intro, :elements => [])
#         xml.link polymorphic_url(post)
#         xml.pubDate post.created_at.to_s(:rfc822)
#       end
#     end
#   end
# }
