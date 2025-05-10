-- Check for Android
if vim.fn.has('linux') == 1 then
  print("linux")
  return true
elseif vim.loop.os_uname().sysname == "Linux" then
  -- print("android")
  return false
end

