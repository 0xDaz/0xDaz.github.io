# Hugo 새 포스트 생성 스크립트
# 사용법: .\scripts\new-post.ps1 -Category "Env" -Title "My New Tool"

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("AI", "Env", "posts")]
    [string]$Category,

    [Parameter(Mandatory=$true)]
    [string]$Title,

    [string[]]$Tags = @(),

    [switch]$Draft = $false
)

# 파일명 생성 (공백을 하이픈으로, 소문자로)
$fileName = $Title.ToLower() -replace '\s+', '-' -replace '[^a-z0-9-]', ''
$filePath = "content/$Category/$fileName.md"

# 이미 존재하는지 확인
if (Test-Path $filePath) {
    Write-Host "❌ 파일이 이미 존재합니다: $filePath" -ForegroundColor Red
    exit 1
}

# 현재 시간 (한국 시간)
$date = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+09:00"

# Tags 배열을 YAML 형식으로 변환
$tagsYaml = if ($Tags.Count -gt 0) {
    '["' + ($Tags -join '", "') + '"]'
} else {
    "[]"
}

# Front matter 생성
$frontMatter = @"
---
title: "$Title"
date: $date
tags: $tagsYaml
categories: ["$Category"]
draft: $Draft
---

## 개요

간단한 설명

## 특징

- 핵심 기능 1
- 핵심 기능 2

## 참고 링크

- [공식 사이트](https://example.com)
"@

# 파일 생성
New-Item -Path $filePath -ItemType File -Force | Out-Null
Set-Content -Path $filePath -Value $frontMatter -Encoding UTF8

Write-Host "✅ 포스트 생성 완료: $filePath" -ForegroundColor Green
Write-Host "📝 편집하려면: code $filePath" -ForegroundColor Cyan

# 선택적으로 VS Code로 열기
$openInEditor = Read-Host "VS Code로 열까요? (y/n)"
if ($openInEditor -eq 'y') {
    code $filePath
}
