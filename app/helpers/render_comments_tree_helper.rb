# coding: UTF-8
# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module RenderCommentsTreeHelper
  module Render
    class << self
      attr_accessor :h, :options

      # Main Helpers
      def controller
        @options[:controller]
      end

      def t str
        controller.t str
      end

      # Render Helpers
      def visible_draft?
        controller.try(:comments_view_token) == @comment.view_token
      end

      def moderator?
        controller.try(:current_user).try(:comments_moderator?, @comment)
      end

      # Render Methods
      def render_node(h, options)
        @h, @options = h, options
        @comment     = options[:node]

        @max_reply_depth = options[:max_reply_depth] || TheComments.config.max_reply_depth

        if @comment.draft?
          draft_comment
        else @comment.published?
          published_comment
        end
      end

      def draft_comment
        if visible_draft? || moderator?
          published_comment
        else
          "<li class='draft' title='#{ t('the_comments.waiting_for_moderation') }'>
            <div class='comment draft' id='comment_#{@comment.anchor}'>
              #{ t('the_comments.waiting_for_moderation') }
              #{ h.link_to '#', '#comment_' + @comment.anchor }
            </div>
            #{ children }
          </li>"
        end
      end

      def published_comment
        title_text = (@comment.draft? && visible_draft?) ? t('the_comments.waiting_for_moderation') : nil
        title      = title_text.present? ? "title='#{ title_text }'" : nil

        "<li #{ title }>
          <div id='comment_#{@comment.anchor}' class='comment #{@comment.state}' data-comment-id='#{@comment.to_param}'>
            <div>
              #{ avatar }
              <div class='cbody'>#{ @comment.content }</div>
              #{ reply }
            </div>
          </div>

          <div class='form_holder'></div>
          #{ children }
        </li>"
      end

      def avatar
        if @comment.user
          "<div class='userpic'>
            <a href='#{ h.user_path(@comment.user) }'>
              <img src='#{ @comment.avatar_url }' alt='userpic' nopin='nopin' />
            </a>
            #{ controls }
          </div>"
        else
          "<div class='userpic'>
            <img src='#{ @comment.avatar_url }' alt='userpic' />
            #{ controls }
          </div>"
        end
      end

      def userbar
        anchor = h.link_to('#', '#comment_' + @comment.anchor)

        title = if @comment.user
          @comment.user.username.present? ? @comment.user.username : @comment.user.login
        else
          @comment.title.present? ? @comment.title : t('the_comments.guest_name')
        end

        "<div class='userbar'><b>#{ title }</b> #{ anchor }</div>"
      end

      def moderator_controls
        if moderator?
          h.link_to(t('the_comments.edit'), h.edit_comment_url(@comment), class: :edit)
        end
      end

      def reply
        if @comment.depth < (@max_reply_depth - 1)
          "<p class='reply'><a href='#' class='reply_link'>#{ t('the_comments.reply') }</a>"
        end
      end

      def controls
        "<div class='controls'>#{ moderator_controls }</div>"
      end

      def children
        "<ol class='nested_set'>#{ options[:children] }</ol>"
      end
    end
  end
end
