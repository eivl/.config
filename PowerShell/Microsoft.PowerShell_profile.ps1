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


Invoke-Expression (&starship init powershell)
