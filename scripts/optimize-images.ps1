# 이미지 최적화 스크립트
# 사용법: .\scripts\optimize-images.ps1 [-Path "static/images"] [-Quality 85]

param(
    [string]$Path = "static/images",
    [int]$Quality = 85,
    [switch]$Backup = $true
)

# ImageMagick 또는 다른 이미지 처리 도구가 필요합니다
# 이 스크립트는 기본적으로 파일 크기를 확인하고 경고를 표시합니다

Write-Host "🖼️  이미지 최적화 시작..." -ForegroundColor Cyan

$imageFiles = Get-ChildItem -Path $Path -Include *.jpg,*.jpeg,*.png,*.gif -Recurse

$totalSize = 0
$largeFiles = @()

foreach ($file in $imageFiles) {
    $size = $file.Length / 1MB
    $totalSize += $size

    if ($size -gt 1) {
        $largeFiles += [PSCustomObject]@{
            Name = $file.Name
            Path = $file.FullName
            SizeMB = [math]::Round($size, 2)
        }
    }
}

Write-Host "`n📊 분석 결과:" -ForegroundColor Yellow
Write-Host "총 파일 수: $($imageFiles.Count)" -ForegroundColor White
Write-Host "총 크기: $([math]::Round($totalSize, 2)) MB" -ForegroundColor White

if ($largeFiles.Count -gt 0) {
    Write-Host "`n⚠️  1MB 이상 파일 ($($largeFiles.Count)개):" -ForegroundColor Yellow
    $largeFiles | Format-Table -AutoSize

    Write-Host "`n💡 최적화 권장사항:" -ForegroundColor Cyan
    Write-Host "1. TinyPNG (https://tinypng.com) 사용" -ForegroundColor White
    Write-Host "2. ImageMagick 설치 후 일괄 최적화" -ForegroundColor White
    Write-Host "3. Hugo의 이미지 처리 기능 활용 (.Resources.Resize)" -ForegroundColor White
} else {
    Write-Host "`n✅ 모든 이미지가 1MB 미만입니다!" -ForegroundColor Green
}

# ImageMagick이 설치되어 있다면 자동 최적화
if (Get-Command magick -ErrorAction SilentlyContinue) {
    Write-Host "`n🔧 ImageMagick 발견! 최적화를 진행할까요? (y/n)" -ForegroundColor Green
    $proceed = Read-Host

    if ($proceed -eq 'y') {
        # 백업 생성
        if ($Backup) {
            $backupPath = "static/images_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Copy-Item -Path $Path -Destination $backupPath -Recurse
            Write-Host "✅ 백업 생성: $backupPath" -ForegroundColor Green
        }

        foreach ($file in $imageFiles) {
            $originalSize = $file.Length / 1KB

            # PNG 최적화
            if ($file.Extension -in @('.png')) {
                magick $file.FullName -strip -quality $Quality $file.FullName
            }
            # JPEG 최적화
            elseif ($file.Extension -in @('.jpg', '.jpeg')) {
                magick $file.FullName -strip -quality $Quality -sampling-factor 4:2:0 $file.FullName
            }

            $newFile = Get-Item $file.FullName
            $newSize = $newFile.Length / 1KB
            $saved = $originalSize - $newSize

            if ($saved -gt 0) {
                Write-Host "✓ $($file.Name): $([math]::Round($saved, 2)) KB 절약" -ForegroundColor Green
            }
        }
    }
} else {
    Write-Host "`n💡 ImageMagick을 설치하면 자동 최적화가 가능합니다:" -ForegroundColor Cyan
    Write-Host "   winget install ImageMagick.ImageMagick" -ForegroundColor White
}
