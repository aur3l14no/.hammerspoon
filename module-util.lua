function Print(x)
  -- hs.console.printStyledtext(x)
  print(hs.inspect(x))
end

function myNotify(msg)
  alert = hs.notify.new({ title = "Hammerspoon", informativeText = msg })
  alert:withdrawAfter(3):send()
end

function timeit(fn, times)
  local t = os.clock()
  if times == nil then
    times = 1
  end
  for i = 1, times do
    fn()
  end
  return (os.clock() - t) / times
end
function map(f, t)
  local o = {}
  for i = 1, #t do
    o[#o + 1] = f(t[i])
  end
  return o
end
function contains(table, val)
  for i = 1, #table do
    if table[i] == val then
      return true
    end
  end
  return false
end
