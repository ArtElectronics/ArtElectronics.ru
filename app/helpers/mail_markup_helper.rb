module MailMarkupHelper
  def zero; "margin:0;padding:0;" ; end
  def img_zero; { border: 0, align: :bottom, style: 'display:block;align:bottom;border:none;' + zero }; end

  # addons
  def iblock; "display:inline-block;" ; end
  def showme; "border: 1px solid red;" ; end

  # fonts
  def arial; "font-family:Arial;" ; end
  def times; "font-family:Times;" ; end

  # text align
  def text_left; "text-align:left;" ; end
  def text_center; "text-align:center;" ; end
  def text_right; "text-align:right;" ; end
  def text_just; "text-align:justify;" ; end

  # font style
  def bold; "font-weight:bold;" ; end
  def italic; "font-style:italic;" ; end

  # table
  def table; { border: 0, valign: :top, cellpadding: 0, cellspacing: 0 } ; end
  def td; { valign: :top, align: :left } ; end
  def tbg(x); { bgcolor: x } ; end

  # custom
  def wjoin2; { colspan: 2 } ; end
  def wjoin3; { colspan: 3 } ; end
  def wjoin4; { colspan: 4 } ; end
  def wjoin n; { colspan: n } ; end

  # bg color
  def bg(x); "background:#{x};" ; end

  # force color
  def fc(x, important = false);
    i = important ? ' !important' : ''
    "color:#{x}#{i};"
  end

  def white; "color:white;" ; end
  def gray; "color:#555;" ; end
  def red; "color:red;" ; end
  def green; "color:green;" ; end
  def blue; "color:blue;" ; end
  def black; "color:black;" ; end

  50.times do |i|
    # BASE
    eval <<-TEXT
      def lh#{10*i}; "line-height:#{10*i}%;" ; end
      def fs#{i}; "font-size:#{i}px;" ; end

      def p#{i}; "padding:#{i}px;" ; end
      def m#{i}; "margin:#{i}px;" ; end

      def pt#{i}; "padding-top:#{i}px;" ; end
      def pr#{i}; "padding-right:#{i}px;" ; end
      def pb#{i}; "padding-bottom:#{i}px;" ; end
      def pl#{i}; "padding-left:#{i}px;" ; end

      def mt#{i}; "margin-top:#{i}px;" ; end
      def mr#{i}; "margin-right:#{i}px;" ; end
      def mb#{i}; "margin-bottom:#{i}px;" ; end
      def ml#{i}; "margin-left:#{i}px;" ; end
    TEXT
  end
end
