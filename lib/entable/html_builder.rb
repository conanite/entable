module Entable::HtmlBuilder
  class ContentDefinitionError < StandardError; end

  def parse_column_content str, errors
    error = false

    str = str.strip.gsub(/%\{[^}]*\}/) { |match|
      attr = match.gsub(/^%\{/, '').gsub(/\}$/, '').gsub(/-/, '_').strip
      if attr.match(/^[a-zA-Z_][a-zA-Z0-9_\.]*$/)
        "%{item.#{attr}}"
      else
        errors << "prohibited attribute #{match}"
        error = true
      end
    }

    raise ContentDefinitionError.new if error
    str
  end

  def parse_column_definitions conf
    title_rows = []
    content_rows = []
    attribute_rows = []
    errors = []

    raise "no config: #{conf.inspect}" unless conf.is_a?(Hash)

    rows = conf["multi-row"]
    if rows.nil?
      one_row = conf["columns"]
      rows = one_row ? [one_row] : []
    end

    rows.each do |columns|
      titles = []
      contents = []
      attrs = []

      columns.each do |column_def|
        titles << column_def["title"]
        attrs << (column_def["attributes"] || { })
        begin
          contents << parse_column_content(column_def["content"], errors)
        rescue ContentDefinitionError => e
        end
      end

      title_rows   << titles
      content_rows << contents
      attribute_rows << attrs
    end

    raise errors.join("\n") unless errors.empty?

    preprocess = conf["preprocess"] || { }
    [title_rows, content_rows, attribute_rows, preprocess["transform"], preprocess["wrap"]]
  end

  def build_title_rows title_rows, attribute_rows
    titles = title_rows.zip(attribute_rows).map { |tr, attrs|
      "<tr>" + tr.zip(attrs).map { |t, attr|
        colspan_attr = attr["colspan"] ? " colspan=#{attr["colspan"]}" : ""
        "<td#{colspan_attr}>#{quote_for_xls(to_utf8 t)}</td>"}.join(" ") + "</tr>"
    }.join("\n")
  end

  def build_line_interpreter columns, attrs
    columns.zip(attrs).map { |cell, attr|
      colspan_attr = attr["colspan"] ? " colspan=#{attr["colspan"]}" : ""
      "<td#{colspan_attr}>\#{to_utf8(#{cell.inspect})}</td>"
    }.join(' ').gsub("%{", '#{')
  end

  def build_interpreter spreadsheet_config
    title_rows, content_rows, attribute_rows, transformer, wrapper = parse_column_definitions(spreadsheet_config)
    titles = build_title_rows title_rows, attribute_rows
    titles = to_utf8 "\n#{titles}\n"

    code = <<CODE

    include Entable::XlsExport

    def to_xls items, *args
      #{transformer ? "items = Entable::Transformer.apply_transform(items, :#{transformer})" : ""}
      #{wrapper ? "items = Entable::Wrapper.apply_wrapper :#{wrapper}, items, *args" : ""}
      #{ "#{xls_html_prologue}#{titles}".inspect } + content(items) + #{xls_html_epilogue.inspect}
    end

    def lines item
       "#{content_rows.zip(attribute_rows).map { |row, attrs| "<tr>#{build_line_interpreter row, attrs}</tr>\\n" }.join }"
    end

    def content(items)
      items.map { |item| lines(item) }.join
    end
CODE

    Class.new do; class_eval code; end.new
  end
end
