require 'rubygems'
require 'redmine_client'
require 'csv'

module Ia::Redmine

  def redmine_export_csv(file, config)
    cfg = yaml_read(config)
    
    csv_file = file

    RedmineClient::Base.configure do
      self.site =     cfg['redmine']['url']
      self.user =     cfg['redmine']['user']
      self.password = cfg['redmine']['password']
    end
  
    #issue = RedmineClient::Issue.find(19000)

    data = []

    CSV.foreach(@csv_file, :col_sep => ';', :quote_char => '"', :headers => :first_row) do |row|
      data << row
    end

    data.each do |row|
      issue = RedmineClient::Issue.new(
                                       :subject => row[0].to_s,
                                       :description => row[1].to_s,
                                       :project_id => row[2].to_i,
                                       :category_id => row[3].to_i,
                                       :fixed_version_id => row[4].to_i,
                                       :estimated_hours => row[5].to_i,
                                       :assigned_to_id => row[6].to_i,
                                       :parent_id => row[7].to_i
                                      )

      if issue.save
        pinfo("Created issue: #{issue.id}")
      else
        perr("Error")
      end
    end
  end
end
