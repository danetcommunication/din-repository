# Command prompt
curl -Lo wizcli.exe https://downloads.wiz.io/v1/wizcli/latest/wizcli-windows-amd64.exe

# PowerShell
Invoke-WebRequest -Uri https://downloads.wiz.io/v1/wizcli/latest/wizcli-windows-amd64.exe -OutFile wizcli.exe

# (Optional) Verify the Wiz CLI signature
# NOTE: You will need to install a GPG signature validation tool
# Wiz CLI's GPG public key can be fetched from downloads.wiz.io or from Ubuntu's key server with the key ID CE4AE4BAD12EE02C and fingerprint 61DF 4068 0AB1 A80E 5150 3B61 CE4A E4BA D12E E02C.

# Command prompt
# Step 1:  Import the public key, as described above, from keyserver or direct link:
# Direct link:
curl -Lo public_key.asc https://downloads.wiz.io/wizcli/public_key.asc
gpg --import public_key.asc
# (OR) Ubuntu's Keyserver
gpg --keyserver keyserver.ubuntu.com --recv-keys CE4AE4BAD12EE02C

# Step 2: Download files to perform signature verification:
cd %TEMP%
curl -Lo wizcli-sha256 https://downloads.wiz.io/v1/wizcli/latest/wizcli-windows-amd64.exe-sha256
curl -Lo wizcli-sha256.sig https://downloads.wiz.io/v1/wizcli/latest/wizcli-windows-amd64.exe-sha256.sig

# Step 3: Verify signature:
gpg --verify %TEMP%/wizcli-sha256.sig %TEMP%/wizcli-sha256

# PowerShell

# Step 4: Create a new PowerShell script that will be used to validate that the signatures match (execute this from the same directory where the Wiz CLI binary is located)
New-Item validate_gpg.ps1

# Step 4a: Open the file in your preferred editor
Start-Process .\validate_gpg.ps1

# Step 4b: Paste the following contents into the `validate_gpg.ps1` file and save
# START SCRIPT validate_gpg.ps1
$wizcliExePath = ".\wizcli.exe" # Or the full path to where you downloaded wizcli.exe
$expectedHashFromFilePath = "$env:TEMP\wizcli-sha256" # Or full path to where you downloaded wizcli-sha256

If (-not (Test-Path $wizcliExePath)) {
    Write-Error "wizcli.exe not found at $wizcliExePath. Please provide the correct path."
    return
}
If (-not (Test-Path $expectedHashFromFilePath)) {
    Write-Error "SHA256 checksum file not found at $expectedH```ashFromFilePath. Please provide the correct path."
    return
}

$expectedHash = (Get-Content -Path $expectedHashFromFilePath -TotalCount 1).Trim()

$actualFileHash = (Get-FileHash -Path $wizcliExePath -Algorithm SHA256).Hash.ToLower()

# Step 4c: Compare the hashes
If ($actualFileHash -eq $expectedHash.ToLower()) {
    Write-Host "SHA256 Verification Successful: The hash of '$wizcliExePath' matches the expected hash." -ForegroundColor Green
} Else {
    Write-Host "SHA256 Verification FAILED!" -ForegroundColor Red
    Write-Host "Expected SHA256: $expectedHash"
    Write-Host "Actual SHA256  : $actualFileHash"
}
# END SCRIPT validate_gpg.ps1

# Step 5: Execute the PowerShell script
& .\validate_gpg.ps1

# Expected output
`SHA256 Verification Successful: The hash of '.\wizcli.exe' matches the expected hash.`