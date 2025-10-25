# Hugo 개발 서버 실행 스크립트 (편의 기능 포함)
# 사용법: .\scripts\dev-server.ps1 [-Port 1313] [-OpenBrowser]

param(
    [int]$Port = 1313,
    [switch]$OpenBrowser = $true,
    [switch]$IncludeDrafts = $true
)

Write-Host "🚀 Hugo 개발 서버 시작..." -ForegroundColor Cyan

# Hugo가 설치되어 있는지 확인
if (-not (Get-Command hugo -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Hugo가 설치되어 있지 않습니다!" -ForegroundColor Red
    Write-Host "설치: winget install Hugo.Hugo.Extended" -ForegroundColor Yellow
    exit 1
}

# 테마 서브모듈 확인
if (-not (Test-Path "themes/PaperMod/.git")) {
    Write-Host "⚠️  테마 서브모듈이 초기화되지 않았습니다. 초기화 중..." -ForegroundColor Yellow
    git submodule update --init --recursive
}

# Hugo 서버 시작
$hugoArgs = @(
    "server"
    "--port", $Port
    "--navigateToChanged"
    "--disableFastRender"
)

if ($IncludeDrafts) {
    $hugoArgs += "-D"
}

Write-Host "📝 설정:" -ForegroundColor Yellow
Write-Host "  포트: $Port" -ForegroundColor White
Write-Host "  Draft 포함: $IncludeDrafts" -ForegroundColor White
Write-Host "  URL: http://localhost:$Port" -ForegroundColor White

# 브라우저 자동 열기
if ($OpenBrowser) {
    Start-Sleep -Seconds 2
    Start-Process "http://localhost:$Port"
}

# Hugo 서버 실행
& hugo $hugoArgs
