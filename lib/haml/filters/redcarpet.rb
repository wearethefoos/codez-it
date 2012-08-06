require 'redcarpet'
require 'albino'

module Haml::Filters::Redcarpet
  include Haml::Filters::Base

  def render(text)
    markdown = Redcarpet::Markdown.new(HTMLWithPants.new(hard_wrap: true, filter_html: true, with_toc_data: true), {autolink: true, no_intra_emphasis: true, fenced_code_blocks: true, strikethrough: true})
    syntax_highlighter(markdown.render(text))
  end

  def syntax_highlighter(html)
    require 'nokogiri'
    doc = Nokogiri::HTML(html)
    doc.search("//pre/code[@class]").each do |code|
      code.parent.replace Albino.colorize(code.text.rstrip, 'ruby') #code[:class])
    end
    doc.to_s
  end

  class HTMLWithPants < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants
  end
end
