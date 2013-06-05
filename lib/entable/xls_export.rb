# -*- coding: utf-8 -*-

module Entable::XlsExport
  def enc; "UTF-8"; end

  def csv_date date
    return I18n.l(date, :format => :csv) if date
  end

  def xls_html_prologue
    "<html><head><meta content='application/vnd.ms-excel;charset=#{enc}' http-equiv='Content-Type'><meta content='#{enc}' http-equiv='Encoding'></head><body><table>"
  end

  def xls_html_epilogue
    "</table></body></html>"
  end

  def to_utf8 str
    (str || "").encode(enc)
  rescue
    raise "unable to convert '#{str}' to #{enc}"
  end

  def array_for_xls item
    item.is_a?(Array) ? item : item.to_csv_array
  end

  def items_as_xls_string items
    prologue = xls_html_prologue
    epilogue = xls_html_epilogue
    items    = items.map { |item| array_for_xls(item) }
    items    = items.map { |item| yield item } if block_given?
    lines    = items.map { |item| "<tr><td>" + item.join("</td><td>") + "</td></tr>" }
    lines    = lines.map { |line| to_utf8 line }
    prologue + lines.join("\n") + epilogue
  end

  def write_items_as_xls items, &block
    write_text_as_xls items_as_xls_string(items, &block)
  end

  def write_text_as_xls text
    render :text => text, :content_type => "application/vnd.ms-excel; charset=#{enc}"
  end

  def quote_for_xls text
    (text.is_a?(String) && needs_quoting?(text)) ? "=\"#{text}\"" : text
  end

  def needs_quoting? text
    text.is_a?(String) && (text.match(/^0\d+$/) || text.match(/^\d+[^\d]+/))
  end

  def make_filename filename
    return filename.reject { |x| x.blank? }.join(" ").strip.gsub(/ +/, '-') if filename.is_a?(Array)
    filename
  end

  def set_xls_headers filename
    headers["Content-Type"] = "application/vnd.ms-excel; charset=#{enc}"
    headers["Content-disposition"] = "attachment; filename=\"#{make_filename filename}.xls\""
    headers["charset"] = enc
  end
end
