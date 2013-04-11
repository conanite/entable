# Entable

LibreOffice and Microsoft Office are both able to open a HTML file and interpret the contents of the &lt;table&gt; element as a worksheet.

This gem generates such a HTML file, given a collection and a configuration. For each column, the configuration specifies the column header text, and how to extract the data for each cell in that column.


## Installation

Add this line to your application's Gemfile:

    gem 'entable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install entable

## Usage


Basic usage:

    include 'entable/builder'

    def table_config
      # return a Hash that you read from somewhere
    end

    def to_xls items, *args
      @interpreter ||= build_interpreter(table_config)
      @interpreter.to_xls items, *args   # returns a HTML file as text
    end


A configuration for a simple one-row-per-item table should look like this:

     ---
     columns:
       - title:    Last Name
         content:  "%{last}"
       - title:    First Name
         content:  "%{first}"
       - title:    Address
         content:  "%{address}"


A more complex configuration, where you want to filter your collection and wrap each item, producing multiple rows per item, might look like this:

    ---
    preprocess:
      wrap: contact_export
      transform: sort_by_last_name
    multi-row:
      - - title:    Last Name
          content:  "%{last}"
        - title:    First Name
          content:  "%{ first }"
      - - title:    Address
          content:  "%{full_address}"
          attributes:
            colspan: 2

In this example, there are two lines per item, and the single cell on the second line will span two columns. Before anything happens, the collection is transformed by #sort_by_last_name, and then each item is wrapped by #contact_export

A transformer allows you sort, filter, or transform your collection in any way. The collection passed here is the collection that was passed to #to_xls above. Here's how you install a transformer:

    Entable.add_transformer :sort_by_full_name do |collection|
      collection.sort { |a, b| a.full_name <=> b.full_name }
    end

Or, similarly,

    Entable.add_transformer :sort_by_full_name do |collection|
      collection.order("full_name ASC")
    end


Wrappers are not strictly necessary; you could apply a wrapper inside a transformer.
Separating the two frees you to apply each independently.

The most important purpose of a wrapper is to provide an isolation layer between
the table configuration and your objects. Remember, the table configuration can
invoke any ruby method on each item, so if you are allowing untrusted parties
create a configuration, you need to make sure that only safe methods are exposed.

A secondary purpose of a wrapper is to expose pre-formatted data values; you might
need to provide translations for some fields, or localised versions of numbers and
dates.

To install a wrapper, call Entable#add_wrapper

    Entable.add_wrapper :contact_export do |item, *args|
      ContactTable.new item, *args
    end

In this example, the _item_ is the object to be wrapped, and _*args_ are the arguments passed to #to_xls earlier. This allows you pass any extra parameters to your wrapper that you might need in order to render each item as a row in a spreadsheet.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
