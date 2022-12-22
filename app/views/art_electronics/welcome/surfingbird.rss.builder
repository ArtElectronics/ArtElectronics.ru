xml.instruct! :xml, version: "1.0"

xml.rss( version: "2.0",
  "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
  "xmlns:media" => "http://search.yahoo.com/mrss/",
  "xmlns:atom"  => "http://www.w3.org/2005/Atom"
  ){
  xml.channel do
    xml.language    'ru'
    xml.title       "ArtElectronics / Surfbird "
    xml.description 'ArtElectronics.ru — это интернет-журнал о самых обсуждаемых трендах будущего: освоении космоса, искусственном разуме и новейших технологиях.'
    xml.link        'http://artelectronics.ru'

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link polymorphic_url(post)

        guid = Digest::MD5.hexdigest(post.id.to_s).slice(0, 8)
        xml.guid guid, isPermaLink: false

        xml.pubDate post.created_at.to_s(:rfc822)

        xml.description do
          xml.cdata! post.intro
        end

        xml.tag! 'content:encoded' do
          xml.cdata! post.content
        end

        if post.respond_to?(:authors)
          xml.tag! 'dc:creator' do
            authors = post.authors.map(&:name).join ?,
            xml.text!(authors.blank? ? 'artelectronics.ru' : authors)
          end
        end
      end
    end
  end
}