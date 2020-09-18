**How to add images:**
1. Go to issues and click 'new issue' 
2. Paste your image into the text box
3. A URL will be generated 
4. Copy and Paste this URL into your page

**How to add tables:**
1. visit this website: https://www.tablesgenerator.com/markdown_tables# 
2. Go to file > paste table data > load > generate > copy to clipboard 
3. You can put line breaks in your table as <br> 

**How to add graphs:** 

Graph 1: 
1. This graph looks like this: ![image](https://user-images.githubusercontent.com/61055197/93594831-7f161200-f9ae-11ea-8eec-3480c9a78ae1.png)
2. You can add a graph like this by using the following format: 

digraph "Measure Types" {
    rankdir=LR
    graph [id=database]
    node [shape=record]
    
    Measure [label="Measure|<1>measure_sid|<2>measure_type_id|<3>..."]
    MeasureType [label="Measure Type|<1>measure_type_id|<2>validity_start_date|<3>validity_end_date"]
    MeasureTypeDescription [label="Measure Type Description|<1>measure_type_id|<2>language_id|<3>description"]

    Measure:2 -> MeasureType:1
    MeasureTypeDescription:1 -> MeasureType:1
}

Graph 2: 
1. This graph looks like this: ![image](https://user-images.githubusercontent.com/61055197/93596740-c651d200-f9b1-11ea-8321-211ecb6d575a.png)
2. You can add a graph like this by using the following format: 

graph "Measures and Regulations" {
  rankdir=LR
  node [shape=box]

  measure1 [label=Measure]
  measure2 [label=Measure]
  measure3 [label=Measure]
  measure4 [label=Measure]
  
  "Regulation" -- measure1
  "Regulation" -- measure2
  "Regulation" -- measure3
  "Regulation" -- measure4
}

**A few things that we need to consider:**
- We need to put a 'back to the top' button at the end of each page 
- We need to add a 'Is there anything wrong with this page?' section at the end of each page so if users notice any mistakes/problems they can notify us
- Although we can add tables, there are still a few formatting kinks that need to be straightend out such as how to highlight rows/columns/cells or how to merge cells
