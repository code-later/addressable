require "addressable/uri"

module Addressable
  class URI
    ##
    # A data URI
    class Data < self
      def self.scheme
        return "data"
      end

      def prefix
        segments = self.path.split(",", -1)
        segments.pop
        segments.join(",")
      end
      private :prefix

      def suffix
        segments = self.path.split(",", -1)
        segments.pop
      end
      private :suffix

      def media_type
        trimmed = prefix.sub(/;\s*base64$/, "")
        if trimmed != ""
          return self.class.unencode_component(trimmed)
        else
          # This is the default media type.
          return "text/plain;charset=US-ASCII"
        end
      end

      def data
        if self.base64?
          require "base64"
          return Base64.decode64(self.class.unencode_component(suffix))
        else
          return self.class.unencode_component(suffix)
        end
      end

      def base64?
        # This is slightly more lenient than the spec.
        return !!(self.class.unencode_component(prefix) =~ /;\s*base64$/)
      end
    end
  end
end