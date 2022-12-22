module ApplicationHelper
  def jsvoid
    "javascript:void(0);"
  end

  def on_off_marker value
    if value.blank?
      content_tag :span, raw('&Oslash;'), class: 'btn btn-default btn-xs'
    else
      content_tag :span, '✓', class: 'btn btn-success btn-xs'
    end
  end

  def system_pages
    hub = Hub.with_slug(:pages)
    return hub.pubs.published_set if hub
    Page.none
  end

  def system_hubs
    Hub.system_hubs
  end

  def model_name
    controller_name.singularize
  end

  def pub_type
    params[:pub_type] || model_name
  end

  def publication_states
    %w[ draft published ].collect{ |state| [ t("pubs.states.#{state}"), state ] }
  end

  def hub_pubs_types
    %w[ posts pages blogs ].collect{ |type| [ t("hubs.pubs_types.#{type}"), type ] }
  end
end
