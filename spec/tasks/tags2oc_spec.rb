require "spec_helper"
require "#{Rails.root}/lib/tasks/includes/helpers.rb"
require "#{Rails.root}/lib/tasks/includes/connect_ae_db.rb"

describe "Articles tags transportation" do
  before(:each) do
    UsersMacros.create_admin
    @post = PostsMacros.create_post_for(User.root)
  end

  # проверяет как работает helper получения тегов из старой базы, так как там другя версия гема acts_as_aggable-on и по другому получить теги я не получится
  it "should good transform old tags to hash" do
    result = get_tags_by_context AE_Article.find(13), :names, :titles, :words
    result[:names].should eq ["Артур Кларк", "Рихард Штраус", "Стэнли Кубрик"]
    result[:titles].should eq ["Путешествие на Луну", "Доктор Стрейнджлав", "Широко закрытые глаза", "2001.Космическая Одиссея"]
    result[:words].should eq ["Космос", "Кино", "Science Fiction"]
  end

  it "should can create tags" do
    old_article = AE_Article.find 13
    new_article = @post
    create_tags old_article, new_article
    new_article.reload

    new_article.name_list.should == ["Артур Кларк", "Рихард Штраус", "Стэнли Кубрик"]
    new_article.title_list.should == ["Путешествие на Луну", "Доктор Стрейнджлав", "Широко закрытые глаза", "2001.Космическая Одиссея"]
    new_article.word_list.should == ["Космос", "Кино", "Science Fiction"]
  end

  it "should can compare articles tags difference" do
    old_article = AE_Article.find 13

    result = compare_article_tags old_article, @post

    result.should eq false 
  end

  it "should can compare articles tags match" do
    old_article = AE_Article.find 13
    @post.title = old_article.title
    @post.name_list  = ["Артур Кларк", "Рихард Штраус", "Стэнли Кубрик"]
    @post.title_list = ["Путешествие на Луну", "Доктор Стрейнджлав", "Широко закрытые глаза", "2001.Космическая Одиссея"]
    @post.word_list  = ["Космос", "Кино", "Science Fiction"]
    @post.save
    @post.reload

    result = compare_article_tags old_article, @post

    result.should eq true 
  end
end

# просто делает запрос к старой базе, тестируя sql запрос
describe "Old base"do
  it "test sql query " do
    sql="select name from tags inner join taggings on tags.id = taggings.tag_id where taggable_id = 13 and taggable_type='Article' and context='names'"
    result = AE_FullDatabase.connection.execute(sql)
    
    # puts result.inspect

    # result.each do |row| 
    #   puts row
    # end 

    # puts record_array.inspect
    1.should == 1
  end
end