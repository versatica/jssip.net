module MyFilters

  class MyVersionSetter < ::Nanoc::Filter
    identifier :my_version_setter
    type :text

    def run content, params={}
      output = content
      output = output.gsub /_JSSIP_VERSION_/, @item[:version]  if @item[:version]
      output = output.gsub /_JSSIP_LAST_VERSION_/, ::MyLib.jssip_last_version
      output = output.gsub /_JSSIP_LAST_FULL_VERSION_/, ::MyLib.jssip_last_full_version
      output = output.gsub /_NEW_FEATURE_/, "*NEW in #{@item[:version]}*"
    end
  end


  class MyCodeGenerator < ::Nanoc::Filter
    identifier :my_code_generator
    type :text

    def run content, params={}
      output = ""
      code = ""

      in_code = false
      content.each_line do |line|
        if (m = line.match /CODE_BEGIN[ ]*(["'](?<lang>.*)["'])?[ ]*$/)
          in_code = true
          lang = m["lang"] || "javascript"
          code = m.pre_match + "<pre><code class='#{lang}'>"
        elsif line =~ /^CODE_END/
          in_code = false
          code << "</code></pre>\n"
          output << code
        elsif in_code
          code << line
        else
          output << line
        end
      end

      output
    end
  end

end

