function explain {
      param(
          [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
          [string]$text
      )

      $command = "gh copilot explain $text"
      Invoke-Expression $command
  }


Invoke-Expression (&starship init powershell)
