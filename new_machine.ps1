function temp_fix_path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", 'User') + ';' + [System.Environment]::GetEnvironmentVariable("Path", 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable("Path")
}
Start-Process powershell -Verb RunAs -ArgumentList "-NoExit -Command Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1"

winget import --import-file "winstall-5644.json" --no-upgrade --accept-package-agreements --accept-source-agreements
# > $null
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", 'User') + ';' + [System.Environment]::GetEnvironmentVariable("Path", 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable("Path")

Start-Process pwsh -ArgumentList '-Command "Install-Module ZLocation -Scope CurrentUser -AcceptLicense -Force"'


Function Test-ScoopInstalled {
    $scoopExists = Get-Command scoop -ErrorAction SilentlyContinue
    return $scoopExists -ne $null
}

if (-NOT (Test-ScoopInstalled)) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

    # Install aria2c for multi-connection downloads
    scoop install aria2 -u
    scoop config aria2-warning-enabled false

    # Install buckets
    scoop bucket add extras
    scoop bucket add nerd-fonts
    scoop bucket add nirsoft
    scoop bucket add sysinternals

# Update scoop
scoop update *

# Install packages
$packages = @(
    'uutils-coreutils'
    'autohotkey'
    'bat'
    'bind'
    'broot'
    'clink'
    'curl'
    'delta'
    'diffutils'
    'dos2unix'
    'dust'
    'eza'
    'fastfetch'
    'fd'
    'ffmpeg'
    'file'
    'findutils'
    'FiraCode'
    'FiraCode-NF-Mono'
    'fzf'
    'fx'
    'gh'
    'git-crypt'
    'glow'
    'grep'
    'ImageMagick'
    'ghostscript'
    'iperf3'
    'JetBrains-Mono'
    'jq'
    'just'
    'komorebi'
    'kubectl'
    'lazygit'
    'less'
    'lf'
    'mediainfo'
    'neovim'
    'ngrok'
    'rclone'
    'ripgrep'
    'rye'
    'scoop-search'
    'sed'
    'spotify-tui'
    'starship'
    'sysinternals/autoruns'
    'sysinternals/psexec'
    'sysinternals/psshutdown'
    'sysinternals/regjump'
    'sysinternals/sdelete'
    'touch'
    'tre-command'
    'ttyd'
    'unzip'
    'vhs'
    'wakemeonlan'
    'wget'
    'whkd'
    'whois'
    'zoxide'
    'pipx'
    'poppler'
    'PSFzf'
    'extras/vcredist2022'
)


foreach ($package in $packages) {
    scoop install $package -u
}


}

# Reset shims in order of package list
# if scoop was already installed
# if (Test-ScoopInstalled) {
#     foreach ($package in $packages) {
#         scoop reset $package
#     }
# }

function Check-GitHubAuthStatus {
      $result = gh auth status
      if ($result -like "*Logged in*") {
          Write-Host "GitHub CLI is authenticated and logged in."
      }
      else {
          Write-Host "GitHub CLI is not authenticated or not logged in."
          gh auth login --web --git-protocol ssh
      }
  }
function Install-GitHubExtension {
      param (
          [string]$extensionName
      )

      # Install the GitHub extension using the GitHub CLI
      gh extension install $extensionName
  }
function Get-GitHubExtension {
      $extensions = gh extension list
      return $extensions
  }

function CheckGitHubExtensions {
      $requiredExtensions = @(
        'github/gh-copilot'
        'dlvhdr/gh-dash'
        )

      $installedExtensions = Get-GitHubExtension

      foreach ($extension in $requiredExtensions) {
          if ([string]$installedExtensions -NotMatch $extension) {
              Install-GitHubExtension $extension
	      $installedExtensions = Get-GitHubExtension
         }
      }
  }
git config --global user.email "eivind.teig@gmail.com"
git config --global user.name "Eivind Teig"
CheckGitHubExtensions

if (Test-PATH $PROFILE) {
    if (-not (Get-Content -Raw -Path $PROFILE)){
        Add-Content -Path $PROFILE -Value "Import-Module $HOME/.config/PowerShell/Microsoft.PowerShell_profile.ps1"
        . $PROFILE
        
    } 
}
else {
    New-Item -ItemType File -Force -Path $PROFILE
    Add-Content -Path $PROFILE -Value "Import-Module $HOME/.config/PowerShell/Microsoft.PowerShell_profile.ps1"
    . $PROFILE
}

# Restart terminal commands

Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
pipx ensurepath
temp_fix_path
[System.Environment]::SetEnvironmentVariable('PYENV',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
[System.Environment]::SetEnvironmentVariable('PYENV_ROOT',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
[System.Environment]::SetEnvironmentVariable('PYENV_HOME',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
pipx install poetry ruff "black[d]"
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")

& $env:Temp\GoogleCloudSDKInstaller.exe
temp_fix_path

pip config set global.require-virtualenv True

rye install posting


# CHECK IF WSL IS INSTALLED
wsl --install
Write-Host "YOU HAVE TO REBOOT NOW"    
# Invoke-WebRequest -Uri 'https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe' -OutFile "$env:Temp\DockerDesktopInstaller.exe"
# Start-Process $env:Temp\DockerDesktopInstaller.exe -Wait -ArgumentList 'install', '--quiet', '--accept-license'
Write-Host "YOU HAVE TO START DOCKER MANUALLY THE FIRST TIME" 

function afterDocker {
    gcloud auth login
    gcloud auth configure-docker
    docker pull eu.gcr.io/amedia-core/amedia/debug:latest
}
