# Written by Matt Shields
# Copyright 2011
# Name: s3push_sync.ps1
# Use: Use to sync files up to S3 bucket.  In my case I used it to push SQL Server transaction logs up to S3
# Requires Cloudberry Explorer Pro installed and licensed to use Powershell modules

$key = "{AWS_KEY}"
$secret = "{AWS_SECRET_KEY}"

if ( (Get-PSSnapin -Name CloudBerryLab.Explorer.PSSnapIn -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin CloudBerryLab.Explorer.PSSnapIn
}


$s3 = Get-CloudS3Connection -Key $key -Secret $secret

Set-CloudOption -PermissionsInheritance "inheritall" -UseChunks 100000 -ChunkTransparency 1

# Copy SwaptreeDB log files
$bucket = "bucket_name/path/to/where/you/want/files/"

$destination = $s3 | Select-CloudFolder -Path $bucket

$source = Get-CloudFileSystemConnection | Select-CloudFolder "C:\source\on\local\computer\"

$source | Copy-CloudSyncFolders $destination -IncludeSubFolders -MissingOnly -DeleteOnTarget -IncludeFiles "*.trn"
#$source | Copy-CloudSyncFolders $destination -IncludeSubFolders -MissingOnly -IncludeFiles "*.trn"

