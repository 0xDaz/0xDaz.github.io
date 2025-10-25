# Hugo 블로그 자동화 스크립트

이 디렉토리는 Hugo 블로그 개발을 쉽게 하기 위한 자동화 스크립트들을 포함합니다.

## 📜 스크립트 목록

### 1. `new-post.ps1` - 새 포스트 생성

**설명**: 표준 템플릿으로 새 포스트를 빠르게 생성합니다.

**사용법**:
```powershell
# 기본 사용
.\scripts\new-post.ps1 -Category "Env" -Title "EverythingToolbar 설치"

# 태그 포함
.\scripts\new-post.ps1 -Category "AI" -Title "Context7 MCP Server" -Tags @("MCP", "AI", "Context7")

# Draft 모드로 생성
.\scripts\new-post.ps1 -Category "posts" -Title "My Post" -Draft
```

**파라미터**:
- `-Category`: 포스트 카테고리 (AI, Env, posts 중 선택)
- `-Title`: 포스트 제목
- `-Tags`: 태그 배열 (선택사항)
- `-Draft`: Draft 모드 (선택사항)

---

### 2. `optimize-images.ps1` - 이미지 최적화

**설명**: static/images/ 디렉토리의 이미지를 분석하고 최적화합니다.

**사용법**:
```powershell
# 기본 사용 (분석만)
.\scripts\optimize-images.ps1

# 품질 지정 (ImageMagick 필요)
.\scripts\optimize-images.ps1 -Quality 85

# 백업 없이 최적화
.\scripts\optimize-images.ps1 -Backup:$false
```

**파라미터**:
- `-Path`: 이미지 디렉토리 경로 (기본: static/images)
- `-Quality`: 압축 품질 (1-100, 기본: 85)
- `-Backup`: 백업 생성 여부 (기본: true)

**요구사항**:
- 자동 최적화 기능을 사용하려면 ImageMagick 설치 필요
- 설치: `winget install ImageMagick.ImageMagick`

---

### 3. `add-seo-metadata.ps1` - SEO 메타데이터 추가

**설명**: 모든 포스트의 SEO 메타데이터를 검사하고 누락된 항목을 자동으로 추가합니다.

**사용법**:
```powershell
# 검사만 수행 (수정 안 함)
.\scripts\add-seo-metadata.ps1 -DryRun

# 자동 수정
.\scripts\add-seo-metadata.ps1
```

**자동 추가 항목**:
- `description`: 본문 첫 단락에서 자동 생성 (최대 160자)
- `tags`: 빈 배열로 추가 (수동으로 채우세요)
- `categories`: 디렉토리 이름 기반으로 추가

**파라미터**:
- `-Path`: 검사할 디렉토리 (기본: content)
- `-DryRun`: 수정 없이 검사만 수행

---

### 4. `dev-server.ps1` - 개발 서버 실행

**설명**: Hugo 개발 서버를 편리하게 시작합니다.

**사용법**:
```powershell
# 기본 사용 (포트 1313, 브라우저 자동 열기)
.\scripts\dev-server.ps1

# 다른 포트 사용
.\scripts\dev-server.ps1 -Port 8080

# 브라우저 자동 열기 비활성화
.\scripts\dev-server.ps1 -OpenBrowser:$false

# Draft 제외
.\scripts\dev-server.ps1 -IncludeDrafts:$false
```

**기능**:
- ✅ 테마 서브모듈 자동 확인
- ✅ 브라우저 자동 열기
- ✅ navigateToChanged 활성화 (수정한 페이지로 자동 이동)
- ✅ Draft 포스트 포함

**파라미터**:
- `-Port`: 서버 포트 (기본: 1313)
- `-OpenBrowser`: 브라우저 자동 열기 (기본: true)
- `-IncludeDrafts`: Draft 포스트 포함 (기본: true)

---

## 🚀 빠른 시작 워크플로우

### 일반적인 개발 프로세스:

```powershell
# 1. 개발 서버 시작
.\scripts\dev-server.ps1

# 2. 새 포스트 작성 (새 터미널 창)
.\scripts\new-post.ps1 -Category "Env" -Title "My Tool" -Tags @("Windows", "Tool")

# 3. 이미지 추가 후 최적화
.\scripts\optimize-images.ps1

# 4. SEO 메타데이터 검사
.\scripts\add-seo-metadata.ps1 -DryRun

# 5. 문제 없으면 자동 수정
.\scripts\add-seo-metadata.ps1

# 6. Git 커밋 & 푸시 (GitHub Actions가 자동 배포)
git add .
git commit -m "Add new post: My Tool"
git push
```

---

## 💡 팁

### PowerShell 실행 정책

스크립트를 실행할 수 없다면:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 스크립트 별칭 설정

`.bashrc` 또는 PowerShell 프로필에 추가:
```powershell
# PowerShell 프로필 열기
notepad $PROFILE

# 추가할 내용:
function New-BlogPost { .\scripts\new-post.ps1 @args }
function Start-BlogServer { .\scripts\dev-server.ps1 @args }
function Optimize-BlogImages { .\scripts\optimize-images.ps1 @args }

Set-Alias nbp New-BlogPost
Set-Alias sbs Start-BlogServer
Set-Alias obi Optimize-BlogImages
```

사용 예시:
```powershell
nbp -Category "AI" -Title "New AI Tool"
sbs
obi
```

---

## 🔧 추가 개선 아이디어

향후 추가할 수 있는 스크립트:
- `deploy.ps1`: 수동 배포 스크립트
- `backup.ps1`: 콘텐츠 백업
- `stats.ps1`: 블로그 통계 (포스트 수, 카테고리별 분포 등)
- `link-check.ps1`: 깨진 링크 확인
- `batch-update-tags.ps1`: 태그 일괄 수정

---

## 📚 관련 문서

- [Hugo 공식 문서](https://gohugo.io/documentation/)
- [PaperMod 테마](https://github.com/adityatelange/hugo-PaperMod)
- [블로그 스타일 가이드](../CLAUDE.md)
