class AuditsController < ApplicationController
  layout 'bootstrap_default'
  include TheAudit::Controller

  before_action :user_require
  before_action :role_required

  def index
    @ctrl_acts = Audit
      .audit_scope(params)
      .select('DISTINCT controller_name, action_name, COUNT(*) as count')
      .group('controller_name, action_name')
      .reorder('count DESC').to_a

    @audits_count = Audit.audit_scope(params).count
    @audits = Audit.audit_scope(params).pagination(params)
  end
end
