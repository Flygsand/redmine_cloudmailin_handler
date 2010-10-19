require 'digest/md5'

module RedmineCloudmailinHandler
  module MailHandlerControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        unloadable
        alias_method_chain :index, :cloudmailin_support
        alias_method_chain :check_credential, :cloudmailin_support
      end
    end

    module InstanceMethods
      def index_with_cloudmailin_support
        options = params.dup
        email = options.delete(:message)
        if MailHandler.receive(email, options)
          render :nothing => true, :status => :ok
        else
          render :nothing => true, :status => :unprocessable_entity
        end
      end
      
      private
      def check_credential_with_cloudmailin_support
        User.current = nil
        signature = request.request_parameters.delete(:signature)
        calculated = Digest::MD5.hexdigest(request.request_parameters.sort.map{|k,v| v}.join + Setting.mail_handler_api_key)
        unless Setting.mail_handler_api_enabled? && signature == calculated
          render :text => 'Access denied. Incoming emails WS is disabled or message signature is invalid.', :status => 403
        end
      end
    end
  end
end
