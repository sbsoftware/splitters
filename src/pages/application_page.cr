require "../views/application_layout"

abstract class ApplicationPage < Crumble::Page
  layout ApplicationLayout

  def redirect(new_path : String)
    ctx.response.status_code = 303
    ctx.response.headers["Location"] = new_path
  end

  def render(tpl)
    ctx.response.headers["Content-Type"] = "text/html"

    if layout = page_layout
      layout.to_html(ctx.response) do |io, indent_level|
        if tpl.responds_to?(:to_html)
          tpl.to_html(io, indent_level)
        else
          tpl.to_s(io)
        end
      end
    else
      if tpl.responds_to?(:to_html)
        tpl.to_html(ctx.response)
      else
        tpl.to_s(ctx.response)
      end
    end
  end
end
