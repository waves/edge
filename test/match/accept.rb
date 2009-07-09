require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require 'test/helpers.rb'

require 'waves/foundations/compact'
require "waves/runtime/mime_types"

describe "Accept header matching" do
  
  Accept = Waves::Accept
  
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "matches correct accept header" do
    
    Test::Resources::Map.on( :get, [ "foo" ], :accept => "text/javascript" ) { }

    resp = get "/foo"
    resp.status.should == 404

    resp = get "/foo", "HTTP_ACCEPT" => "text/javascript"
    resp.status.should == 200
    
  end

  feature 'Accept header is being parsed parses in the right way.' do
    accept_header = "text/*, text/html ;q=0.3, text/html;q=0.7, text/html;level=1, text/html;level=2;q=0.4, */*;q=0.5"
    terms = Accept.parse(accept_header)
    terms.size.should == 6
    terms.map{|term,params| term }.uniq[0] == %w( text html )

    accept_header = "text/html,application/xhtml+xml;q=0.95,application/xml;q=0.9,*/*;q=0.8"
    terms = Accept.parse(accept_header)
    terms.size.should == 4
    terms[0][0].should == %w( text html )
    terms[1][0].should == %w( application xhtml+xml )
    terms[2][0].should == %w( application xml )
    terms[3][0].should == [ true, true ]

    accept_header = "text/css,*/*;q=0.1"
    terms = Accept.parse(accept_header)
    terms.size.should == 2
    terms[0][0].should == %w( text css )
    terms[1][0].should == [ true, true ]

    accept_header = "image/png,image/*;q=0.8,*/*;q=0.5"
    terms = Accept.parse(accept_header)
    terms.size.should == 3
    terms[0][0].should == %w( image png )
    terms[1][0].should == [ 'image', true ]
    terms[2][0].should == [ true, true ]
  end

  feature 'Should return all the terms in a Accept-Charset header' do
    accept_charset_header = "ISO-8859-1,utf-8;q=0.7,*;q=0.7"
    terms = Accept.parse( accept_charset_header )
    terms.size.should == 3
    terms[0][0].should == [ 'ISO-8859-1' ]
    terms[1][0].should == [ 'utf-8' ]
    terms[2][0].should == [ true ]
  end

  feature 'Should return all the terms in a Accept-Language header' do
    accept_language_header = "en-us,en;q=0.5"
    terms = Accept.parse(accept_language_header)
    terms.size.should == 2
    terms[0][0][0] == 'en-us'
    terms[1][0][0] == 'en'
  end
  
end
