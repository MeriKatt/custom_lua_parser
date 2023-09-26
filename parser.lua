local parser = parser or {}

parser.patterns = {
  { patt = "@", repl = "self" },
  { patt = "&&", repl = " and " },
  { patt = "||", repl = " or " },
  { patt = "fn# ", repl = "function " },
  { patt = "lfn# ", repl = "local function "},
}


local function ReverseTable(t)
 local reversedTable = {}
 local itemCount = #t
 for k, v in ipairs(t) do
     reversedTable[itemCount + 1 - k] = v
 end
 return reversedTable
end

local function transform(parser, s , rev)
 local str = s

 local patterns = parser.patterns
 if rev then
  local rev_patterns = ReverseTable(patterns)
  for _, v in ipairs(rev_patterns) do
   str = str:gsub(v.repl, v.patt)
  end
 else
  for _, v in ipairs(patterns) do
   str = str:gsub(v.patt, v.repl)
   print(v.patt)
   print(v.repl)
  end
 end
  return str
end

function parser.to_lua(self, path)
 local fh = assert(io.open(path, 'rb'))
 local source = fh:read'*a'
 local transformed = transform(self, source, false)
 fh:close()
 local fw = assert(io.open(path, 'wb'))
 fw:write(transformed)
 fw:close()
end

function parser.from_lua(self, path)
 local fh = assert(io.open(path, 'rb'))
 local source = fh:read'*a'
 local transformed = transform(self, source, true)
 fh:close()
 local fw = assert(io.open(path, 'wb'))
 fw:write(transformed)
 fw:close()
end

return parser
