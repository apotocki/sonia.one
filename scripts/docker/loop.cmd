echo off
for /l %%x in (1, 1, 100) do (
   echo %%x
   call run_dev-test.cmd
)
