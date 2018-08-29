/*
  Generate a user friendly naviation table based on supplied metadata

  Usage:
  let
    Table.NavigationTable = Load("Table/NavigationTable"),
    objects = #table(
      {"Name",       "Key",        "Data",                           "ItemKind", "ItemName", "IsLeaf"},{
      {"Item1",      "item1",      #table({"Column1"}, {{"Item1"}}), "Table",    "Table",    true},
      {"Item2",      "item2",      FunctionCallThatReturnsATable(),  "Table",    "Table",    true}
      }),
    NavTable = Table.ToNavigationTable(objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
  in
    NavTable;

  Result: a navigation table
*/

(
  table as table,
  keyColumns as list,
  nameColumn as text,
  dataColumn as text,
  itemKindColumn as text,
  itemNameColumn as text,
  isLeafColumn as text
) as table =>
  let
    tableType = Value.Type(table),
    newTableType = Type.AddTableKey(tableType, keyColumns, true) meta
    [
      NavigationTable.NameColumn = nameColumn,
      NavigationTable.DataColumn = dataColumn,
      NavigationTable.ItemKindColumn = itemKindColumn,
      Preview.DelayColumn = itemNameColumn,
      NavigationTable.IsLeafColumn = isLeafColumn
    ],
    navigationTable = Value.ReplaceType(table, newTableType)
  in
    navigationTable;
