module Remotipart
  # Responder used to automagically wrap any non-xml replies in a text-area
  # as expected by iframe-transport.
  module RenderOverrides
    include ERB::Util

    # 141204, Joon Min - Call render_with_remotipart manually only when required to save function call overhead
    # def self.included(base)
    #   base.class_eval do
    #     alias_method_chain :render, :remotipart
    #   end
    # end

    def render_with_remotipart(*args)
      render(*args)
      if remotipart_submitted?
        textarea_body = response.content_type == 'text/html' ? html_escape(response.body) : response.body
        response.body = %{<textarea data-type=\"#{response.content_type}\" data-status=\"#{response.response_code}\" data-statusText=\"#{response.message}\">#{textarea_body}</textarea>}
        response.content_type = Mime::HTML
      end
      response_body
    end
  end
end
