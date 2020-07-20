class HospitalsController < ApplicationController
  def show
    if selected_code.present?
      sql = <<~SQL
        select
          pac,
          visit_type,
          count(id) as visit_count
        from visits
        where codes @> ?
        and hospital_id = ?
        group by pac, visit_type
      SQL
      puts sql
      @visits = Visit.find_by_sql([sql, JSON.generate([code: selected_code]), params[:id]])
    else
      @visits = Visit
        .where(
          hospital_id: params[:id]
        )
        .select(
          :pac,
          :visit_type,
          "COUNT(id) as visit_count"
        )
        .group(:pac, :visit_type)
    end
  end

  def code_options
    [['', nil]] + [['-none-', 'ZZZNONE!']] + Code.all.map{|code| [code.name, code.code]}
  end
  helper_method :code_options

  def selected_code
    params.permit(:code)[:code]
  end
  helper_method :selected_code
end
