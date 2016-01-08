# -*- coding: utf-8 -*-
#
# オブジェクトをHTMLのテーブルにして出力
#

module QuickTable
  class Htmlizer
    attr_accessor :view_context
    alias h view_context

    def self.htmlize(view_context, *args, &block)
      if block_given?
        obj = yield
        options = args.extract_options!
      else
        if args.size == 0
          return
        elsif args.size == 1
          obj = args.first
          options = {}
        else
          options = args.extract_options!
          if args.size > 1
            obj = args
          else
            obj = args.first
          end
        end
      end

      new(view_context, options).htmlize(obj, &block)
    end

    def initialize(view_context, options)
      @view_context = view_context
      @options = {
        :skip_header => false,
        :depth  => 0,
      }.merge(options)
    end

    def htmlize(obj, &block)
      return if obj.blank?

      info = function_table.find { |e| e[:if].call(obj) }
      body = info[:code].call(obj)

      if true
        if @options[:caption].present?
          body = tag(:caption, @options[:caption]) + body
        end
      end
      body = tag(:table, body, :class => table_class)
      if @options[:depth].zero?
        if @options[:responsive]
          body = tag(:div, body, :class => "table-responsive")
        end
        if true
          if @options[:title].present?
            body = tag(:h2, @options[:title], :class => "title") + body
          end
        end
      end
      tag(:div, body, :class => "quick_table quick_table_depth_#{@options[:depth]}")
    end

    private

    def function_table
      [
        # {:a => 1, :b => 2}
        # [a][1]
        # [b][2]
        {
          :if   => -> obj { obj.kind_of?(Hash) },
          :code => -> obj {
            obj.collect {|key, val|
              tr do
                th(key) + td(val)
              end
            }.join.html_safe
          },
        },

        # [{:a => 1, :b => 2}, {:a => 3, :b => 4}]
        # [a][b]
        # [1][2]
        # [3][4]
        {
          :if   => -> obj { obj.kind_of?(Array) && obj.all?{|e|e.kind_of?(Hash)} },
          :code => -> obj {
            keys = obj.inject([]) { |a, e| a | e.keys }
            body = "".html_safe
            unless @options[:skip_header]
              body += tag(:thead) do
                tr do
                  keys.collect {|e| th(e) }.join.html_safe
                end
              end
            end
            body + tag(:tbody) do
              obj.collect { |hash|
                tr do
                  keys.collect { |key| td(hash[key]) }.join.html_safe
                end
              }.join.html_safe
            end
          },
        },

        # [[:a, :b], [ 1,  2], [ 3,  4]]
        # [a][b]
        # [1][2]
        # [3][4]
        {
          :if   => -> obj { obj.kind_of?(Array) && obj.all?{|e|e.kind_of?(Array)} },
          :code => -> obj {
            tag(:tbody) do
              obj.collect { |elems|
                tr do
                  elems.collect { |e| td(e) }.join.html_safe
                end
              }.join.html_safe
            end
          },
        },

        # [:a, :b]
        # [a][b]
        {
          :if   => -> obj { obj.kind_of?(Array) },
          :code => -> obj {
            tag(:tbody) do
              tr do
                obj.collect { |e| td(e) }.join.html_safe
              end
            end
          },
        },

        # :a
        # [a]
        {
          :if   => -> obj { true },
          :code => -> obj {
            tag(:tbody) do
              tr { td(obj) }
            end
          },
        },
      ]
    end

    def tag(*args, &block)
      h.content_tag(*args, &block)
    end

    def tr(&block)
      tag(:tr, &block)
    end

    def th(val)
      tag(:th, val)
    end

    def td(val)
      tag(:td, value_as_string(val))
    end

    def value_as_string(val)
      if val.kind_of?(Array) || val.kind_of?(Hash)
        self.class.htmlize(view_context, @options.merge(:depth => @options[:depth].next)) { val }
      else
        val
      end
    end

    def table_class
      # return "table table-condensed table-bordered table-striped"
      "table #{@options[:table_class]}".squish.scan(/\S+/).uniq.join(" ")
    end
  end
end
