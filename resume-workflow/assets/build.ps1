# typst 一键编译脚本
# 自动补双括号 + 编译 + 检查页数
# 用法：powershell -File build.ps1 xxx.typ
param([string]$file)

if (-not $file) { Write-Host "用法: build.ps1 xxx.typ"; exit 1 }

# 自动补双括号
$c = Get-Content $file
if ($c[-1].Trim() + $c[-2].Trim() -ne ']]') {
    Add-Content $file ']'
    Write-Host "[FIX] 自动补双括号" -ForegroundColor Yellow
} else {
    Write-Host "[OK] 双括号" -ForegroundColor Green
}

# 编译
$pdf = $file -replace '\.typ$', '.pdf'
$root = Split-Path $file -Parent
$root = Split-Path $root  # go up one level for image path
# Typst 可执行文件：优先用 PATH 中的 typst；也可通过环境变量 TYPST_PATH 指定自定义路径
$typst = $env:TYPST_PATH
if (-not $typst) { $typst = "typst" }
& $typst compile --root $root $file $pdf

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] 编译成功" -ForegroundColor Green
    # 检查页数
    $bytes = [IO.File]::ReadAllBytes($pdf)
    $text = [Text.Encoding]::ASCII.GetString($bytes)
    $pages = ([regex]::Matches($text, '/Type\s*/Page[^s]')).Count
    Write-Host "[OK] 页数: $pages" -ForegroundColor $(if($pages -eq 1){'Green'}else{'Yellow'})
    Write-Host "输出: $pdf"
} else {
    Write-Host "[FAIL] 编译失败" -ForegroundColor Red
}
