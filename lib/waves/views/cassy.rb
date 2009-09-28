# Markaby-ish way to declare CSS
# This code is based on code written by automatthew: 
#   http://github.com/automatthew/cassandra/tree/master
class Cassy
  
  HTML_TAGS = %w( a abbr acronym address area b base bdo big blockquote body br button caption cite code col colgroup dd del dfn div dl dt em fieldset form 
    h1 h2 h3 h4 h5 h6 head hr html i img input ins kbd label legend li link map meta noscript object ol optgroup option p param pre q samp script select 
    small span strong style sub sup table tbody td textarea tfoot th thead title tr tt ul var )
  
  CSS_PROPERTIES = %w( azimuth background background_attachment background_color background_image background_position background_repeat border
    border_left border_top border_right border_bottom border_collapse border_color border_spacing border_style border_top border_top_color border_top_style
    border_top_width border_width bottom caption_side clear clip color content counter_increment counter_reset cue cue_after cue_before cursor
    direction display elevation empty_cells float font font_family font_size font_size_adjust font_stretch font_style font_variant font_weight height
    left letter_spacing line_height list_style list_style_image list_style_position list_style_type margin margin_left margin_top margin_right margin_bottom
    marker_offset marks max_height max_width min_height min_width orphans outline outline_color outline_style outline_width overflow padding padding_left
    padding_top padding_right padding_bottom page page_break_after page_break_before page_break_inside pause pause_after pause_before pitch pitch_range
    play_during position quotes richness right size speak speak_header speak_numeral speak_punctuation speech_rate stress table_layout text_align
    text_decoration text_indent text_shadow text_transform top unicode_bidi vertical_align visibility voice_family volume white_space widows width
    word_spacing z_index )
  
  METHODS = %w( class include extend instance_eval send __send__ __id__ respond_to? )
  instance_methods.each { |m| undef_method( m ) unless METHODS.include? m }
  
  methods =  HTML_TAGS.each do |tag|
    module_eval( "def #{tag}(&block); selector_eval(@selector.first, '#{tag}', &block);end\n" )
  end
  
  attr_reader :data
  
  def initialize(sel=nil)
    @data = []
    @selectors = [ sel ]
    @properties = []
    
    # Primitive state machine
    # possible states are :closed_block, :chain, :open_block
    @state = :closed_block
  end
  
  def self.process(*args,&block)
    self.new.process(*args,&block)
  end
  
  def process(*args, &block)
    if block
      instance_eval(&block)
    else
      instance_eval(args.join("\n"))
    end
    self
  end
  
  def to_s
    @data.map do |sel|
      properties = sel.last.join("\n  ")
      "#{sel.first} {\n  #{properties}\n}\n"
    end.join
  end



  # Pushes an empty array on the properties stack and registers
  # that array (against the current selector) in @data
  def new_property_set
    @properties.push []
    @data << [@selectors[-1], @properties[-1] ]
  end


  # Declare a CSS selector using a block.  May be chained and nested.
  def selector(sel)
    if block_given?
      open_block(sel)
      yield
      closed_block
    else
      chain(sel)
    end
    self
  end
  
  # Catch unknown methods and treat them as CSS class or id selectors.
  def method_missing(name, &block)
    sel = selectify(name)
    if block_given?
      open_block(sel)
      yield
      closed_block
    else
      chain(sel)
    end
    self
  end
  
  # bang methods represent CSS ids.  Otherwise CSS classes.
  def selectify(method_name)
    matches = method_name.to_s.match( /([\w_]+)!$/)
    matches ? "##{matches[1]}" : ".#{method_name}"
  end


  # define tag methods that delegate to selector
  methods =  HTML_TAGS.map do |tag|
    <<-METHOD
    def #{tag}(&block)
      selector('#{tag}', &block)
    end
    METHOD
  end.join; module_eval(methods)

  # define methods for CSS properties.
  CSS_PROPERTIES.each do |method_name|
    define_method method_name do |*args|
      css_attr = method_name.gsub('_', '-')
      property(css_attr, args)
    end
  end

  # Add a property declaration string to the current selector's properties array.
  def property(css_attr, *args)
    @properties[-1] << "#{css_attr}: #{args.join(' ')};"
  end
  
  ##  State transitions
  
  # Push the accumulated selector and a new property array onto the
  # tops of their respected stacks
  def open_block(new_selector)
    case @state
    when :closed_block, :open_block
      combined_selector = [@selectors[-1], new_selector].compact.join(" ")
      @selectors.push combined_selector
      new_property_set
    when :chain
      @selectors[-1] = "#{@selectors[-1]}#{new_selector}"
      new_property_set
    else
      raise "You can't get to :open_block from #{@state.inspect}"
    end
    
    @state = :open_block
  end

  # Pushes accumulated selector on the stack without generating a new properties array.
  def chain(new_selector)
    case @state
    when :closed_block, :open_block
      combined_selector = [@selectors[-1], new_selector].compact.join(" ")
      @selectors.push( combined_selector)
    when :chain
      @selectors[-1] = "#{@selectors[-1]}#{new_selector}"
    else
      raise "You can't get to :chain from #{@state.inspect}"
    end
    
    @state = :chain
  end

  # Pop the selector string and property array for the closing block
  # off of their respective stacks
  def closed_block
    case @state
    when :open_block, :closed_block
      @selectors.pop
      @properties.pop
    else
      raise "You can't get to :closed_block from #{@state.inspect}"
    end
    
    @state = :closed_block
  end
  
end
