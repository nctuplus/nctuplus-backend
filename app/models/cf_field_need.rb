class CfFieldNeed < ActiveRecord::Base
	self.table_name = "cf_field_need"
	belongs_to :course_field
end
