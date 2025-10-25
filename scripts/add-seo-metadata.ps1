# SEO 메타데이터 자동 추가 스크립트
# 사용법: .\scripts\add-seo-metadata.ps1 [-Path "content"]

param(
    [string]$Path = "content",
    [switch]$DryRun = $false
)

Write-Host "🔍 SEO 메타데이터 검사 시작..." -ForegroundColor Cyan

$mdFiles = Get-ChildItem -Path $Path -Filter *.md -Recurse | Where-Object { $_.Name -ne "_index.md" }

$issues = @()

foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw

    # Front matter 파싱
    if ($content -match '(?s)^---\s*\n(.*?)\n---') {
        $frontMatter = $matches[1]

        $hasDescription = $frontMatter -match 'description:'
        $hasTags = $frontMatter -match 'tags:'
        $hasCategories = $frontMatter -match 'categories:'

        # 본문에서 첫 단락 추출 (description 자동 생성용)
        $bodyContent = $content -replace '(?s)^---.*?---\n', ''
        $firstParagraph = ($bodyContent -split '\n\n' | Where-Object { $_ -notmatch '^#' -and $_.Trim() -ne '' } | Select-Object -First 1)

        if ($firstParagraph) {
            $firstParagraph = ($firstParagraph -replace '\n', ' ').Trim()
            # 최대 160자로 제한
            if ($firstParagraph.Length -gt 160) {
                $firstParagraph = $firstParagraph.Substring(0, 157) + "..."
            }
        }

        $issue = [PSCustomObject]@{
            File = $file.FullName
            RelativePath = $file.FullName -replace [regex]::Escape((Get-Location).Path + "\"), ""
            HasDescription = $hasDescription
            HasTags = $hasTags
            HasCategories = $hasCategories
            SuggestedDescription = $firstParagraph
        }

        if (-not $hasDescription -or -not $hasTags -or -not $hasCategories) {
            $issues += $issue
        }
    }
}

if ($issues.Count -eq 0) {
    Write-Host "✅ 모든 포스트에 SEO 메타데이터가 있습니다!" -ForegroundColor Green
    exit 0
}

Write-Host "`n⚠️  SEO 메타데이터가 누락된 포스트: $($issues.Count)개" -ForegroundColor Yellow

foreach ($issue in $issues) {
    Write-Host "`n📄 $($issue.RelativePath)" -ForegroundColor Cyan

    if (-not $issue.HasDescription) {
        Write-Host "  ❌ description 없음" -ForegroundColor Red
        if ($issue.SuggestedDescription) {
            Write-Host "  💡 추천: $($issue.SuggestedDescription)" -ForegroundColor Yellow
        }
    }
    if (-not $issue.HasTags) {
        Write-Host "  ❌ tags 없음" -ForegroundColor Red
    }
    if (-not $issue.HasCategories) {
        Write-Host "  ❌ categories 없음" -ForegroundColor Red
    }

    # 자동 수정 (DryRun이 아닐 때)
    if (-not $DryRun) {
        $content = Get-Content $issue.File -Raw
        $modified = $false

        if ($content -match '(?s)^(---\s*\n)(.*?)(\n---)') {
            $frontMatterStart = $matches[1]
            $frontMatterContent = $matches[2]
            $frontMatterEnd = $matches[3]

            # description 추가
            if (-not $issue.HasDescription -and $issue.SuggestedDescription) {
                $frontMatterContent += "`ndescription: `"$($issue.SuggestedDescription)`""
                $modified = $true
            }

            # tags 추가 (비어있는 배열)
            if (-not $issue.HasTags) {
                $frontMatterContent += "`ntags: []"
                $modified = $true
            }

            # categories 추가 (디렉토리 이름 기반)
            if (-not $issue.HasCategories) {
                $dirName = Split-Path (Split-Path $issue.File -Parent) -Leaf
                $frontMatterContent += "`ncategories: [`"$dirName`"]"
                $modified = $true
            }

            if ($modified) {
                $newContent = $content -replace '(?s)^---\s*\n.*?\n---', ($frontMatterStart + $frontMatterContent + $frontMatterEnd)
                Set-Content -Path $issue.File -Value $newContent -Encoding UTF8
                Write-Host "  ✅ 자동 수정 완료" -ForegroundColor Green
            }
        }
    }
}

if ($DryRun) {
    Write-Host "`n💡 실제로 수정하려면 -DryRun 플래그를 제거하세요" -ForegroundColor Cyan
} else {
    Write-Host "`n✅ SEO 메타데이터 자동 추가 완료" -ForegroundColor Green
}
