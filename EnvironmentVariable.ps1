$DATA = "XYZ"

#@ Set Variable "VAR" for current user
[System.Environment]::SetEnvironmentVariable('VAR',$DATA,[System.EnvironmentVariableTarget]::User)

#@ Set Variable "VAR" for all users
If ($Admin)
  {
  [System.Environment]::SetEnvironmentVariable('VAR',$DATA,[System.EnvironmentVariableTarget]::Machine)
  }

#@ Display the stored value of "VAR"
[System.Environment]::GetEnvironmentVariable('VAR')