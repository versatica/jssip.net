module MyLib

  # Update these attributes for new stable releases.
  @jssip_last_version = "0.6.x"
  @jssip_last_full_version = "0.7.6"

  class << self
    attr_reader :jssip_last_version, :jssip_last_full_version
  end

  class Error < ::StandardError ; end

  def my_lib_breadcrumbs
    breadcrumbs = "/ " + link_to("home", "/") + " / "

    breadcrumbs_trail.each do |parent|
      if @item == parent
        unless @item[:title]
          raise Error, "my_lib_breadcrumbs(): item #{@item.identifier.inspect} has no [:title] field"
        end
        breadcrumbs << @item[:title]
      elsif parent.parent
        unless parent[:title]
          raise Error, "my_lib_breadcrumbs(): parent #{@item.identifier.inspect} has no [:title] field"
        end
        unless parent[:no_breadcrumbs]
          breadcrumbs << link_to(parent[:title], parent)
        else
          breadcrumbs << parent[:title]
        end
        breadcrumbs << " / "
      end
    end

    breadcrumbs
  end

  def my_lib_get_item_with_path path
    # Remove possible "/" at the end of the path.
    path.gsub!(/\/$/,"")

    # Complete the absolute path with the current item's parent path
    # if it does not start with "/".
    if path !~ /^\//
      path = @item.parent.identifier + path
    end

    # Add a "/" at the end.
    path = path << "/"

    # Search for the item and return it.
    items = @items.select {|child| child.identifier == path}
    if items.empty?
      raise Error, "item with path #{path.inspect} not found"
    end
    items.first
  end

  def my_lib_link_to path, options={}
    anchor = path.split("#")[1]
    path = path.split("#")[0]

    item = my_lib_get_item_with_path path
    unless item[:title]
      raise Error, "item with path #{path.inspect} has no [:title] field"
    end

    link_text = options[:text] || item[:link_text] || item[:title]

    link_to(link_text, item.path + (anchor ? "#" << anchor : ""))
  end

  def my_lib_gravatar email
    hash = ::Digest::MD5.hexdigest email.downcase
    image_src = "http://www.gravatar.com/avatar/#{hash}"
    return "<img class='gravatar' src='http://www.gravatar.com/avatar/#{hash}?s=80&amp;d=mm' />"
  end

  def my_lib_api_method name
    method_name = name.split("(")[0]
    method_params = name.split("(")[1] || ""
    unless method_params.empty?
      method_params = "(" + method_params
    end

    "<strong><code>#{method_name}</code></strong><code class='normal'>#{method_params}</code>"
  end

  def my_lib_api_parameters params={}
    output = "<dl class='api params'>"
    params.each do |param, desc|
      output << "<dt><code>#{param}</code></dt>"
      output << "<dd>#{desc}</dd>"
    end
    output << "</dl>"

    output
  end

end

include ::MyLib
