param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^v\d+\.\d+\.\d+$')]
    [string]$Version,

    [string]$DocsRoot = "docs"
)

$ErrorActionPreference = "Stop"

function Add-Issue {
    param(
        [string]$Level,
        [string]$Message
    )

    [PSCustomObject]@{
        Level = $Level
        Message = $Message
    }
}

function Test-AnyMarkdown {
    param([string]$Path)

    return (Test-Path $Path) -and ((Get-ChildItem -Path $Path -Filter "*.md" -File -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0)
}

function Get-MarkdownBaseNames {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return @()
    }

    return @(Get-ChildItem -Path $Path -Filter "*.md" -File | ForEach-Object { $_.BaseName })
}

function Test-DocumentStatus {
    param([string]$Path)

    $content = Get-Content -Path $Path -Raw
    if ($content -match '(?m)^>\s*Status:\s*(STALE|BLOCKED)\b') {
        return $Matches[1]
    }

    if ($content -notmatch '(?m)^>\s*Status:\s*(ACTIVE|DRAFT|STALE|BLOCKED)\b') {
        return "MISSING"
    }

    return "OK"
}

$issues = @()
$versionRoot = Join-Path $DocsRoot $Version

if (-not (Test-Path (Join-Path $DocsRoot "technical-architecture.md"))) {
    $issues += Add-Issue "ERROR" "Missing docs/technical-architecture.md"
}

if (-not (Test-Path $versionRoot)) {
    $issues += Add-Issue "ERROR" "Missing $versionRoot"
}

$progressPath = Join-Path $versionRoot "progress.md"
if (-not (Test-Path $progressPath)) {
    $issues += Add-Issue "ERROR" "Missing $progressPath"
}

$originPath = Join-Path $versionRoot "prd/origin"
$summarizedPath = Join-Path $versionRoot "prd/summarized"
$designPath = Join-Path $versionRoot "design"
$plansPath = Join-Path $versionRoot "plans"
$reviewPath = Join-Path $versionRoot "review"
$testReportPath = Join-Path $versionRoot "test-report.md"

if (-not (Test-AnyMarkdown $originPath)) {
    $issues += Add-Issue "ERROR" "Missing origin PRD markdown files in $originPath"
}

$originNames = Get-MarkdownBaseNames $originPath
$summarizedNames = Get-MarkdownBaseNames $summarizedPath
$designNames = Get-MarkdownBaseNames $designPath
$planNames = Get-MarkdownBaseNames $plansPath

foreach ($name in $originNames) {
    if ($summarizedNames -notcontains $name) {
        $issues += Add-Issue "ERROR" "Missing summarized PRD for $name"
    }
}

foreach ($name in $summarizedNames) {
    if (($designNames -notcontains $name) -and (Test-AnyMarkdown $designPath)) {
        $issues += Add-Issue "WARN" "Missing design for summarized PRD $name"
    }
}

foreach ($name in $designNames) {
    if (($planNames -notcontains $name) -and (Test-AnyMarkdown $plansPath)) {
        $issues += Add-Issue "WARN" "Missing plan for design $name"
    }
}

$generatedDocs = @()
foreach ($path in @($summarizedPath, $designPath, $plansPath, $reviewPath)) {
    if (Test-Path $path) {
        $generatedDocs += Get-ChildItem -Path $path -Filter "*.md" -File
    }
}

if (Test-Path $testReportPath) {
    $generatedDocs += Get-Item $testReportPath
}

foreach ($doc in $generatedDocs) {
    $status = Test-DocumentStatus $doc.FullName
    if ($status -eq "STALE" -or $status -eq "BLOCKED") {
        $issues += Add-Issue "ERROR" "$($doc.FullName) is $status"
    }
    elseif ($status -eq "MISSING") {
        $issues += Add-Issue "WARN" "$($doc.FullName) is missing Status header"
    }
}

if (Test-Path $testReportPath) {
    $report = Get-Content -Path $testReportPath -Raw

    $reportStatus = $null
    if ($report -match '(?m)^>\s*Status:\s*(ACTIVE|DRAFT|STALE|BLOCKED)\b') {
        $reportStatus = $Matches[1]
    }

    $reportConclusion = $null
    if ($report -match '结论[：:]\s*\*{0,2}\s*(可进入 review|阻塞)\s*\*{0,2}') {
        $reportConclusion = $Matches[1]
    }

    if ($null -eq $reportConclusion) {
        $issues += Add-Issue "WARN" "test-report.md missing or unrecognized 摘要.结论 (expected 可进入 review / 阻塞)"
    }
    elseif ($null -ne $reportStatus) {
        # 文首 Status 与 摘要.结论 必须一致：ACTIVE ↔ 可进入 review；DRAFT/BLOCKED ↔ 阻塞
        if ($reportStatus -eq "ACTIVE" -and $reportConclusion -ne "可进入 review") {
            $issues += Add-Issue "ERROR" "test-report.md Status=ACTIVE but 结论=$reportConclusion (expected 可进入 review)"
        }
        elseif (($reportStatus -eq "DRAFT" -or $reportStatus -eq "BLOCKED") -and $reportConclusion -ne "阻塞") {
            $issues += Add-Issue "ERROR" "test-report.md Status=$reportStatus but 结论=$reportConclusion (expected 阻塞)"
        }
    }
}

if (Test-Path $progressPath) {
    $progress = Get-Content -Path $progressPath -Raw
    # 只解析 ## Blockers 段落，到下一个标题或文件结束为止
    if ($progress -match '(?ms)^##\s+Blockers\s*\r?\n(.*?)(?=^##\s|\z)') {
        $blockerSection = $Matches[1]
        if ($blockerSection -match '(?im)^\s*-\s+(?!None\b).+') {
            $issues += Add-Issue "WARN" "progress.md Blockers section is not empty; inspect blockers"
        }
    }
}

if ($issues.Count -eq 0) {
    Write-Host "OK: $Version iteration structure passed validation."
    exit 0
}

$issues | Format-Table -AutoSize

if (($issues | Where-Object { $_.Level -eq "ERROR" }).Count -gt 0) {
    exit 1
}

exit 0
