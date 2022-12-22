# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module NavigationHubsTreeHelper
  class Render
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]

        "
          <div level='#{ options[:level] }'>#{ show_link }</div>
          #{ children }
        "
      end

      def show_link
        node = options[:node]
        ns   = options[:namespace]
        url  = h.url_for(ns + [node])
        title_field = options[:title]

        hub = h.instance_variable_get :@hub
        klass = (hub == node) ? :current : nil

        h.link_to(node.send(title_field), url, class: klass)
      end

      def children
        options[:children] unless options[:children].blank?
      end
    end
  end
end