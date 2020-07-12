module ActionView::Template::Handlers
  class NokogiriTemplateBuilder
    class_attribute :default_format
    self.default_format = :xml

    # @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Builder
    def call(template)
      <<-RUBY
        builder = ::Nokogiri::XML::Builder.new { |xml| #{template.source} }
        save_options = ::Nokogiri::XML::Node::SaveOptions::NO_DECLARATION | \ # omit <?xml ..?> declaration
                       ::Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS      # render <tag></tag> instead of <tag />
        options = { encoding: "UTF-8", indent: 2, save_with: save_options }
        builder.to_xml(options)
      RUBY
    end
  end
end

ActionView::Template.register_template_handler :nxml, ActionView::Template::Handlers::NokogiriTemplateBuilder.new
