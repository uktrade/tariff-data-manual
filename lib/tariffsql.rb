require 'sqlite3'

DB = SQLite3::Database.new(ENV['LOCAL_DATABASE'] || 'tariff.sqlite')

STATEMENTS = Hash.new do |hash, sql|
  hash[sql] = []
end

RESULTS = Hash.new do |hash, sql|
  hash[sql] = []
  remainder = sql
  loop do
    stmt = DB.prepare remainder
    remainder = stmt.remainder.strip
    result = stmt.execute!

    # Return the last non-empty result set.
    unless result.empty?
      hash[sql] = result
      STATEMENTS[sql] << stmt
    end
    break if remainder.empty?
  end
  hash[sql]
end

def sql_to_table sql
  rows = RESULTS[sql]
  statement = STATEMENTS[sql].last

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
    <tfoot>
      <tr>
        <td colspan=#{statement.columns.size}>
          Last updated #{Time.now.strftime('%d %b %Y')}
        </td>
      </tr>
    </tfoot>
  </table>"
end
