module RedmineZenCocoonGanttFilters
  module Patchs
    module IssuesHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :query_links, :gantt
        end
      end

      module InstanceMethods
        def query_links_with_gantt(title, queries)
          url_params = controller_name == 'issues' ? {:controller => 'issues', :action => 'index', :project_id => @project} : params
          gantt_params = { :controller => 'gantts', :action => 'show', :project_id => @project }

          content_tag('h3', title) +
            queries.collect {|query|
                gantt_link = User.current.allowed_to?(:view_gantt, @project, :global => true) ?
                  link_to("[" + l(:label_gantt) + "]", gantt_params.merge(:query_id => query)) + " " :
                  ''
                gantt_link + link_to(h(query.name), url_params.merge(:query_id => query))
              }.join('<br />')
        end
      end
    end
  end
end
