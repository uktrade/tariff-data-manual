require 'dbml'
require_relative 'dot'

def dbml_to_svg code
  dot_to_svg dbml_to_dot code
end

def unique_id prefix
  [prefix.to_s, (rand*1000).to_i].join("_")
end

def dbml_to_dot code
  project = DBML::Parser.parse code

  dot = %{digraph #{project.name || 'Database'} {
    rankdir=LR
    graph [id=#{unique_id :database}]
    edge [arrowsize=0.75]
    node [shape=none, fontsize=9]

    #{project.tables.map do |table|
      %{"#{table.name}" [id=#{unique_id :table} label=<<TABLE ALIGN="LEFT" CELLSPACING="0" CELLPADDING="2" CELLBORDER="1">
        <TR>
          <TD COLSPAN="3">#{table.name}</TD>
        </TR>
        #{table.columns.each_with_index.map do |column, index|
          %{<TR>
              <TD PORT="#{column.name}_name">#{column.name}</TD>
              <TD PORT="#{column.name}_type">#{column.type}</TD>
              <TD PORT="#{column.name}_attribs">#{column.settings.keys.reject{|k| k == :note }.join(", ")}</TD>
            </TR>
          } end.join("\n")}
      </TABLE>>]

      #{table.columns.map{|c| [c, c.settings[:note]] }.reject {|(c, note)| note.nil? }.map do |c, note|
        %{"#{c.name} Note" [shape=note, id=#{unique_id :note}, label="#{note}"]
          "#{c.name} Note" -> "#{table.name}":#{c.name}_name [style=dotted, arrowhead=none]
        } end.join("\n")}
    } end.join("\n")}


    #{project.relationships.map do |relationship| %{
      "#{relationship.left_table}":"#{relationship.left_fields.first}_attribs":e -> "#{relationship.right_table}":"#{relationship.right_fields.first}_name":w
    } end.join("\n")}
  }}
end

if $0 == __FILE__
  puts dbml_to_dot ARGF.read
end
