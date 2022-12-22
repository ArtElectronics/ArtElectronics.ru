xml.instruct! :xml, :version=>"1.0"

xml.rss(
    version: '2.0',
    "xmlns:yandex" => "http://news.yandex.ru",
    "xmlns:media"  => "http://search.yahoo.com/mrss/"
  ){

  xml.channel do
    xml.title "ArtElectronics: Публикации"
    xml.link  "http://artelectronics.ru"
    xml.description "Интернет-журнал о самых обсуждаемых трендах будущего: освоении космоса, искусственном разуме и новейших технологиях"

    xml.tag! 'yandex:logo' do
      xml.text! image_url('/ae180x180.png')
    end

    xml.tag! 'yandex:logo', type: :square do
      xml.text! image_url('/ae180x180.png')
    end

    @posts.each do |post|
      xml.item do
        xml.title   post.title
        xml.link    polymorphic_url(post)
        xml.pubDate post.created_at.to_s(:rfc822)

        # guid = Digest::MD5.hexdigest(post.id.to_s).slice(0, 8)
        # xml.guid guid, isPermaLink: false

        xml.tag! "yandex:full-text" do
          text = post.intro + post.content
          xml.text! Sanitize.clean(text, :elements => [])
        end

        xml.description post.intro

        xml.tag! 'yandex:genre', {} { xml.text! 'article' }
        xml.category post.hub.title

        if post.respond_to?(:authors)
          xml.author post.authors.map(&:name).join ?,
        end

        if (img = post.main_image).present?
          xml.enclosure url: image_url(img.url(:base, timestamp: false)), type: img.content_type
        end

        # if (img = post.main_image).present?
        #   length = File.exists?(file_path = img.path(:base)) ? file_path : 0
        #   xml.enclosure url: image_url(img.url(:base, timestamp: false)), length: length, type: img.content_type
        # end
      end
    end
  end
}
