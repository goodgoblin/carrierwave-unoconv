module CarrierWave
  module UNOConv
    extend ActiveSupport::Concern
    module ClassMethods
      def uno_convert format
        process uno_convert: format
      end
    end
  
    def uno_convert format
      directory = File.dirname( current_path )
      tmpfile   = File.join( directory, "tmpfile" )
  
      File.rename( current_path, tmpfile )
      begin
        system "unoconv -f #{format} '#{tmpfile}'"
        File.rename( File.join(directory, "tmpfile.#{format}"), current_path )
        File.delete( tmpfile )
        if model.respond_to?('pdf_encoding_state')
          model.pdf_encoding_state = 1
        end
      rescue Exception=>e
        if model.respond_to?('pdf_encoding_state')
          model.pdf_encoding_state = 2
        end
        Rails.logger.error("Error converting file #{current_path} #{e}")
      end  
    end
  end
end