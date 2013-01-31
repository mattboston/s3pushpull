# Written by Matt Shields
# Copyright 2011
# Name: s3pull_sync.ps1
# Use: Use to sync files down from S3 bucket.  In my case I used it to pull SQL Server transaction logs from S3
# Requires Cloudberry Explorer Pro installed and licensed to use Powershell modules

$key = "{AWS_KEY}"
$secret = "{AWS_SECRET_KEY}"
if ( (Get-PSSnapin -Name CloudBerryLab.Explorer.PSSnapIn -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin CloudBerryLab.Explorer.PSSnapIn
}

$s3 = Get-CloudS3Connection -Key $key -Secret $secret

Set-CloudOption -PermissionsInheritance "inheritall"

$log = "C:\scripts\sync.log"

echo "Starting" >> $log
get-date >> $log

$bucket = "bucket_name/path/of/source/"

$source = $s3 | Select-CloudFolder -Path $bucket

$local = Get-CloudFileSystemConnection
$target = $local | Select-CloudFolder "C:\path\of\destination\"

$source | Copy-CloudSyncFolders $target -IncludeSubFolders -MissingOnly -DeleteOnTarget -ExcludeFolders "2011*" -IncludeFicles "*.trn"

echo "Complete" >> $log
get-date >> $log
