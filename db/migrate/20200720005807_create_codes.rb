class CreateCodes < ActiveRecord::Migration[5.2]
  def up
    execute <<~SQL
      create view codes as
      select
        codes.name,
        codes.code
      from
        visits,
        jsonb_to_recordset(visits.codes) as codes(name text, code text)
      group by codes.name, codes.code
      order by codes.name, codes.code
    SQL
  end
  def down
    execute <<~SQL
      drop view if exists codes
    SQL
  end
end
