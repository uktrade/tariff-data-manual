require 'sqlite3'

DB = SQLite3::Database.new(ENV['LOCAL_DATABASE'] || 'tariff.sqlite')

STATEMENTS = Hash.new do |hash, sql|
  hash[sql] = DB.prepare sql
end

RESULTS = Hash.new do |hash, sql|
  STDERR.puts sql
  hash[sql] = STATEMENTS[sql].execute!
end

def sql_to_table sql
  statement = STATEMENTS[sql]
  rows = RESULTS[sql]

  "<table>
    <thead>
      <tr>
        #{statement.columns.map do |col|
          "<th>#{col}</th>"
        end.join}
      </tr>
    </thead>
    <tbody>
      #{rows.map do |row|
        "<tr>#{row.map do |val|
          "<td>#{val}</td>"
        end.join}</tr>"
      end.join}
    </tbody>
  </table>"
end
