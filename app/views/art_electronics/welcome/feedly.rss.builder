# http://blog.feedly.com/2015/07/31/10-ways-to-optimize-your-feed-for-feedly/#more-6276

xml.instruct! :xml, :version => "1.0"
xml.rss(
  :version => "2.0",
  "xmlns:content"  => "http://purl.org/rss/1.0/modules/content/",
  "xmlns:webfeeds" => "http://webfeeds.org/rss/1.0"
  ){

  xml.channel do
    xml.title "ArtElectronics. Футурологический журнал"
    xml.description "О самых обсуждаемых трендах будущего"

    xml.link "http://blog.feedly.com" # ???
    # xml.tag! 'atom:link', href: 'http://blog.feedly.com/feed/', rel: 'self', type: 'application/rss+xml'

    xml.tag! 'webfeeds:icon' do
      xml.text! "http://feedly.com/icon.svg"
    end

    xml.tag! 'webfeeds:cover' do
      xml.text! image_url "/ae1024x1024.png"
    end

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
