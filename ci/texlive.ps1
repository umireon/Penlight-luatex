$INSTALL_TL_URL = "http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip"
$INSTALL_TL_DIR = "$Env:USERPROFILE\install-tl"
$env:TEXLIVE_INSTALL_PREFIX = "$Env:USERPROFILE\texlive"

Function Resolve-Redirect([String]$Uri, [Int32] $MaximumRedirection = 5)
{
    for ($i = 0; $i -lt $MaximumRedirection; $i++) {
        $request = Invoke-WebRequest $Uri -Method HEAD -MaximumRedirection 0 -ErrorAction Ignore
        if ($request.StatusCode -like "3??") {
            $Uri = $request.Headers.Location;
        }
        if ($request.StatusCode -like "2??" -or $Uri.StartsWith("ftp")) {
            return $Uri
        }
    }
}

if (-not (Test-Path "$Env:TEXLIVE_INSTALL_PREFIX\bin\*\tex.exe")) {

New-Item -Path $INSTALL_TL_DIR -ItemType Directory
Invoke-WebRequest -Uri $(Resolve-Redirect $INSTALL_TL_URL) -OutFile "$INSTALL_TL_DIR\install-tl.zip"
Expand-Archive -Path "$INSTALL_TL_DIR\install-tl.zip" -DestinationPath "$INSTALL_TL_DIR" -Force

@"
option_doc 0
option_src 0
"@ | Set-Content "$INSTALL_TL_DIR\texlive.profile"

$install_tl_base = (Get-ChildItem "$INSTALL_TL_DIR\install-tl-*").FullName
$perl = "$install_tl_base\tlpkg\tlperl\bin\perl.exe"
$install_tl = "$install_tl_base\install-tl"

&$perl $install_tl -scheme basic -portable -profile "$INSTALL_TL_DIR\texlive.profile"

}

$TEXLIVE_BIN = Get-ChildItem "$Env:TEXLIVE_INSTALL_PREFIX\bin\*\tex.exe" | % FullName | Split-Path -Parent
$env:Path = "$TEXLIVE_BIN;$env:Path"
