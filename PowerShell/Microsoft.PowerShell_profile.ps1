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

function customls {
    [alias('ls')]
    param(
        [Parameter(Mandatory=$false)][string]$Path # path for ls
    )
    if(!($Path)){
      $Path = '.'
    }
    eza.exe -lab --group-directories-first --git --icons $Path
}


Set-Item -Path Env:PIP_REQUIRE_VIRTUALENV -Value "true"
Import-Module ZLocation
# Import-Module gsudoModule
Invoke-Expression (&starship init powershell)
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
# Set-Alias ls -Value eza.exe
$db = New-TemporaryFile
(Get-ZLocation).GetEnumerator() | ForEach-Object { Write-Output ($_.Name+'|'+$_.Value+'|0') } | Out-File $db
zoxide import --from=z $db --merge
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
