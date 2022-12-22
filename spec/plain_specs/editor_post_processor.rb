dir = File.expand_path('../',  __FILE__)

src  = "#{ dir }/editor_html.txt"
dest = "#{ dir }/editor_html_res.txt"

content = File.read src

# <p style="text-align: justify;"></p>         #=> <br>
# <p style="text-align: justify;">   <br> </p> #=> <br>
def empty_p2br content
  txt = content.dup

  txt.scan(/(<p.*?>)(.*?)(<\/p>)/mix).each do |item|
    start   = item[0]
    content = item[1]
    fin     = item[2]

    # <p style="text-align: justify;"></p>         #=> <br>
    if content.match(/\A[[:space:]]*\Z/mix)
      pattern = item.join ''
      txt = txt.gsub pattern, '<br>'
    end

    # <p style="text-align: justify;">   <br> </p> #=> <br>
    if content.match(/\A[[:space:]]*<br>[[:space:]]*\Z/mix)
      pattern = item.join ''
      txt = txt.gsub pattern, '<br>'
    end
  end

  txt
end

def wrap_nofollow_with_noindex content
  txt = content.dup

  txt.scan(/(<a.*?>)(.*?)(<\/a>)/mix) do |item|
    start   = item[0]
    content = item[1]
    fin     = item[2]

    if start.match(/nofollow/)
      pattern = item.join ''
      txt = txt.gsub pattern, "<noindex>#{ pattern }</noindex>"
    end
  end

  txt
end

content = empty_p2br content
content = wrap_nofollow_with_noindex content

f = File.open(dest, 'w')
f.write content
f.close

# TODO: to <br>
# <p style="text-align: justify;"><br></p>

# <p style="text-align: justify;"> </p>

# <p> </p>
# Example:
# <a(.*?)>(.*?)<\/a>
