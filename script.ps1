Function New-PopUpForm {

    $Time = (get-date).tostring("HH:mm:ss")

  Add-Type -AssemblyName System.Windows.Forms  

    # Create the form.
    $objForm = New-Object System.Windows.Forms.Form -Property @{
      Text = "Internet Down"
      Size = New-Object System.Drawing.Size 500,500
    }

    # Create a label...
    $objLabel = New-Object System.Windows.Forms.Label -Property @{
      Location = New-Object System.Drawing.Size 250,250
      Size = New-Object System.Drawing.Size 200,200
      Text = "Last Attempt at $Time"
    }

    # ... and add it to the form.
    $objForm.Controls.Add($objLabel)

    # Return the form.
    return $objForm
}

while($true)
{


$Result = (test-connection 1.1.1.1 -count 1 -quiet)

if($Result -eq $False){

$form = New-PopupForm
$form.Topmost = $True


$Date = (get-date).tostring("yyyy-MM-dd")
$Time = (get-date).tostring("HH:mm:ss")

IF(-not(TEST-PATH "C:\code\logs\Internet\$date.txt")){new-item -itemtype File -path "C:\code\logs\internet\$date.txt" | out-null }

Add-Content "C:\code\logs\Internet\$date.txt" "# START OF INCIDENT #"


Add-Content "C:\code\logs\Internet\$date.txt" "Internet unresponsive at $Time"


do{


$form.Show() 
  sleep 5
$Result2 = (test-connection 1.1.1.1 -count 1 -quiet)
      $Form.Close()
      $form = New-PopupForm
$form.Topmost = $True
}
until($Result2 -eq $True)
sleep 2
if($Result2 -eq $True){
$time2 = (get-date).tostring("HH:mm:ss")
Add-Content "C:\code\logs\Internet\$date.txt" "Internet recovered at $Time2"

$Total = new-timespan -start $time -end $Time2

$Mins = $Total.TotalMinutes
$Secs = $Total.TotalSeconds

if($Mins -GE 1){

Add-Content "C:\code\logs\Internet\$date.txt" "Internet down for $Mins minutes"

}

else {
    Add-Content "C:\code\logs\Internet\$date.txt" "Internet down for $Secs seconds"

}

Add-Content "C:\code\logs\Internet\$date.txt" "# END OF INCIDENT #"


    $Form.Close()
}


$Master = get-content c:\code\logs\internet\master.txt
$NewTotal = [int]$Master + 1
Set-Content c:\code\logs\internet\master.txt $NewTotal
sleep 3
get-process *Powershell* | Stop-process -force
C:\code\UptimeHelper.ps1
}

sleep 5
}
