xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0" ,
  "xmlns:content"=>"http://purl.org/rss/1.0/modules/content/",
  "xmlns:media"=>"http://search.yahoo.com/mrss/",
  "xmlns:wfw"=>"http://wellformedweb.org/CommentAPI/",
  "xmlns:dc"=>"http://purl.org/dc/elements/1.1/"){

  xml.channel do
    xml.title "ArtElectronics, RSS telegraf feed"
    xml.description "ArtElectronics.ru — это интернет-журнал о самых обсуждаемых трендах будущего: освоении космоса, искусственном разуме и новейших технологиях."
    xml.link "http://artelectronics.ru"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.intro + post.content
        xml.link polymorphic_url(post)
        xml.pubDate post.created_at.to_s(:rfc822)
      end
    end
  end
}
