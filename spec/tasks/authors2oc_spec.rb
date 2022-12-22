require "spec_helper"
require "#{Rails.root}/lib/tasks/includes/helpers.rb"
require "#{Rails.root}/lib/tasks/includes/connect_ae_db.rb"

describe "Authors drags" do
  before(:each) do
    UsersMacros.create_admin
    @post = PostsMacros.create_post_for(User.root)
  end

  it "get articles titles by author from old base" do
    author = AE_Author.first

    old_articles = get_article_titles author
    old_articles.first.should eq 'Стэнли Кубрик'
    old_articles[1].should eq 'Blow up'
    old_articles.last.should eq '«Автокатастрофа» Дэвида Кроненберга     '
  end
end

