require 'redmine'

require 'dispatcher'

Dispatcher.to_prepare :redmine_zencocoon_gantt_filters do
  require_dependency 'issues_helper'
  unless IssuesHelper.included_modules.include?(RedmineZenCocoonGanttFilters::Patchs::IssuesHelperPatch)
    IssuesHelper.send(:include, RedmineZenCocoonGanttFilters::Patchs::IssuesHelperPatch)
  end
end

Redmine::Plugin.register :redmine_zencocoon_gantt_filters do
  name 'Redmine Zencocoon Gantt Filters Plugin'
  author 'Sébastien Grosjean - ZenCocoon'
  description "Add a link in front of issues' filters with direct access to filtered Gantt."
  version '0.0.1'
  author_url 'http://www.zencocoon.com'
end

require 'redmine_zencocoon_gantt_filters/patchs/issues_helper_patch'