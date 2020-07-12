class ApplicationError < StandardError

  attr_accessor :details, :initial_exception
  attr_writer :code, :http_status_code, :message, :title

  def initialize(opts = {})
    @code, @http_status_code, @title, @message = opts.values_at(:code, :http_status_code, :title, :message)
    @initial_exception, @details = opts.values_at(:initial_exception, :details)
  end

  def to_h
    {
      code: code,
      details: details,
      http_status_code: http_status_code,
      initial_exception: initial_exception,
      message: message,
      title: title,
    }
  end

  def inspect
    "#<#{self.class.name}: #{@title || @message}>"
  end

  def self.const_missing(name)
    # Calculate slug name "application_error.subclass_name".
    slug = "#{self.name}::#{name}".underscore.gsub("/", ".")
    raise NameError, "cant dynamically create #{name} - no translation defined" unless I18n.exists?(slug)
    klass = Class.new(ApplicationError) do |k|
      define_method(:slug) { slug }
      # Define reader methods with fallback to I18N under <locale>.application_error.<class_name>
      %i[code http_status_code message title].each do |m|
        define_method(m) { instance_variable_get("@#{m}") || I18n.t("#{slug}.#{m}", default: nil) }
      end
    end
    return self.const_set(name, klass)
  end
end
