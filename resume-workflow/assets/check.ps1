# typst 编译前检查脚本
# 用法：powershell -File check.ps1 resume.typ

param([string]$file)

if (-not $file) {
    Write-Host "用法: check.ps1 xxx.typ" -ForegroundColor Yellow
    exit 1
}

$lines = Get-Content $file
$last = $lines[-1].Trim()
$second = $lines[-2].Trim()
$errors = 0

# 1. 双括号
if ($last -ne ']' -or $second -ne ']') {
    Write-Host "[FAIL] 末尾缺双括号 - 最后两行：" -ForegroundColor Red
    Write-Host "  -2: $second"
    Write-Host "  -1: $last"
    $errors++
} else {
    Write-Host "[OK] 双括号" -ForegroundColor Green
}

# 2. 中文引号
$quotes = Select-String -Path $file -Pattern '["\u201c\u201d]' -AllMatches
if ($quotes) {
    Write-Host "[WARN] 发现中文引号" -ForegroundColor Yellow
    $quotes | ForEach-Object { Write-Host "  行$($_.LineNumber): $($_.Line.Trim())" }
}

exit $errors
