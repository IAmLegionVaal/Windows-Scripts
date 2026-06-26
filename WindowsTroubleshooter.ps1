# ================================================================
# Windows Troubleshooter Toolkit v9.0 (ULTIMATE ENTERPRISE SUITE)
# Compatible: Windows 10 / Windows 11
# Cover Range: Tier 1 (Helpdesk) to Tier 3 (Infrastructure & Security)
# Launch via: Launch_Troubleshooter.bat or Admin PowerShell Window
#
# v8.0 added: Office Removal/Scrubbing Suite, Bloatware & Copilot
# Removal Engine, User Profile -> Entra Migration Helper, Autopilot/
# Provisioning Diagnostics, and Office Activation & Licensing Tools.
#
# v9.0 adds: Browser Repair & Hygiene, Backup & System Restore Mgmt,
# Deep Hardware Diagnostics, Printing & Print Server Toolkit, Outlook/
# Exchange Advanced Diagnostics, Entra MFA/Conditional Access Deep-Dive,
# Advanced Network L2/L3 Toolkit, Full Diagnostic Report Generator, and
# an Action Audit Logging Engine.
# ================================================================

$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference    = "SilentlyContinue"

# ================================================================
# HELPERS
# ================================================================

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "  ============================================================" -ForegroundColor Cyan
    Write-Host "        WINDOWS TROUBLESHOOTER TOOLKIT v9.0 (ALL-TIER)        " -ForegroundColor Cyan
    Write-Host "        Created By: Dewald                                     " -ForegroundColor Magenta
    Write-Host "        $env:COMPUTERNAME  |  $env:USERNAME  |  $(Get-Date -Format 'HH:mm dd/MM/yyyy')" -ForegroundColor DarkCyan
    Write-Host "  ============================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Wait-Key {
    Write-Host ""
    Write-Host "  Press any key to go back..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-Title($t) {
    Write-Host ""
    Write-Host "  --- $t ---" -ForegroundColor Yellow
    Write-Host ""
}

function Write-AuditLog {
    param([string]$Action, [string]$Detail = "")
    $LogDir  = "C:\ProgramData\WinTroubleshooter"
    $LogFile = Join-Path $LogDir "AuditLog.csv"
    try {
        if (-not (Test-Path $LogDir)) { New-Item -Path $LogDir -ItemType Directory -Force | Out-Null }
        if (-not (Test-Path $LogFile)) {
            "Timestamp,User,Computer,Action,Detail" | Out-File $LogFile -Encoding UTF8
        }
        $line = '{0},{1},{2},"{3}","{4}"' -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $env:USERNAME, $env:COMPUTERNAME, $Action, ($Detail -replace '"','''')
        Add-Content -Path $LogFile -Value $line -Encoding UTF8
    } catch {
        # Never let logging failure break the actual tool action
    }
}

# ================================================================
# MAIN MENU (REDESIGNED FOR CLEAN VERTICAL SCANNABILITY)
# ================================================================

function Show-MainMenu {
    while ($true) {
        Show-Header
        
        Write-Host "  [ BASELINE INFRASTRUCTURE & REPAIR ]" -ForegroundColor Gray
        Write-Host "   1.  Network Tools"
        Write-Host "   2.  System Tools"
        Write-Host "   3.  Disk and Storage"
        Write-Host "   4.  Windows Update and Repair"
        Write-Host "   5.  Event Log and Diagnostics"
        Write-Host "   6.  Services and Startup"
        Write-Host "   7.  Security and Firewall"
        Write-Host "   8.  Performance Tools"
        Write-Host "   9.  Driver and Hardware"
        Write-Host "   10. Remote and Sharing"
        Write-Host "   11. Registry and Advanced"
        Write-Host "   12. Quick Fixes"
        Write-Host ""
        
        Write-Host "  [ ADVANCED L1 - L3 ENTERPRISE ENGINE MODULES ]" -ForegroundColor Gold
        Write-Host "   13. UWP & Windows Store App Fixes"
        Write-Host "   14. Accounts, Users & Local Groups"
        Write-Host "   15. Entra ID / Cloud Workspace Audits"
        Write-Host "   16. Features & Optional Component Engine"
        Write-Host "   17. MS Office, OneDrive & SP Suite"
        Write-Host "   18. Advanced BSOD & Crash Analytics"
        Write-Host "   19. Enterprise LGPO & Policy Engine"
        Write-Host "   20. WMI Repository Repair & Salvage"
        Write-Host "   21. Active Directory Domain Trust"
        Write-Host "   22. BitLocker Encryption Toolkit"
        Write-Host "   23. MECM / SCCM Endpoint Management"
        Write-Host "   24. Certificate Store & Network Routes"
        Write-Host ""

        Write-Host "  [ DEPLOYMENT, CLEANUP & MIGRATION ENGINE MODULES ]" -ForegroundColor Gold
        Write-Host "   25. Office Removal / Scrubbing Toolkit"
        Write-Host "   26. Bloatware, Copilot & Consumer App Debloat Engine"
        Write-Host "   27. Profile & Data Migration Toolkit (Local/Roaming -> Entra)"
        Write-Host "   28. Autopilot / Provisioning & Imaging Diagnostics"
        Write-Host "   29. Office Activation & Licensing Tools"
        Write-Host ""

        Write-Host "  [ EXTENDED L1 - L3 SUPPORT MODULES ]" -ForegroundColor Gold
        Write-Host "   30. Browser Repair & Hygiene Toolkit"
        Write-Host "   31. Backup, Shadow Copy & System Restore Manager"
        Write-Host "   32. Deep Hardware Diagnostics"
        Write-Host "   33. Printing & Print Server Toolkit"
        Write-Host "   34. Outlook / Exchange Advanced Diagnostics"
        Write-Host "   35. Entra MFA / Conditional Access Deep-Dive"
        Write-Host "   36. Advanced Network L2/L3 Toolkit"
        Write-Host "   37. Full Diagnostic Report Generator"
        Write-Host "   38. Action Audit Log Viewer"
        Write-Host ""
        
        Write-Host "   0.  Exit"
        Write-Host ""
        
        $c = Read-Host "   Choice"
        if     ($c -eq "1")  { Menu-Network }
        elseif ($c -eq "2")  { Menu-System }
        elseif ($c -eq "3")  { Menu-Disk }
        elseif ($c -eq "4")  { Menu-Update }
        elseif ($c -eq "5")  { Menu-Events }
        elseif ($c -eq "6")  { Menu-Services }
        elseif ($c -eq "7")  { Menu-Security }
        elseif ($c -eq "8")  { Menu-Performance }
        elseif ($c -eq "9")  { Menu-Drivers }
        elseif ($c -eq "10") { Menu-Remote }
        elseif ($c -eq "11") { Menu-Advanced }
        elseif ($c -eq "12") { Menu-QuickFix }
        elseif ($c -eq "13") { Menu-UWPApps }
        elseif ($c -eq "14") { Menu-Accounts }
        elseif ($c -eq "15") { Menu-CloudIdentity }
        elseif ($c -eq "16") { Menu-OptionalFeatures }
        elseif ($c -eq "17") { Menu-OfficeSuite }
        elseif ($c -eq "18") { Menu-CrashAnalytics }
        elseif ($c -eq "19") { Menu-PolicyInjection }
        elseif ($c -eq "20") { Menu-WMISalvage }
        elseif ($c -eq "21") { Menu-ADDomain }
        elseif ($c -eq "22") { Menu-BitLocker }
        elseif ($c -eq "23") { Menu-MECM }
        elseif ($c -eq "24") { Menu-CertRoute }
        elseif ($c -eq "25") { Menu-OfficeScrub }
        elseif ($c -eq "26") { Menu-Debloat }
        elseif ($c -eq "27") { Menu-ProfileMigration }
        elseif ($c -eq "28") { Menu-Provisioning }
        elseif ($c -eq "29") { Menu-OfficeActivation }
        elseif ($c -eq "30") { Menu-Browser }
        elseif ($c -eq "31") { Menu-BackupRestore }
        elseif ($c -eq "32") { Menu-HardwareDeep }
        elseif ($c -eq "33") { Menu-Printing }
        elseif ($c -eq "34") { Menu-OutlookAdvanced }
        elseif ($c -eq "35") { Menu-ConditionalAccess }
        elseif ($c -eq "36") { Menu-NetworkAdvanced }
        elseif ($c -eq "37") { Menu-DiagnosticReport }
        elseif ($c -eq "38") { Menu-AuditLog }
        elseif ($c -eq "0")  { Write-Host "  Bye!"; Start-Sleep 1; exit }
    }
}

# ================================================================
# 1. NETWORK
# ================================================================
function Menu-Network {
    while ($true) {
        Show-Header
        Write-Host "  [ NETWORK TOOLS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  IP Configuration (ipconfig /all)"
        Write-Host "   2.  Ping a Host"
        Write-Host "   3.  Flush DNS Cache"
        Write-Host "   4.  Release and Renew IP"
        Write-Host "   5.  Reset TCP/IP Stack"
        Write-Host "   6.  Reset Winsock"
        Write-Host "   7.  Traceroute"
        Write-Host "   8.  DNS Lookup (nslookup)"
        Write-Host "   9.  Active Connections (netstat)"
        Write-Host "  10. ARP Table"
        Write-Host "  11. Test Internet (ping multiple targets)"
        Write-Host "  12. Show Wi-Fi Profiles"
        Write-Host "  13. Show Wi-Fi Password"
        Write-Host "  14. Toggle Network Adapter"
        Write-Host "  15. Network Adapter Details"
        Write-Host "  16. Deep Adapter Reset (netcfg -d)"
        Write-Host "  17. Clear Malicious/Stuck Proxy Settings"
        Write-Host "  18. Monitor Live Network Connections"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Show-Title "IP Configuration"; ipconfig /all; Wait-Key }
        elseif ($c -eq "2") { $h = Read-Host "   Hostname or IP"; Show-Title "Ping $h"; ping $h -n 10; Wait-Key }
        elseif ($c -eq "3") { Show-Title "Flush DNS"; ipconfig /flushdns; Wait-Key }
        elseif ($c -eq "4") {
            Show-Title "Release and Renew IP"
            Write-Host "  Releasing IP..." -ForegroundColor Yellow; ipconfig /release; Start-Sleep 2
            Write-Host "  Renewing IP..." -ForegroundColor Yellow; ipconfig /renew; Wait-Key
        }
        elseif ($c -eq "5") { Show-Title "Reset TCP/IP"; netsh int ip reset; Write-Host "  Done. Restart PC." -ForegroundColor Yellow; Wait-Key }
        elseif ($c -eq "6") { Show-Title "Reset Winsock"; netsh winsock reset; Write-Host "  Done. Restart PC." -ForegroundColor Yellow; Wait-Key }
        elseif ($c -eq "7") { $h = Read-Host "   Hostname or IP"; Show-Title "Traceroute $h"; tracert $h; Wait-Key }
        elseif ($c -eq "8") { $d = Read-Host "   Domain"; Show-Title "NSLookup $d"; nslookup $d; Wait-Key }
        elseif ($c -eq "9") { Show-Title "Active Connections"; netstat -ano; Wait-Key }
        elseif ($c -eq "10") { Show-Title "ARP Table"; arp -a; Wait-Key }
        elseif ($c -eq "11") {
            Show-Title "Internet Connectivity Test"
            foreach ($t in @("8.8.8.8","1.1.1.1","google.com","microsoft.com")) {
                if (Test-Connection $t -Count 2 -Quiet -ErrorAction SilentlyContinue) { Write-Host "  [PASS] $t" -ForegroundColor Green }
                else { Write-Host "  [FAIL] $t" -ForegroundColor Red }
            }
            Wait-Key
        }
        elseif ($c -eq "12") { Show-Title "Wi-Fi Profiles"; netsh wlan show profiles; Wait-Key }
        elseif ($c -eq "13") { $s = Read-Host "   SSID Name"; Show-Title "Wi-Fi Password: $s"; netsh wlan show profile name="$s" key=clear; Wait-Key }
        elseif ($c -eq "14") {
            Show-Title "Network Adapters"
            Get-NetAdapter | Format-Table Name, Status -AutoSize
            $n = Read-Host "   Adapter name to toggle"
            $a = Get-NetAdapter -Name $n -ErrorAction SilentlyContinue
            if ($a) {
                if ($a.Status -eq "Up") { Disable-NetAdapter -Name $n -Confirm:$false; Write-Host "  Disabled." -ForegroundColor Yellow }
                else                    { Enable-NetAdapter  -Name $n -Confirm:$false; Write-Host "  Enabled."  -ForegroundColor Green }
            } else { Write-Host "  Adapter not found." -ForegroundColor Red }
            Wait-Key
        }
        elseif ($c -eq "15") { Show-Title "Adapter Details"; Get-NetAdapter | Format-List Name, Status, MacAddress, LinkSpeed, InterfaceDescription; Wait-Key }
        elseif ($c -eq "16") {
            Show-Title "Deep Adapter Reset"
            Write-Host "  Wiping and reinitializing internal network binding tables..." -ForegroundColor Yellow
            netcfg -d
            Write-Host "  Complete. Please reboot the computer immediately." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "17") {
            Show-Title "Clear Proxy Settings"
            netsh winhttp reset proxy
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 0
            Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -ErrorAction SilentlyContinue
            Write-Host "  All standard user environment proxy redirections dropped." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "18") {
            Show-Title "Live Network Connections Overview"
            Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess | Out-GridView -Title "Live TCP Infrastructure Diagnostics"
            Write-Host "  Dynamic tracking frame sent to interactive screen layout." -ForegroundColor Green
            Wait-Key
        }
    }
}

# ================================================================
# 2. SYSTEM
# ================================================================
function Menu-System {
    while ($true) {
        Show-Header
        Write-Host "  [ SYSTEM TOOLS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  System Information (systeminfo)"
        Write-Host "   2.  Check Disk (chkdsk)"
        Write-Host "   3.  System File Checker (sfc /scannow)"
        Write-Host "   4.  DISM Health Restore"
        Write-Host "   5.  Show Disk Usage"
        Write-Host "   6.  Interactive Process Manager (See & Stop)"
        Write-Host "   7.  Kill a Process by Name"
        Write-Host "   8.  Installed Programs"
        Write-Host "   9.  Windows Version"
        Write-Host "   10. System Uptime"
        Write-Host "   11. Clear Temp Files"
        Write-Host "   12. Memory Diagnostic"
        Write-Host "   13. Disk Cleanup"
        Write-Host "   14. Restart / Shutdown Options"
        Write-Host "   15. Audit Corrupted/Temporary User Profiles"
        Write-Host "   16. View Device Resource Environment Summary"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Show-Title "System Info"; systeminfo; Wait-Key }
        elseif ($c -eq "2") {
            $d = Read-Host "   Drive letter (e.g. C)"
            Show-Title "Check Disk ${d}:"
            cmd /c "echo Y | chkdsk ${d}: /f /r"
            Wait-Key
        }
        elseif ($c -eq "3") { Show-Title "System File Checker"; sfc /scannow; Wait-Key }
        elseif ($c -eq "4") {
            Show-Title "DISM Restore Health"
            DISM /Online /Cleanup-Image /CheckHealth
            DISM /Online /Cleanup-Image /ScanHealth
            DISM /Online /Cleanup-Image /RestoreHealth
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Disk Usage"
            Get-PSDrive -PSProvider FileSystem | Format-Table Name,
                @{L="Used(GB)";  E={[math]::Round($_.Used/1GB,2)}},
                @{L="Free(GB)";  E={[math]::Round($_.Free/1GB,2)}},
                @{L="Total(GB)"; E={[math]::Round(($_.Used+$_.Free)/1GB,2)}} -AutoSize
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Interactive Process Manager"
            Write-Host "  Select a process from the window and click 'OK' at the bottom to kill it." -ForegroundColor Cyan
            Write-Host "  Close the window without selecting anything to cancel." -ForegroundColor DarkGray
            
            $selected = Get-Process | Select-Object Name, Id, Description, CPU, WorkingSet | 
                Out-GridView -Title "Select a Process to Terminate" -OutputMode Single
                
            if ($selected) {
                Stop-Process -Id $selected.Id -Force
                Write-Host "  Successfully killed: $($selected.Name) (PID: $($selected.Id))" -ForegroundColor Green
            } else {
                Write-Host "  Operation cancelled." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            $p = Read-Host "   Process name to kill"
            $proc = Get-Process -Name $p -ErrorAction SilentlyContinue
            if ($proc) { Stop-Process -Name $p -Force; Write-Host "  Killed." -ForegroundColor Green }
            else { Write-Host "  Process not found." -ForegroundColor Red }
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Installed Programs"
            $paths = @("HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*","HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*","HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*")
            $paths | ForEach-Object { Get-ItemProperty $_ -ErrorAction SilentlyContinue } | Where-Object { $_.DisplayName } | Sort-Object DisplayName | Format-Table DisplayName, DisplayVersion, Publisher -AutoSize
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Windows Version"
            $o = Get-CimInstance Win32_OperatingSystem
            Write-Host "  OS      : $($o.Caption)`n  Version : $($o.Version)`n  Build   : $($o.BuildNumber)`n  Arch    : $($o.OSArchitecture)"
            Wait-Key
        }
        elseif ($c -eq "10") {
            Show-Title "System Uptime"
            $boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
            $up = (Get-Date) - $boot
            Write-Host "  Boot   : $boot`n  Uptime : $($up.Days)d $($up.Hours)h $($up.Minutes)m" -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "11") {
            Show-Title "Clear Temp Files"
            foreach ($l in @("$env:TEMP","$env:SystemRoot\Temp","$env:LOCALAPPDATA\Temp")) {
                Get-ChildItem $l -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            }
            Write-Host "  Done!" -ForegroundColor Green; Wait-Key
        }
        elseif ($c -eq "12") { Start-Process mdsched.exe; Wait-Key }
        elseif ($c -eq "13") { Start-Process cleanmgr; Wait-Key }
        elseif ($c -eq "14") {
            Write-Host "   1. Restart in 30s`n   2. Shutdown in 30s`n   3. Cancel"
            $s = Read-Host "   Choice"
            if     ($s -eq "1") { shutdown /r /t 30 }
            elseif ($s -eq "2") { shutdown /s /t 30 }
            elseif ($s -eq "3") { shutdown /a }
            Wait-Key
        }
        elseif ($c -eq "15") {
            Show-Title "User Profile Audit"
            $Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
            $Baks = Get-ChildItem $Path | Where-Object { $_.Name -like "*.bak" }
            if ($Baks) {
                Write-Host "  [WARNING] Corrupted Registry User Profiles (.bak) found:" -ForegroundColor Red
                $Baks | ForEach-Object { Write-Host "  -> Profile ID: $($_.PSChildName)" -ForegroundColor Yellow }
                Write-Host "`n  Note: Load regedit and correct the '.bak' folder configuration extension." -ForegroundColor Cyan
            } else {
                Write-Host "  All user profile registration paths healthy." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "16") {
            Show-Title "Resource Summary Profile"
            Get-CimInstance Win32_ComputerSystem | Format-List TotalPhysicalMemory, Model, Manufacturer, Domain, Workgroup, PCSystemType
            Wait-Key
        }
    }
}

# ================================================================
# 3. DISK & STORAGE
# ================================================================
function Menu-Disk {
    while ($true) {
        Show-Header
        Write-Host "  [ DISK & STORAGE ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  List All Disks"
        Write-Host "   2.  List All Partitions"
        Write-Host "   3.  List All Volumes"
        Write-Host "   4.  Open Disk Management"
        Write-Host "   5.  SMART Disk Health"
        Write-Host "   6.  Defragment a Drive"
        Write-Host "   7.  Find Largest Files (Top 20)"
        Write-Host "   8.  Repair Volume"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Show-Title "All Disks"; Get-Disk | Format-Table -AutoSize; Wait-Key }
        elseif ($c -eq "2") { Show-Title "All Partitions"; Get-Partition | Format-Table -AutoSize; Wait-Key }
        elseif ($c -eq "3") { Show-Title "All Volumes"; Get-Volume | Format-Table -AutoSize; Wait-Key }
        elseif ($c -eq "4") { Start-Process diskmgmt.msc; Wait-Key }
        elseif ($c -eq "5") {
            Show-Title "SMART Health"
            $disks = Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus
            if ($disks) {
                foreach ($d in $disks) {
                    $status = if ($d.PredictFailure) {"WARNING - Failure Predicted!"} else {"Healthy"}
                    $color  = if ($d.PredictFailure) {"Red"} else {"Green"}
                    Write-Host "  $($d.InstanceName) : $status" -ForegroundColor $color
                }
            } else { Write-Host "  SMART telemetry tracking unavailable." -ForegroundColor Yellow }
            Wait-Key
        }
        elseif ($c -eq "6") { $d = Read-Host "   Drive letter"; defrag "${d}:" /U /V; Wait-Key }
        elseif ($c -eq "7") {
            $p = Read-Host "   Path to search (e.g. C:\)"
            Show-Title "Largest Files in $p"
            Get-ChildItem $p -Recurse -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object -First 20 FullName, @{L="MB"; E={[math]::Round($_.Length/1MB,2)}} | Format-Table -AutoSize
            Wait-Key
        }
        elseif ($c -eq "8") { $d = Read-Host "   Drive letter"; Repair-Volume -DriveLetter $d -Scan; Wait-Key }
    }
}

# ================================================================
# 4. WINDOWS UPDATE & REPAIR
# ================================================================
function Menu-Update {
    while ($true) {
        Show-Header
        Write-Host "  [ WINDOWS UPDATE & REPAIR ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Open Windows Update Settings"
        Write-Host "   2.  Show Installed Updates"
        Write-Host "   3.  Reset Windows Update Components"
        Write-Host "   4.  Clear Windows Update Cache"
        Write-Host "   5.  DISM Component Cleanup"
        Write-Host "   6.  Check for Updates (PSWindowsUpdate module)"
        Write-Host "   7.  Analyze WinSxS Component Store Health"
        Write-Host "   8.  Deep Purge & Unlock CryptSvc / Catroot2 Operations"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Start-Process "ms-settings:windowsupdate"; Wait-Key }
        elseif ($c -eq "2") { Show-Title "Installed Updates"; Get-HotFix | Sort-Object InstalledOn -Descending | Format-Table HotFixID, Description, InstalledBy, InstalledOn -AutoSize; Wait-Key }
        elseif ($c -eq "3") {
            Show-Title "Reset Windows Update"
            $svcs = @("wuauserv","cryptSvc","bits","msiserver")
            foreach ($s in $svcs) { net stop $s 2>&1 | Out-Null }
            Rename-Item "$env:SystemRoot\SoftwareDistribution" "SoftwareDistribution.old" -ErrorAction SilentlyContinue
            Rename-Item "$env:SystemRoot\System32\catroot2"    "catroot2.old"             -ErrorAction SilentlyContinue
            foreach ($s in $svcs) { net start $s 2>&1 | Out-Null }
            Write-Host "  Done! Windows Update components baseline reset." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Clear Update Cache"
            Stop-Service wuauserv -Force
            Remove-Item "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force
            Start-Service wuauserv
            Write-Host "  Cache cleared." -ForegroundColor Green; Wait-Key
        }
        elseif ($c -eq "5") { Show-Title "DISM Cleanup"; DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase; Wait-Key }
        elseif ($c -eq "6") {
            Show-Title "PSWindowsUpdate"
            if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
                Install-Module PSWindowsUpdate -Force -Scope CurrentUser
            }
            Import-Module PSWindowsUpdate; Get-WindowsUpdate; Wait-Key
        }
        elseif ($c -eq "7") { Show-Title "WinSxS Store Analysis"; DISM /Online /Cleanup-Image /AnalyzeComponentStore; Wait-Key }
        elseif ($c -eq "8") {
            Show-Title "Force Unlocking Cryptographic Database Structures"
            Stop-Service cryptsvc -Force
            Stop-Service wuauserv -Force
            cmd /c "taskkill /F /FI `"SERVICES eq cryptsvc`""
            Remove-Item "$env:SystemRoot\System32\catroot2" -Recurse -Force
            Start-Service cryptsvc
            Start-Service wuauserv
            Write-Host "  Cryptographic signature parsing engines reset completed safely." -ForegroundColor Green
            Wait-Key
        }
    }
}

# ================================================================
# 5. EVENT LOG & DIAGNOSTICS
# ================================================================
function Menu-Events {
    while ($true) {
        Show-Header
        Write-Host "  [ EVENT LOG & DIAGNOSTICS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Last 50 System Errors"
        Write-Host "   2.  Last 50 Application Errors"
        Write-Host "   3.  Critical Events (last 24h)"
        Write-Host "   4.  BSOD / Crash Events (ID 41)"
        Write-Host "   5.  Open Event Viewer"
        Write-Host "   6.  Export System Log to Desktop"
        Write-Host "   7.  Last 20 Security Events"
        Write-Host "   8.  Clear All Event Logs"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Show-Title "Last 50 System Errors"; Get-EventLog -LogName System -EntryType Error -Newest 50 | Format-Table TimeGenerated, Source, EventID, Message -AutoSize -Wrap; Wait-Key }
        elseif ($c -eq "2") { Show-Title "Last 50 App Errors"; Get-EventLog -LogName Application -EntryType Error -Newest 50 | Format-Table TimeGenerated, Source, EventID, Message -AutoSize -Wrap; Wait-Key }
        elseif ($c -eq "3") { Show-Title "Critical Events (24h)"; Get-WinEvent -FilterHashtable @{LogName="System"; Level=1; StartTime=(Get-Date).AddHours(-24)} | Format-Table TimeCreated, ProviderName, Id, Message -AutoSize -Wrap; Wait-Key }
        elseif ($c -eq "4") { Show-Title "BSOD Events (ID 41)"; Get-WinEvent -FilterHashtable @{LogName="System"; Id=41} | Format-Table TimeCreated, Message -AutoSize -Wrap; Wait-Key }
        elseif ($c -eq "5") { Start-Process eventvwr.msc; Wait-Key }
        elseif ($c -eq "6") {
            $out = "$env:USERPROFILE\Desktop\SystemLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
            Get-EventLog -LogName System -Newest 500 | Export-Csv $out -NoTypeInformation
            Write-Host "  Saved: $out" -ForegroundColor Green; Wait-Key
        }
        elseif ($c -eq "7") { Show-Title "Last 20 Security Events"; Get-EventLog -LogName Security -Newest 20 | Format-Table TimeGenerated, EventID, Message -AutoSize -Wrap; Wait-Key }
        elseif ($c -eq "8") {
            if ((Read-Host "  Type YES to clear ALL logs") -eq "YES") {
                Get-EventLog -List | ForEach-Object { Clear-EventLog $_.Log }
                Write-Host "  All logs cleared." -ForegroundColor Yellow
            }
            Wait-Key
        }
    }
}

# ================================================================
# 6. SERVICES & STARTUP
# ================================================================
function Menu-Services {
    while ($true) {
        Show-Header
        Write-Host "  [ SERVICES & STARTUP ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  List All Services"
        Write-Host "   2.  Running Services"
        Write-Host "   3.  Stopped Services"
        Write-Host "   4.  Start a Service"
        Write-Host "   5.  Stop a Service"
        Write-Host "   6.  Restart a Service"
        Write-Host "   7.  Open Services Manager"
        Write-Host "   8.  Startup Programs"
        Write-Host "   9.  Open Task Manager"
        Write-Host "   10. Open MSConfig"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1")  { Show-Title "All Services"; Get-Service | Sort-Object Status,Name | Format-Table Name, DisplayName, Status, StartType -AutoSize; Wait-Key }
        elseif ($c -eq "2")  { Show-Title "Running Services"; Get-Service | Where-Object {$_.Status -eq "Running"} | Format-Table Name, DisplayName -AutoSize; Wait-Key }
        elseif ($c -eq "3")  { Show-Title "Stopped Services"; Get-Service | Where-Object {$_.Status -eq "Stopped"} | Format-Table Name, DisplayName -AutoSize; Wait-Key }
        elseif ($c -eq "4")  { $s = Read-Host "   Service name"; Start-Service $s; Wait-Key }
        elseif ($c -eq "5")  { $s = Read-Host "   Service name"; Stop-Service $s -Force; Wait-Key }
        elseif ($c -eq "6")  { $s = Read-Host "   Service name"; Restart-Service $s -Force; Wait-Key }
        elseif ($c -eq "7")  { Start-Process services.msc; Wait-Key }
        elseif ($c -eq "8")  { Show-Title "Startup Programs"; Get-CimInstance Win32_StartupCommand | Format-Table Name, Command, Location, User -AutoSize; Wait-Key }
        elseif ($c -eq "9")  { Start-Process taskmgr;  Wait-Key }
        elseif ($c -eq "10") { Start-Process msconfig; Wait-Key }
    }
}

# ================================================================
# 7. SECURITY & FIREWALL
# ================================================================
function Menu-Security {
    while ($true) {
        Show-Header
        Write-Host "  [ SECURITY & FIREWALL ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Firewall Status"
        Write-Host "   2.  Enable Firewall"
        Write-Host "   3.  Disable Firewall"
        Write-Host "   4.  List Active Firewall Rules"
        Write-Host "   5.  Open Windows Firewall"
        Write-Host "   6.  Windows Defender Status"
        Write-Host "   7.  Defender Quick Scan"
        Write-Host "   8.  Update Defender Signatures"
        Write-Host "   9.  Local Users"
        Write-Host "   10. Local Groups"
        Write-Host "   11. Logged-On Users"
        Write-Host "   12. Listening Ports"
        Write-Host "   13. Open Windows Security"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1")  { Show-Title "Firewall Status"; netsh advfirewall show allprofiles; Wait-Key }
        elseif ($c -eq "2")  { netsh advfirewall set allprofiles state on; Wait-Key }
        elseif ($c -eq "3")  { if ((Read-Host "  Type YES to disable firewall") -eq "YES") { netsh advfirewall set allprofiles state off }; Wait-Key }
        elseif ($c -eq "4")  { Show-Title "Active Rules"; Get-NetFirewallRule | Where-Object {$_.Enabled -eq $true} | Select-Object Name, Direction, Action, Profile | Format-Table -AutoSize; Wait-Key }
        elseif ($c -eq "5")  { Start-Process wf.msc; Wait-Key }
        elseif ($c -eq "6")  { Show-Title "Defender Status"; Get-MpComputerStatus | Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled, RealTimeProtectionEnabled | Format-List; Wait-Key }
        elseif ($c -eq "7")  { Start-MpScan -ScanType QuickScan; Wait-Key }
        elseif ($c -eq "8")  { Update-MpSignature; Wait-Key }
        elseif ($c -eq "9")  { Show-Title "Local Users"; Get-LocalUser | Format-Table Name, Enabled, LastLogon -AutoSize; Wait-Key }
        elseif ($c -eq "10") { Show-Title "Local Groups"; Get-LocalGroup | Format-Table Name, Description -AutoSize; Wait-Key }
        elseif ($c -eq "11") { Show-Title "Logged-On Users"; query user 2>&1; Wait-Key }
        elseif ($c -eq "12") {
            Show-Title "Listening Ports"
            netstat -ano | Select-String "LISTENING" | ForEach-Object {
                $p = ($_.ToString().Trim()) -split '\s+'; [PSCustomObject]@{Protocol=$p[0]; Address=$p[1]; PID=$p[4]}
            } | Sort-Object Address | Format-Table -AutoSize; Wait-Key
        }
        elseif ($c -eq "13") { Start-Process "windowsdefender:"; Wait-Key }
    }
}

# ================================================================
# 8. PERFORMANCE
# ================================================================
function Menu-Performance {
    while ($true) {
        Show-Header
        Write-Host "  [ PERFORMANCE TOOLS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Top CPU Processes"
        Write-Host "   2.  RAM Usage"
        Write-Host "   3.  GPU Info"
        Write-Host "   4.  Battery Status"
        Write-Host "   5.  Generate Battery Report"
        Write-Host "   6.  Open Resource Monitor"
        Write-Host "   7.  Open Performance Monitor"
        Write-Host "   8.  Page File Info"
        Write-Host "   9.  Last Boot Time"
        Write-Host "   10. Open Reliability Monitor"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Get-Process | Sort-Object CPU -Descending | Select-Object -First 25 Name, Id, @{L="CPU(s)"; E={[math]::Round($_.CPU,2)}}, @{L="RAM(MB)"; E={[math]::Round($_.WorkingSet/1MB,2)}} | Format-Table -AutoSize; Wait-Key }
        elseif ($c -eq "2") {
            $os = Get-CimInstance Win32_OperatingSystem
            $total = [math]::Round($os.TotalVisibleMemorySize/1MB,2); $free = [math]::Round($os.FreePhysicalMemory/1MB,2); $used = [math]::Round($total - $free,2)
            Write-Host "  Total : ${total} GB`n  Used  : ${used} GB ($([math]::Round(($used/$total)*100,1))%)`n  Free  : ${free} GB"; Wait-Key
        }
        elseif ($c -eq "3") { Get-CimInstance Win32_VideoController | Format-List Name, DriverVersion, VideoModeDescription; Wait-Key }
        elseif ($b = Get-CimInstance Win32_Battery) {
            if ($b) { Write-Host "  Charge : $($b.EstimatedChargeRemaining)%" } else { Write-Host "  No battery." }; Wait-Key
        }
        elseif ($c -eq "5") { $out = "$env:USERPROFILE\Desktop\BatteryReport.html"; powercfg /batteryreport /output $out 2>&1; Start-Process $out; Wait-Key }
        elseif ($c -eq "6")  { Start-Process resmon; Wait-Key }
        elseif ($c -eq "7")  { Start-Process perfmon; Wait-Key }
        elseif ($c -eq "8")  { Get-CimInstance Win32_PageFileUsage | Format-List Name, AllocatedBaseSize, CurrentUsage; Wait-Key }
        elseif ($c -eq "9")  { $boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime; $up = (Get-Date) - $boot; Write-Host "  Uptime: $($up.Days)d $($up.Hours)h"; Wait-Key }
        elseif ($c -eq "10") { Start-Process "perfmon /rel"; Wait-Key }
    }
}

# ================================================================
# 9. DRIVERS & HARDWARE
# ================================================================
function Menu-Drivers {
    while ($true) {
        Show-Header
        Write-Host "  [ DRIVER & HARDWARE ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Problem Devices"
        Write-Host "   2.  All PnP Devices"
        Write-Host "   3.  Open Device Manager"
        Write-Host "   4.  Hardware Info (CPU / RAM / BIOS Serial Tag)"
        Write-Host "   5.  DirectX Diagnostic (dxdiag)"
        Write-Host "   6.  Driver Signature Verifier"
        Write-Host "   7.  Export Driver List to Desktop"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            $p = Get-WmiObject Win32_PnPEntity | Where-Object {$_.ConfigManagerErrorCode -ne 0}
            if ($p) { $p | Format-Table Name, ConfigManagerErrorCode -AutoSize } else { Write-Host "  No problem devices." -ForegroundColor Green }; Wait-Key
        }
        elseif ($c -eq "2") { Get-PnpDevice | Sort-Object Status | Format-Table Status, Class, FriendlyName -AutoSize; Wait-Key }
        elseif ($c -eq "3") { Start-Process devmgmt.msc; Wait-Key }
        elseif ($c -eq "4") {
            $bios = Get-CimInstance Win32_BIOS
            $cpu = (Get-CimInstance Win32_Processor).Name; $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum/1GB,2)
            Write-Host "  CPU         : $cpu"
            Write-Host "  RAM         : ${ram} GB"
            Write-Host "  Serial / Tag: $($bios.SerialNumber)" -ForegroundColor Gold
            Wait-Key
        }
        elseif ($c -eq "5") { Start-Process dxdiag; Wait-Key }
        elseif ($c -eq "6") { Start-Process sigverif; Wait-Key }
        elseif ($c -eq "7") { $out = "$env:USERPROFILE\Desktop\DriverList.txt"; driverquery /v /fo csv | Out-File $out; Write-Host "  Exported." -ForegroundColor Green; Wait-Key }
    }
}

# ================================================================
# 10. REMOTE & SHARING
# ================================================================
function Menu-Remote {
    while ($true) {
        Show-Header
        Write-Host "  [ REMOTE & SHARING ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Enable Remote Desktop"
        Write-Host "   2.  Disable Remote Desktop"
        Write-Host "   3.  Open Remote Desktop Client"
        Write-Host "   4.  Shared Folders"
        Write-Host "   5.  Active Sessions"
        Write-Host "   6.  Enable WinRM"
        Write-Host "   7.  Map Network Drive"
        Write-Host "   8.  List Mapped Drives"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Set-ItemProperty "HKLM:\System\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" 0; Enable-NetFirewallRule -DisplayGroup "Remote Desktop"; Wait-Key }
        elseif ($c -eq "2") { Set-ItemProperty "HKLM:\System\CurrentControlSet\Control\Terminal Server" "fDenyTSConnections" 1; Disable-NetFirewallRule -DisplayGroup "Remote Desktop"; Wait-Key }
        elseif ($c -eq "3") { Start-Process mstsc; Wait-Key }
        elseif ($c -eq "4") { net share; Wait-Key }
        elseif ($c -eq "5") { net session; Wait-Key }
        elseif ($c -eq "6") { Enable-PSRemoting -Force; Wait-Key }
        elseif ($c -eq "7") { net use "$((Read-Host '   Drive Letter')):" $(Read-Host '   Network Path') /persistent:yes; Wait-Key }
        elseif ($c -eq "8") { net use; Wait-Key }
    }
}

# ================================================================
# 11. REGISTRY & ADVANCED
# ================================================================
function Menu-Advanced {
    while ($true) {
        Show-Header
        Write-Host "  [ REGISTRY & ADVANCED ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Open Registry Editor"
        Write-Host "   2.  Open Group Policy Editor"
        Write-Host "   3.  Advanced System Properties"
        Write-Host "   4.  Control Panel"
        Write-Host "   5.  Rebuild Icon Cache"
        Write-Host "   6.  Show Boot Config (bcdedit)"
        Write-Host "   7.  Enable Hibernate"
        Write-Host "   8.  Disable Hibernate"
        Write-Host "   9.  Scheduled Tasks"
        Write-Host "   10. Programs and Features"
        Write-Host "   11. Flush and Reset App Execution Aliases"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1")  { Start-Process regedit; Wait-Key }
        elseif ($c -eq "2")  { Start-Process gpedit.msc; Wait-Key }
        elseif ($c -eq "3")  { Start-Process sysdm.cpl; Wait-Key }
        elseif ($c -eq "4")  { Start-Process control; Wait-Key }
        elseif ($c -eq "5")  {
            Stop-Process -Name explorer -Force; Start-Sleep 2
            Remove-Item "$env:LOCALAPPDATA\IconCache.db" -Force
            Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\iconcache*" -Force
            Start-Process explorer; Wait-Key
        }
        elseif ($c -eq "6")  { bcdedit; Wait-Key }
        elseif ($c -eq "7")  { powercfg /hibernate on; Wait-Key }
        elseif ($c -eq "8")  { powercfg /hibernate off; Wait-Key }
        elseif ($c -eq "9")  { Start-Process taskschd.msc; Wait-Key }
        elseif ($c -eq "10") { Start-Process appwiz.cpl; Wait-Key }
        elseif ($c -eq "11") { Remove-Item "$env:LOCALAPPDATA\Microsoft\WindowsApps\*" -Recurse -Force; Wait-Key }
    }
}

# ================================================================
# 12. QUICK FIXES
# ================================================================
function Menu-QuickFix {
    while ($true) {
        Show-Header
        Write-Host "  [ QUICK FIXES ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Full System Repair (SFC + DISM)"
        Write-Host "   2.  Full Network Reset"
        Write-Host "   3.  Clear All Temp and Junk Files"
        Write-Host "   4.  Restart Windows Explorer"
        Write-Host "   5.  Rebuild Windows Search Index"
        Write-Host "   6.  Reset Windows Store"
        Write-Host "   7.  Re-enable Critical Services"
        Write-Host "   8.  Fix Windows Time Sync"
        Write-Host "   9.  Reset Hosts File + Flush DNS"
        Write-Host "   10. Purge Spooler & Clear Frozen Print Queue"
        Write-Host "   11. Force Group Policy Engine Re-Evaluation (gpupdate /force)"
        Write-Host "   12. Reset Local Group Policy Client Side Cache"
        Write-Host "   13. Advanced Printer Driver Remediation"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { sfc /scannow; DISM /Online /Cleanup-Image /RestoreHealth; Wait-Key }
        elseif ($c -eq "2") { ipconfig /flushdns; netsh winsock reset; netsh int ip reset; Wait-Key }
        elseif ($c -eq "3") {
            foreach ($l in @("$env:TEMP","$env:SystemRoot\Temp","$env:LOCALAPPDATA\Temp","$env:SystemRoot\Prefetch")) {
                Get-ChildItem $l -Recurse -Force | Remove-Item -Recurse -Force
            }
            Wait-Key
        }
        elseif ($c -eq "4") { Stop-Process -Name explorer -Force; Start-Sleep 2; Start-Process explorer; Wait-Key }
        elseif ($c -eq "5") { Stop-Service WSearch -Force; Remove-Item "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\*" -Recurse -Force; Start-Service WSearch; Wait-Key }
        elseif ($c -eq "6") { wsreset.exe; Wait-Key }
        elseif ($c -eq "7") {
            foreach ($s in @("wuauserv","bits","CryptSvc","WinDefend","MpsSvc","Dhcp","Dnscache")) {
                Set-Service $s -StartupType Automatic; Start-Service $s
            }
            Wait-Key
        }
        elseif ($c -eq "8") { net stop w32tm; w32tm /unregister; w32tm /register; net start w32tm; w32tm /resync /force; Wait-Key }
        elseif ($c -eq "9") { "# Windows hosts file`r`n127.0.0.1    localhost" | Set-Content "$env:SystemRoot\System32\drivers\etc\hosts" -Force; ipconfig /flushdns; Wait-Key }
        elseif ($c -eq "10") {
            Stop-Service -Name Spooler -Force
            Get-ChildItem -Path "$env:SystemRoot\System32\spool\PRINTERS\*" -Recurse | Remove-Item -Force
            Start-Service -Name Spooler; Wait-Key
        }
        elseif ($c -eq "11") { gpupdate /force; Wait-Key }
        elseif ($c -eq "12") {
            Remove-Item "$env:SystemRoot\System32\GroupPolicy\Machine\Registry.pol" -Force
            Remove-Item "$env:SystemRoot\System32\GroupPolicy\User\Registry.pol" -Force
            gpupdate /force; Wait-Key
        }
        elseif ($c -eq "13") {
            Show-Title "Re-registering and Auditing Print Subsystems"
            Get-PrinterDriver | Format-Table Name, PrinterEnvironment, DriverPath -AutoSize
            Write-Host "`nTo delete a broken driver run: Remove-PrinterDriver -Name 'DriverName'" -ForegroundColor Cyan
            Wait-Key
        }
    }
}

# ================================================================
# 13. UWP & STORE APP FIXES
# ================================================================
function Menu-UWPApps {
    while ($true) {
        Show-Header
        Write-Host "  [ UWP & WINDOWS STORE APP FIXES ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Reinstall All Default Built-In Apps"
        Write-Host "   2.  Re-register Windows Microsoft Store Environment"
        Write-Host "   3.  Force Clear Microsoft Store Local Cache"
        Write-Host "   4.  Fix Store Apps Licensing Policy Sync"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Get-AppxPackage -AllUsers | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }; Wait-Key }
        elseif ($c -eq "2") { Get-AppXPackage -AllUsers -Name "Microsoft.WindowsStore" | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }; Wait-Key }
        elseif ($c -eq "3") {
            $StorePath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache"
            if (Test-Path $StorePath) { Get-ChildItem $StorePath -Recurse | Remove-Item -Recurse -Force }
            Wait-Key
        }
        elseif ($c -eq "4") { Get-CimInstance Win32_WindowsUpdateAgent | Invoke-CimMethod -MethodName ApplyAuthorizationPolicy; Wait-Key }
    }
}

# ================================================================
# 14. ACCOUNTS, USERS & LOCAL GROUPS
# ================================================================
function Menu-Accounts {
    while ($true) {
        Show-Header
        Write-Host "  [ ACCOUNTS, USERS & LOCAL GROUPS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Unlock a Local Account"
        Write-Host "   2.  Force Reset Password of Local Account"
        Write-Host "   3.  Create a New Local Admin Account Instantly"
        Write-Host "   4.  View Detailed List of Administrators Group"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Unlock-LocalUser -Name (Read-Host "   Target Account Username"); Wait-Key }
        elseif ($c -eq "2") { Set-LocalUser -Name (Read-Host "   Username") -Password (Read-Host "   New Password" -AsSecureString); Wait-Key }
        elseif ($c -eq "3") {
            $u = Read-Host "   Enter Target New Username"
            $p = Read-Host "   Enter Password" -AsSecureString
            New-LocalUser -Name $u -Password $p -Description "Emergency Support Admin"
            Add-LocalGroupMember -Group "Administrators" -Member $u; Wait-Key
        }
        elseif ($c -eq "4") { Get-LocalGroupMember -Group "Administrators" | Format-Table Name, PrincipalSource, ObjectClass -AutoSize; Wait-Key }
    }
}

# ================================================================
# 15. ENTRA ID / CLOUD WORKSPACE AUDITS
# ================================================================
function Menu-CloudIdentity {
    while ($true) {
        Show-Header
        Write-Host "  [ ENTRA ID / CLOUD WORKSPACE AUDITS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Check Device Azure AD / Entra Join Status (dsregcmd /status)"
        Write-Host "   2.  Force Trigger PRT (Primary Refresh Token) Cloud Sync"
        Write-Host "   3.  Clear Workplace Join Certificate Locks"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { dsregcmd /status; Wait-Key }
        elseif ($c -eq "2") { dsregcmd /refreshprt; Wait-Key }
        elseif ($c -eq "3") {
            Show-Title "Clearing Stale Broker Plugin Registrations"
            Start-Process taskkill -ArgumentList "/f /im Microsoft.AAD.BrokerPlugin.exe" -Wait
            $IdPath = "$env:LOCALAPPDATA\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"
            if (Test-Path $IdPath) { 
                Remove-Item $IdPath -Recurse -Force 
                Write-Host "  Identity plug-in database cache successfully swept clean." -ForegroundColor Green
            } else {
                Write-Host "  Broker cache path was already clean or unallocated." -ForegroundColor Yellow
            }
            Wait-Key
        }
    }
}

# ================================================================
# 16. FEATURES & OPTIONAL COMPONENT ENGINE
# ================================================================
function Menu-OptionalFeatures {
    while ($true) {
        Show-Header
        Write-Host "  [ FEATURES & OPTIONAL COMPONENT ENGINE ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  List Active Windows Optional Features"
        Write-Host "   2.  Enable Windows Subsystem for Linux (WSL)"
        Write-Host "   3.  Enable Hyper-V Virtualization Framework"
        Write-Host "   4.  Enable Sandbox Environment Mode"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Get-WindowsOptionalFeature -Online | Where-Object {$_.State -eq "Enabled"} | Format-Table FeatureName, Description -AutoSize; Wait-Key }
        elseif ($c -eq "2") { Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart; Wait-Key }
        elseif ($c -eq "3") { Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-All" -NoRestart; Wait-Key }
        elseif ($c -eq "4") { Enable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableWinSandbox" -NoRestart; Wait-Key }
    }
}

# ================================================================
# 17. MS OFFICE, ONEDRIVE & SHAREPOINT REPAIR SUITE
# ================================================================
function Menu-OfficeSuite {
    while ($true) {
        Show-Header
        Write-Host "  [ MS OFFICE, ONEDRIVE & SHAREPOINT REPAIR SUITE ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Purge Cached Office/OneDrive Credentials (Fix Sign-In Loops)"
        Write-Host "   2.  Execute Hard OneDrive Sync App Reset (/reset)"
        Write-Host "   3.  Clear Corrupted Office Document Cache (Fix Upload Blocked)"
        Write-Host "   4.  Force Outlook to Safe Mode (Next Launch Only)"
        Write-Host "   5.  Reset Outlook Local Preferences & Clear Profiles"
        Write-Host "   6.  Nuke Word/Excel Stuck Recovery Document Hives"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Clearing Stale Identity & Collaboration Tokens"
            cmd /c "cmdkey /list | findstr /I `"MicrosoftOffice16_Data OneDrive MatrixCachedAuth`" > %temp%\offtokens.txt"
            Get-Content "$env:TEMP\offtokens.txt" | ForEach-Object {
                if ($_ -match "Target:\s*(.*)") {
                    $t = $matches[1].Trim()
                    cmd /c "cmdkey /delete:`"$t`""
                }
            }
            Write-Host "  Identity credentials unlinked. Users must re-authenticate on next app launch." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Executing Hard OneDrive Reset"
            Write-Host "  Terminating OneDrive processing trees..." -ForegroundColor Yellow
            Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
            
            $paths = @(
                "$env:ProgramFiles\Microsoft OneDrive\OneDrive.exe",
                "${env:ProgramFiles(x86)}\Microsoft OneDrive\OneDrive.exe",
                "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
            )
            
            $executed = $false
            foreach ($p in $paths) {
                if (Test-Path $p) {
                    Write-Host "  Found engine instance at: $p" -ForegroundColor Cyan
                    Write-Host "  Triggering database wipe and re-indexing..." -ForegroundColor Yellow
                    Start-Process -FilePath $p -ArgumentList "/reset" -NoNewWindow
                    $executed = $true
                    break
                }
            }
            
            if (-not $executed) {
                Write-Host "  [ERROR] OneDrive execution binary could not be auto-located." -ForegroundColor Red
            } else {
                Start-Sleep -Seconds 3
                Write-Host "  Reset command sent successfully. OneDrive will re-index local/SharePoint paths shortly." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Clearing Corrupted Office Document Cache (ODC)"
            Write-Host "  Killing synchronization hold threads..." -ForegroundColor Yellow
            Stop-Process -Name "msosync" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "FileCoAuth" -Force -ErrorAction SilentlyContinue
            
            $OdcPaths = @(
                "$env:LOCALAPPDATA\Microsoft\Office\16.0\OfficeFileCache",
                "$env:LOCALAPPDATA\Microsoft\Office\15.0\OfficeFileCache"
            )
            
            foreach ($path in $OdcPaths) {
                if (Test-Path $path) {
                    Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "  Purged Office File Cache at: $path" -ForegroundColor Green
                }
            }
            Write-Host "  Upload allocation maps cleared. Conflict blocks resolved." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Setting Outlook Recovery Flag"
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Outlook\Security" -Name "SafeMode" -Value 1
            Write-Host "  Flag initialized. Outlook will launch in safe environment layout." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Outlook Structural Nuke"
            if ((Read-Host "  Type YES to wipe local profiles") -eq "YES") {
                Stop-Process -Name outlook -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "HKCU:\Software\Microsoft\Office\16.0\Outlook\Profiles\*" -Recurse -Force
                Write-Host "  Profiles dropped. New workspace map required on execution." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Clearing Office Autorecover Caches"
            Remove-Item "$env:APPDATA\Microsoft\Word\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item "$env:APPDATA\Microsoft\Excel\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "  Document loop buffers clear." -ForegroundColor Green
            Wait-Key
        }
    }
}

# ================================================================
# 18. ADVANCED BSOD & CRASH ANALYTICS
# ================================================================
function Menu-CrashAnalytics {
    while ($true) {
        Show-Header
        Write-Host "  [ ADVANCED BSOD & CRASH ANALYTICS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Analyze Last Crash Mini-Dump Metadata"
        Write-Host "   2.  Audit Live Kernel Error Records via CIM"
        Write-Host "   3.  Check Memory Dump Generation Settings"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Mini-Dump Inventory Analysis"
            $Dumps = Get-ChildItem -Path "$env:SystemRoot\Minidump\*" -Include *.dmp -ErrorAction SilentlyContinue
            if ($Dumps) {
                $Dumps | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
                Write-Host "  Target structures isolated. Point standard WinDbg parsing models to location above." -ForegroundColor Cyan
            } else {
                Write-Host "  No mini-dump allocation matrices present on storage layout." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Parsing Kernel Error Logs"
            Get-CimInstance -ClassName Win32_NTLogEvent -Filter "Logfile='System' AND (EventCode=41 OR EventCode=1001)" | 
                Select-Object TimeGenerated, EventCode, Message -First 5 | Format-List
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Crash Settings Architecture Check"
            Get-CimInstance Win32_OSRecoveryConfiguration | Format-List DebugInfoType, DumpFile, WriteToSystemLog
            Wait-Key
        }
    }
}

# ================================================================
# 19. ENTERPRISE LGPO & POLICY ENGINE
# ================================================================
function Menu-PolicyInjection {
    while ($true) {
        Show-Header
        Write-Host "  [ ENTERPRISE LGPO & POLICY INJECTION ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Dump Active RSOP (Resultant Set of Policy) HTML Report"
        Write-Host "   2.  Nuke Client Side Registry Policy Hives completely"
        Write-Host "   3.  Verify Intune / MDM Management Enrollment Status"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Generating Local Policy Infrastructure Map"
            $OutPath = "$env:USERPROFILE\Desktop\RSOP_Report.html"
            gpresult /h $OutPath /f
            Write-Host "  Report rendered to Desktop container: $OutPath" -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Dropping Local Group Policy Targets"
            if ((Read-Host "  Type WIPE to delete all local policy files") -eq "WIPE") {
                Remove-Item "$env:SystemRoot\System32\GroupPolicy\Machine\*" -Recurse -Force
                Remove-Item "$env:SystemRoot\System32\GroupPolicy\User\*" -Recurse -Force
                gpupdate /force
                Write-Host "  Local client policies fully decoupled." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "MDM Enrollment Configuration State"
            Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Enrollments\*" | ForEach-Object {
                $Upn = Get-ItemProperty $_.PSPath -Name "UPN" -ErrorAction SilentlyContinue
                if ($Upn) { Write-Host "  [FOUND ACTIVE MDM] Managed Target: $($Upn.UPN)" -ForegroundColor Green }
            }
            Wait-Key
        }
    }
}

# ================================================================
# 20. WMI REPOSITORY REPAIR & SALVAGE
# ================================================================
function Menu-WMISalvage {
    while ($true) {
        Show-Header
        Write-Host "  [ WMI REPOSITORY REPAIR & SALVAGE ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Verify WMI Core Repository Consistency Status"
        Write-Host "   2.  Execute Soft-Salvage Rebuild (Non-Destructive)"
        Write-Host "   3.  NUCLEAR WMI REBUILD (Complete Architecture Sync)"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Validating WMI Consistency Metrics"
            cmd /c "winmgmt /verifyrepository"
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Attempting Salvage Operations"
            Stop-Service winmgmt -Force
            cmd /c "winmgmt /salvagerepository"
            Start-Service winmgmt
            Write-Host "  Consistency analysis complete." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Executing Full System WMI Database Recovery"
            if ((Read-Host "  Confirm by typing NUCLEAR") -eq "NUCLEAR") {
                Write-Host "  Halting dependency frameworks..." -ForegroundColor Yellow
                Stop-Service iphlpsvc -Force
                Stop-Service ncisvc -Force
                Stop-Service winmgmt -Force
                
                Write-Host "  Resetting core repository database targets..." -ForegroundColor Yellow
                cmd /c "winmgmt /resetrepository"
                
                Write-Host "  Re-registering infrastructure modules..." -ForegroundColor Yellow
                cmd /c "cd /d %windir%\system32\wbem && for %i in (*.dll) do RegSvr32 /s %i"
                cmd /c "cd /d %windir%\system32\wbem && for %i in (*.mof,*.mfl) do MofComp %i"
                
                Write-Host "  Starting core communication nodes..." -ForegroundColor Yellow
                Start-Service winmgmt
                Write-Host "  WMI framework reset complete. Systems require immediate machine restart." -ForegroundColor Green
            }
            Wait-Key
        }
    }
}

# ================================================================
# 21. ACTIVE DIRECTORY LOCAL DOMAIN TRUST (L2/L3)
# ================================================================
function Menu-ADDomain {
    while ($true) {
        Show-Header
        Write-Host "  [ ACTIVE DIRECTORY LOCAL DOMAIN TRUST ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Verify Domain Secure Channel Trust Relationship"
        Write-Host "   2.  Force Repair Broken Computer Trust Account"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Checking Active Directory Trust Boundaries"
            if (Test-ComputerSecureChannel -VerifySecureChannel) {
                Write-Host "  [PASS] Local workstation authentication tunnel to Domain Controller is healthy." -ForegroundColor Green
            } else {
                Write-Host "  [FAIL] Trust relationship broken or machine is on a workgroup." -ForegroundColor Red
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Executing Local Secure Channel Repair Sequence"
            Write-Host "  Note: Requires line of sight to Domain Controller (VPN/On-Site)." -ForegroundColor Cyan
            $Cred = Get-Credential -UserName "DOMAIN\AdminUser" -Message "Enter Domain Admin Credentials to Repair Trust"
            if (Test-ComputerSecureChannel -Repair -Credential $Cred) {
                Write-Host "  [SUCCESS] Workspace domain machine token re-established successfully." -ForegroundColor Green
            } else {
                Write-Host "  [FAILURE] Could not reconcile machine cryptographic state with DC." -ForegroundColor Red
            }
            Wait-Key
        }
    }
}

# ================================================================
# 22. BITLOCKER ENCRYPTION TOOLKIT (L1-L2)
# ================================================================
function Menu-BitLocker {
    while ($true) {
        Show-Header
        Write-Host "  [ BITLOCKER ENCRYPTION TOOLKIT ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Check Volumes BitLocker Status"
        Write-Host "   2.  Extract Cleartext BitLocker Recovery Keys"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Analyzing Volume Encryption Layouts"
            manage-bde -status
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Extracting Safety Recovery Protector Keys"
            $Volumes = Get-BitLockerVolume -ErrorAction SilentlyContinue
            if ($Volumes) {
                foreach ($Vol in $Volumes) {
                    Write-Host "  Drive Mount Point: $($Vol.MountPoint)" -ForegroundColor Gold
                    $Vol | Select-Object -ExpandProperty KeyProtector | Format-List
                }
            } else {
                Write-Host "  No BitLocker protection structures detected on this hardware." -ForegroundColor Yellow
            }
            Wait-Key
        }
    }
}

# ================================================================
# 23. MECM / SCCM ENDPOINT MANAGEMENT (L2-L3)
# ================================================================
function Menu-MECM {
    while ($true) {
        Show-Header
        Write-Host "  [ MECM / SCCM ENDPOINT MANAGEMENT ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Restart SMS Agent Host Service (CcmExec)"
        Write-Host "   2.  Force Immediate Machine Discovery Data Cycle"
        Write-Host "   3.  Trigger Software Inventory & Evaluation Cycles"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Bouncing Configuration Manager Core Engine"
            Restart-Service -Name "CcmExec" -Force
            Write-Host "  SMS Agent Host service cycled successfully." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Triggering MECM Discovery Data Cycle"
            Invoke-CimMethod -Namespace root\ccm -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID = "{00000000-0000-0000-0000-0000-000000000003}"}
            Write-Host "  DDR deployment discovery thread pushed out into background." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Triggering MECM Inventory App Evaluation Passes"
            Invoke-CimMethod -Namespace root\ccm -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID = "{00000000-0000-0000-0000-0000-000000000001}"}
            Invoke-CimMethod -Namespace root\ccm -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID = "{00000000-0000-0000-0000-0000-000000000022}"}
            Write-Host "  Software updates evaluation evaluation framework initiated." -ForegroundColor Green
            Wait-Key
        }
    }
}

# ================================================================
# 24. CERTIFICATE STORE & L3 ROUTES (L3)
# ================================================================
function Menu-CertRoute {
    while ($true) {
        Show-Header
        Write-Host "  [ CERTIFICATE STORE & L3 ROUTES ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Audit Expired / Stale Local Machine Certificates"
        Write-Host "   2.  Show Network Kernel IPv4 Routing Tables"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Auditing Expired Local Identity Certificates"
            $Expired = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.NotAfter -lt (Get-Date) }
            if ($Expired) {
                $Expired | Format-Table Subject, NotAfter, Thumbprint, Issuer -AutoSize
            } else {
                Write-Host "  All items in the local computer Personal Certificate store are completely valid." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Displaying IPv4 Infrastructure Route Maps"
            Get-NetRoute -AddressFamily IPv4 | Format-Table DestinationPrefix, NextHop, RouteMetric, InterfaceAlias -AutoSize
            Wait-Key
        }
    }
}

# ================================================================
# 25. OFFICE REMOVAL / SCRUBBING TOOLKIT (L1-L3)
# ================================================================
function Menu-OfficeScrub {
    while ($true) {
        Show-Header
        Write-Host "  [ OFFICE REMOVAL / SCRUBBING TOOLKIT ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  List All Detected Office Installations (C2R + MSI)"
        Write-Host "   2.  Uninstall Office via Click-to-Run (OfficeClickToRun.exe)"
        Write-Host "   3.  Uninstall Office via MSI (Legacy 2010/2013/2016 MSI builds)"
        Write-Host "   4.  Download & Run Microsoft SaRA Office Uninstall (Online)"
        Write-Host "   5.  Scrub Leftover Office Registry Keys"
        Write-Host "   6.  Scrub Leftover Office Files & Folders (Program Files + AppData)"
        Write-Host "   7.  Remove Office Scheduled Tasks & Services"
        Write-Host "   8.  Remove Office Shortcuts (Desktop / Start Menu)"
        Write-Host "   9.  FULL OFFICE SCRUB (Uninstall + Registry + Files + Tasks) [DESTRUCTIVE]"
        Write-Host "  10. Verify Office Fully Removed (Post-Scrub Check)"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Detected Office Installations"
            Write-Host "  -- Click-to-Run (Microsoft 365 / 2016+) --" -ForegroundColor Cyan
            $C2R = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -ErrorAction SilentlyContinue
            if ($C2R) {
                Write-Host "  ProductReleaseIds : $($C2R.ProductReleaseIds)"
                Write-Host "  VersionToReport   : $($C2R.VersionToReport)"
                Write-Host "  Platform          : $($C2R.Platform)"
                Write-Host "  InstallationPath  : $($C2R.InstallationPath)"
            } else {
                Write-Host "  No Click-to-Run installation registry hive found." -ForegroundColor Yellow
            }
            Write-Host ""
            Write-Host "  -- MSI-based (Legacy) Office Products --" -ForegroundColor Cyan
            $paths = @(
                "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
                "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
            )
            $paths | ForEach-Object { Get-ItemProperty $_ -ErrorAction SilentlyContinue } |
                Where-Object { $_.DisplayName -match "Microsoft Office|Microsoft 365|Outlook|Visio|Project \d" } |
                Select-Object DisplayName, DisplayVersion, UninstallString | Format-Table -AutoSize
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Uninstall Office (Click-to-Run)"
            $OdtExe = "$env:CommonProgramFiles\Microsoft Shared\ClickToRun\OfficeClickToRun.exe"
            if (Test-Path $OdtExe) {
                Write-Host "  Launching Click-to-Run uninstall sequence..." -ForegroundColor Yellow
                Write-Host "  (This opens the native 'Uninstall updates/repair' tool. Choose Uninstall.)" -ForegroundColor Cyan
                Start-Process $OdtExe -ArgumentList "scenario=install scenariosubtype=ARP sourcetype=None productstoremove=AllOfficeProducts culture=en-us version.16=16.0" -Wait
                Write-Host "  Click-to-Run uninstall process completed/closed." -ForegroundColor Green
            } else {
                Write-Host "  [INFO] OfficeClickToRun.exe not found. Office may not be C2R, or already removed." -ForegroundColor Yellow
                Write-Host "  Falling back to standard ARP uninstall string lookup..." -ForegroundColor Cyan
                $App = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
                    Where-Object { $_.DisplayName -match "Microsoft 365|Microsoft Office" } | Select-Object -First 1
                if ($App -and $App.UninstallString) {
                    Write-Host "  Found: $($App.DisplayName)" -ForegroundColor Cyan
                    cmd /c $App.UninstallString
                } else {
                    Write-Host "  No uninstall path could be resolved automatically." -ForegroundColor Red
                }
            }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Uninstall Office (Legacy MSI)"
            $paths = @(
                "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
                "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
            )
            $MsiApps = $paths | ForEach-Object { Get-ItemProperty $_ -ErrorAction SilentlyContinue } |
                Where-Object { $_.DisplayName -match "Microsoft Office|Visio|Project \d" -and $_.UninstallString -match "MsiExec" }
            if ($MsiApps) {
                $MsiApps | Select-Object DisplayName, PSChildName | Format-Table -AutoSize
                $Target = Read-Host "   Enter exact DisplayName to uninstall (or blank to cancel)"
                $Match = $MsiApps | Where-Object { $_.DisplayName -eq $Target }
                if ($Match) {
                    $ProductCode = $Match.PSChildName
                    Write-Host "  Uninstalling $Target via msiexec ($ProductCode)..." -ForegroundColor Yellow
                    Start-Process msiexec.exe -ArgumentList "/x $ProductCode /qb" -Wait
                    Write-Host "  MSI uninstall sequence finished." -ForegroundColor Green
                } else {
                    Write-Host "  No matching entry, or cancelled." -ForegroundColor Yellow
                }
            } else {
                Write-Host "  No legacy MSI-based Office products detected." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Microsoft SaRA Office Uninstall (Online Tool)"
            Write-Host "  This downloads Microsoft's official 'Support and Recovery Assistant'" -ForegroundColor Cyan
            Write-Host "  uninstall package directly from Microsoft's CDN and runs it." -ForegroundColor Cyan
            Write-Host "  Requires internet access on this machine." -ForegroundColor Yellow
            if ((Read-Host "  Type YES to download and launch SaRA Office Uninstall") -eq "YES") {
                $SaraUrl = "https://aka.ms/SaRA_EnterpriseVersionFiles"
                $Dest    = "$env:TEMP\SaRACMD.zip"
                try {
                    Write-Host "  Downloading SaRA package..." -ForegroundColor Yellow
                    Invoke-WebRequest -Uri $SaraUrl -OutFile $Dest -UseBasicParsing
                    $ExtractPath = "$env:TEMP\SaRACMD"
                    Expand-Archive -Path $Dest -DestinationPath $ExtractPath -Force
                    $SaraExe = Get-ChildItem -Path $ExtractPath -Filter "SaRAcmd.exe" -Recurse | Select-Object -First 1
                    if ($SaraExe) {
                        Write-Host "  Launching SaRA in Office Scrub (OffSweep) mode..." -ForegroundColor Yellow
                        Start-Process -FilePath $SaraExe.FullName -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All" -Wait
                        Write-Host "  SaRA Office removal scenario completed." -ForegroundColor Green
                    } else {
                        Write-Host "  [ERROR] Could not locate SaRAcmd.exe after extraction." -ForegroundColor Red
                    }
                } catch {
                    Write-Host "  [ERROR] Download or execution failed: $($_.Exception.Message)" -ForegroundColor Red
                    Write-Host "  Manual fallback: https://aka.ms/SaRA-OfficeUninstall-OffSweep" -ForegroundColor Cyan
                }
            }
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Scrubbing Leftover Office Registry Keys"
            if ((Read-Host "  Type YES to scrub Office registry remnants") -eq "YES") {
                $RegTargets = @(
                    "HKCU:\Software\Microsoft\Office",
                    "HKLM:\SOFTWARE\Microsoft\Office",
                    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office",
                    "HKCU:\Software\Microsoft\Office\ClickToRun",
                    "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun",
                    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OfficeClickToRun",
                    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\OfficeClickToRun",
                    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run\OfficeC2RAU"
                )
                foreach ($r in $RegTargets) {
                    if (Test-Path $r) {
                        Remove-Item -Path $r -Recurse -Force -ErrorAction SilentlyContinue
                        Write-Host "  Removed: $r" -ForegroundColor Green
                    }
                }
                Write-Host "  Registry scrub pass complete." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Scrubbing Leftover Office Files & Folders"
            if ((Read-Host "  Type YES to delete leftover Office files/folders") -eq "YES") {
                $FolderTargets = @(
                    "$env:ProgramFiles\Microsoft Office",
                    "${env:ProgramFiles(x86)}\Microsoft Office",
                    "$env:CommonProgramFiles\Microsoft Shared\OFFICE16",
                    "$env:CommonProgramFiles\Microsoft Shared\ClickToRun",
                    "$env:LOCALAPPDATA\Microsoft\Office",
                    "$env:APPDATA\Microsoft\Templates",
                    "$env:ProgramData\Microsoft\ClickToRun",
                    "$env:ProgramData\Microsoft\OfficeC2RVirtualSetupTasks"
                )
                foreach ($f in $FolderTargets) {
                    if (Test-Path $f) {
                        Remove-Item -Path $f -Recurse -Force -ErrorAction SilentlyContinue
                        Write-Host "  Removed: $f" -ForegroundColor Green
                    }
                }
                Write-Host "  File system scrub pass complete." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Removing Office Scheduled Tasks & Services"
            $Tasks = @(
                "\Microsoft\Office\Office 15 Subscription Heartbeat",
                "\Microsoft\Office\Office Automatic Updates 2.0",
                "\Microsoft\Office\Office ClickToRun Service Monitor",
                "\Microsoft\Office\OfficeTelemetryAgentLogOn2016",
                "\Microsoft\Office\OfficeTelemetryAgentFallBack2016"
            )
            foreach ($t in $Tasks) {
                schtasks /Delete /TN $t /F 2>&1 | Out-Null
            }
            Write-Host "  Office scheduled tasks removed (where present)." -ForegroundColor Green
            foreach ($svc in @("ClickToRunSvc","OfficeSvc")) {
                $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
                if ($s) {
                    Stop-Service $svc -Force -ErrorAction SilentlyContinue
                    sc.exe delete $svc | Out-Null
                    Write-Host "  Removed service: $svc" -ForegroundColor Green
                }
            }
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Removing Office Shortcuts"
            $ShortcutPaths = @(
                "$env:Public\Desktop\*.lnk",
                "$env:USERPROFILE\Desktop\*.lnk",
                "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\*.lnk",
                "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\*.lnk"
            )
            $OfficeNames = "Word|Excel|PowerPoint|Outlook|OneNote|Access|Publisher|Visio|Project|Microsoft 365|Office"
            foreach ($sp in $ShortcutPaths) {
                Get-ChildItem $sp -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $OfficeNames } | ForEach-Object {
                    Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
                    Write-Host "  Removed shortcut: $($_.Name)" -ForegroundColor Green
                }
            }
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "FULL OFFICE SCRUB"
            Write-Host "  This will attempt to: uninstall C2R Office, delete registry remnants," -ForegroundColor Yellow
            Write-Host "  delete leftover files/folders, remove scheduled tasks/services, and" -ForegroundColor Yellow
            Write-Host "  remove leftover shortcuts. This is DESTRUCTIVE and not reversible." -ForegroundColor Red
            Write-Host "  Recommend reboot before and after running this option." -ForegroundColor Cyan
            if ((Read-Host "  Type SCRUB to proceed") -eq "SCRUB") {
                $OdtExe = "$env:CommonProgramFiles\Microsoft Shared\ClickToRun\OfficeClickToRun.exe"
                if (Test-Path $OdtExe) {
                    Write-Host "  [1/5] Uninstalling via Click-to-Run..." -ForegroundColor Yellow
                    Start-Process $OdtExe -ArgumentList "scenario=install scenariosubtype=ARP sourcetype=None productstoremove=AllOfficeProducts culture=en-us version.16=16.0" -Wait
                } else {
                    Write-Host "  [1/5] No C2R engine found, skipping native uninstall step." -ForegroundColor Yellow
                }

                Write-Host "  [2/5] Stopping and removing Office services/tasks..." -ForegroundColor Yellow
                foreach ($svc in @("ClickToRunSvc","OfficeSvc")) {
                    Stop-Service $svc -Force -ErrorAction SilentlyContinue
                    sc.exe delete $svc | Out-Null
                }
                schtasks /Delete /TN "\Microsoft\Office\Office Automatic Updates 2.0" /F 2>&1 | Out-Null
                schtasks /Delete /TN "\Microsoft\Office\Office ClickToRun Service Monitor" /F 2>&1 | Out-Null

                Write-Host "  [3/5] Scrubbing registry remnants..." -ForegroundColor Yellow
                $RegTargets = @(
                    "HKCU:\Software\Microsoft\Office",
                    "HKLM:\SOFTWARE\Microsoft\Office",
                    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office"
                )
                foreach ($r in $RegTargets) { if (Test-Path $r) { Remove-Item $r -Recurse -Force -ErrorAction SilentlyContinue } }

                Write-Host "  [4/5] Scrubbing leftover files and folders..." -ForegroundColor Yellow
                $FolderTargets = @(
                    "$env:ProgramFiles\Microsoft Office",
                    "${env:ProgramFiles(x86)}\Microsoft Office",
                    "$env:CommonProgramFiles\Microsoft Shared\ClickToRun",
                    "$env:LOCALAPPDATA\Microsoft\Office",
                    "$env:ProgramData\Microsoft\ClickToRun"
                )
                foreach ($f in $FolderTargets) { if (Test-Path $f) { Remove-Item $f -Recurse -Force -ErrorAction SilentlyContinue } }

                Write-Host "  [5/5] Removing leftover shortcuts..." -ForegroundColor Yellow
                Get-ChildItem "$env:Public\Desktop\*.lnk","$env:ProgramData\Microsoft\Windows\Start Menu\Programs\*.lnk" -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -match "Word|Excel|PowerPoint|Outlook|OneNote|Access|Publisher|Visio|Microsoft 365|Office" } |
                    Remove-Item -Force -ErrorAction SilentlyContinue

                Write-Host ""
                Write-Host "  FULL OFFICE SCRUB COMPLETE. A restart is strongly recommended before" -ForegroundColor Green
                Write-Host "  reinstalling any Office product." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "10") {
            Show-Title "Post-Scrub Verification"
            $Found = $false
            if (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -ErrorAction SilentlyContinue) {
                Write-Host "  [WARNING] Click-to-Run configuration hive still present." -ForegroundColor Red; $Found = $true
            }
            if (Test-Path "$env:ProgramFiles\Microsoft Office") {
                Write-Host "  [WARNING] Program Files\Microsoft Office folder still present." -ForegroundColor Red; $Found = $true
            }
            if (Test-Path "${env:ProgramFiles(x86)}\Microsoft Office") {
                Write-Host "  [WARNING] Program Files (x86)\Microsoft Office folder still present." -ForegroundColor Red; $Found = $true
            }
            $paths = @("HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*","HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*")
            $Remaining = $paths | ForEach-Object { Get-ItemProperty $_ -ErrorAction SilentlyContinue } | Where-Object { $_.DisplayName -match "Microsoft Office|Microsoft 365" }
            if ($Remaining) {
                Write-Host "  [WARNING] ARP entries still registered:" -ForegroundColor Red
                $Remaining | Select-Object DisplayName | Format-Table -AutoSize
                $Found = $true
            }
            if (-not $Found) { Write-Host "  No obvious leftover traces detected. Office appears fully removed." -ForegroundColor Green }
            Wait-Key
        }
    }
}

# ================================================================
# 26. BLOATWARE, COPILOT & CONSUMER APP DEBLOAT ENGINE (L1-L2)
# ================================================================
function Menu-Debloat {
    while ($true) {
        Show-Header
        Write-Host "  [ BLOATWARE, COPILOT & CONSUMER APP DEBLOAT ENGINE ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  List All Installed AppX Packages (Current User)"
        Write-Host "   2.  Remove Microsoft Copilot (App + Taskbar Icon + Policy Lock)"
        Write-Host "   3.  Remove Cortana"
        Write-Host "   4.  Remove Xbox / Gaming Bloat (Xbox App, Game Bar, Xbox Identity)"
        Write-Host "   5.  Remove Consumer Bloat (Bing News/Weather, Solitaire, 3D Viewer, etc.)"
        Write-Host "   6.  Remove Microsoft Teams (Consumer / Personal build)"
        Write-Host "   7.  Disable Recall / Windows AI Snapshot Features"
        Write-Host "   8.  Disable Suggested/Sponsored Apps & Start Menu Ads"
        Write-Host "   9.  Disable Widgets & News and Interests"
        Write-Host "  10. FULL DEBLOAT PASS (Copilot + Cortana + Xbox + Consumer Bloat) [DESTRUCTIVE]"
        Write-Host "  11. Re-Install a Removed Built-In App (by package family name)"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Installed AppX Packages (Current User)"
            Get-AppxPackage | Sort-Object Name | Format-Table Name, PackageFullName -AutoSize
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Removing Microsoft Copilot"
            if ((Read-Host "  Type YES to remove Copilot") -eq "YES") {
                Write-Host "  Removing Copilot AppX package (all users)..." -ForegroundColor Yellow
                Get-AppxPackage -AllUsers "Microsoft.Windows.Ai.Copilot.Provider" -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                Get-AppxPackage -AllUsers "*Copilot*" -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match "Copilot" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null

                Write-Host "  Hiding Copilot taskbar icon..." -ForegroundColor Yellow
                if (-not (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced")) {
                    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Force | Out-Null
                }
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Value 0 -Type DWord -Force

                Write-Host "  Applying machine-wide policy lock (TurnOffWindowsCopilot)..." -ForegroundColor Yellow
                $PolPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
                if (-not (Test-Path $PolPath)) { New-Item -Path $PolPath -Force | Out-Null }
                Set-ItemProperty -Path $PolPath -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord -Force

                Write-Host "  Copilot removal pass complete. Explorer restart recommended." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Removing Cortana"
            if ((Read-Host "  Type YES to remove Cortana") -eq "YES") {
                Get-AppxPackage -AllUsers "Microsoft.549981C3F5F10" -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "Microsoft.549981C3F5F10" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
                Write-Host "  Cortana removed (where present on this Windows build)." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Removing Xbox / Gaming Bloat"
            if ((Read-Host "  Type YES to remove Xbox/Gaming components") -eq "YES") {
                $XboxApps = @(
                    "Microsoft.XboxApp",
                    "Microsoft.XboxGamingOverlay",
                    "Microsoft.XboxGameOverlay",
                    "Microsoft.XboxIdentityProvider",
                    "Microsoft.XboxSpeechToTextOverlay",
                    "Microsoft.GamingApp",
                    "Microsoft.Xbox.TCUI"
                )
                foreach ($pkg in $XboxApps) {
                    Get-AppxPackage -AllUsers $pkg -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $pkg } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
                }
                Write-Host "  Xbox / gaming overlay components removed." -ForegroundColor Green
                Write-Host "  Note: Game Bar registry toggle also available under option 8 in Quick Fixes if needed." -ForegroundColor Cyan
            }
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Removing Consumer Bloat Apps"
            if ((Read-Host "  Type YES to remove standard consumer bloat apps") -eq "YES") {
                $BloatApps = @(
                    "Microsoft.BingNews",
                    "Microsoft.BingWeather",
                    "Microsoft.BingSearch",
                    "Microsoft.MicrosoftSolitaireCollection",
                    "Microsoft.Microsoft3DViewer",
                    "Microsoft.MixedReality.Portal",
                    "Microsoft.People",
                    "Microsoft.PowerAutomateDesktop",
                    "Microsoft.Wallet",
                    "Microsoft.YourPhone",
                    "Microsoft.ZuneMusic",
                    "Microsoft.ZuneVideo",
                    "Microsoft.GetHelp",
                    "Microsoft.Getstarted",
                    "Microsoft.Messaging",
                    "Microsoft.MicrosoftOfficeHub",
                    "Microsoft.Office.OneNote",
                    "Microsoft.OneConnect",
                    "Microsoft.SkypeApp",
                    "Microsoft.WindowsFeedbackHub",
                    "Microsoft.WindowsMaps",
                    "Microsoft.WindowsSoundRecorder",
                    "Microsoft.Todos",
                    "Clipchamp.Clipchamp",
                    "MicrosoftCorporationII.MicrosoftFamily",
                    "MicrosoftTeams"
                )
                foreach ($pkg in $BloatApps) {
                    Get-AppxPackage -AllUsers $pkg -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $pkg } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
                }
                Write-Host "  Standard consumer bloat apps removed." -ForegroundColor Green
                Write-Host "  Note: Microsoft.Office.OneNote here is the UWP OneNote app, not desktop OneNote in Office." -ForegroundColor Cyan
            }
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Removing Microsoft Teams (Consumer Build)"
            if ((Read-Host "  Type YES to remove the consumer Teams app") -eq "YES") {
                Get-AppxPackage -AllUsers "MicrosoftTeams" -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "MicrosoftTeams" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
                $TeamsExe = "$env:LOCALAPPDATA\Microsoft\TeamsPresenceAddin"
                Write-Host "  Consumer Teams (chat icon build) removed." -ForegroundColor Green
                Write-Host "  Note: This does NOT remove the full Microsoft 365 Apps Teams client (classic/new work Teams)." -ForegroundColor Cyan
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Disabling Recall / Windows AI Snapshot Features"
            if ((Read-Host "  Type YES to disable Recall/AI snapshot features") -eq "YES") {
                $PolPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"
                if (-not (Test-Path $PolPath)) { New-Item -Path $PolPath -Force | Out-Null }
                Set-ItemProperty -Path $PolPath -Name "DisableAIDataAnalysis" -Value 1 -Type DWord -Force
                Set-ItemProperty -Path $PolPath -Name "AllowRecallEnablement" -Value 0 -Type DWord -Force
                Write-Host "  Disabling Recall optional feature (if present on this build)..." -ForegroundColor Yellow
                Disable-WindowsOptionalFeature -Online -FeatureName "Recall" -NoRestart -ErrorAction SilentlyContinue | Out-Null
                Write-Host "  Recall / AI snapshot policy locks applied." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Disabling Suggested Apps & Start Menu Ads"
            $CDM = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
            if (-not (Test-Path $CDM)) { New-Item -Path $CDM -Force | Out-Null }
            $Settings = @{
                "SubscribedContent-338388Enabled" = 0
                "SubscribedContent-338389Enabled" = 0
                "SubscribedContent-353698Enabled" = 0
                "SilentInstalledAppsEnabled"       = 0
                "SystemPaneSuggestionsEnabled"     = 0
                "PreInstalledAppsEnabled"          = 0
                "OemPreInstalledAppsEnabled"       = 0
                "RotatingLockScreenOverlayEnabled" = 0
            }
            foreach ($k in $Settings.Keys) { Set-ItemProperty -Path $CDM -Name $k -Value $Settings[$k] -Type DWord -Force -ErrorAction SilentlyContinue }
            Write-Host "  Suggested apps, app ads and silent app installs disabled for current user." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Disabling Widgets & News and Interests"
            $PolPath = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
            if (-not (Test-Path $PolPath)) { New-Item -Path $PolPath -Force | Out-Null }
            Set-ItemProperty -Path $PolPath -Name "AllowNewsAndInterests" -Value 0 -Type DWord -Force
            Get-AppxPackage -AllUsers "MicrosoftWindows.Client.WebExperience" -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
            Write-Host "  Widgets / News and Interests disabled and Web Experience pack removed." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "10") {
            Show-Title "FULL DEBLOAT PASS"
            Write-Host "  This removes Copilot, Cortana, Xbox/Gaming bloat, consumer bloat apps," -ForegroundColor Yellow
            Write-Host "  consumer Teams, disables Recall, suggested apps, and widgets in one pass." -ForegroundColor Yellow
            Write-Host "  Business-critical apps (Office, OneDrive, work Teams) are NOT touched." -ForegroundColor Cyan
            if ((Read-Host "  Type DEBLOAT to proceed") -eq "DEBLOAT") {
                $AllBloat = @(
                    "Microsoft.Windows.Ai.Copilot.Provider","*Copilot*","Microsoft.549981C3F5F10",
                    "Microsoft.XboxApp","Microsoft.XboxGamingOverlay","Microsoft.XboxGameOverlay",
                    "Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay","Microsoft.GamingApp","Microsoft.Xbox.TCUI",
                    "Microsoft.BingNews","Microsoft.BingWeather","Microsoft.BingSearch","Microsoft.MicrosoftSolitaireCollection",
                    "Microsoft.Microsoft3DViewer","Microsoft.MixedReality.Portal","Microsoft.People","Microsoft.PowerAutomateDesktop",
                    "Microsoft.Wallet","Microsoft.YourPhone","Microsoft.ZuneMusic","Microsoft.ZuneVideo","Microsoft.GetHelp",
                    "Microsoft.Getstarted","Microsoft.Messaging","Microsoft.MicrosoftOfficeHub","Microsoft.OneConnect",
                    "Microsoft.SkypeApp","Microsoft.WindowsFeedbackHub","Microsoft.WindowsMaps","Microsoft.WindowsSoundRecorder",
                    "Microsoft.Todos","Clipchamp.Clipchamp","MicrosoftCorporationII.MicrosoftFamily","MicrosoftTeams",
                    "MicrosoftWindows.Client.WebExperience"
                )
                foreach ($pkg in $AllBloat) {
                    Get-AppxPackage -AllUsers $pkg -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $pkg } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
                }
                if (-not (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced")) {
                    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Force | Out-Null
                }
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Value 0 -Type DWord -Force
                $CopilotPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
                if (-not (Test-Path $CopilotPol)) { New-Item -Path $CopilotPol -Force | Out-Null }
                Set-ItemProperty -Path $CopilotPol -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord -Force

                $CDM = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                if (-not (Test-Path $CDM)) { New-Item -Path $CDM -Force | Out-Null }
                foreach ($k in @("SubscribedContent-338388Enabled","SubscribedContent-338389Enabled","SubscribedContent-353698Enabled","SilentInstalledAppsEnabled","SystemPaneSuggestionsEnabled","PreInstalledAppsEnabled","OemPreInstalledAppsEnabled")) {
                    Set-ItemProperty -Path $CDM -Name $k -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
                }

                $DshPol = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
                if (-not (Test-Path $DshPol)) { New-Item -Path $DshPol -Force | Out-Null }
                Set-ItemProperty -Path $DshPol -Name "AllowNewsAndInterests" -Value 0 -Type DWord -Force

                Write-Host ""
                Write-Host "  FULL DEBLOAT PASS COMPLETE. Restart Explorer or sign out/in to refresh the Start Menu/taskbar." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "11") {
            Show-Title "Re-Install a Removed Built-In App"
            Write-Host "  Enter the Package Family Name root (e.g. Microsoft.BingWeather)." -ForegroundColor Cyan
            $Name = Read-Host "   Package Name"
            if ($Name) {
                try {
                    Get-AppxPackage -AllUsers $Name -ErrorAction SilentlyContinue | ForEach-Object {
                        Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"
                    }
                    Write-Host "  Re-registered any cached package data found for: $Name" -ForegroundColor Green
                    Write-Host "  If the package was fully removed (not just deregistered), reinstall it from the Microsoft Store instead." -ForegroundColor Cyan
                } catch {
                    Write-Host "  Could not re-register. The package may need to be reinstalled from the Microsoft Store." -ForegroundColor Yellow
                }
            }
            Wait-Key
        }
    }
}

# ================================================================
# 27. PROFILE & DATA MIGRATION TOOLKIT (LOCAL/ROAMING -> ENTRA) (L2-L3)
# ================================================================
function Menu-ProfileMigration {
    while ($true) {
        Show-Header
        Write-Host "  [ PROFILE & DATA MIGRATION TOOLKIT (LOCAL/ROAMING -> ENTRA) ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  List All Local User Profiles on this Machine"
        Write-Host "   2.  Identify Current Entra-Joined Profile Folder"
        Write-Host "   3.  Scan Source Profile Size (Desktop/Documents/Pictures/AppData)"
        Write-Host "   4.  Migrate Desktop, Documents, Pictures & Downloads -> Entra Profile"
        Write-Host "   5.  Migrate Roaming AppData (Signatures, Custom Dictionaries, Templates)"
        Write-Host "   6.  Migrate Outlook Signatures & AutoComplete Cache Specifically"
        Write-Host "   7.  Migrate Browser Bookmarks/Favorites (Edge & Chrome) -> New Profile"
        Write-Host "   8.  Migrate Mapped Drives & Printers List (Export for Re-Creation)"
        Write-Host "   9.  FULL PROFILE MIGRATION (Folders + Roaming + Outlook + Browser)"
        Write-Host "  10. Generate Migration Summary Report (Desktop)"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Local User Profiles"
            Get-CimInstance Win32_UserProfile | Where-Object { -not $_.Special } |
                Select-Object LocalPath, SID, LastUseTime, @{N="SizeGB";E={ if (Test-Path $_.LocalPath) { [math]::Round(((Get-ChildItem $_.LocalPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum/1GB),2) } else { 0 } }} |
                Format-Table -AutoSize
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Identifying Entra-Joined Profile"
            $JoinInfo = dsregcmd /status | Out-String
            if ($JoinInfo -match "AzureAdJoined\s*:\s*YES") {
                Write-Host "  [OK] This device is Entra (Azure AD) joined." -ForegroundColor Green
            } else {
                Write-Host "  [WARNING] This device does not report as Entra joined. Run dsregcmd /status for full detail." -ForegroundColor Yellow
            }
            Write-Host ""
            Write-Host "  Profile folders found under C:\Users :" -ForegroundColor Cyan
            Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue | Select-Object Name, LastWriteTime | Format-Table -AutoSize
            Write-Host "  Tip: Entra/AAD profiles are typically named like 'firstname.lastname_companyname.com' or just 'firstname.lastname'." -ForegroundColor Cyan
            Wait-Key
        }
        elseif ($c -eq "3") {
            $Source = Read-Host "   Source profile folder name (e.g. jsmith.OLDDOMAIN)"
            $SourcePath = "C:\Users\$Source"
            if (Test-Path $SourcePath) {
                Show-Title "Scanning Source Profile: $Source"
                $Folders = @("Desktop","Documents","Pictures","Downloads","Music","Videos","AppData\Roaming")
                foreach ($f in $Folders) {
                    $p = Join-Path $SourcePath $f
                    if (Test-Path $p) {
                        $size = (Get-ChildItem $p -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
                        $sizeGB = [math]::Round($size/1GB,2)
                        Write-Host ("  {0,-20} : {1} GB" -f $f, $sizeGB)
                    } else {
                        Write-Host ("  {0,-20} : Not found" -f $f) -ForegroundColor DarkGray
                    }
                }
            } else {
                Write-Host "  Profile path not found: $SourcePath" -ForegroundColor Red
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Migrate Personal Folders -> Entra Profile"
            Write-Host "  NOTE: This uses Robocopy to MIRROR-COPY user files. It does not move" -ForegroundColor Cyan
            Write-Host "  Windows account settings, app installs, or registry-bound preferences." -ForegroundColor Cyan
            Write-Host "  Always confirm the target user is signed out (or use an admin session) first." -ForegroundColor Yellow
            $Source = Read-Host "   Source profile folder name (old local/roaming profile)"
            $Dest   = Read-Host "   Destination profile folder name (new Entra profile)"
            $SourcePath = "C:\Users\$Source"
            $DestPath   = "C:\Users\$Dest"
            if (-not (Test-Path $SourcePath)) { Write-Host "  Source not found: $SourcePath" -ForegroundColor Red; Wait-Key; continue }
            if (-not (Test-Path $DestPath))   { Write-Host "  Destination not found: $DestPath" -ForegroundColor Red; Wait-Key; continue }
            if ((Read-Host "  Type YES to copy Desktop/Documents/Pictures/Downloads/Music/Videos") -eq "YES") {
                $Folders = @("Desktop","Documents","Pictures","Downloads","Music","Videos")
                foreach ($f in $Folders) {
                    $s = Join-Path $SourcePath $f
                    $d = Join-Path $DestPath $f
                    if (Test-Path $s) {
                        Write-Host "  Copying $f ..." -ForegroundColor Yellow
                        robocopy $s $d /E /COPY:DAT /R:1 /W:1 /XJ /NFL /NDL /NP | Out-Null
                        Write-Host "  Done: $f" -ForegroundColor Green
                    }
                }
                Write-Host "  Personal folder migration complete." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Migrate Roaming AppData"
            Write-Host "  Copies Office templates, custom dictionaries, signatures, and other" -ForegroundColor Cyan
            Write-Host "  Roaming AppData items. Skips large/risky folders (browser profiles," -ForegroundColor Cyan
            Write-Host "  credential stores) which are handled separately or intentionally excluded." -ForegroundColor Cyan
            $Source = Read-Host "   Source profile folder name"
            $Dest   = Read-Host "   Destination profile folder name"
            $SourcePath = "C:\Users\$Source\AppData\Roaming"
            $DestPath   = "C:\Users\$Dest\AppData\Roaming"
            if (-not (Test-Path $SourcePath)) { Write-Host "  Source Roaming path not found." -ForegroundColor Red; Wait-Key; continue }
            if ((Read-Host "  Type YES to migrate Roaming AppData subset") -eq "YES") {
                $SafeSubfolders = @(
                    "Microsoft\Signatures",
                    "Microsoft\Templates",
                    "Microsoft\Spelling",
                    "Microsoft\UProof",
                    "Microsoft\Office",
                    "Microsoft\Windows\Recent"
                )
                foreach ($sf in $SafeSubfolders) {
                    $s = Join-Path $SourcePath $sf
                    $d = Join-Path $DestPath $sf
                    if (Test-Path $s) {
                        Write-Host "  Copying Roaming\$sf ..." -ForegroundColor Yellow
                        robocopy $s $d /E /COPY:DAT /R:1 /W:1 /XJ /NFL /NDL /NP | Out-Null
                    }
                }
                Write-Host "  Roaming AppData subset migration complete." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Migrate Outlook Signatures & AutoComplete"
            $Source = Read-Host "   Source profile folder name"
            $Dest   = Read-Host "   Destination profile folder name"
            $SigSrc = "C:\Users\$Source\AppData\Roaming\Microsoft\Signatures"
            $SigDst = "C:\Users\$Dest\AppData\Roaming\Microsoft\Signatures"
            if (Test-Path $SigSrc) {
                robocopy $SigSrc $SigDst /E /COPY:DAT /R:1 /W:1 /NFL /NDL /NP | Out-Null
                Write-Host "  Outlook signatures migrated." -ForegroundColor Green
            } else {
                Write-Host "  No signatures folder found at source." -ForegroundColor Yellow
            }
            Write-Host ""
            Write-Host "  NOTE: Outlook AutoComplete (.NK2/stream) cache is tied to the mailbox" -ForegroundColor Cyan
            Write-Host "  profile (cloud cache in modern Outlook/Exchange Online) and generally" -ForegroundColor Cyan
            Write-Host "  rebuilds automatically once the new profile signs in to the mailbox." -ForegroundColor Cyan
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Migrate Browser Bookmarks/Favorites"
            $Source = Read-Host "   Source profile folder name"
            $Dest   = Read-Host "   Destination profile folder name"
            if ((Read-Host "  Type YES to copy Edge & Chrome bookmark files") -eq "YES") {
                $BrowserPaths = @(
                    @{Name="Edge";   Path="AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"},
                    @{Name="Chrome"; Path="AppData\Local\Google\Chrome\User Data\Default\Bookmarks"}
                )
                foreach ($b in $BrowserPaths) {
                    $s = Join-Path "C:\Users\$Source" $b.Path
                    $d = Join-Path "C:\Users\$Dest" $b.Path
                    if (Test-Path $s) {
                        $dDir = Split-Path $d -Parent
                        if (-not (Test-Path $dDir)) { New-Item -ItemType Directory -Path $dDir -Force | Out-Null }
                        Copy-Item $s $d -Force
                        Write-Host "  $($b.Name) bookmarks copied." -ForegroundColor Green
                    } else {
                        Write-Host "  $($b.Name) bookmarks not found at source (browser may not have run yet)." -ForegroundColor Yellow
                    }
                }
                Write-Host "  Recommend the user is signed into Edge/Chrome sync as the cleanest long-term option going forward." -ForegroundColor Cyan
            }
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Export Mapped Drives & Printers"
            $Out = "$env:USERPROFILE\Desktop\MigrationReport_DrivesPrinters_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
            "=== Mapped Network Drives ===" | Out-File $Out
            net use | Out-File $Out -Append
            "" | Out-File $Out -Append
            "=== Installed Printers ===" | Out-File $Out -Append
            Get-Printer | Select-Object Name, DriverName, PortName | Format-Table -AutoSize | Out-File $Out -Append
            Write-Host "  Exported to: $Out" -ForegroundColor Green
            Write-Host "  Use this list to manually re-map drives/printers under the new Entra profile," -ForegroundColor Cyan
            Write-Host "  or push them via Intune (mapped drives are not 'migrated' automatically, by design)." -ForegroundColor Cyan
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "FULL PROFILE MIGRATION"
            Write-Host "  This runs personal folder copy, Roaming AppData subset copy, Outlook" -ForegroundColor Yellow
            Write-Host "  signatures copy, and browser bookmarks copy in sequence." -ForegroundColor Yellow
            Write-Host "  This does NOT migrate: installed apps, Windows credentials/saved" -ForegroundColor Red
            Write-Host "  passwords, BitLocker keys, or full browser profiles (passwords/" -ForegroundColor Red
            Write-Host "  extensions/history) - those should sync via the user's Microsoft/Google" -ForegroundColor Red
            Write-Host "  account sign-in on first login to the new profile." -ForegroundColor Red
            $Source = Read-Host "   Source profile folder name"
            $Dest   = Read-Host "   Destination profile folder name"
            $SourcePath = "C:\Users\$Source"
            $DestPath   = "C:\Users\$Dest"
            if (-not (Test-Path $SourcePath)) { Write-Host "  Source not found: $SourcePath" -ForegroundColor Red; Wait-Key; continue }
            if (-not (Test-Path $DestPath))   { Write-Host "  Destination not found: $DestPath" -ForegroundColor Red; Wait-Key; continue }
            if ((Read-Host "  Type MIGRATE to proceed") -eq "MIGRATE") {
                Write-Host "  [1/4] Copying personal folders..." -ForegroundColor Yellow
                foreach ($f in @("Desktop","Documents","Pictures","Downloads","Music","Videos")) {
                    $s = Join-Path $SourcePath $f; $d = Join-Path $DestPath $f
                    if (Test-Path $s) { robocopy $s $d /E /COPY:DAT /R:1 /W:1 /XJ /NFL /NDL /NP | Out-Null }
                }
                Write-Host "  [2/4] Copying Roaming AppData subset..." -ForegroundColor Yellow
                foreach ($sf in @("Microsoft\Signatures","Microsoft\Templates","Microsoft\Spelling","Microsoft\UProof")) {
                    $s = Join-Path $SourcePath "AppData\Roaming\$sf"; $d = Join-Path $DestPath "AppData\Roaming\$sf"
                    if (Test-Path $s) { robocopy $s $d /E /COPY:DAT /R:1 /W:1 /XJ /NFL /NDL /NP | Out-Null }
                }
                Write-Host "  [3/4] Copying Outlook signatures..." -ForegroundColor Yellow
                $SigSrc = Join-Path $SourcePath "AppData\Roaming\Microsoft\Signatures"
                $SigDst = Join-Path $DestPath "AppData\Roaming\Microsoft\Signatures"
                if (Test-Path $SigSrc) { robocopy $SigSrc $SigDst /E /COPY:DAT /R:1 /W:1 /NFL /NDL /NP | Out-Null }
                Write-Host "  [4/4] Copying browser bookmarks..." -ForegroundColor Yellow
                foreach ($b in @("AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks","AppData\Local\Google\Chrome\User Data\Default\Bookmarks")) {
                    $s = Join-Path $SourcePath $b; $d = Join-Path $DestPath $b
                    if (Test-Path $s) {
                        $dDir = Split-Path $d -Parent
                        if (-not (Test-Path $dDir)) { New-Item -ItemType Directory -Path $dDir -Force | Out-Null }
                        Copy-Item $s $d -Force
                    }
                }
                Write-Host ""
                Write-Host "  FULL PROFILE MIGRATION COMPLETE." -ForegroundColor Green
                Write-Host "  Recommend verifying file counts/spot-checking before decommissioning the old profile." -ForegroundColor Cyan
            }
            Wait-Key
        }
        elseif ($c -eq "10") {
            Show-Title "Migration Summary Report"
            $Source = Read-Host "   Source profile folder name"
            $Dest   = Read-Host "   Destination profile folder name"
            $Out = "$env:USERPROFILE\Desktop\MigrationSummary_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
            "Migration Summary Report - Generated $(Get-Date)" | Out-File $Out
            "Source Profile      : C:\Users\$Source" | Out-File $Out -Append
            "Destination Profile : C:\Users\$Dest" | Out-File $Out -Append
            "" | Out-File $Out -Append
            foreach ($f in @("Desktop","Documents","Pictures","Downloads","Music","Videos")) {
                $s = "C:\Users\$Source\$f"
                $d = "C:\Users\$Dest\$f"
                $sCount = if (Test-Path $s) { (Get-ChildItem $s -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object).Count } else { "N/A" }
                $dCount = if (Test-Path $d) { (Get-ChildItem $d -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object).Count } else { "N/A" }
                "$f -> Source items: $sCount | Destination items: $dCount" | Out-File $Out -Append
            }
            Write-Host "  Report saved to: $Out" -ForegroundColor Green
            Start-Process $Out
            Wait-Key
        }
    }
}

# ================================================================
# 28. AUTOPILOT / PROVISIONING & IMAGING DIAGNOSTICS (L2-L3)
# ================================================================
function Menu-Provisioning {
    while ($true) {
        Show-Header
        Write-Host "  [ AUTOPILOT / PROVISIONING & IMAGING DIAGNOSTICS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Get Autopilot Hardware Hash (Export to CSV)"
        Write-Host "   2.  Check Autopilot Deployment Profile Status"
        Write-Host "   3.  View ESP (Enrollment Status Page) Tracking Status"
        Write-Host "   4.  Re-Run Autopilot/ESP Diagnostics Page"
        Write-Host "   5.  Reset Device for Re-Provisioning (Remove Provisioning Packages)"
        Write-Host "   6.  Check OOBE/Sysprep Generalization Readiness"
        Write-Host "   7.  View Provisioning Package (.ppkg) Application History"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Exporting Autopilot Hardware Hash"
            Write-Host "  Requires the 'Get-WindowsAutoPilotInfo' script (installs from PSGallery if missing)." -ForegroundColor Cyan
            if ((Read-Host "  Type YES to install/run and export hash to Desktop") -eq "YES") {
                try {
                    if (-not (Get-InstalledScript -Name Get-WindowsAutoPilotInfo -ErrorAction SilentlyContinue)) {
                        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
                        Install-Script -Name Get-WindowsAutoPilotInfo -Force -Scope CurrentUser
                    }
                    $Out = "$env:USERPROFILE\Desktop\AutopilotHWID.csv"
                    Get-WindowsAutoPilotInfo.ps1 -OutputFile $Out
                    Write-Host "  Hardware hash exported to: $Out" -ForegroundColor Green
                    Write-Host "  Upload this CSV to Intune > Devices > Enrollment > Windows Autopilot Devices." -ForegroundColor Cyan
                } catch {
                    Write-Host "  [ERROR] Could not install/run script: $($_.Exception.Message)" -ForegroundColor Red
                    Write-Host "  Manual fallback: Get-CimInstance -Namespace root/cimv2/mdm/dmmap -ClassName MDM_DevDetail_Ext01" -ForegroundColor Cyan
                }
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Autopilot Deployment Profile Status"
            $Reg = "HKLM:\SOFTWARE\Microsoft\Provisioning\Diagnostics\AutoPilot"
            if (Test-Path $Reg) {
                Get-ItemProperty $Reg | Format-List
            } else {
                Write-Host "  No Autopilot diagnostic registry data found on this device." -ForegroundColor Yellow
            }
            dsregcmd /status | Select-String "AzureAdJoined|DomainJoined|EnterpriseJoined|TenantName"
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "ESP Tracking Status"
            $EspReg = "HKLM:\SOFTWARE\Microsoft\Enrollments\*\FirstSync"
            $Found = Get-Item $EspReg -ErrorAction SilentlyContinue
            if ($Found) {
                $Found | Get-ItemProperty | Format-List
            } else {
                Write-Host "  No active ESP first-sync tracking keys found (device may already be past ESP)." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Launching Autopilot Diagnostics Page"
            Start-Process "ms-cxh:autopilotdiagnostics"
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Remove Provisioning Packages"
            Get-ProvisioningPackage -AllInstalledPackages | Format-Table PackageName, PackageId -AutoSize
            $Pkg = Read-Host "   PackageId to remove (blank to cancel)"
            if ($Pkg) {
                Remove-ProvisioningPackage -PackageId $Pkg
                Write-Host "  Provisioning package removed." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "OOBE / Sysprep Generalization Readiness"
            $SetupState = Get-ItemProperty "HKLM:\SYSTEM\Setup" -Name "OOBEInProgress" -ErrorAction SilentlyContinue
            Write-Host "  OOBEInProgress flag : $($SetupState.OOBEInProgress)"
            $PantherLogs = "$env:SystemRoot\System32\Sysprep\Panther\setupact.log"
            if (Test-Path $PantherLogs) {
                Write-Host "  Last 10 lines of Sysprep setupact.log:" -ForegroundColor Cyan
                Get-Content $PantherLogs -Tail 10
            } else {
                Write-Host "  No Sysprep Panther log found (machine likely never sysprepped, or log purged)." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Provisioning Package Application History"
            Get-ProvisioningPackage -AllInstalledPackages | Format-List PackageName, PackageId, Version
            Wait-Key
        }
    }
}

# ================================================================
# 29. OFFICE ACTIVATION & LICENSING TOOLS (L1-L3)
# ================================================================
function Menu-OfficeActivation {
    while ($true) {
        Show-Header
        Write-Host "  [ OFFICE ACTIVATION & LICENSING TOOLS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Check Office Activation Status (ospp.vbs /dstatus)"
        Write-Host "   2.  Activate Office Online (ospp.vbs /act)"
        Write-Host "   3.  Remove a Product Key from Office Licensing"
        Write-Host "   4.  Convert Office Subscription <-> Volume License Channel Info"
        Write-Host "   5.  Clear Office License Cache (Force Re-Check)"
        Write-Host "   6.  Open Microsoft 365 Admin Portal (My Account)"
        ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Office Activation Status"
            $OsppPaths = @(
                "$env:ProgramFiles\Microsoft Office\Office16\ospp.vbs",
                "${env:ProgramFiles(x86)}\Microsoft Office\Office16\ospp.vbs"
            )
            $Ospp = $OsppPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
            if ($Ospp) {
                cscript "$Ospp" /dstatus
            } else {
                Write-Host "  ospp.vbs not found. Office may not be installed, or uses a different version path." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Activate Office Online"
            $OsppPaths = @(
                "$env:ProgramFiles\Microsoft Office\Office16\ospp.vbs",
                "${env:ProgramFiles(x86)}\Microsoft Office\Office16\ospp.vbs"
            )
            $Ospp = $OsppPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
            if ($Ospp) {
                cscript "$Ospp" /act
            } else {
                Write-Host "  ospp.vbs not found." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Remove Product Key"
            $OsppPaths = @(
                "$env:ProgramFiles\Microsoft Office\Office16\ospp.vbs",
                "${env:ProgramFiles(x86)}\Microsoft Office\Office16\ospp.vbs"
            )
            $Ospp = $OsppPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
            if ($Ospp) {
                cscript "$Ospp" /dstatus
                $LastFive = Read-Host "   Last 5 characters of the Product Key to remove"
                if ($LastFive) { cscript "$Ospp" /unpkey:$LastFive }
            } else {
                Write-Host "  ospp.vbs not found." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Office Channel & Subscription Info"
            $C2R = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -ErrorAction SilentlyContinue
            if ($C2R) {
                Write-Host "  CDNBaseUrl       : $($C2R.CDNBaseUrl)"
                Write-Host "  UpdateChannel    : $($C2R.UpdateChannel)"
                Write-Host "  ProductReleaseIds: $($C2R.ProductReleaseIds)"
                Write-Host "  ClientCulture    : $($C2R.ClientCulture)"
            } else {
                Write-Host "  No Click-to-Run config found (legacy MSI build, or Office not installed)." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Clearing Office License Cache"
            if ((Read-Host "  Type YES to clear license token cache") -eq "YES") {
                Remove-Item "HKCU:\Software\Microsoft\Office\16.0\Common\Licensing" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item "$env:LOCALAPPDATA\Microsoft\Office\Licensing" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "  License cache cleared. Re-open an Office app and sign in to re-check entitlement." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "6") { Start-Process "https://portal.office.com/account/"; Wait-Key }
    }
}

# ================================================================
# 30. BROWSER REPAIR & HYGIENE TOOLKIT (L1-L2)
# ================================================================
function Menu-Browser {
    while ($true) {
        Show-Header
        Write-Host "  [ BROWSER REPAIR & HYGIENE TOOLKIT ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Clear Edge Cache & Cookies (Keep Passwords/Bookmarks)"
        Write-Host "   2.  Clear Chrome Cache & Cookies (Keep Passwords/Bookmarks)"
        Write-Host "   3.  Reset Edge to Default Settings (Profile-Safe)"
        Write-Host "   4.  List Installed Browser Extensions (Edge & Chrome)"
        Write-Host "   5.  Audit Browser Policies (Managed by Org / GPO / Intune)"
        Write-Host "   6.  Check & Clear Proxy / PAC Script Configuration"
        Write-Host "   7.  Detect Hijacked Homepage / Search Engine Settings"
        Write-Host "   8.  Kill All Stuck Browser Processes (Edge/Chrome/Firefox)"
        Write-Host "   9.  Reset Hosts File to Default (Malware Hijack Recovery)"
        Write-Host "  10. Re-Register Default Browser/Protocol Handlers"
        Write-Host "  11. Export Browser Version & Update Channel Info"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Clear Edge Cache & Cookies"
            if ((Read-Host "  Type YES to clear Edge cache/cookies (passwords/bookmarks kept)") -eq "YES") {
                Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue
                $EdgePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default"
                foreach ($f in @("Cache","Code Cache","GPUCache","Cookies","Cookies-journal","Service Worker")) {
                    Remove-Item -Path (Join-Path $EdgePath $f) -Recurse -Force -ErrorAction SilentlyContinue
                }
                Write-AuditLog -Action "Browser-ClearCache" -Detail "Edge cache/cookies cleared for $env:USERNAME"
                Write-Host "  Edge cache and cookies cleared. Bookmarks and saved passwords were not touched." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Clear Chrome Cache & Cookies"
            if ((Read-Host "  Type YES to clear Chrome cache/cookies (passwords/bookmarks kept)") -eq "YES") {
                Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
                $ChromePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
                foreach ($f in @("Cache","Code Cache","GPUCache","Cookies","Cookies-journal","Service Worker")) {
                    Remove-Item -Path (Join-Path $ChromePath $f) -Recurse -Force -ErrorAction SilentlyContinue
                }
                Write-AuditLog -Action "Browser-ClearCache" -Detail "Chrome cache/cookies cleared for $env:USERNAME"
                Write-Host "  Chrome cache and cookies cleared. Bookmarks and saved passwords were not touched." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Reset Edge to Default Settings"
            Write-Host "  This resets Edge's Preferences (startup page, search engine, new tab)" -ForegroundColor Cyan
            Write-Host "  but keeps the user's signed-in profile, passwords and bookmarks intact." -ForegroundColor Cyan
            if ((Read-Host "  Type YES to reset Edge settings") -eq "YES") {
                Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue
                $PrefFile = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Preferences"
                if (Test-Path $PrefFile) {
                    Copy-Item $PrefFile "$PrefFile.bak_$(Get-Date -Format 'yyyyMMddHHmmss')" -Force
                    Write-Host "  Backed up existing Preferences file." -ForegroundColor Yellow
                }
                Start-Process "msedge.exe" -ArgumentList "edge://settings/reset" 
                Write-Host "  Opened Edge's native reset page. Click 'Restore settings to their default values' there." -ForegroundColor Green
                Write-AuditLog -Action "Browser-ResetEdge" -Detail "Edge settings reset initiated for $env:USERNAME"
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Installed Browser Extensions"
            Write-Host "  -- Edge Extensions --" -ForegroundColor Cyan
            $EdgeExt = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Extensions"
            if (Test-Path $EdgeExt) {
                Get-ChildItem $EdgeExt -Directory | ForEach-Object {
                    $manifestDir = Get-ChildItem $_.FullName -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
                    if ($manifestDir) {
                        $manifest = Join-Path $manifestDir.FullName "manifest.json"
                        if (Test-Path $manifest) {
                            $json = Get-Content $manifest -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
                            if ($json) { Write-Host "  - $($json.name) ($($json.version))" }
                        }
                    }
                }
            } else { Write-Host "  No Edge extensions folder found." -ForegroundColor Yellow }
            Write-Host ""
            Write-Host "  -- Chrome Extensions --" -ForegroundColor Cyan
            $ChromeExt = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions"
            if (Test-Path $ChromeExt) {
                Get-ChildItem $ChromeExt -Directory | ForEach-Object {
                    $manifestDir = Get-ChildItem $_.FullName -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
                    if ($manifestDir) {
                        $manifest = Join-Path $manifestDir.FullName "manifest.json"
                        if (Test-Path $manifest) {
                            $json = Get-Content $manifest -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
                            if ($json) { Write-Host "  - $($json.name) ($($json.version))" }
                        }
                    }
                }
            } else { Write-Host "  No Chrome extensions folder found." -ForegroundColor Yellow }
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Browser Policies (Managed by Org)"
            Write-Host "  -- Edge Policies (HKLM) --" -ForegroundColor Cyan
            $EdgePol = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
            if (Test-Path $EdgePol) { Get-ItemProperty $EdgePol | Format-List } else { Write-Host "  No Edge GPO/Intune policies applied." -ForegroundColor Yellow }
            Write-Host ""
            Write-Host "  -- Chrome Policies (HKLM) --" -ForegroundColor Cyan
            $ChromePol = "HKLM:\SOFTWARE\Policies\Google\Chrome"
            if (Test-Path $ChromePol) { Get-ItemProperty $ChromePol | Format-List } else { Write-Host "  No Chrome GPO policies applied." -ForegroundColor Yellow }
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Proxy / PAC Script Configuration"
            $InetSettings = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
            Get-ItemProperty $InetSettings | Select-Object ProxyEnable, ProxyServer, AutoConfigURL | Format-List
            if ((Read-Host "  Type YES to clear proxy/PAC configuration") -eq "YES") {
                Set-ItemProperty -Path $InetSettings -Name ProxyEnable -Value 0 -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path $InetSettings -Name ProxyServer -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path $InetSettings -Name AutoConfigURL -ErrorAction SilentlyContinue
                netsh winhttp reset proxy
                Write-AuditLog -Action "Browser-ClearProxy" -Detail "Proxy/PAC settings cleared for $env:USERNAME"
                Write-Host "  Proxy and PAC script configuration cleared." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Detecting Hijacked Homepage / Search Settings"
            $Found = $false
            $EdgePrefs = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Preferences"
            if (Test-Path $EdgePrefs) {
                $json = Get-Content $EdgePrefs -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue
                if ($json.homepage) { Write-Host "  Edge Homepage   : $($json.homepage)" -ForegroundColor Cyan; $Found = $true }
                if ($json.session.startup_urls) { Write-Host "  Edge Startup URLs: $($json.session.startup_urls -join ', ')" -ForegroundColor Cyan; $Found = $true }
            }
            $SuspiciousRun = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue
            if ($SuspiciousRun) {
                $SuspiciousRun.PSObject.Properties | Where-Object { $_.Value -match "\.exe.*http|chrome\.exe.*--|msedge\.exe.*--" } | ForEach-Object {
                    Write-Host "  [SUSPICIOUS] Run key '$($_.Name)' launches browser with arguments: $($_.Value)" -ForegroundColor Red
                    $Found = $true
                }
            }
            if (-not $Found) { Write-Host "  No obvious homepage/search hijack indicators found." -ForegroundColor Green }
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Killing Stuck Browser Processes"
            foreach ($p in @("msedge","msedgewebview2","chrome","firefox")) {
                Get-Process -Name $p -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
            }
            Write-Host "  All known browser processes terminated." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Reset Hosts File to Default"
            if ((Read-Host "  Type YES to reset hosts file to clean default") -eq "YES") {
                $HostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
                Copy-Item $HostsPath "$HostsPath.bak_$(Get-Date -Format 'yyyyMMddHHmmss')" -Force -ErrorAction SilentlyContinue
                "# Copyright (c) 1993-2099 Microsoft Corp.`r`n#`r`n# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.`r`n#`r`n127.0.0.1       localhost`r`n::1             localhost" | Set-Content $HostsPath -Force
                ipconfig /flushdns
                Write-AuditLog -Action "Browser-ResetHosts" -Detail "Hosts file reset to default on $env:COMPUTERNAME"
                Write-Host "  Hosts file reset to clean default. Previous version backed up alongside it." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "10") {
            Show-Title "Re-Registering Default Browser/Protocol Handlers"
            Start-Process "ms-settings:defaultapps"
            Write-Host "  Opened Default Apps settings. Re-select the desired browser for HTTP/HTTPS/.html." -ForegroundColor Cyan
            Wait-Key
        }
        elseif ($c -eq "11") {
            Show-Title "Browser Version & Update Channel Info"
            $EdgeVer = (Get-Item "$env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe" -ErrorAction SilentlyContinue).VersionInfo.ProductVersion
            if (-not $EdgeVer) { $EdgeVer = (Get-Item "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe" -ErrorAction SilentlyContinue).VersionInfo.ProductVersion }
            $ChromeVer = (Get-Item "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" -ErrorAction SilentlyContinue).VersionInfo.ProductVersion
            if (-not $ChromeVer) { $ChromeVer = (Get-Item "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe" -ErrorAction SilentlyContinue).VersionInfo.ProductVersion }
            Write-Host "  Edge Version   : $(if ($EdgeVer) {$EdgeVer} else {'Not installed/found'})"
            Write-Host "  Chrome Version : $(if ($ChromeVer) {$ChromeVer} else {'Not installed/found'})"
            Wait-Key
        }
    }
}

# ================================================================
# 31. BACKUP, SHADOW COPY & SYSTEM RESTORE MANAGER (L1-L2)
# ================================================================
function Menu-BackupRestore {
    while ($true) {
        Show-Header
        Write-Host "  [ BACKUP, SHADOW COPY & SYSTEM RESTORE MANAGER ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  List Available System Restore Points"
        Write-Host "   2.  Create a New System Restore Point"
        Write-Host "   3.  Restore System to a Selected Restore Point"
        Write-Host "   4.  Enable System Protection on a Drive"
        Write-Host "   5.  List Volume Shadow Copies (VSS)"
        Write-Host "   6.  Create a Manual Shadow Copy of a Drive"
        Write-Host "   7.  Check File History Status"
        Write-Host "   8.  Check Windows Backup (Legacy) Status"
        Write-Host "   9.  Export Key User Settings Snapshot (Pre-Wipe Safety Net)"
        Write-Host "  10. Check BitLocker Recovery Key Escrow Status (Entra/AD)"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Available System Restore Points"
            Get-ComputerRestorePoint | Format-Table SequenceNumber, Description, RestorePointType, CreationTime -AutoSize
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Create a New System Restore Point"
            $Desc = Read-Host "   Description for this restore point"
            if (-not $Desc) { $Desc = "Manual Checkpoint - $(Get-Date -Format 'yyyy-MM-dd HH:mm')" }
            Checkpoint-Computer -Description $Desc -RestorePointType "MODIFY_SETTINGS"
            Write-AuditLog -Action "RestorePoint-Create" -Detail $Desc
            Write-Host "  Restore point created: $Desc" -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Restore to a Selected Restore Point"
            Get-ComputerRestorePoint | Format-Table SequenceNumber, Description, CreationTime -AutoSize
            $Seq = Read-Host "   Enter SequenceNumber to restore to (blank to cancel)"
            if ($Seq) {
                Write-Host "  [WARNING] This will restart the computer and roll back system state." -ForegroundColor Red
                if ((Read-Host "  Type YES to confirm restore") -eq "YES") {
                    Write-AuditLog -Action "RestorePoint-Restore" -Detail "SequenceNumber $Seq"
                    Restore-Computer -RestorePoint $Seq -Confirm:$false
                }
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            $d = Read-Host "   Drive letter to enable System Protection on (e.g. C)"
            Enable-ComputerRestore -Drive "${d}:\"
            Write-Host "  System Protection enabled on ${d}:\" -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Volume Shadow Copies (VSS)"
            vssadmin list shadows
            Wait-Key
        }
        elseif ($c -eq "6") {
            $d = Read-Host "   Drive letter to snapshot (e.g. C)"
            Show-Title "Creating Manual Shadow Copy of ${d}:"
            $wmi = Get-WmiObject -List Win32_ShadowCopy
            $result = $wmi.Create("${d}:\", "ClientAccessible")
            if ($result.ReturnValue -eq 0) {
                Write-AuditLog -Action "ShadowCopy-Create" -Detail "Drive ${d}:"
                Write-Host "  Shadow copy created successfully." -ForegroundColor Green
            } else {
                Write-Host "  Shadow copy creation failed (ReturnValue: $($result.ReturnValue))." -ForegroundColor Red
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "File History Status"
            $fhStatus = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\FileHistory" -ErrorAction SilentlyContinue
            if ($fhStatus) { $fhStatus | Format-List } else { Write-Host "  File History does not appear to be configured for this user." -ForegroundColor Yellow }
            Start-Process "control.exe" -ArgumentList "/name Microsoft.FileHistory"
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Windows Backup (Legacy) Status"
            $sdrsvc = Get-Service -Name "SDRSVC" -ErrorAction SilentlyContinue
            if ($sdrsvc) { Write-Host "  Windows Backup service (SDRSVC) status: $($sdrsvc.Status)" } else { Write-Host "  SDRSVC service not found on this build." -ForegroundColor Yellow }
            wbadmin get versions 2>&1
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Export Key User Settings Snapshot"
            Write-Host "  Captures a lightweight text snapshot of key settings before a profile" -ForegroundColor Cyan
            Write-Host "  wipe or rebuild - mapped drives, printers, installed apps, Wi-Fi profiles." -ForegroundColor Cyan
            $Out = "$env:USERPROFILE\Desktop\PreWipeSnapshot_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
            "Pre-Wipe Settings Snapshot - $(Get-Date)" | Out-File $Out
            "`n=== Mapped Drives ===" | Out-File $Out -Append
            net use | Out-File $Out -Append
            "`n=== Installed Printers ===" | Out-File $Out -Append
            Get-Printer | Select-Object Name, DriverName, PortName | Format-Table -AutoSize | Out-File $Out -Append
            "`n=== Wi-Fi Profiles ===" | Out-File $Out -Append
            netsh wlan show profiles | Out-File $Out -Append
            "`n=== Installed Programs ===" | Out-File $Out -Append
            Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
                Where-Object { $_.DisplayName } | Select-Object DisplayName, DisplayVersion | Format-Table -AutoSize | Out-File $Out -Append
            Write-AuditLog -Action "Snapshot-PreWipe" -Detail "Saved to $Out"
            Write-Host "  Snapshot saved to: $Out" -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "10") {
            Show-Title "BitLocker Recovery Key Escrow Status"
            $Vols = Get-BitLockerVolume -ErrorAction SilentlyContinue
            if ($Vols) {
                foreach ($v in $Vols) {
                    $hasRecoveryProtector = $v.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }
                    if ($hasRecoveryProtector) { Write-Host "  $($v.MountPoint) : Recovery password protector present locally." -ForegroundColor Green }
                    else { Write-Host "  $($v.MountPoint) : No local recovery password protector found." -ForegroundColor Yellow }
                }
            } else { Write-Host "  No BitLocker volumes detected." -ForegroundColor Yellow }
            Write-Host ""
            Write-Host "  To confirm cloud escrow, check Entra ID > Devices > BitLocker keys" -ForegroundColor Cyan
            Write-Host "  or on-prem AD Computer object properties > BitLocker Recovery tab." -ForegroundColor Cyan
            Wait-Key
        }
    }
}

# ================================================================
# 32. DEEP HARDWARE DIAGNOSTICS (L1-L3)
# ================================================================
function Menu-HardwareDeep {
    while ($true) {
        Show-Header
        Write-Host "  [ DEEP HARDWARE DIAGNOSTICS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Parse Battery Report (Design vs Full Charge Capacity)"
        Write-Host "   2.  RAM Slot / Channel Configuration"
        Write-Host "   3.  Storage Drive Type Detection (SSD/HDD/NVMe) & TRIM Status"
        Write-Host "   4.  Audio Device Quick Test"
        Write-Host "   5.  Webcam / Microphone Device Inventory"
        Write-Host "   6.  CPU Thermal & Throttle Snapshot"
        Write-Host "   7.  Monitor / Display Inventory & Resolution Report"
        Write-Host "   8.  USB Device Tree & Power Inventory"
        Write-Host "   9.  Full Hardware Health Export (CSV to Desktop)"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Battery Health Report"
            $Out = "$env:TEMP\BatteryReport_$(Get-Date -Format 'yyyyMMddHHmmss').xml"
            powercfg /batteryreport /output $Out /xml 2>&1 | Out-Null
            if (Test-Path $Out) {
                try {
                    [xml]$xml = Get-Content $Out
                    $design = $xml.BatteryReport.Design.DesignCapacity
                    $full   = $xml.BatteryReport.Design.FullChargeCapacity
                    if ($design -and $full) {
                        $health = [math]::Round(([double]$full / [double]$design) * 100, 1)
                        Write-Host "  Design Capacity     : $design mWh"
                        Write-Host "  Full Charge Capacity: $full mWh"
                        Write-Host "  Battery Health      : $health%" -ForegroundColor $(if ($health -lt 70) {"Red"} elseif ($health -lt 85) {"Yellow"} else {"Green"})
                    } else {
                        Write-Host "  Could not parse capacity values from report (no battery, or desktop PC)." -ForegroundColor Yellow
                    }
                } catch {
                    Write-Host "  Could not parse XML battery report on this build. Generating HTML version instead..." -ForegroundColor Yellow
                    $OutHtml = "$env:USERPROFILE\Desktop\BatteryReport.html"
                    powercfg /batteryreport /output $OutHtml 2>&1 | Out-Null
                    Start-Process $OutHtml
                }
            } else {
                Write-Host "  No battery detected, or report generation failed (likely a desktop PC)." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "RAM Slot / Channel Configuration"
            Get-CimInstance Win32_PhysicalMemory | Select-Object BankLabel, DeviceLocator, Capacity, Speed, Manufacturer, PartNumber |
                Format-Table -AutoSize
            $TotalSlots = (Get-CimInstance Win32_PhysicalMemoryArray).MemoryDevices
            $UsedSlots  = (Get-CimInstance Win32_PhysicalMemory).Count
            Write-Host "  Populated Slots: $UsedSlots of $TotalSlots total slots." -ForegroundColor Cyan
            if ($UsedSlots -eq 1 -and $TotalSlots -gt 1) { Write-Host "  [NOTE] Single stick installed - running in single-channel mode. Adding a matched stick would enable dual-channel." -ForegroundColor Yellow }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Storage Drive Type Detection"
            Get-PhysicalDisk | Select-Object FriendlyName, MediaType, BusType, HealthStatus, @{N="SizeGB";E={[math]::Round($_.Size/1GB,1)}} | Format-Table -AutoSize
            Write-Host ""
            Write-Host "  TRIM Status:" -ForegroundColor Cyan
            $trim = fsutil behavior query DisableDeleteNotify
            Write-Host "  $trim"
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Audio Device Quick Test"
            Get-CimInstance Win32_SoundDevice | Select-Object Name, Status, Manufacturer | Format-Table -AutoSize
            Write-Host "  Playing test tone..." -ForegroundColor Yellow
            [console]::beep(800,400)
            Start-Process "ms-settings:sound"
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Webcam / Microphone Inventory"
            Write-Host "  -- Cameras / Imaging Devices --" -ForegroundColor Cyan
            Get-PnpDevice -Class "Camera","Image" -ErrorAction SilentlyContinue | Select-Object FriendlyName, Status | Format-Table -AutoSize
            Write-Host "  -- Audio Capture Devices --" -ForegroundColor Cyan
            Get-CimInstance Win32_SoundDevice | Select-Object Name, Status | Format-Table -AutoSize
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "CPU Thermal & Throttle Snapshot"
            $cpu = Get-CimInstance Win32_Processor
            Write-Host "  CPU              : $($cpu.Name)"
            Write-Host "  Current Clock    : $($cpu.CurrentClockSpeed) MHz"
            Write-Host "  Max Clock        : $($cpu.MaxClockSpeed) MHz"
            Write-Host "  Load Percentage  : $($cpu.LoadPercentage)%"
            $temp = Get-CimInstance MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" -ErrorAction SilentlyContinue
            if ($temp) {
                foreach ($t in $temp) {
                    $celsius = [math]::Round(($t.CurrentTemperature / 10) - 273.15, 1)
                    Write-Host "  Thermal Zone     : $celsius C"
                }
            } else { Write-Host "  Thermal zone data unavailable via WMI on this hardware/driver combination." -ForegroundColor Yellow }
            if ($cpu.CurrentClockSpeed -lt ($cpu.MaxClockSpeed * 0.6)) {
                Write-Host "  [NOTE] Current clock is well below max - possible throttle (thermal, power plan, or battery saver)." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Monitor / Display Inventory"
            Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorID -ErrorAction SilentlyContinue | ForEach-Object {
                $name = ($_.UserFriendlyName -ne 0 | ForEach-Object { [char]$_ }) -join ""
                if ($name) { Write-Host "  Monitor: $name" }
            }
            Get-CimInstance Win32_VideoController | Select-Object Name, CurrentHorizontalResolution, CurrentVerticalResolution, CurrentRefreshRate | Format-Table -AutoSize
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "USB Device Tree & Power Inventory"
            Get-PnpDevice -Class "USB" | Select-Object FriendlyName, Status, InstanceId | Format-Table -AutoSize
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Full Hardware Health Export"
            $Out = "$env:USERPROFILE\Desktop\HardwareHealth_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
            $Report = [PSCustomObject]@{
                Computer       = $env:COMPUTERNAME
                CPU            = (Get-CimInstance Win32_Processor).Name
                RAM_GB         = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,1)
                Disks          = (Get-PhysicalDisk | ForEach-Object { "$($_.FriendlyName) [$($_.MediaType)] $($_.HealthStatus)" }) -join " | "
                BIOSSerial     = (Get-CimInstance Win32_BIOS).SerialNumber
                BIOSVersion    = (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion
                GeneratedOn    = (Get-Date)
            }
            $Report | Export-Csv $Out -NoTypeInformation
            Write-Host "  Hardware health export saved to: $Out" -ForegroundColor Green
            Wait-Key
        }
    }
}

# ================================================================
# 33. PRINTING & PRINT SERVER TOOLKIT (L1-L2)
# ================================================================
function Menu-Printing {
    while ($true) {
        Show-Header
        Write-Host "  [ PRINTING & PRINT SERVER TOOLKIT ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  List All Installed Printers"
        Write-Host "   2.  Set Default Printer"
        Write-Host "   3.  Add a Network/TCP-IP Printer"
        Write-Host "   4.  Add a Shared Printer by UNC Path"
        Write-Host "   5.  Remove a Printer"
        Write-Host "   6.  Clear Print Queue for a Specific Printer"
        Write-Host "   7.  Restart Print Spooler Service"
        Write-Host "   8.  Deep Spooler Reset (Stop + Purge ALL Queues + Start)"
        Write-Host "   9.  List & Remove Installed Printer Drivers"
        Write-Host "  10. Test Print a Page to a Selected Printer"
        Write-Host "  11. Check Printer Port / IP Connectivity"
        Write-Host "  12. Export Printer Configuration Report"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Installed Printers"
            Get-Printer | Select-Object Name, DriverName, PortName, Shared, PrinterStatus | Format-Table -AutoSize
            Wait-Key
        }
        elseif ($c -eq "2") {
            Get-Printer | Format-Table Name -AutoSize
            $p = Read-Host "   Exact printer name to set as default"
            if ($p) {
                (New-Object -ComObject WScript.Network).SetDefaultPrinter($p)
                Write-Host "  Default printer set to: $p" -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Add a Network/TCP-IP Printer"
            $ip = Read-Host "   Printer IP Address"
            $name = Read-Host "   Friendly name for this printer port"
            $driver = Read-Host "   Driver name (must already be installed, e.g. 'HP Universal Printing PCL 6')"
            try {
                Add-PrinterPort -Name $name -PrinterHostAddress $ip
                Add-Printer -Name $name -DriverName $driver -PortName $name
                Write-AuditLog -Action "Printer-AddNetwork" -Detail "$name @ $ip"
                Write-Host "  Printer added: $name ($ip) using driver '$driver'." -ForegroundColor Green
            } catch {
                Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
                Write-Host "  Tip: confirm the driver is already installed (Print Management > Drivers) before adding the printer." -ForegroundColor Cyan
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Add a Shared Printer by UNC Path"
            $unc = Read-Host "   UNC Path (e.g. \\PRINTSERVER\HR-Printer)"
            try {
                Add-Printer -ConnectionName $unc
                Write-AuditLog -Action "Printer-AddShared" -Detail $unc
                Write-Host "  Shared printer connected: $unc" -ForegroundColor Green
            } catch {
                Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
            }
            Wait-Key
        }
        elseif ($c -eq "5") {
            Get-Printer | Format-Table Name -AutoSize
            $p = Read-Host "   Exact printer name to remove"
            if ($p) {
                Remove-Printer -Name $p
                Write-AuditLog -Action "Printer-Remove" -Detail $p
                Write-Host "  Printer removed: $p" -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "6") {
            Get-Printer | Format-Table Name -AutoSize
            $p = Read-Host "   Exact printer name to clear queue for"
            if ($p) {
                Get-PrintJob -PrinterName $p -ErrorAction SilentlyContinue | Remove-PrintJob -ErrorAction SilentlyContinue
                Write-Host "  Print queue cleared for: $p" -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Restart Print Spooler"
            Restart-Service -Name Spooler -Force
            Write-Host "  Print Spooler service restarted." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Deep Spooler Reset"
            if ((Read-Host "  Type YES to stop spooler, purge ALL queues, and restart") -eq "YES") {
                Stop-Service -Name Spooler -Force
                Get-ChildItem "$env:SystemRoot\System32\spool\PRINTERS\*" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
                Start-Service -Name Spooler
                Write-AuditLog -Action "Printer-DeepSpoolerReset" -Detail "All queues purged on $env:COMPUTERNAME"
                Write-Host "  Deep spooler reset complete. All pending jobs across all printers were purged." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Installed Printer Drivers"
            Get-PrinterDriver | Format-Table Name, Manufacturer, DriverVersion, PrinterEnvironment -AutoSize
            $d = Read-Host "   Driver name to remove (blank to skip)"
            if ($d) {
                try {
                    Remove-PrinterDriver -Name $d
                    Write-Host "  Driver removed: $d" -ForegroundColor Green
                } catch {
                    Write-Host "  [ERROR] $($_.Exception.Message) (driver may still be in use by an installed printer)" -ForegroundColor Red
                }
            }
            Wait-Key
        }
        elseif ($c -eq "10") {
            Get-Printer | Format-Table Name -AutoSize
            $p = Read-Host "   Exact printer name to send test page to"
            if ($p) {
                try {
                    Get-WmiObject -Class Win32_Printer -Filter "Name='$p'" | ForEach-Object { $_.PrintTestPage() } | Out-Null
                    Write-Host "  Test page sent to: $p" -ForegroundColor Green
                } catch {
                    Write-Host "  [ERROR] Could not send test page: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            Wait-Key
        }
        elseif ($c -eq "11") {
            $ip = Read-Host "   Printer IP Address to test"
            Show-Title "Testing Connectivity to $ip"
            if (Test-Connection $ip -Count 3 -Quiet) {
                Write-Host "  [PASS] Printer responds to ping at $ip" -ForegroundColor Green
            } else {
                Write-Host "  [FAIL] No ping response from $ip (check cabling, power, or ICMP being blocked)." -ForegroundColor Red
            }
            Write-Host "  Checking common printing ports (9100, 515, 631)..." -ForegroundColor Cyan
            foreach ($port in @(9100,515,631)) {
                $test = Test-NetConnection -ComputerName $ip -Port $port -WarningAction SilentlyContinue
                $status = if ($test.TcpTestSucceeded) { "OPEN" } else { "CLOSED/FILTERED" }
                $color = if ($test.TcpTestSucceeded) { "Green" } else { "Yellow" }
                Write-Host "  Port $port : $status" -ForegroundColor $color
            }
            Wait-Key
        }
        elseif ($c -eq "12") {
            Show-Title "Printer Configuration Report"
            $Out = "$env:USERPROFILE\Desktop\PrinterReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
            Get-Printer | Select-Object Name, DriverName, PortName, Shared, Published, PrinterStatus | Export-Csv $Out -NoTypeInformation
            Write-Host "  Printer report exported to: $Out" -ForegroundColor Green
            Wait-Key
        }
    }
}

# ================================================================
# 34. OUTLOOK / EXCHANGE ADVANCED DIAGNOSTICS (L2-L3)
# ================================================================
function Menu-OutlookAdvanced {
    while ($true) {
        Show-Header
        Write-Host "  [ OUTLOOK / EXCHANGE ADVANCED DIAGNOSTICS ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Test Autodiscover Resolution for a Domain"
        Write-Host "   2.  Check Outlook Connection Status (via Registry/Profile)"
        Write-Host "   3.  Locate & Report OST File Size/Health"
        Write-Host "   4.  Force OST Rebuild (Rename to Trigger Re-Cache)"
        Write-Host "   5.  Clear Outlook AutoComplete Cache (Stream/NK2)"
        Write-Host "   6.  Report Mailbox-Related Local Cache Sizes"
        Write-Host "   7.  Check Outlook Add-Ins (Enabled/Disabled/Crashed)"
        Write-Host "   8.  Test Exchange Online / O365 Endpoint Connectivity"
        Write-Host "   9.  Open Outlook in Safe Mode Right Now"
        Write-Host "  10. Repair Outlook Data Files (scanpst.exe Launcher)"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            $domain = Read-Host "   Domain to test (e.g. contoso.com)"
            Show-Title "Autodiscover Resolution for $domain"
            foreach ($prefix in @("autodiscover.$domain","$domain")) {
                Write-Host "  Resolving $prefix ..." -ForegroundColor Cyan
                Resolve-DnsName -Name $prefix -Type CNAME -ErrorAction SilentlyContinue | Format-Table -AutoSize
            }
            $url = "https://autodiscover-s.outlook.com/autodiscover/autodiscover.xml"
            Write-Host "  Checking Microsoft 365 Autodiscover endpoint reachability..." -ForegroundColor Cyan
            try {
                $r = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
                Write-Host "  [OK] Endpoint reachable (HTTP $($r.StatusCode))." -ForegroundColor Green
            } catch {
                Write-Host "  [INFO] Endpoint check returned an error (often normal for HEAD without auth): $($_.Exception.Message)" -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Outlook Profile / Connection Status"
            $ProfilesPath = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Profiles"
            if (Test-Path $ProfilesPath) {
                Get-ChildItem $ProfilesPath | Select-Object PSChildName | Format-Table -AutoSize
            } else {
                Write-Host "  No Outlook 16.0 profiles found in registry." -ForegroundColor Yellow
            }
            $OutlookProc = Get-Process outlook -ErrorAction SilentlyContinue
            if ($OutlookProc) { Write-Host "  Outlook is currently running (PID: $($OutlookProc.Id))." -ForegroundColor Green }
            else { Write-Host "  Outlook is not currently running." -ForegroundColor Yellow }
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "OST File Size/Health Report"
            $OstPath = "$env:LOCALAPPDATA\Microsoft\Outlook"
            if (Test-Path $OstPath) {
                Get-ChildItem $OstPath -Filter "*.ost" -Recurse -ErrorAction SilentlyContinue |
                    Select-Object Name, @{N="SizeGB";E={[math]::Round($_.Length/1GB,2)}}, LastWriteTime | Format-Table -AutoSize
            } else {
                Write-Host "  Outlook data folder not found at: $OstPath" -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Force OST Rebuild"
            Write-Host "  This closes Outlook and renames the .ost file so Outlook rebuilds a" -ForegroundColor Cyan
            Write-Host "  fresh local cache from the mailbox on next launch. Safe for cached-mode" -ForegroundColor Cyan
            Write-Host "  Exchange Online mailboxes; first sync after this may take a while." -ForegroundColor Cyan
            if ((Read-Host "  Type YES to rename .ost file(s) and trigger rebuild") -eq "YES") {
                Stop-Process -Name outlook -Force -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 2
                $OstPath = "$env:LOCALAPPDATA\Microsoft\Outlook"
                Get-ChildItem $OstPath -Filter "*.ost" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
                    $newName = "$($_.FullName).old_$(Get-Date -Format 'yyyyMMddHHmmss')"
                    Rename-Item $_.FullName $newName -Force
                    Write-Host "  Renamed: $($_.Name) -> $(Split-Path $newName -Leaf)" -ForegroundColor Green
                }
                Write-AuditLog -Action "Outlook-OSTRebuild" -Detail "OST renamed for $env:USERNAME"
                Write-Host "  Done. Relaunch Outlook to trigger a fresh OST rebuild." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Clear Outlook AutoComplete Cache"
            if ((Read-Host "  Type YES to clear AutoComplete cache") -eq "YES") {
                Stop-Process -Name outlook -Force -ErrorAction SilentlyContinue
                $RoamingStream = "$env:LOCALAPPDATA\Microsoft\Outlook\RoamCache"
                if (Test-Path $RoamingStream) {
                    Get-ChildItem $RoamingStream -Filter "Stream_Autocomplete*" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
                    Write-Host "  AutoComplete stream cache cleared." -ForegroundColor Green
                } else {
                    Write-Host "  No RoamCache folder found (modern cloud-cached AutoComplete may live entirely server-side)." -ForegroundColor Yellow
                }
            }
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Mailbox-Related Local Cache Sizes"
            $Paths = @(
                @{Name="OST Files";          Path="$env:LOCALAPPDATA\Microsoft\Outlook"},
                @{Name="RoamCache";          Path="$env:LOCALAPPDATA\Microsoft\Outlook\RoamCache"},
                @{Name="Office Document Cache"; Path="$env:LOCALAPPDATA\Microsoft\Office\16.0\OfficeFileCache"}
            )
            foreach ($p in $Paths) {
                if (Test-Path $p.Path) {
                    $size = (Get-ChildItem $p.Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
                    Write-Host ("  {0,-25} : {1} GB" -f $p.Name, [math]::Round($size/1GB,2))
                } else {
                    Write-Host ("  {0,-25} : Not found" -f $p.Name) -ForegroundColor DarkGray
                }
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Outlook Add-Ins Status"
            $AddinPaths = @(
                "HKCU:\Software\Microsoft\Office\Outlook\Addins\*",
                "HKLM:\Software\Microsoft\Office\Outlook\Addins\*"
            )
            $AddinPaths | ForEach-Object { Get-ItemProperty $_ -ErrorAction SilentlyContinue } |
                Select-Object PSChildName, Description, LoadBehavior | Format-Table -AutoSize
            Write-Host "  LoadBehavior 3 = enabled. 2 or 0 = disabled. 1 or 9 = often crashed/disabled by Outlook." -ForegroundColor Cyan
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Exchange Online / O365 Endpoint Connectivity"
            $Endpoints = @(
                "outlook.office365.com",
                "outlook.office.com",
                "smtp.office365.com",
                "login.microsoftonline.com"
            )
            foreach ($e in $Endpoints) {
                $test = Test-NetConnection -ComputerName $e -Port 443 -WarningAction SilentlyContinue
                $status = if ($test.TcpTestSucceeded) { "[PASS]" } else { "[FAIL]" }
                $color  = if ($test.TcpTestSucceeded) { "Green" } else { "Red" }
                Write-Host "  $status $e : 443" -ForegroundColor $color
            }
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Launching Outlook in Safe Mode"
            Stop-Process -Name outlook -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            Start-Process "outlook.exe" -ArgumentList "/safe"
            Write-Host "  Outlook launched in Safe Mode (add-ins disabled for this session)." -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "10") {
            Show-Title "Repair Outlook Data Files (scanpst.exe)"
            $ScanPstPaths = @(
                "$env:ProgramFiles\Microsoft Office\root\Office16\SCANPST.EXE",
                "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\SCANPST.EXE"
            )
            $ScanPst = $ScanPstPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
            if ($ScanPst) {
                Start-Process $ScanPst
                Write-Host "  Launched Inbox Repair Tool. Browse to the .pst/.ost file to scan." -ForegroundColor Green
            } else {
                Write-Host "  scanpst.exe not found in expected Office16 path. Search manually under the Office install directory." -ForegroundColor Yellow
            }
            Wait-Key
        }
    }
}

# ================================================================
# 35. ENTRA MFA / CONDITIONAL ACCESS DEEP-DIVE (L2-L3)
# ================================================================
function Menu-ConditionalAccess {
    while ($true) {
        Show-Header
        Write-Host "  [ ENTRA MFA / CONDITIONAL ACCESS DEEP-DIVE ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Full Device Join/Registration Status (dsregcmd /status)"
        Write-Host "   2.  Check Windows Hello for Business Enrollment Status"
        Write-Host "   3.  Clear WAM (Web Account Manager) Token Cache"
        Write-Host "   4.  Clear Browser SSO / Primary Refresh Token Cache"
        Write-Host "   5.  Force Re-Check Device Compliance (Intune Sync)"
        Write-Host "   6.  View Local MDM Diagnostic Report (MDMDiagnostics)"
        Write-Host "   7.  Check Certificate-Based Device Authentication Status"
        Write-Host "   8.  Test Conditional Access Endpoint Reachability"
        Write-Host "   9.  Clear Cached Credentials (Credential Manager) for Office/M365"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") { Show-Title "Full Device Join/Registration Status"; dsregcmd /status; Wait-Key }
        elseif ($c -eq "2") {
            Show-Title "Windows Hello for Business Enrollment Status"
            $WhfbPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WinBio\AccountInfo\*"
            $NgcPath  = "HKLM:\SOFTWARE\Microsoft\Cryptography\Ngc"
            if (Test-Path $NgcPath) { Write-Host "  NGC (Next Generation Credential) container present - Hello container exists." -ForegroundColor Green }
            else { Write-Host "  No NGC container found - Windows Hello for Business not provisioned." -ForegroundColor Yellow }
            dsregcmd /status | Select-String "NgcSet|WorkplaceJoined|WamDefaultSet"
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Clear WAM Token Cache"
            if ((Read-Host "  Type YES to clear WAM token cache") -eq "YES") {
                Stop-Process -Name "Microsoft.AAD.BrokerPlugin" -Force -ErrorAction SilentlyContinue
                $WamPath = "$env:LOCALAPPDATA\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\AC\TokenBroker\Cache"
                if (Test-Path $WamPath) {
                    Remove-Item "$WamPath\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Write-AuditLog -Action "CA-ClearWAMCache" -Detail "WAM token cache cleared for $env:USERNAME"
                    Write-Host "  WAM token cache cleared. User will need to re-authenticate on next app launch." -ForegroundColor Green
                } else {
                    Write-Host "  WAM cache path not found (already clean, or different Windows build)." -ForegroundColor Yellow
                }
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Clear Browser SSO / PRT Cache"
            if ((Read-Host "  Type YES to clear browser SSO state and refresh PRT") -eq "YES") {
                foreach ($p in @("msedge","chrome")) { Stop-Process -Name $p -Force -ErrorAction SilentlyContinue }
                dsregcmd /refreshprt
                Write-AuditLog -Action "CA-ClearSSO" -Detail "Browser SSO cleared + PRT refreshed for $env:USERNAME"
                Write-Host "  Browser processes closed and PRT refresh triggered." -ForegroundColor Green
            }
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "Force Intune Device Compliance Re-Check"
            try {
                $enrollmentId = (Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Enrollments" -ErrorAction Stop | Where-Object {
                    (Get-ItemProperty $_.PSPath -Name "UPN" -ErrorAction SilentlyContinue).UPN
                } | Select-Object -First 1).PSChildName
                if ($enrollmentId) {
                    Get-ScheduledTask | Where-Object { $_.TaskPath -like "*Microsoft*Windows*EnterpriseMgmt*$enrollmentId*" } | Start-ScheduledTask
                    Write-Host "  Triggered Intune sync scheduled tasks for enrollment: $enrollmentId" -ForegroundColor Green
                } else {
                    Write-Host "  No active MDM enrollment ID found. Device may not be Intune-managed." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "  Could not locate enrollment tasks: $($_.Exception.Message)" -ForegroundColor Red
            }
            Write-Host "  Tip: 'Settings > Accounts > Access work or school > Info > Sync' achieves the same result interactively." -ForegroundColor Cyan
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Generating Local MDM Diagnostic Report"
            $Out = "$env:USERPROFILE\Desktop\MDMDiagReport_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            mdmdiagnosticstool.exe -out $Out 2>&1 | Out-Null
            if (Test-Path $Out) {
                Write-Host "  MDM diagnostic report generated at: $Out" -ForegroundColor Green
                Start-Process explorer.exe -ArgumentList $Out
            } else {
                Write-Host "  Report generation may have failed or used a different output path on this build." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Certificate-Based Device Authentication Status"
            $DeviceCerts = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match "CN=" -and $_.Issuer -match "MS-Organization-Access" }
            if ($DeviceCerts) {
                $DeviceCerts | Select-Object Subject, NotAfter, Thumbprint | Format-Table -AutoSize
                Write-Host "  Device authentication certificate(s) found (MS-Organization-Access issued)." -ForegroundColor Green
            } else {
                Write-Host "  No MS-Organization-Access device certificate found in LocalMachine\My store." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "8") {
            Show-Title "Conditional Access Endpoint Reachability"
            $Endpoints = @("login.microsoftonline.com","device.login.microsoftonline.com","enterpriseregistration.windows.net","login.windows.net")
            foreach ($e in $Endpoints) {
                $test = Test-NetConnection -ComputerName $e -Port 443 -WarningAction SilentlyContinue
                $status = if ($test.TcpTestSucceeded) { "[PASS]" } else { "[FAIL]" }
                $color  = if ($test.TcpTestSucceeded) { "Green" } else { "Red" }
                Write-Host "  $status $e : 443" -ForegroundColor $color
            }
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Clear Cached Office/M365 Credentials"
            if ((Read-Host "  Type YES to clear cached Office/M365 credentials") -eq "YES") {
                cmd /c "cmdkey /list" | Select-String "MicrosoftOffice|OneDrive|MSOPENTECH|MicrosoftAccount" | ForEach-Object {
                    if ($_ -match "Target:\s*(.*)") {
                        $t = $matches[1].Trim()
                        cmd /c "cmdkey /delete:`"$t`""
                        Write-Host "  Removed cached credential: $t" -ForegroundColor Green
                    }
                }
                Write-AuditLog -Action "CA-ClearCachedCreds" -Detail "Office/M365 cached credentials cleared for $env:USERNAME"
                Write-Host "  Cached credential sweep complete." -ForegroundColor Green
            }
            Wait-Key
        }
    }
}

# ================================================================
# 36. ADVANCED NETWORK L2/L3 TOOLKIT
# ================================================================
function Menu-NetworkAdvanced {
    while ($true) {
        Show-Header
        Write-Host "  [ ADVANCED NETWORK L2/L3 TOOLKIT ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Show Current DHCP Lease Details"
        Write-Host "   2.  Release & Renew with Verbose Lease Reporting"
        Write-Host "   3.  802.1x Authentication Status (Wired/Wireless)"
        Write-Host "   4.  Show Connected SSID Security/Auth Type"
        Write-Host "   5.  VPN Client Connection Status (Built-in RAS)"
        Write-Host "   6.  Locate Common 3rd-Party VPN Client Logs"
        Write-Host "   7.  Continuous Latency/Packet Loss Logger (Background CSV)"
        Write-Host "   8.  MTU / Path Fragmentation Test"
        Write-Host "   9.  Show Network Adapter Power Management Settings"
        Write-Host "  10. Capture Quick Network Trace (netsh trace, 60s)"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Current DHCP Lease Details"
            Get-NetIPConfiguration | ForEach-Object {
                Write-Host "  Interface: $($_.InterfaceAlias)" -ForegroundColor Cyan
                Write-Host "  IPv4 Address : $($_.IPv4Address.IPAddress)"
                Write-Host "  Gateway      : $($_.IPv4DefaultGateway.NextHop)"
                Write-Host "  DNS Servers  : $($_.DNSServer.ServerAddresses -join ', ')"
            }
            ipconfig /all | Select-String "Lease Obtained|Lease Expires|DHCP Server"
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Release & Renew with Lease Reporting"
            ipconfig /release
            Start-Sleep 2
            ipconfig /renew
            ipconfig /all | Select-String "Lease Obtained|Lease Expires|DHCP Server|IPv4 Address"
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "802.1x Authentication Status"
            netsh lan show interfaces
            Write-Host ""
            netsh wlan show interfaces | Select-String "Authentication|Cipher|State"
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Connected SSID Security/Auth Type"
            netsh wlan show interfaces | Select-String "SSID|Authentication|Cipher|Signal|Radio type"
            Wait-Key
        }
        elseif ($c -eq "5") {
            Show-Title "VPN Client Connection Status (Built-in RAS)"
            Get-VpnConnection -ErrorAction SilentlyContinue | Format-Table Name, ServerAddress, ConnectionStatus -AutoSize
            rasdial
            Wait-Key
        }
        elseif ($c -eq "6") {
            Show-Title "Common 3rd-Party VPN Client Logs"
            $VpnLogs = @(
                @{Name="Cisco AnyConnect"; Path="$env:ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Log"},
                @{Name="GlobalProtect";    Path="$env:ProgramData\Palo Alto Networks\GlobalProtect\PanGPS.log"},
                @{Name="Always On VPN";    Path="Event Log: Microsoft-Windows-NetworkAccessProtection/Operational"}
            )
            foreach ($v in $VpnLogs) {
                if ($v.Path -like "Event Log:*") {
                    Write-Host "  $($v.Name) : check $($v.Path) in Event Viewer" -ForegroundColor Cyan
                } elseif (Test-Path $v.Path) {
                    Write-Host "  $($v.Name) : Found at $($v.Path)" -ForegroundColor Green
                } else {
                    Write-Host "  $($v.Name) : Not found / not installed on this machine." -ForegroundColor DarkGray
                }
            }
            Wait-Key
        }
        elseif ($c -eq "7") {
            Show-Title "Continuous Latency/Packet Loss Logger"
            $target = Read-Host "   Target host/IP to monitor (e.g. 8.8.8.8)"
            $durationMin = Read-Host "   Duration in minutes (e.g. 10)"
            $Out = "$env:USERPROFILE\Desktop\LatencyLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
            "Timestamp,Target,ResponseTimeMs,Status" | Out-File $Out
            Write-Host "  Logging to $Out - press Ctrl+C to stop early." -ForegroundColor Yellow
            $endTime = (Get-Date).AddMinutes([int]$durationMin)
            while ((Get-Date) -lt $endTime) {
                $result = Test-Connection -ComputerName $target -Count 1 -ErrorAction SilentlyContinue
                $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                if ($result) {
                    "$ts,$target,$($result.ResponseTime),OK" | Out-File $Out -Append
                } else {
                    "$ts,$target,N/A,TIMEOUT" | Out-File $Out -Append
                }
                Start-Sleep -Seconds 2
            }
            Write-Host "  Logging complete. Saved to: $Out" -ForegroundColor Green
            Wait-Key
        }
        elseif ($c -eq "8") {
            $target = Read-Host "   Target host/IP for MTU test"
            Show-Title "MTU / Path Fragmentation Test against $target"
            Write-Host "  Testing standard Ethernet MTU (1472 payload + 28 header = 1500)..." -ForegroundColor Cyan
            ping $target -f -l 1472 -n 2
            Write-Host ""
            Write-Host "  Testing common VPN-safe MTU (1400 payload)..." -ForegroundColor Cyan
            ping $target -f -l 1400 -n 2
            Wait-Key
        }
        elseif ($c -eq "9") {
            Show-Title "Network Adapter Power Management Settings"
            Get-NetAdapter | ForEach-Object {
                $adapter = $_
                $pm = Get-CimInstance MSPower_DeviceEnable -Namespace root\wmi -ErrorAction SilentlyContinue |
                    Where-Object { $_.InstanceName -match [regex]::Escape($adapter.PnPDeviceID.Substring(0,[Math]::Min(20,$adapter.PnPDeviceID.Length))) }
                Write-Host "  $($adapter.Name) : $($adapter.Status)"
            }
            Write-Host ""
            Write-Host "  To check/disable 'Allow computer to turn off this device to save power':" -ForegroundColor Cyan
            Write-Host "  Device Manager > Network Adapter > Properties > Power Management tab." -ForegroundColor Cyan
            Start-Process devmgmt.msc
            Wait-Key
        }
        elseif ($c -eq "10") {
            Show-Title "Quick Network Trace (60 seconds)"
            $Out = "$env:USERPROFILE\Desktop\NetTrace_$(Get-Date -Format 'yyyyMMdd_HHmmss').etl"
            if ((Read-Host "  Type YES to start a 60-second network trace") -eq "YES") {
                netsh trace start capture=yes tracefile=$Out maxsize=256 overwrite=yes | Out-Null
                Write-Host "  Tracing for 60 seconds..." -ForegroundColor Yellow
                Start-Sleep -Seconds 60
                netsh trace stop | Out-Null
                Write-AuditLog -Action "Network-QuickTrace" -Detail "Saved to $Out"
                Write-Host "  Trace saved to: $Out (open with Microsoft Message Analyzer or Wireshark with ETL support)." -ForegroundColor Green
            }
            Wait-Key
        }
    }
}

# ================================================================
# 37. FULL DIAGNOSTIC REPORT GENERATOR (ALL TIERS)
# ================================================================
function Menu-DiagnosticReport {
    while ($true) {
        Show-Header
        Write-Host "  [ FULL DIAGNOSTIC REPORT GENERATOR ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  Generate Quick Triage Report (System + Network + Events)"
        Write-Host "   2.  Generate Full Enterprise Report (All Categories, HTML)"
        Write-Host "   3.  Generate Security-Focused Report (Defender + Firewall + Users)"
        Write-Host "   4.  Open Last Generated Report"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Generating Quick Triage Report"
            $Out = "$env:USERPROFILE\Desktop\TriageReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
            "QUICK TRIAGE REPORT - $env:COMPUTERNAME - $(Get-Date)" | Out-File $Out
            "=" * 60 | Out-File $Out -Append

            "`n--- SYSTEM INFO ---" | Out-File $Out -Append
            $os = Get-CimInstance Win32_OperatingSystem
            "OS: $($os.Caption) Build $($os.BuildNumber)" | Out-File $Out -Append
            "Uptime: $((Get-Date) - $os.LastBootUpTime)" | Out-File $Out -Append

            "`n--- DISK SPACE ---" | Out-File $Out -Append
            Get-PSDrive -PSProvider FileSystem | Format-Table Name, @{L="UsedGB";E={[math]::Round($_.Used/1GB,1)}}, @{L="FreeGB";E={[math]::Round($_.Free/1GB,1)}} | Out-String | Out-File $Out -Append

            "`n--- NETWORK ---" | Out-File $Out -Append
            foreach ($t in @("8.8.8.8","1.1.1.1")) {
                $r = Test-Connection $t -Count 1 -Quiet -ErrorAction SilentlyContinue
                "$t : $(if($r){'PASS'}else{'FAIL'})" | Out-File $Out -Append
            }

            "`n--- LAST 10 SYSTEM ERRORS ---" | Out-File $Out -Append
            Get-EventLog -LogName System -EntryType Error -Newest 10 -ErrorAction SilentlyContinue | Format-Table TimeGenerated, Source, EventID -AutoSize | Out-String | Out-File $Out -Append

            Write-AuditLog -Action "Report-QuickTriage" -Detail "Saved to $Out"
            Write-Host "  Quick triage report saved to: $Out" -ForegroundColor Green
            Start-Process $Out
            Wait-Key
        }
        elseif ($c -eq "2") {
            Show-Title "Generating Full Enterprise Report (HTML)"
            $Out = "$env:USERPROFILE\Desktop\FullDiagnosticReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
            $os = Get-CimInstance Win32_OperatingSystem
            $cs = Get-CimInstance Win32_ComputerSystem
            $cpu = Get-CimInstance Win32_Processor
            $disks = Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{N="UsedGB";E={[math]::Round($_.Used/1GB,1)}}, @{N="FreeGB";E={[math]::Round($_.Free/1GB,1)}}
            $netTests = foreach ($t in @("8.8.8.8","1.1.1.1","google.com")) {
                [PSCustomObject]@{ Target = $t; Result = if (Test-Connection $t -Count 1 -Quiet -ErrorAction SilentlyContinue) {"PASS"} else {"FAIL"} }
            }
            $errors = Get-EventLog -LogName System -EntryType Error -Newest 15 -ErrorAction SilentlyContinue | Select-Object TimeGenerated, Source, EventID
            $services = Get-Service | Where-Object { $_.Status -eq "Stopped" -and $_.StartType -eq "Automatic" } | Select-Object Name, DisplayName

            $html = @"
<html><head><title>Full Diagnostic Report - $env:COMPUTERNAME</title>
<style>
body { font-family: Segoe UI, Arial, sans-serif; margin: 30px; color: #222; }
h1 { color: #0078D4; } h2 { color: #333; border-bottom: 2px solid #0078D4; padding-bottom: 4px; margin-top: 30px; }
table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
th, td { border: 1px solid #ccc; padding: 6px 10px; text-align: left; font-size: 13px; }
th { background-color: #0078D4; color: white; }
tr:nth-child(even) { background-color: #f5f5f5; }
.pass { color: green; font-weight: bold; } .fail { color: red; font-weight: bold; }
</style></head><body>
<h1>Full Diagnostic Report</h1>
<p><b>Computer:</b> $env:COMPUTERNAME &nbsp; <b>User:</b> $env:USERNAME &nbsp; <b>Generated:</b> $(Get-Date)</p>

<h2>System Overview</h2>
<table>
<tr><th>OS</th><td>$($os.Caption) Build $($os.BuildNumber)</td></tr>
<tr><th>Manufacturer / Model</th><td>$($cs.Manufacturer) $($cs.Model)</td></tr>
<tr><th>CPU</th><td>$($cpu.Name)</td></tr>
<tr><th>RAM</th><td>$([math]::Round($cs.TotalPhysicalMemory/1GB,1)) GB</td></tr>
<tr><th>Uptime</th><td>$((Get-Date) - $os.LastBootUpTime)</td></tr>
</table>

<h2>Disk Space</h2>
<table><tr><th>Drive</th><th>Used (GB)</th><th>Free (GB)</th></tr>
$($disks | ForEach-Object { "<tr><td>$($_.Name)</td><td>$($_.UsedGB)</td><td>$($_.FreeGB)</td></tr>" } | Out-String)
</table>

<h2>Network Connectivity</h2>
<table><tr><th>Target</th><th>Result</th></tr>
$($netTests | ForEach-Object { "<tr><td>$($_.Target)</td><td class='$(if($_.Result -eq "PASS"){"pass"}else{"fail"})'>$($_.Result)</td></tr>" } | Out-String)
</table>

<h2>Recent System Errors (Last 15)</h2>
<table><tr><th>Time</th><th>Source</th><th>Event ID</th></tr>
$($errors | ForEach-Object { "<tr><td>$($_.TimeGenerated)</td><td>$($_.Source)</td><td>$($_.EventID)</td></tr>" } | Out-String)
</table>

<h2>Stopped Services (Set to Automatic)</h2>
<table><tr><th>Name</th><th>Display Name</th></tr>
$($services | ForEach-Object { "<tr><td>$($_.Name)</td><td>$($_.DisplayName)</td></tr>" } | Out-String)
</table>

</body></html>
"@
            $html | Out-File $Out -Encoding UTF8
            Write-AuditLog -Action "Report-FullEnterprise" -Detail "Saved to $Out"
            Write-Host "  Full enterprise HTML report saved to: $Out" -ForegroundColor Green
            Start-Process $Out
            Wait-Key
        }
        elseif ($c -eq "3") {
            Show-Title "Generating Security-Focused Report"
            $Out = "$env:USERPROFILE\Desktop\SecurityReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
            "SECURITY REPORT - $env:COMPUTERNAME - $(Get-Date)" | Out-File $Out
            "`n--- DEFENDER STATUS ---" | Out-File $Out -Append
            Get-MpComputerStatus -ErrorAction SilentlyContinue | Select-Object AntivirusEnabled, RealTimeProtectionEnabled, AntivirusSignatureLastUpdated | Format-List | Out-String | Out-File $Out -Append
            "`n--- FIREWALL STATUS ---" | Out-File $Out -Append
            Get-NetFirewallProfile -ErrorAction SilentlyContinue | Select-Object Name, Enabled | Format-Table -AutoSize | Out-String | Out-File $Out -Append
            "`n--- LOCAL ADMINISTRATORS ---" | Out-File $Out -Append
            Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue | Select-Object Name, PrincipalSource | Format-Table -AutoSize | Out-String | Out-File $Out -Append
            "`n--- BITLOCKER STATUS ---" | Out-File $Out -Append
            Get-BitLockerVolume -ErrorAction SilentlyContinue | Select-Object MountPoint, VolumeStatus, ProtectionStatus | Format-Table -AutoSize | Out-String | Out-File $Out -Append
            Write-AuditLog -Action "Report-Security" -Detail "Saved to $Out"
            Write-Host "  Security report saved to: $Out" -ForegroundColor Green
            Start-Process $Out
            Wait-Key
        }
        elseif ($c -eq "4") {
            Show-Title "Opening Most Recent Report"
            $Latest = Get-ChildItem "$env:USERPROFILE\Desktop" -Filter "*Report*" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            if ($Latest) { Start-Process $Latest.FullName; Write-Host "  Opened: $($Latest.Name)" -ForegroundColor Green }
            else { Write-Host "  No report files found on Desktop yet." -ForegroundColor Yellow }
            Wait-Key
        }
    }
}

# ================================================================
# 38. ACTION AUDIT LOG VIEWER
# ================================================================
function Menu-AuditLog {
    while ($true) {
        Show-Header
        Write-Host "  [ ACTION AUDIT LOG VIEWER ]" -ForegroundColor Green
        Write-Host ""
        Write-Host "   1.  View Recent Audit Log Entries (Last 50)"
        Write-Host "   2.  Search Audit Log by Keyword"
        Write-Host "   3.  Export Audit Log to Desktop"
        Write-Host "   4.  Open Audit Log Location in Explorer"
        Write-Host "   5.  Clear Audit Log (Local Only)"
        Write-Host ""
        Write-Host "   0.  Back"
        Write-Host ""
        $c = Read-Host "   Choice"

        $LogDir  = "C:\ProgramData\WinTroubleshooter"
        $LogFile = Join-Path $LogDir "AuditLog.csv"

        if ($c -eq "0") { return }
        elseif ($c -eq "1") {
            Show-Title "Recent Audit Log Entries"
            if (Test-Path $LogFile) {
                Import-Csv $LogFile | Select-Object -Last 50 | Format-Table -AutoSize -Wrap
            } else {
                Write-Host "  No audit log exists yet on this machine. Entries are created as destructive" -ForegroundColor Yellow
                Write-Host "  actions are performed across the toolkit's other modules." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "2") {
            $kw = Read-Host "   Keyword to search for"
            if (Test-Path $LogFile) {
                Import-Csv $LogFile | Where-Object { $_.Action -match $kw -or $_.Detail -match $kw } | Format-Table -AutoSize -Wrap
            } else {
                Write-Host "  No audit log exists yet." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "3") {
            if (Test-Path $LogFile) {
                $Out = "$env:USERPROFILE\Desktop\AuditLogExport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
                Copy-Item $LogFile $Out
                Write-Host "  Audit log exported to: $Out" -ForegroundColor Green
            } else {
                Write-Host "  No audit log exists yet." -ForegroundColor Yellow
            }
            Wait-Key
        }
        elseif ($c -eq "4") {
            if (Test-Path $LogDir) { Start-Process explorer.exe -ArgumentList $LogDir }
            else { Write-Host "  Log directory does not exist yet." -ForegroundColor Yellow }
            Wait-Key
        }
        elseif ($c -eq "5") {
            if ((Read-Host "  Type YES to permanently clear the local audit log") -eq "YES") {
                if (Test-Path $LogFile) {
                    Remove-Item $LogFile -Force
                    Write-Host "  Audit log cleared." -ForegroundColor Green
                } else {
                    Write-Host "  No audit log to clear." -ForegroundColor Yellow
                }
            }
            Wait-Key
        }
    }
}

# ================================================================
# START ENGINE EXECUTION
# ================================================================
Show-MainMenu
