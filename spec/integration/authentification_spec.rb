require 'spec_helper'

describe "Authentificaton process" do
  before :each do
    basic_authorize( 'test', 'test', :no_verbose )
  end

  subject { page }

  describe "Site pages" do
    before { visit root_path }
    it { should have_link('Регистрация') }
    it { should have_link('Вход') }
    
    it "should have SignIn page" do
      click_link 'Вход'
      should have_content 'Email'    
      should have_content 'Password'
      should have_content 'Запомнить меня'
      should_not have_content 'Login'    
    end
  end


  describe "Admin authentificaton" do
    before :each do
      UsersMacros.create_admin
      visit root_path 
    end

    it "should signin" do
      click_link 'Вход'
      fill_in 'Email',    with: 'admin@site.com'      
      fill_in 'Password', with: 'qwerty'      

      click_button "Вход"
      should have_content 'Вход в систему выполнен.'
      should have_content 'Кабинет (admin)'


      # should have admin privileges
      visit '/hubs/manage'
      should have_content 'Новый хаб'

      # should can logout
      click_link "Выход"           
      should have_content "Выход из системы выполнен."
    end

    it "should not signin" do
      click_link 'Вход'
      fill_in 'Email',    with: 'test@test.test'      
      fill_in 'Password', with: 'qwerty'      

      click_button "Вход"
      should have_content 'Неверный email или пароль' 
    end
  end

  # describe "User authentificaton" do
  #   before :each do
  #     UsersMacros.create_admin
  #     visit root_path 
  #   end
    
  #   it "should can registration" do
  #     click_link 'Регистрация'
      
  #     fill_in 'Email',     with: 'test_my_USER@ya.ru'
  #     fill_in 'Password',  with: 'password1'

  #     click_button "Зарегистрироваться"

  #     should have_content 'Добро пожаловать! Вы успешно зарегистрировались.'    
  #     should have_content 'Кабинет (test-my-user)'
  #     should have_content 'Кабинет: test-my-user'

  #     # # should not have admin privileges
  #     # visit '/hubs/manage'
  #     # should_not have_content 'Новый хаб'

  #     # # should can logout
  #     # click_link "Выход"           
  #     # should have_content "Выход из системы выполнен."
  #   end
  # end
end
