function explain {
      param(
          [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
          [string]$text
      )

      $command = "gh copilot explain $text"
      Invoke-Expression $command
  }

function gcloud_auth {
    Start-Process pwsh -ArgumentList '-Command "gcloud auth print-access-token"' -Verb runAs
}

function restart_tb {
    ps pythonw -ErrorAction SilentlyContinue | ForEach-Object {kill $_.Id}
    C:\Users\eivin\yasb\.venv\Scripts\pythonw.exe C:\Users\eivin\yasb\src\main.py
}


function kr {
    if (Get-Process -Name "komorebi" -ErrorAction SilentlyContinue) {
        komorebic stop --whkd && komorebic start --whkd
    } else {
        komorebic start --whkd
    }
}


Set-Item -Path Env:PIP_REQUIRE_VIRTUALENV -Value "true"
Import-Module ZLocation
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
Invoke-Expression (&starship init powershell)
Set-Alias ls -Value eza.exe
