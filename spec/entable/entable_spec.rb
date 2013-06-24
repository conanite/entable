# -*- coding: utf-8 -*-

require File.expand_path('../../spec_helper', __FILE__)

describe Entable do

  it "should generate a very simple table with one row per item" do
    config = {
      "columns" => [
                    { "title" => "First",    "content" => "%{firstname}" },
                    { "title" => "Last",     "content" => "%{lastname}"  },
                    { "title" => "Phone",    "content" => "%{phone}"     },
                    { "title" => "Postcode", "content" => "%{postcode}"  },
                   ]
    }
    Exporter.new(config).to_xls(CONTACTS).should == %{<html><head><meta content='application/vnd.ms-excel;charset=UTF-8' http-equiv='Content-Type'><meta content='UTF-8' http-equiv='Encoding'></head><body><table>
<tr><td>First</td> <td>Last</td> <td>Phone</td> <td>Postcode</td></tr>
<tr><td>Conan</td> <td>Dalton</td> <td>01234567</td> <td>75020</td></tr>
<tr><td>Zed</td> <td>Zenumbra</td> <td>999999</td> <td>99999</td></tr>
<tr><td>Abraham</td> <td>Aardvark</td> <td>0000000</td> <td>0</td></tr>
<tr><td>James</td> <td>Joyce</td> <td>3647583</td> <td>75001</td></tr>
</table></body></html>}
  end

  it "should generate a simple table wrapping each item first" do
    config = {
      "preprocess" => {
        "wrap" => "uppercase"
      },
      "columns" => [
                    { "title" => "First",    "content" => "%{firstname}" },
                    { "title" => "Last",     "content" => "%{lastname}"  },
                    { "title" => "Phone",    "content" => "%{phone}"     },
                   ]
    }
    Exporter.new(config).to_xls(CONTACTS).should == %{<html><head><meta content='application/vnd.ms-excel;charset=UTF-8' http-equiv='Content-Type'><meta content='UTF-8' http-equiv='Encoding'></head><body><table>
<tr><td>First</td> <td>Last</td> <td>Phone</td></tr>
<tr><td>CONAN</td> <td>DALTON</td> <td>01234567</td></tr>
<tr><td>ZED</td> <td>ZENUMBRA</td> <td>999999</td></tr>
<tr><td>ABRAHAM</td> <td>AARDVARK</td> <td>0000000</td></tr>
<tr><td>JAMES</td> <td>JOYCE</td> <td>3647583</td></tr>
</table></body></html>}
  end

  it "should generate a simple table sorting items first" do
    config = {
      "preprocess" => {
        "transform" => "sort_by_last_name"
      },
      "columns" => [
                    { "title" => "First",    "content" => "%{firstname}" },
                    { "title" => "Last",     "content" => "%{lastname}"  },
                    { "title" => "Phone",    "content" => "%{phone}"     },
                   ]
    }
    Exporter.new(config).to_xls(CONTACTS).should == %{<html><head><meta content='application/vnd.ms-excel;charset=UTF-8' http-equiv='Content-Type'><meta content='UTF-8' http-equiv='Encoding'></head><body><table>
<tr><td>First</td> <td>Last</td> <td>Phone</td></tr>
<tr><td>Abraham</td> <td>Aardvark</td> <td>0000000</td></tr>
<tr><td>Conan</td> <td>Dalton</td> <td>01234567</td></tr>
<tr><td>James</td> <td>Joyce</td> <td>3647583</td></tr>
<tr><td>Zed</td> <td>Zenumbra</td> <td>999999</td></tr>
</table></body></html>}
  end

  it "should generate a simple table, with two of each item" do
    config = {
      "preprocess" => {
        "transform" => "double_each_item"
      },
      "columns" => [
                    { "title" => "First",    "content" => "%{firstname}" },
                    { "title" => "Last",     "content" => "%{lastname}"  }
                   ]
    }
    Exporter.new(config).to_xls(CONTACTS).should == %{<html><head><meta content='application/vnd.ms-excel;charset=UTF-8' http-equiv='Content-Type'><meta content='UTF-8' http-equiv='Encoding'></head><body><table>
<tr><td>First</td> <td>Last</td></tr>
<tr><td>Conan</td> <td>Dalton</td></tr>
<tr><td>Conan</td> <td>Dalton</td></tr>
<tr><td>Zed</td> <td>Zenumbra</td></tr>
<tr><td>Zed</td> <td>Zenumbra</td></tr>
<tr><td>Abraham</td> <td>Aardvark</td></tr>
<tr><td>Abraham</td> <td>Aardvark</td></tr>
<tr><td>James</td> <td>Joyce</td></tr>
<tr><td>James</td> <td>Joyce</td></tr>
</table></body></html>}
  end


  it "should generate a table with two rows per item, applying #colspan attribute " do
    config = {
      "multi-row" => [
                      [
                       { "title" => "First",    "content" => "%{firstname}" },
                       { "title" => "Last",     "content" => "%{lastname}"  },
                      ],
                      [
                       { "title" => "Postcode",    "content" => "%{postcode}", "attributes" => { "colspan" => 2 } },
                      ]
                     ]
    }
    Exporter.new(config).to_xls(CONTACTS).should == %{<html><head><meta content='application/vnd.ms-excel;charset=UTF-8' http-equiv='Content-Type'><meta content='UTF-8' http-equiv='Encoding'></head><body><table>
<tr><td>First</td> <td>Last</td></tr>
<tr><td colspan=2>Postcode</td></tr>
<tr><td>Conan</td> <td>Dalton</td></tr>
<tr><td colspan=2>75020</td></tr>
<tr><td>Zed</td> <td>Zenumbra</td></tr>
<tr><td colspan=2>99999</td></tr>
<tr><td>Abraham</td> <td>Aardvark</td></tr>
<tr><td colspan=2>0</td></tr>
<tr><td>James</td> <td>Joyce</td></tr>
<tr><td colspan=2>75001</td></tr>
</table></body></html>}
  end


  it "should generate a table with two rows per item, applying #colspan attribute, sorting by last name, uppercasing names " do
    config = {
      "preprocess" => {
        "transform" => "sort_by_last_name",
        "wrap" => "uppercase"
      },
      "multi-row" => [
                      [
                       { "title" => "First",    "content" => "%{firstname}" },
                       { "title" => "Last",     "content" => "%{lastname}"  },
                      ],
                      [
                       { "title" => "Postcode",    "content" => "%{postcode}", "attributes" => { "colspan" => 2 } },
                      ]
                     ]
    }
    Exporter.new(config).to_xls(CONTACTS).should == %{<html><head><meta content='application/vnd.ms-excel;charset=UTF-8' http-equiv='Content-Type'><meta content='UTF-8' http-equiv='Encoding'></head><body><table>
<tr><td>First</td> <td>Last</td></tr>
<tr><td colspan=2>Postcode</td></tr>
<tr><td>ABRAHAM</td> <td>AARDVARK</td></tr>
<tr><td colspan=2>0</td></tr>
<tr><td>CONAN</td> <td>DALTON</td></tr>
<tr><td colspan=2>75020</td></tr>
<tr><td>JAMES</td> <td>JOYCE</td></tr>
<tr><td colspan=2>75001</td></tr>
<tr><td>ZED</td> <td>ZENUMBRA</td></tr>
<tr><td colspan=2>99999</td></tr>
</table></body></html>}
  end

  it "should generate a simple table, reversing names, capitalizing some, applying prefix and postfix" do
    config = {
      "preprocess" => {
        "transform" => "alernating_boolean",
        "wrap" => "reversi"
      },
      "columns" => [
                    { "title" => "First",    "content" => "%{firstname}" },
                    { "title" => "Last",     "content" => "%{lastname}"  },
                    { "title" => "Phone",    "content" => "%{phone}"     },
                    { "title" => "Postcode", "content" => "%{postcode}"  },
                   ]
    }
    Exporter.new(config).to_xls(CONTACTS, "PREFIX", "POSTFIX").should == %{<html><head><meta content='application/vnd.ms-excel;charset=UTF-8' http-equiv='Content-Type'><meta content='UTF-8' http-equiv='Encoding'></head><body><table>
<tr><td>First</td> <td>Last</td> <td>Phone</td> <td>Postcode</td></tr>
<tr><td>Nanoc</td> <td>Notlad</td> <td>PREFIX01234567</td> <td>75020POSTFIX</td></tr>
<tr><td>dez</td> <td>arbmunez</td> <td>PREFIX999999</td> <td>99999POSTFIX</td></tr>
<tr><td>Maharba</td> <td>Kravdraa</td> <td>PREFIX0000000</td> <td>0POSTFIX</td></tr>
<tr><td>semaj</td> <td>ecyoj</td> <td>PREFIX3647583</td> <td>75001POSTFIX</td></tr>
</table></body></html>}
  end

  it "should escape double-quotes when necessary" do
    self.class.send :include, Entable::XlsExport
    quote_for_xls('2, "The Hammonds"').should == '="2, ""The Hammonds"""'
  end

end
