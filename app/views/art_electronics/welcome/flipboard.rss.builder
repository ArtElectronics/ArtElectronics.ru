xml.instruct! :xml, version: "1.0"

xml.rss( version: "2.0",
  "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
  "xmlns:media" => "http://search.yahoo.com/mrss/",
  "xmlns:atom"  => "http://www.w3.org/2005/Atom"
  ){
  xml.channel do
    xml.language    'ru'
    xml.title       "ArtElectronics: #{ @feed_name }"
    xml.description 'ArtElectronics.ru — это интернет-журнал о самых обсуждаемых трендах будущего: освоении космоса, искусственном разуме и новейших технологиях.'
    xml.link        'http://artelectronics.ru'

    xml.tag!('atom:link', href: 'http://dallas.example.com/rss.xml', rel: :self, type: 'application/rss+xml')
    xml.tag!('atom:link', rel: :hub, href: 'http://pubsubhubbub.appspot.com')

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link polymorphic_url(post)

        guid = Digest::MD5.hexdigest(post.id.to_s).slice(0, 8)
        xml.guid guid, isPermaLink: false

        xml.pubDate post.created_at.to_s(:rfc822)

        if post.respond_to?(:authors)
          xml.tag! 'dc:creator' do
            authors = post.authors.map(&:name).join ?,
            xml.text!(authors.blank? ? 'artelectronics.ru' : authors)
          end
        end

        xml.description do
          xml.cdata! post.intro
        end

        xml.tag! 'content:encoded' do
          image = ''

          if (img = post.main_image).present?
            image = "
              <figure>
              <img src='#{ image_url img.url(:original, timestamp: false) }'>
              <figcaption>#{ post.title }</figcaption>
              </figure>
            "
          end

          xml.cdata! image + post.content
        end
      end
    end
  end
}
