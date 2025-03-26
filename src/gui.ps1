Add-Type -AssemblyName System.Windows.Forms

# Get the first argument as URL (if provided)
$downloadUrl = $args[0]

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Aria2c Downloader"
$form.Size = New-Object System.Drawing.Size(400, 180)
$form.StartPosition = "CenterScreen"

# Create a text box for the URL (pre-filled if argument exists)
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 20)
$textBox.Size = New-Object System.Drawing.Size(360, 20)
$textBox.Text = $downloadUrl
$form.Controls.Add($textBox)

# Create a button for downloading
$button = New-Object System.Windows.Forms.Button
$button.Text = "Download"
$button.Location = New-Object System.Drawing.Point(140, 60)
$button.Add_Click({
    $url = $textBox.Text.Trim()
    
    if ($url -eq "") {
        [System.Windows.Forms.MessageBox]::Show("Please enter a URL.")
        return
    }

    # Open folder selection dialog
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Choose Save Directory"
    # $folderDialog.SelectedPath = (Get-Location).Path
    
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $saveDir = $folderDialog.SelectedPath

        # Run aria2c with the selected directory
        Start-Process -FilePath "aria2c.exe" -ArgumentList `
        "-x 8", `
        "-s 8", `
        "-k 4M", `
        "--lowest-speed-limit=10K", `
        "--async-dns=false", `
        "--check-certificate=false", `
        "--conditional-get=true", `
        "--allow-overwrite=true", `
        "--always-resume=true", `
        "--http-no-cache=true", `
        "--max-file-not-found=0", `
        "--max-tries=20", `
        "--retry-wait=5", `
        "`"$url`"", `
        "-d", "`"$saveDir`"" `
        -NoNewWindow -Wait
    }

})

$form.Controls.Add($button)

# Show the form
$form.ShowDialog()
