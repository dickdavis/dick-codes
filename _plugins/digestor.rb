# frozen_string_literal: true

module Jekyll
  module Buster
    # Handles CSS file digesting for cache busting
    class Digester
      require "digest/md5"

      @source_path = nil

      # Cache and return the source path to avoid repeated config loads
      def self.source_path
        @source_path ||= Jekyll.configuration({})["source"]
      end

      # Generate a cache-busting digest for CSS files
      # @param file_name [String] Name of the CSS file (e.g., 'styles.css')
      # @return [String] File path with appended MD5 hash query parameter
      def self.digest(file_name)
        css_path = File.join("assets", "css", file_name)
        full_path = File.join(source_path, css_path)
        return css_path unless File.exist?(full_path)

        hash = Digest::MD5.hexdigest(File.read(full_path))
        "#{css_path}?v=#{hash}"
      rescue
        css_path
      end
    end

    # Liquid filter for cache busting CSS files
    # @param file_name [String] Name of the CSS file
    # @return [String] File path with cache-busting query parameter
    def bust_css_cache(file_name)
      Digester.digest(file_name)
    end
  end
end

Liquid::Template.register_filter(Jekyll::Buster)
