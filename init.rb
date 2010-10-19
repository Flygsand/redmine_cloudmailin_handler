# -*- coding: utf-8 -*-

require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare :redmine_cloudmailin_handler do
  app_dependency = Redmine::VERSION.to_a.slice(0,3).join('.') > '0.8.4' ? 'application_controller' : 'application'
  require_dependency(app_dependency)
  require_dependency 'mail_handler_controller'
  
  unless MailHandlerController.included_modules.include? RedmineCloudmailinHandler::MailHandlerControllerPatch
    MailHandlerController.send(:include, RedmineCloudmailinHandler::MailHandlerControllerPatch)
  end
end

Redmine::Plugin.register :redmine_cloudmailin_handler do
  name 'Redmine Cloudmailin handler plugin'
  author 'Martin Häger'
  description 'This plugin patches the default mail handler to work with Cloudmailin'
  version '0.0.1'
  url 'http://github.com/mtah/redmine_cloudmailin_handler'
  author_url 'http://freeasinbeard.org'
end
