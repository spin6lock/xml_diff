#! /usr/bin/env lua

--1. git config diff.xml_diff.textconv xml_diff.lua
---- file: .git/config 
---- [diff "xml_diff"] 
----     textconv = xml_diff.lua

--2. file: .gitattributes] 
---- *.xml diff=xml_diff

--3. file: chmod u+x xml_diff.lua

 local args = {...}
 local filepath = args[1]
 local txt = io.open(filepath, "r"):read("*a")

 -- 不是临时文件
 local print_first_line
 if string.find(filepath, "design") then
     print_first_line = true
 end

 for name, sheet in string.gmatch(txt, "<Worksheet ss:Name=\"(.-)\"(.-)</Worksheet>") do

     print(string.format("----------- Table: %s -------------", name))

     local lines = {}

     local count = 1
     for line in string.gmatch(sheet, "<Row(.-)/Row>") do
         local cells = {string.format("Row:%d", count)}
         for c in string.gmatch(line, "Data.->(.-)</Data>") do
             table.insert(cells, c)
         end

         lines[count] = table.concat(cells, "\t")
         count = count + 1
     end

     if print_first_line then
         table.remove(lines, 2)
         table.remove(lines, 2)
         print_first_line = nil
     else
         table.remove(lines, 1)
         table.remove(lines, 1)
         table.remove(lines, 1)
     end

     local result = table.concat(lines, "\n")

     print(result)
 end
