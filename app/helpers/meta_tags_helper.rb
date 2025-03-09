# frozen_string_literal: true

module MetaTagsHelper
  def meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : DEFAULT_META["meta_title"]
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META["meta_description"]
  end

  def meta_author
    content_for?(:meta_author) ? content_for(:meta_author) : false
  end

  def meta_keywords
    content_for?(:meta_keywords) ? content_for(:meta_keywords) : false
  end

  def og_type
    content_for?(:og_type) ? content_for(:og_type) : "website"
  end

  def meta_image
    meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"])
    begin
      meta_image.starts_with?("http") ? meta_image : image_url(meta_image)
    rescue Sprockets::Rails::Helper::AssetNotFound
      DEFAULT_META["meta_image"]
    end
  end

  def noindex
    content_for?(:noindex)
  end

  def nofollow
    content_for?(:nofollow)
  end
end
