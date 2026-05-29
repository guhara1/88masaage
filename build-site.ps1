$ErrorActionPreference = "Stop"

$brand = "88마사지"
$siteUrl = "https://88masaage.pages.dev"
$phone = "0508-000-0088"
$today = (Get-Date).ToString("yyyy-MM-dd")

function HtmlEscape($value) {
  return [System.Net.WebUtility]::HtmlEncode([string]$value)
}

function XmlEscape($value) {
  return [System.Security.SecurityElement]::Escape([string]$value)
}

function Ensure-Dir($path) {
  if (!(Test-Path $path)) {
    New-Item -ItemType Directory -Force -Path $path | Out-Null
  }
}

function Write-Utf8($path, $content) {
  $dir = Split-Path $path -Parent
  if ($dir) { Ensure-Dir $dir }
  [System.IO.File]::WriteAllText((Join-Path (Get-Location) $path), $content, [System.Text.UTF8Encoding]::new($false))
}

$services = @(
  @{
    slug="swedish-massage"; name="스웨디시"; tone="부드러운 압과 긴 호흡으로 전신 긴장을 낮추는 릴랙스 관리"; user="강한 압보다 편안한 흐름과 안정감을 선호하는 고객"; feature="부드러운 터치와 일정한 리듬으로 전신을 차분하게 정리하는 방식"; need="장시간 앉아 일한 뒤 몸이 예민하거나 수면 전 편안한 휴식이 필요한 경우"; traits="피부 자극이 적은 오일, 낮은 압, 느린 템포, 조용한 분위기"; time60="가볍게 전신 흐름을 정리하고 싶은 고객"; time90="전신 릴랙스를 충분히 느끼고 싶은 고객"; time120="여유 있게 깊은 휴식을 원하는 고객"; compare="스포츠마사지는 활동 후 피로 부위에 집중하고, 타이마사지는 스트레칭 비중이 높지만 스웨디시는 부드러운 전신 릴랙스에 초점을 둡니다."
  },
  @{
    slug="aroma-therapy"; name="아로마테라피"; tone="피부 자극이 적은 오일을 사용해 향과 터치로 안정감을 더하는 관리"; user="낯선 숙소나 출장 일정 뒤 향을 곁들인 휴식을 원하는 고객"; feature="오일 선호도와 향 민감도를 먼저 확인하고 잔향이 부담스럽지 않게 조절하는 방식"; need="긴 이동 뒤 긴장이 남아 있거나 조용한 분위기에서 몸을 가볍게 정리하고 싶은 경우"; traits="향 선택, 오일 사용량, 실내 환기, 타월 정리를 세심하게 맞추는 점이 특징"; time60="향과 터치감을 짧게 경험하고 싶은 고객"; time90="전신을 여유 있게 관리받고 싶은 고객"; time120="숙소에서 충분한 휴식 시간을 확보한 고객"; compare="스웨디시가 터치 흐름을 중시한다면 아로마테라피는 향, 오일감, 실내 분위기까지 함께 맞추는 관리입니다."
  },
  @{
    slug="deep-tissue"; name="딥티슈"; tone="등, 어깨, 하체처럼 뭉침이 잦은 부위를 천천히 풀어 주는 집중 관리"; user="특정 부위가 무겁고 단단하게 느껴져 세밀한 압 조절을 원하는 고객"; feature="넓게 문지르기보다 뭉침이 잦은 부위를 천천히 확인하고 압을 단계적으로 맞추는 방식"; need="어깨와 등, 허벅지처럼 반복적으로 피로가 쌓이는 부위를 중심으로 관리받고 싶은 경우"; traits="처음부터 강하게 누르지 않고 반응을 보며 압을 조절하는 집중형 관리"; time60="한두 부위를 중심으로 정리하고 싶은 고객"; time90="상체 또는 하체 흐름까지 함께 보고 싶은 고객"; time120="여러 부위를 나누어 천천히 관리받고 싶은 고객"; compare="딥티슈는 스웨디시보다 집중 부위와 압 조절이 뚜렷하고, 스포츠마사지보다 휴식 흐름을 더 부드럽게 가져갑니다."
  },
  @{
    slug="thai-massage"; name="타이마사지"; tone="스트레칭과 지압을 조합해 굳은 움직임을 부드럽게 만드는 관리"; user="몸이 뻣뻣하고 가벼운 스트레칭이 필요한 고객"; feature="매트 공간을 확보한 뒤 관절 범위를 무리하지 않게 확인하며 지압과 스트레칭을 조합하는 방식"; need="오래 앉아 있어 움직임이 답답하거나 전신을 시원하게 늘리고 싶은 경우"; traits="오일 사용보다 복장과 공간 확보가 중요하며 호흡에 맞춘 스트레칭을 진행"; time60="가볍게 주요 부위를 늘리고 싶은 고객"; time90="전신 스트레칭과 지압을 균형 있게 원하는 고객"; time120="천천히 움직임을 확인하며 여유 있게 받고 싶은 고객"; compare="타이마사지는 오일 중심 관리와 달리 스트레칭 비중이 높고, 딥티슈처럼 한 부위만 깊게 누르기보다 전신 움직임을 봅니다."
  },
  @{
    slug="sports-massage"; name="스포츠마사지"; tone="활동량이 많은 고객의 근육 피로와 회복 리듬을 돕는 관리"; user="운동, 등산, 골프, 장거리 운전 뒤 회복 시간을 확보하려는 고객"; feature="활동 부위와 피로가 큰 부위를 먼저 묻고 스트레칭 범위를 무리하지 않게 정하는 방식"; need="운동 후 뻐근함이 남거나 다음 일정 전 몸을 가볍게 정리하고 싶은 경우"; traits="압 조절, 부위별 집중, 간단한 스트레칭, 관리 후 무리한 활동 자제 안내를 포함"; time60="운동 후 특정 부위 위주로 정리하고 싶은 고객"; time90="상하체를 균형 있게 관리받고 싶은 고객"; time120="활동량이 많았던 날 전신 회복 시간을 길게 잡고 싶은 고객"; compare="스포츠마사지는 릴랙스보다 활동 후 피로 부위 정리에 가깝고, 타이마사지보다 압과 부위별 관리 비중이 높습니다."
  },
  @{
    slug="lymph-massage"; name="림프마사지"; tone="가벼운 압과 일정한 방향의 터치로 붓기와 무거움을 덜어 주는 관리"; user="오래 앉아 있거나 서 있는 시간이 많아 몸이 무겁게 느껴지는 고객"; feature="강한 자극보다 방향성과 반복 리듬을 중시하며 편안한 범위에서 진행하는 방식"; need="다리나 팔이 무겁게 느껴지고 강한 압은 부담스러운 경우"; traits="가벼운 압, 일정한 방향, 느린 반복, 편안한 호흡을 중심으로 구성"; time60="하체나 팔처럼 한 영역을 가볍게 정리하고 싶은 고객"; time90="전신의 무거움을 여유 있게 낮추고 싶은 고객"; time120="부드러운 압으로 충분한 휴식을 원하는 고객"; compare="림프마사지는 딥티슈처럼 깊게 누르기보다 가벼운 압과 방향성을 중시하고, 스포츠마사지보다 안정적인 템포로 진행합니다."
  }
)

$regions = @(
  @{slug="seoul"; name="서울"; focus="업무지구와 주거지가 촘촘히 붙어 있어 퇴근 직후 예약과 심야 문의가 많은 지역"; movement="주차와 엘리베이터 출입 확인이 중요하며 강남, 여의도, 마포 권역은 이동 시간이 빠르게 변합니다"; cost="도심 혼잡 시간에는 추가 이동 시간이 생길 수 있어 예약 시 건물 출입 조건을 먼저 확인합니다"},
  @{slug="gyeonggi"; name="경기"; focus="신도시, 산업단지, 대형 아파트 단지가 넓게 퍼져 있어 생활권별 예약 패턴이 다릅니다"; movement="수원, 성남, 고양, 용인처럼 이동 축이 긴 도시는 같은 시 안에서도 도착 시간이 달라집니다"; cost="외곽 단지와 야간 장거리 이동은 상담 단계에서 출장 가능 시간을 따로 안내합니다"},
  @{slug="incheon"; name="인천"; focus="공항 일정, 송도 국제업무지구, 청라와 구월동 생활권 문의가 섞이는 지역"; movement="공항 도착 시간과 교량 이동 상황에 따라 예약 여유 시간을 넉넉히 두는 편이 좋습니다"; cost="영종, 강화 등 도서·교량 이동이 필요한 곳은 사전 확인 후 가능 여부를 안내합니다"},
  @{slug="busan"; name="부산"; focus="해운대와 서면, 광안리, 남포동처럼 관광과 업무 수요가 동시에 발생합니다"; movement="해안가 숙소는 성수기 주차와 프런트 출입 기준이 달라 예약 전 확인이 필요합니다"; cost="기장, 강서처럼 이동 거리가 긴 권역은 시간대별 안내가 달라질 수 있습니다"},
  @{slug="daegu"; name="대구"; focus="동성로, 수성구, 혁신도시 생활권을 중심으로 저녁 예약이 꾸준합니다"; movement="도심과 외곽 간 이동 시간이 분명해 원하는 시작 시간이 있다면 빠른 상담이 좋습니다"; cost="달성군 일부 권역은 배정 가능 관리사와 이동비 기준을 별도로 확인합니다"},
  @{slug="gwangju"; name="광주"; focus="상무지구, 첨단, 충장로, 수완지구처럼 생활권별 특성이 뚜렷합니다"; movement="아파트 단지와 숙박시설 출입 방식이 달라 예약 전 방문 조건을 남겨 주면 배정이 수월합니다"; cost="광산구 외곽과 전남 인접 지역은 이동 가능 시간을 따로 안내합니다"},
  @{slug="daejeon"; name="대전"; focus="둔산, 유성, 관저, 대덕 연구단지 일정 뒤 휴식 문의가 많습니다"; movement="출장·세미나 고객은 행사 종료 시간이 밀리는 경우가 있어 예약 여유를 두는 편이 안정적입니다"; cost="세종과 인접한 권역은 당일 배정 상황에 따라 안내가 달라집니다"},
  @{slug="ulsan"; name="울산"; focus="산업단지 근무자와 해안 숙소 이용 고객의 문의가 함께 나타납니다"; movement="교대 근무 후 이용하는 경우가 많아 야간 시간대와 주차 동선을 먼저 확인합니다"; cost="울주군 산간·해안 이동은 거리와 시간대에 따라 별도 상담이 필요합니다"},
  @{slug="sejong"; name="세종"; focus="정부청사, 신도심 아파트, 조치원 생활권의 이용 상황이 다릅니다"; movement="건물 출입 보안이 까다로운 곳이 있어 방문자 등록 가능 여부를 알려 주면 좋습니다"; cost="세종 외곽과 대전 인접 권역은 배정 가능 시간 확인이 우선입니다"},
  @{slug="gangwon"; name="강원"; focus="원주, 춘천, 강릉처럼 도시별 거리 차이가 커 여행 숙소 문의가 많은 지역"; movement="리조트와 펜션은 주소가 비슷해도 진입로가 달라 정확한 위치 공유가 필요합니다"; cost="산간·해안 이동은 기상과 시간대 영향을 받아 사전 상담이 중요합니다"},
  @{slug="chungcheong"; name="충청"; focus="천안, 청주, 아산, 당진처럼 산업과 주거 수요가 함께 있는 권역"; movement="고속도로와 산업단지 퇴근 시간 영향을 받아 시작 시간을 여유 있게 잡는 것이 좋습니다"; cost="시 경계를 넘는 이동은 예약 전 예상 도착 시간을 안내합니다"},
  @{slug="jeju"; name="제주"; focus="공항, 제주시, 서귀포, 중문 숙소 중심으로 여행 후 휴식 문의가 많습니다"; movement="렌터카 이동과 숙소 체크인 시간이 겹치면 예약 변경 가능성을 고려해야 합니다"; cost="동부·서부 해안 숙소는 이동 시간이 길어 당일 가능 여부를 먼저 확인합니다"}
)

$districts = @(
  @{slug="gangnam-gu"; name="강남구"; zones="역삼, 삼성, 청담, 논현"; scene="업무 미팅과 야근 뒤 이용 문의가 많아 시작 시간의 정확성이 중요합니다"},
  @{slug="seocho-gu"; name="서초구"; zones="서초, 반포, 양재, 방배"; scene="법조타운과 주거지가 가까워 조용한 방문 절차와 주차 확인이 자주 필요합니다"},
  @{slug="songpa-gu"; name="송파구"; zones="잠실, 문정, 가락, 위례"; scene="대형 단지와 호텔이 함께 있어 출입 동선과 엘리베이터 이용 기준이 다양합니다"},
  @{slug="gangdong-gu"; name="강동구"; zones="천호, 길동, 암사, 명일"; scene="주거권 예약이 많아 늦은 시간 소음과 공동현관 기준을 먼저 확인합니다"},
  @{slug="mapo-gu"; name="마포구"; zones="공덕, 상암, 합정, 연남"; scene="업무지와 숙소, 원룸 밀집지가 섞여 있어 예약 목적과 공간 조건을 구분합니다"},
  @{slug="yongsan-gu"; name="용산구"; zones="한남, 이태원, 용산역, 후암"; scene="외국인 동행 고객과 출장 일정 문의가 있어 안내 문구를 명확히 남깁니다"},
  @{slug="jung-gu"; name="중구"; zones="명동, 을지로, 충무로, 회현"; scene="호텔 방문 문의가 많고 프런트 안내 기준을 사전에 확인하는 편이 좋습니다"},
  @{slug="jongno-gu"; name="종로구"; zones="광화문, 혜화, 삼청, 종로3가"; scene="오래된 건물과 업무 공간이 함께 있어 정확한 출입구 설명이 도움이 됩니다"},
  @{slug="seongdong-gu"; name="성동구"; zones="성수, 왕십리, 금호, 옥수"; scene="성수 업무 공간과 주거권 예약이 섞여 시간대별 이동 흐름이 달라집니다"},
  @{slug="gwangjin-gu"; name="광진구"; zones="건대입구, 구의, 자양, 광장"; scene="상권과 주거지가 가까워 저녁 시간 문의가 몰리는 편입니다"},
  @{slug="dongdaemun-gu"; name="동대문구"; zones="장안, 청량리, 회기, 답십리"; scene="역세권 이동과 주거 단지 방문이 많아 세부 주소 확인이 중요합니다"},
  @{slug="jungnang-gu"; name="중랑구"; zones="상봉, 면목, 망우, 신내"; scene="주거지 중심 예약이 많고 시작 전 조용한 방문 요청이 자주 있습니다"},
  @{slug="seongbuk-gu"; name="성북구"; zones="성신여대, 길음, 정릉, 안암"; scene="대학가와 아파트 단지가 섞여 관리 시간 선택지가 넓습니다"},
  @{slug="gangbuk-gu"; name="강북구"; zones="수유, 미아, 번동, 우이"; scene="북부 생활권 특성상 이동 여유 시간과 정확한 위치 공유가 필요합니다"},
  @{slug="dobong-gu"; name="도봉구"; zones="창동, 방학, 쌍문, 도봉"; scene="주거권 비중이 높아 가족이 있는 공간의 방문 매너를 중시합니다"},
  @{slug="nowon-gu"; name="노원구"; zones="상계, 중계, 하계, 공릉"; scene="대형 단지와 학원가 일정 뒤 휴식 문의가 꾸준합니다"},
  @{slug="eunpyeong-gu"; name="은평구"; zones="연신내, 불광, 응암, 진관"; scene="서북권 이동 특성상 도착 가능 시간을 미리 확인하는 것이 좋습니다"},
  @{slug="seodaemun-gu"; name="서대문구"; zones="신촌, 연희, 홍제, 충정로"; scene="대학가, 업무지, 주거지가 겹쳐 공간 유형에 맞춘 안내가 필요합니다"},
  @{slug="yangcheon-gu"; name="양천구"; zones="목동, 신정, 신월, 오목교"; scene="아파트 단지 예약이 많아 공동현관과 주차 안내가 중요합니다"},
  @{slug="gangseo-gu"; name="강서구"; zones="마곡, 발산, 김포공항, 화곡"; scene="공항 일정과 업무지 문의가 함께 있어 이동 시간 변수가 큽니다"},
  @{slug="guro-gu"; name="구로구"; zones="구로디지털단지, 오류, 개봉, 신도림"; scene="IT 업무지와 역세권 숙소 예약이 많아 퇴근 직후 문의가 집중됩니다"},
  @{slug="geumcheon-gu"; name="금천구"; zones="가산, 독산, 시흥, 금천구청"; scene="가산 업무지 중심으로 짧고 정돈된 회복 관리 수요가 있습니다"},
  @{slug="yeongdeungpo-gu"; name="영등포구"; zones="여의도, 문래, 당산, 영등포역"; scene="금융권과 숙박시설 방문이 섞여 정확한 예약명 확인이 필요합니다"},
  @{slug="dongjak-gu"; name="동작구"; zones="사당, 노량진, 상도, 흑석"; scene="교통 환승지와 주거지가 가까워 시간 조율이 비교적 세밀합니다"},
  @{slug="gwanak-gu"; name="관악구"; zones="서울대입구, 신림, 봉천, 낙성대"; scene="원룸과 오피스텔 예약이 많아 공간 크기와 소음 기준을 먼저 확인합니다"}
)

$adminAreas = @(
  @{slug="suwon"; name="수원"; parent="경기"; zones="광교, 인계, 영통, 권선"; scene="업무지와 신도시 주거권이 가까워 저녁 예약이 안정적으로 이어집니다"},
  @{slug="seongnam"; name="성남"; parent="경기"; zones="판교, 분당, 야탑, 위례"; scene="IT 업무 일정과 주거지 방문이 섞여 평일 늦은 문의가 많습니다"},
  @{slug="goyang"; name="고양"; parent="경기"; zones="일산, 화정, 삼송, 킨텍스"; scene="전시 일정 뒤 숙소에서 휴식을 찾는 고객과 주거권 문의가 함께 있습니다"},
  @{slug="yongin"; name="용인"; parent="경기"; zones="수지, 기흥, 처인, 동백"; scene="지역 범위가 넓어 같은 용인 안에서도 이동 시간 확인이 중요합니다"},
  @{slug="bucheon"; name="부천"; parent="경기"; zones="중동, 상동, 송내, 역곡"; scene="역세권 오피스텔과 주거 단지 예약이 균형 있게 들어옵니다"},
  @{slug="yeonsu-gu"; name="연수구"; parent="인천"; zones="송도, 연수, 동춘, 청학"; scene="국제업무지구와 주거 단지가 붙어 있어 건물 출입 기준이 다양합니다"},
  @{slug="bupyeong-gu"; name="부평구"; parent="인천"; zones="부평역, 삼산, 갈산, 산곡"; scene="상권과 주거지가 섞여 늦은 저녁 상담에서 정확한 위치가 중요합니다"},
  @{slug="haeundae-gu"; name="해운대구"; parent="부산"; zones="해운대, 센텀, 좌동, 송정"; scene="관광 숙소와 업무 미팅 후 예약이 함께 있어 성수기 여유 시간이 필요합니다"},
  @{slug="busanjin-gu"; name="부산진구"; parent="부산"; zones="서면, 부전, 전포, 가야"; scene="도심 상권 중심 예약이 많아 이동과 주차 조건을 먼저 봅니다"},
  @{slug="changwon"; name="창원"; parent="경상"; zones="성산, 의창, 마산, 진해"; scene="산업단지 근무 일정과 주거권 문의가 함께 나타납니다"},
  @{slug="cheongju"; name="청주"; parent="충청"; zones="오송, 복대, 율량, 상당"; scene="오송 출장과 도심 주거권 예약이 섞여 일정 확인이 중요합니다"},
  @{slug="jeonju"; name="전주"; parent="전라"; zones="완산, 덕진, 혁신도시, 한옥마을"; scene="여행 숙소와 주거지 예약이 모두 있어 공간 유형별 안내가 필요합니다"}
)

function Section($title, $body) {
  return "<section class=`"content-section`"><h2>$title</h2><p>$body</p></section>"
}

function FaqBlock($items) {
  $html = "<section class=`"content-section faq`"><h2>자주 묻는 질문</h2>"
  foreach ($item in $items) {
    $html += "<details><summary>$($item.q)</summary><p>$($item.a)</p></details>"
  }
  return $html + "</section>"
}

function Layout($title, $description, $path, $body, $schemaType, $areaServed) {
  $canonical = "$siteUrl$path"
  $escapedTitle = HtmlEscape $title
  $escapedDescription = HtmlEscape $description
  $serviceNav = ($services | ForEach-Object { "<a href=`"/services/$($_.slug)/`">$($_.name)</a>" }) -join ""
  $schema = @{
    "@context"="https://schema.org"
    "@type"=$schemaType
    name=$title
    description=$description
    url=$canonical
    provider=@{"@type"="Organization"; name=$brand; telephone=$phone; url=$siteUrl}
  }
  if ($areaServed) { $schema.areaServed = $areaServed }
  $json = ($schema | ConvertTo-Json -Depth 8 -Compress).Replace("</", "<\/")
  return @"
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$escapedTitle</title>
  <meta name="description" content="$escapedDescription">
  <link rel="canonical" href="$canonical">
  <meta property="og:type" content="website">
  <meta property="og:title" content="$escapedTitle">
  <meta property="og:description" content="$escapedDescription">
  <meta property="og:url" content="$canonical">
  <meta property="og:image" content="$siteUrl/assets/hero-wellness.png">
  <link rel="icon" href="/assets/favicon.svg">
  <link rel="stylesheet" href="/styles.css">
  <script type="application/ld+json">$json</script>
</head>
<body>
  <header class="site-header">
    <a class="logo" href="/"><span>88</span>마사지</a>
    <button class="menu-button" type="button" aria-label="메뉴 열기">☰</button>
    <nav class="main-nav">
      <div class="nav-group"><a href="/services/">서비스 안내</a><div class="submenu">$serviceNav</div></div>
      <a href="/#areas">지역</a>
      <a href="/#how">이용 방법</a>
      <a href="/#price">요금</a>
      <a href="/#faq">FAQ</a>
      <a href="/#contact">예약 문의</a>
    </nav>
  </header>
  <main>
    $body
  </main>
  <footer class="site-footer">
    <strong>$brand</strong>
    <p>건전한 휴식 관리 안내를 제공하는 출장마사지 예약 상담 사이트입니다. 의료 행위, 치료, 진단, 효과 보장을 약속하지 않으며 이용 전 컨디션과 방문 환경을 확인합니다.</p>
    <p>책임 편집: 고객센터 운영팀 · 문의: <a href="tel:$phone">$phone</a> · 최종 검수일: $today</p>
  </footer>
  <div class="sticky-cta"><a href="tel:$phone">전화 예약</a><a href="/#areas">지역 확인</a></div>
  <script src="/script.js"></script>
</body>
</html>
"@
}

function Hero($eyebrow, $title, $lead) {
  return @"
<section class="hero">
  <div class="hero-inner">
    <p class="eyebrow">$eyebrow</p>
    <h1>$title</h1>
    <p class="lead">$lead</p>
    <div class="hero-actions"><a class="primary" href="tel:$phone">전화 예약</a><a class="secondary" href="/#areas">출장 가능 지역</a></div>
  </div>
</section>
"@
}

function Build-Main {
  $serviceLinks = ($services | ForEach-Object { "<a class=`"link-card`" href=`"/services/$($_.slug)/`"><strong>$($_.name)</strong><span>$($_.tone)</span></a>" }) -join ""
  $regionLinks = ($regions | ForEach-Object { "<a class=`"link-card`" href=`"/areas/$($_.slug)/`"><strong>$($_.name)</strong><span>$($_.focus)</span></a>" }) -join ""
  $body = Hero "전국 예약 상담" "$brand 출장마사지" "88마사지는 자택, 호텔, 숙소, 업무 공간에서 편안한 휴식 관리를 받을 수 있도록 예약 전 확인 정보를 먼저 안내합니다. 과장된 효과보다 방문 조건, 관리 범위, 준비 사항, 취소 기준을 투명하게 설명합니다."
  $body += Section "신뢰 기준" "88마사지는 건강 관련 표현을 조심스럽게 다룹니다. 모든 콘텐츠는 고객센터 운영팀이 작성하고 검수하며, 실제 예약 상담에서 반복적으로 확인되는 질문을 바탕으로 정리합니다. 특정 증상 개선, 치료, 의학적 효과를 보장하지 않고 편안한 휴식과 컨디션 관리의 범위 안에서 안내합니다. 예약 전에는 고객의 현재 컨디션, 방문 장소의 출입 방식, 관리 가능 시간, 관리사 배정 가능 여부를 확인합니다. 이 과정은 단순한 홍보 문구가 아니라 현장에서 혼선이 자주 생기는 부분을 줄이기 위한 운영 원칙입니다."
  $body += Section "도움되는 콘텐츠 원칙" "사이트의 모든 페이지는 지역명만 바꾸는 복제 문단을 피하고, 생활권과 이동 조건, 숙소 유형, 주차와 공동현관 기준, 자주 묻는 질문을 다르게 구성합니다. 검색 노출을 위한 대량 문서보다 실제 예약자가 읽고 결정할 수 있는 정보를 우선합니다. 페이지마다 작성일과 검수일을 남기며, 안내가 바뀌면 sitemap과 RSS를 다시 생성해 검색엔진이 최신 구조를 발견하도록 합니다. 구조화 데이터는 실제로 노출된 정보와 일치하는 범위에서만 사용합니다."
  $body += "<section id=`"services`" class=`"grid-section`"><h2>서비스 안내</h2><div class=`"card-grid`">$serviceLinks</div></section>"
  $body += "<section id=`"areas`" class=`"grid-section`"><h2>출장 가능 지역</h2><div class=`"card-grid`">$regionLinks</div></section>"
  $body += Section "이용 방법" "예약은 문의, 지역 확인, 관리 선택, 방문 조건 확인, 배정 안내 순서로 진행됩니다. 주소는 상세 동과 건물 유형까지 알려 주면 도착 시간을 더 정확히 안내할 수 있습니다. 호텔은 프런트 출입 기준, 오피스텔은 공동현관과 엘리베이터 이용 기준, 자택은 주차 가능 여부를 함께 확인합니다. 관리는 고객이 편안함을 느끼는 압과 속도를 기준으로 조절하며 불편한 부위는 무리하지 않습니다."
  $body += Section "요금 안내" "기본 상담은 60분, 90분, 120분 단위로 안내합니다. 실제 금액은 지역, 시간대, 관리 종류, 이동 거리, 동시 예약 여부에 따라 달라질 수 있어 예약 전 상담에서 확정합니다. 안내되지 않은 추가 비용을 현장에서 요구하지 않도록 이동 조건과 연장 가능 여부를 먼저 설명합니다. 심야, 원거리, 교량·산간 이동은 별도 기준이 적용될 수 있습니다."
  $body += Section "편집 정책" "88마사지는 검색 순위만을 목적으로 같은 문장을 반복해 늘리지 않습니다. 서비스 설명, 지역 안내, FAQ는 실제 상담에서 확인되는 질문을 기준으로 나누고, 책임 편집자가 표현을 검수합니다. 새 페이지를 만들 때도 지역명만 바꾸는 방식은 사용하지 않으며 방문 조건, 생활권, 준비 사항이 충분히 다를 때만 공개합니다."
  $body += Section "안전한 예약 기준" "예약 가능 여부는 고객의 편의뿐 아니라 관리사가 안전하게 방문할 수 있는지도 함께 봅니다. 주소가 불명확하거나 예약 범위를 벗어난 요구가 있는 경우에는 진행하지 않습니다. 건전한 휴식 관리라는 기준이 지켜질 때 고객도 더 편안하게 서비스를 이용할 수 있습니다."
  $body += FaqBlock @(
    @{q="예약 전 무엇을 알려야 하나요?"; a="지역, 시작 희망 시간, 공간 유형, 엘리베이터와 주차 가능 여부, 원하는 관리 시간을 알려 주시면 됩니다."},
    @{q="의료 목적 관리인가요?"; a="아닙니다. 88마사지는 휴식과 컨디션 관리를 안내하며 치료, 진단, 통증 개선 보장을 하지 않습니다."},
    @{q="관리사는 어떻게 배정되나요?"; a="지역과 시간대, 관리 종류, 고객 요청 사항을 확인한 뒤 가능한 인력을 안내합니다."}
  )
  $body += Section "예약 문의" "지금 이용하려는 지역과 희망 시간을 알려 주시면 가능한 관리 종류와 예상 도착 시간을 확인해 드립니다. 상담 내용은 예약 안내 목적에만 사용하며, 무리한 권유 없이 조건이 맞는 경우에만 진행합니다."
  return Layout "$brand | 전국 출장마사지 예약 안내" "전국 출장마사지 예약 전 확인해야 할 서비스, 지역, 이용 방법, 요금, 신뢰 기준을 안내하는 88마사지 공식 사이트입니다." "/" $body "Organization" "대한민국"
}

function Build-ServicesIndex {
  $serviceLinks = ($services | ForEach-Object { "<a class=`"link-card`" href=`"/services/$($_.slug)/`"><strong>$($_.name)</strong><span>$($_.tone)</span></a>" }) -join ""
  $body = Hero "서비스 안내" "전국 출장마사지 서비스 안내" "스웨디시, 아로마테라피, 딥티슈, 타이마사지, 스포츠마사지, 림프마사지까지 고객의 컨디션과 목적에 맞춘 출장마사지 서비스를 안내합니다."
  $body += Section "서비스 선택 기준" "출장마사지 서비스를 고를 때는 이름보다 현재 컨디션, 원하는 압의 강도, 오일 사용 여부, 공간 조건을 먼저 확인하는 것이 좋습니다. 88마사지는 각 서비스를 같은 표현으로 반복하지 않고 관리 목적과 진행 방식, 이용 전 확인 사항을 나누어 설명합니다. 스웨디시는 부드러운 전신 릴랙스, 아로마테라피는 향과 오일감, 딥티슈는 뭉침이 잦은 부위, 타이마사지는 스트레칭, 스포츠마사지는 활동 후 피로, 림프마사지는 가벼운 압과 방향성을 중심으로 안내합니다."
  $body += "<section class=`"grid-section`"><h2>서비스 안내</h2><div class=`"card-grid`">$serviceLinks</div></section>"
  $body += Section "추천 대상별 안내" "강한 압이 부담스럽다면 스웨디시나 림프마사지를 먼저 고려할 수 있습니다. 향을 곁들인 차분한 휴식이 필요하다면 아로마테라피가 어울리고, 등이나 어깨처럼 특정 부위가 단단하게 느껴진다면 딥티슈가 적합할 수 있습니다. 몸이 뻣뻣해 움직임을 늘리고 싶다면 타이마사지, 운동이나 장거리 이동 뒤라면 스포츠마사지를 상담할 수 있습니다. 단, 치료나 질환 개선을 목적으로 선택해서는 안 되며 건강 문제가 의심되면 의료 전문가 상담이 우선입니다."
  $body += Section "서비스별 소요 시간" "대부분의 관리는 60분, 90분, 120분 단위로 상담합니다. 60분은 특정 부위나 가벼운 전신 정리에 적합하고, 90분은 전신 흐름과 집중 부위를 함께 보기 좋습니다. 120분은 이동이 많았던 날이나 숙소에서 여유롭게 쉬고 싶은 고객에게 어울립니다. 실제 추천 시간은 서비스 종류와 고객 컨디션, 방문 공간, 예약 가능 시간에 따라 달라지므로 상담 단계에서 다시 확인합니다."
  $body += Section "이용 전 공통 확인사항" "예약 전에는 지역, 희망 시간, 관리받을 공간, 주차 또는 공동현관 기준, 원하는 서비스와 관리 시간을 알려 주세요. 오일을 사용하는 관리는 향 민감도와 피부 자극 여부를 확인하고, 스트레칭이 포함되는 관리는 공간과 복장을 함께 봅니다. 음주 직후, 발열, 외상, 급성 통증이 있는 경우에는 이용을 미루는 편이 안전합니다. 88마사지는 건전한 휴식 관리 범위 안에서만 예약을 안내합니다."
  $body += Section "서비스 비교 방법" "서비스를 비교할 때는 압의 강도, 오일 사용 여부, 스트레칭 포함 여부, 집중 부위, 관리 후 일정까지 함께 보는 것이 좋습니다. 스웨디시와 아로마테라피는 조용한 휴식에 가깝고, 딥티슈와 스포츠마사지는 특정 부위와 활동 후 피로를 더 세밀하게 봅니다. 타이마사지는 매트 공간과 움직임 범위가 중요하고, 림프마사지는 가벼운 압을 선호하는 고객에게 맞습니다. 이렇게 기준을 나누면 키워드만 보고 고르는 것보다 실제 만족도가 높아집니다."
  $body += Section "예약 상담에서 묻는 내용" "상담에서는 어떤 서비스를 원하는지보다 왜 그 서비스를 생각했는지를 먼저 확인합니다. 예를 들어 어깨가 무거운지, 전신이 예민한지, 향을 원하는지, 스트레칭이 부담스럽지 않은지에 따라 추천이 달라집니다. 또한 호텔, 자택, 오피스텔, 숙소처럼 공간 유형에 따라 준비물이 달라질 수 있습니다. 88마사지는 확인되지 않은 효과를 약속하지 않고, 고객이 안전하게 받을 수 있는 범위와 예약 가능 조건을 기준으로 안내합니다. 예약자가 처음 이용하는 경우에는 가장 부담이 적은 시간과 압부터 선택하도록 설명합니다."
  $body += Section "작성·검수 기준" "이 서비스 안내 페이지는 검색 키워드 나열보다 실제 예약자가 비교해야 할 차이를 설명하기 위해 작성했습니다. 각 상세 페이지는 설명, 추천 대상, 소요 시간, 이용 전 안내, FAQ를 다르게 구성합니다. 같은 문장을 서비스명만 바꿔 반복하지 않고 고객센터 운영팀이 상담에서 확인한 질문을 기준으로 검수합니다. 구조화 데이터와 메타 설명은 페이지에 실제로 표시된 정보와 일치하도록 관리합니다."
  $body += FaqBlock @(
    @{q="처음 이용하면 어떤 서비스를 고르면 좋나요?"; a="강한 압이 부담스럽다면 스웨디시나 아로마테라피처럼 편안한 흐름의 관리부터 상담하는 편이 좋습니다."},
    @{q="서비스를 현장에서 바꿀 수 있나요?"; a="가능한 범위가 있지만 관리사 준비물과 시간 배정이 달라질 수 있어 예약 전 선택을 권합니다."},
    @{q="모든 서비스가 치료 목적인가요?"; a="아닙니다. 88마사지는 휴식과 컨디션 관리를 안내하며 치료, 진단, 효과 보장을 하지 않습니다."}
  )
  return Layout "전국 출장마사지 서비스 안내 | 스웨디시·아로마·딥티슈·타이마사지" "스웨디시, 아로마테라피, 딥티슈, 타이마사지, 스포츠마사지, 림프마사지 등 전국 출장마사지 서비스 종류와 특징을 확인해 보세요." "/services/" $body "Service" "대한민국"
}

function Build-Service($svc) {
  $other = ($services | Where-Object { $_.slug -ne $svc.slug } | Select-Object -First 4 | ForEach-Object { "<a class=`"pill`" href=`"/services/$($_.slug)/`">$($_.name)</a>" }) -join ""
  $body = Hero "서비스 상세 안내" "$($svc.name) 출장마사지 서비스 안내" "$($svc.name) 서비스는 $($svc.tone)입니다. $($svc.user)에게 적합하며, 예약 전 컨디션과 방문 환경을 확인한 뒤 무리 없는 범위에서 진행합니다."
  $body += Section "$($svc.name) 마사지란?" "$($svc.name) 서비스는 $($svc.feature)을 중심으로 하는 출장마사지 서비스입니다. 관리는 치료나 의학적 처치가 아니라 긴 하루 뒤 몸과 마음을 차분하게 정리하는 휴식 관리입니다. 상담 단계에서 최근 피로가 쌓인 부위, 피하고 싶은 압, 오일이나 스트레칭 가능 여부, 관리받을 공간의 밝기와 온도를 확인합니다. 특히 출장 관리는 낯선 공간에서 진행되기 때문에 시작 전 흐름을 다시 안내하고 불편한 느낌이 있으면 즉시 조절합니다."
  $body += Section "$($svc.name) 관리가 필요한 경우" "$($svc.need)에 $($svc.name) 서비스를 고려할 수 있습니다. $($svc.user)이라면 처음 상담에서 원하는 압과 관리 목적을 분명히 말하면 안내가 빨라집니다. 다만 열감, 급성 통증, 외상, 의학적 판단이 필요한 상태라면 마사지를 먼저 선택하지 말고 전문 의료기관의 조언을 받는 것이 우선입니다. 이 페이지의 안내는 예약 결정을 돕기 위한 정보이며 건강 문제의 해결책으로 제시하지 않습니다."
  $body += Section "$($svc.name) 마사지의 특징" "$($svc.name) 서비스의 특징은 $($svc.traits)입니다. 같은 출장마사지라도 서비스마다 준비물과 진행 템포가 다릅니다. 오일이 필요한 관리는 향 민감도와 타월 정리를 확인하고, 스트레칭이 들어가는 관리는 매트 공간과 복장을 함께 봅니다. 88마사지는 코스명을 과장하기보다 실제 현장에서 무엇이 달라지는지 설명합니다. 강도는 고객이 편안함을 느끼는 범위 안에서 조절하며 무리한 압이나 자세는 권하지 않습니다."
  $body += Section "관리 진행 방식" "예약은 문의 접수, 지역 확인, 관리 시간 선택, 방문 조건 확인, 관리사 배정 순서로 진행됩니다. 관리사가 도착하면 공간과 위생 기준을 확인하고 시작 전 관리 시간, 집중 부위, 피해야 할 부위를 짧게 점검합니다. $($svc.name) 서비스는 상담 내용과 현장 상황이 다르면 고객에게 다시 확인한 뒤 진행합니다. 관리 중 대화가 불편하면 조용한 진행을 요청할 수 있고, 압이나 자세를 바꾸고 싶을 때는 언제든 말할 수 있습니다."
  $body += Section "추천 관리 시간" "60분은 $($svc.time60)에게 적합합니다. 90분은 $($svc.time90)에게 좋고, 120분은 $($svc.time120)에게 어울립니다. 실제 추천 시간은 지역, 방문 공간, 고객 컨디션, 예약 가능 시간에 따라 달라질 수 있습니다. 처음 이용하는 고객은 너무 긴 시간보다 60분이나 90분으로 시작해 본인에게 맞는 압과 흐름을 확인하는 편이 안전합니다. 연장은 당일 배정 상황에 따라 가능 여부가 달라집니다."
  $body += Section "$($svc.name)와 다른 마사지의 차이" "$($svc.compare) 예약 전에는 서비스명을 키워드처럼 고르기보다 원하는 느낌을 구체적으로 말하는 것이 좋습니다. 예를 들어 부드러운 휴식, 향을 곁들인 안정감, 특정 부위 집중, 스트레칭 중심, 활동 후 정리, 가벼운 방향성처럼 목적을 나누면 안내가 정확해집니다. 이런 차이를 이해하면 현장에서 코스를 바꾸는 일을 줄일 수 있습니다."
  $body += Section "이용 전 준비사항" "방문 공간은 관리 매트나 타월을 펼칠 수 있을 정도면 충분합니다. 호텔이나 오피스텔은 방문자 등록이 필요한지, 자택은 반려동물 분리와 주차 가능 여부를 미리 알려 주세요. 식사 직후나 음주 후 이용은 권하지 않으며, 컨디션이 좋지 않다면 일정을 미루는 편이 안전합니다. 원하는 압 강도와 불편한 부위, 피해야 할 자세가 있다면 예약 단계에서 전달해 주세요."
  $body += Section "예약 전 확인사항" "예약 전에는 출장 가능 지역, 예약 가능 시간, 관리 코스와 소요 시간, 추가 출장비 여부, 결제 방식을 확인합니다. 주소는 동 단위보다 건물 유형과 출입 방식까지 알려 주는 편이 좋습니다. 심야, 원거리, 교량·산간 이동은 가능 여부와 비용 기준이 달라질 수 있습니다. 88마사지는 현장에서 갑자기 조건을 바꾸지 않도록 상담 단계에서 가능한 범위와 어려운 범위를 나누어 설명합니다."
  $body += Section "작성·검수 기준" "이 페이지는 고객센터 운영팀이 실제 상담에서 자주 받는 질문을 기준으로 작성했습니다. 검색을 위한 반복 문구보다 예약 전 판단에 필요한 정보를 우선했고, 의료적 표현이나 효과 보장 문구는 사용하지 않았습니다. 정보가 바뀌는 경우 관리 범위, 준비 사항, FAQ를 먼저 수정합니다. 책임 저자와 연락처는 하단에 표시되어 있으며 잘못된 안내를 발견하면 문의를 통해 정정 요청을 할 수 있습니다."
  $body += "<section class=`"content-section related`"><h2>함께 비교할 서비스</h2><div>$other</div></section>"
  $body += FaqBlock @(
    @{q="$($svc.name) 서비스는 어떤 분에게 적합한가요?"; a="$($svc.user)에게 적합합니다. 예약 전 원하는 압과 목적을 알려 주시면 더 정확히 안내합니다."},
    @{q="$($svc.name) 서비스는 압이 강한 관리인가요?"; a="$($svc.traits)를 기준으로 고객 반응에 맞춰 조절합니다. 불편하면 즉시 낮출 수 있습니다."},
    @{q="출장 가능한 지역은 어디인가요?"; a="전국 주요 지역을 기준으로 상담하지만 시간대와 배정 상황에 따라 가능 여부가 달라집니다."},
    @{q="관리 시간은 어떻게 선택하면 좋나요?"; a="가볍게 정리하려면 60분, 전신 흐름까지 보려면 90분, 여유로운 휴식은 120분을 상담할 수 있습니다."}
  )
  return Layout "$($svc.name) 출장마사지 서비스 안내 | $brand" "$($svc.name) 출장마사지의 특징, 추천 대상, 관리 방식, 이용 전 준비사항을 안내합니다. 고객 컨디션에 맞춘 건전한 휴식 관리를 확인해 보세요." "/services/$($svc.slug)/" $body "Service" "대한민국"
}

function Build-Region($r) {
  $serviceLinks = ($services | Select-Object -First 5 | ForEach-Object { "<a class=`"pill`" href=`"/services/$($_.slug)/`">$($_.name)</a>" }) -join ""
  $body = Hero "지역별 출장 가능 안내" "$($r.name) 출장마사지 예약 안내" "$($r.focus)입니다. $($r.movement)"
  $body += Section "$($r.name) 이용 흐름" "$($r.name) 지역은 $($r.focus) 예약 전에는 세부 주소, 공간 유형, 시작 희망 시간, 출입 방식이 가장 중요합니다. 같은 지역명 안에서도 업무지구, 주거 단지, 관광 숙소, 산업단지의 이동 조건이 달라 도착 시간과 배정 가능 인력이 달라질 수 있습니다. 88마사지는 단순히 가능하다는 말보다 어떤 조건에서 안정적으로 방문할 수 있는지 먼저 확인합니다. 고객이 읽고 바로 판단할 수 있도록 지역별 이동 변수와 준비 사항을 구분해 안내합니다."
  $body += Section "생활권별 특징" "$($r.movement) 호텔과 숙소는 프런트 기준이 다르고, 아파트와 오피스텔은 공동현관이나 주차 등록 방식이 다릅니다. 이런 정보가 빠지면 예약 시간이 확정되어도 현장에서 대기 시간이 생길 수 있습니다. $($r.name)에서는 이용 장소의 이름보다 실제 진입 동선이 더 중요할 때가 많습니다. 건물명, 동·호수 전달 방식, 관리사가 연락할 수 있는 번호를 정확히 남겨 주세요."
  $body += Section "출장비와 시간 기준" "$($r.cost) 기본 요금은 관리 시간과 코스에 따라 안내되지만 이동 조건이 복잡한 곳은 추가 비용 또는 예약 가능 시간대가 달라질 수 있습니다. 88마사지는 현장에서 갑자기 조건을 바꾸지 않도록 상담 중 예상 비용과 변경 가능성을 먼저 말합니다. 심야, 원거리, 악천후, 행사장 주변 혼잡은 도착 시간에 영향을 줄 수 있습니다."
  $body += Section "추천 관리 선택" "$($r.name) 고객은 일정 성격에 따라 다른 관리를 선택합니다. 업무 후에는 오피스케어나 스웨디시, 여행 숙소에서는 아로마테라피, 운동이나 장거리 운전 뒤에는 스포츠마사지 문의가 많습니다. 다만 서비스명보다 중요한 것은 현재 컨디션과 원하는 강도입니다. 강한 자극이 항상 좋은 선택은 아니므로 불편한 부위와 피해야 할 움직임을 미리 알려 주시면 적합한 범위로 조절합니다."
  $body += Section "이용 전 확인" "방문 공간은 깨끗하게 정리하고 귀중품은 별도로 보관하는 것이 좋습니다. 음주 직후, 발열, 급성 통증, 외상, 피부 이상이 있는 경우에는 이용을 미루는 편이 안전합니다. 88마사지는 치료나 진단을 제공하지 않으며 건강 문제가 의심되면 의료 전문가와 상담해야 합니다. 예약 취소나 시간 변경은 가능한 빨리 알려 주면 관리사 배정 손실을 줄일 수 있습니다."
  $body += Section "작성·검수 기준" "이 페이지는 $($r.name) 지역의 생활권, 이동 방식, 고객 문의 유형을 반영해 작성했습니다. 다른 지역 페이지와 같은 문단을 반복하지 않도록 지역의 실제 예약 변수와 FAQ를 다르게 구성했습니다. 검색 노출만을 위한 키워드 반복을 피하고, 고객이 예약 전 확인해야 할 정보를 먼저 배치했습니다. 내용은 고객센터 운영팀이 검수하며 변경 사항은 sitemap과 RSS에 반영합니다."
  $body += Section "$($r.name) 예약 예시" "$($r.name)에서 상담할 때는 단순히 시·도명만 남기는 것보다 실제 머무는 권역과 건물 유형을 알려 주는 편이 좋습니다. 예를 들어 업무지구의 고층 건물, 주거 단지의 지하 주차장, 관광 숙소의 프런트 통과 여부는 모두 배정 시간에 영향을 줍니다. $($r.cost) 또한 예약자가 미리 알고 있어야 하는 부분입니다. 희망 시간이 촉박한 경우에는 가능한 관리 시간과 코스를 줄여 안내할 수 있고, 여유가 있다면 이동이 안정적인 시간대로 조정할 수 있습니다. 이런 확인 과정은 번거롭게 보일 수 있지만 현장 대기와 취소를 줄이는 가장 현실적인 방법입니다."
  $body += Section "$($r.name) 현장 확인 기준" "방문 당일에는 관리사가 도착하기 전 연락 가능한 상태를 유지해 주세요. 지하 주차장 진입이 어렵거나 숙소 출입 정책이 바뀐 경우에는 즉시 알려 주는 것이 좋습니다. $($r.name) 지역은 생활권별로 이동 흐름이 달라 한 번의 지연이 다음 예약에도 영향을 줄 수 있습니다. 88마사지는 고객에게 무리한 준비를 요구하지 않지만, 정확한 위치와 출입 정보는 서비스 품질을 좌우하는 기본 정보로 봅니다."
  $body += Section "$($r.name) 예약자 체크리스트" "문의 전에는 희망 시작 시간, 상세 주소, 건물 유형, 주차 가능 여부, 원하는 관리 시간을 한 번에 정리해 두면 좋습니다. $($r.name)에서는 $($r.focus) 이 특성이 있어 상담 중 작은 정보 차이가 배정 결과를 바꿀 수 있습니다. 88마사지는 확인된 정보만 기준으로 안내합니다."
  $body += "<section class=`"content-section related`"><h2>$($r.name)에서 선택 가능한 관리</h2><div>$serviceLinks</div></section>"
  $body += FaqBlock @(
    @{q="$($r.name) 전 지역 방문이 가능한가요?"; a="가능 지역은 시간대와 배정 상황에 따라 달라집니다. 세부 주소를 알려 주시면 당일 기준으로 확인합니다."},
    @{q="출장비는 언제 확정되나요?"; a="주소, 시간대, 관리 시간, 이동 거리 확인 후 상담 단계에서 안내합니다."},
    @{q="호텔에서도 예약할 수 있나요?"; a="숙소 정책상 외부 방문이 가능한지 확인되면 상담 후 진행할 수 있습니다."}
  )
  return Layout "$($r.name) 출장마사지 | $brand 지역 안내" "$($r.name) 출장마사지 예약 전 생활권, 이동 조건, 출장비, 준비 사항을 안내합니다." "/areas/$($r.slug)/" $body "Service" $r.name
}

function Build-District($d) {
  $body = Hero "서울 구별 상세 안내" "$($d.name) 출장마사지 서비스 안내" "$($d.zones) 생활권을 중심으로 예약 전 확인해야 할 방문 조건과 관리 선택 기준을 정리했습니다."
  $body += Section "$($d.name) 이용 안내" "$($d.name)은 $($d.zones) 권역의 문의가 많은 지역입니다. $($d.scene) 같은 서울 안에서도 구마다 이동 흐름과 건물 유형이 달라 단순히 지역명만으로는 정확한 안내가 어렵습니다. 예약 전에는 상세 주소, 공간 유형, 희망 시작 시간, 주차 또는 공동현관 기준을 알려 주세요. 88마사지는 고객이 현장에서 당황하지 않도록 방문 가능 조건을 먼저 확인하고, 무리한 배정은 진행하지 않습니다."
  $body += Section "주요 권역별 특징" "$($d.zones) 일대는 업무지, 주거지, 상권의 비중이 서로 다릅니다. 업무지에서는 퇴근 직후 짧은 관리 문의가 많고, 주거지에서는 조용한 방문과 가족 동선 배려가 중요합니다. 호텔이나 숙소는 외부 방문 정책이 다를 수 있어 예약명과 프런트 안내 기준을 미리 확인해야 합니다. 오피스텔은 엘리베이터 호출, 주차 등록, 공동현관 호출 방식이 달라 관리사 도착 시간이 변할 수 있습니다."
  $body += Section "예약 전 확인 사항" "$($d.name) 예약에서는 시작 시간보다 도착 가능 조건이 더 중요할 때가 있습니다. 건물 앞 정차가 어려운 곳, 심야 출입이 제한되는 곳, 주차가 유료인 곳은 상담에서 미리 공유해 주세요. 관리 시간은 60분, 90분, 120분 단위로 안내하며 컨디션에 따라 압과 집중 부위를 조절합니다. 음주 직후, 발열, 급성 통증, 외상처럼 안전한 진행이 어려운 상태에서는 예약을 권하지 않습니다."
  $body += Section "이용 가능한 관리" "스웨디시는 부드러운 휴식, 아로마테라피는 향과 안정감, 림프마사지는 가벼운 흐름, 스포츠마사지는 활동 후 뻐근함, 오피스케어는 목과 어깨 중심 관리에 어울립니다. $($d.name) 고객은 하루 일정과 공간 조건이 다르기 때문에 코스명만 보고 선택하기보다 원하는 느낌과 피하고 싶은 자극을 함께 말하는 것이 좋습니다. 88마사지는 치료나 효과 보장 표현을 쓰지 않고, 편안한 휴식 관리 범위에서 안내합니다."
  $body += Section "준비와 방문 매너" "관리를 받을 공간은 타월과 매트를 놓을 수 있게 정리해 주세요. 반려동물이 있거나 가족이 함께 있는 경우 관리 중 방해가 없도록 동선을 분리하면 좋습니다. 귀중품은 미리 보관하고, 향에 민감하거나 특정 오일을 피해야 한다면 예약 단계에서 알려 주세요. 관리사는 위생과 시간을 지키는 것을 기본으로 하며 고객 역시 무리한 요구를 하지 않는 선에서 안전한 이용 환경을 함께 만들어야 합니다."
  $body += Section "작성·검수 기준" "이 페이지는 $($d.name)의 권역명, 건물 유형, 예약 상황을 반영해 작성했습니다. 서울의 다른 구와 같은 문단을 반복하지 않도록 $($d.zones) 생활권의 특징을 본문에 포함했습니다. 정보는 고객센터 운영팀이 검수하며, 실제 상담에서 반복되는 질문이 바뀌면 FAQ와 안내 문단을 수정합니다. 검색을 위한 키워드 나열보다 이용자가 예약 전 확인할 수 있는 실질 정보를 우선합니다."
  $body += Section "$($d.name) 상담 메모" "$($d.name)에서 빠르게 예약을 확인하려면 '$($d.zones) 중 어느 권역인지, 방문 장소가 자택인지 숙소인지, 주차나 공동현관 호출이 가능한지'를 함께 알려 주세요. $($d.scene) 이런 특징 때문에 같은 구 안에서도 20분 이상 도착 시간이 달라질 수 있습니다. 업무지에서는 관리 시작 전 짧은 정리 시간이 필요하고, 주거지에서는 가족이나 이웃에게 방해되지 않는 조용한 방문이 중요합니다. 88마사지는 예약을 성사시키는 것보다 실제로 편안히 받을 수 있는 조건인지 확인하는 일을 먼저 둡니다."
  $body += Section "$($d.name) 현장 확인 기준" "$($d.name) 예약 당일에는 건물 앞 정차 가능 여부와 호출 방식을 다시 확인합니다. $($d.zones) 일대는 상권, 주거지, 역세권이 가까워 기사 이동 경로와 관리사 도보 이동 시간이 다르게 잡힐 수 있습니다. 고객이 원하는 시작 시간이 분명하다면 주소 공유를 늦추지 않는 것이 좋습니다. 방문 후에는 관리 범위와 시간을 다시 확인하고, 불편한 압이나 자세가 있으면 즉시 조절합니다. 이 기준은 모든 고객에게 같은 설명을 반복하기 위한 것이 아니라 $($d.name)에서 자주 생기는 현장 변수를 줄이기 위한 안내입니다."
  $body += Section "$($d.name) 예약자 체크리스트" "문의 전에는 $($d.zones) 중 가까운 권역, 희망 시간, 공간 유형, 관리 시간을 정리해 주세요. $($d.name)은 서울 안에서도 이동 변수가 뚜렷해 세부 정보가 빠르면 더 정확한 답변을 받을 수 있습니다. 확인된 조건만으로 예약을 안내합니다."
  $body += FaqBlock @(
    @{q="$($d.name) $($d.zones.Split(',')[0]) 근처도 가능한가요?"; a="당일 배정 상황과 시간대에 따라 가능합니다. 상세 주소를 알려 주시면 이동 가능 시간을 확인합니다."},
    @{q="오피스텔 방문 시 무엇을 알려야 하나요?"; a="공동현관 호출 방식, 엘리베이터 이용 기준, 주차 가능 여부를 알려 주시면 좋습니다."},
    @{q="조용히 진행할 수 있나요?"; a="가능합니다. 대화를 최소화하고 압 조절 요청만 간단히 주고받는 방식으로 진행할 수 있습니다."}
  )
  return Layout "$($d.name) 출장마사지 | $brand 서울 지역 안내" "$($d.name) 출장마사지 예약 전 $($d.zones) 권역의 방문 조건, 관리 선택, FAQ를 안내합니다." "/areas/seoul/$($d.slug)/" $body "Service" "서울 $($d.name)"
}

function Build-AdminArea($a) {
  $body = Hero "$($a.parent) 상세 지역 안내" "$($a.name) 출장마사지 예약 안내" "$($a.zones) 생활권의 이동 조건과 공간 유형을 기준으로 예약 전 확인 사항을 정리했습니다."
  $body += Section "$($a.name) 이용 상황" "$($a.name)은 $($a.zones) 권역의 문의가 많은 지역입니다. $($a.scene) 같은 시 안에서도 업무지, 주거 단지, 숙박시설, 산업단지의 거리와 출입 조건이 다르기 때문에 세부 주소 확인이 중요합니다. 88마사지는 예약 가능 여부를 넓게 말하기보다 실제 방문 가능한 시간과 관리 종류를 먼저 안내합니다. 고객이 불필요하게 기다리지 않도록 이동 변수와 배정 가능 인력을 함께 확인합니다."
  $body += Section "생활권별 체크 포인트" "$($a.zones) 주변은 시간대에 따라 도로 흐름이 크게 바뀔 수 있습니다. 출퇴근 시간, 행사 종료 시간, 단지 내 주차 기준, 숙소 프런트 정책이 모두 도착 시간에 영향을 줍니다. 상담 시 건물명과 동, 출입구 위치, 주차장 진입 가능 여부를 알려 주면 배정이 더 정확해집니다. 특히 외곽이나 산업단지 인근은 같은 주소라도 야간 진입 동선이 달라질 수 있습니다."
  $body += Section "관리 선택 기준" "업무 후 짧게 쉬고 싶다면 오피스케어나 스웨디시, 여행이나 장거리 이동 뒤에는 아로마테라피와 림프마사지를 고려할 수 있습니다. 활동량이 많은 날에는 스포츠마사지가 어울릴 수 있지만 강한 압을 무조건 권하지 않습니다. 현재 컨디션, 피하고 싶은 부위, 원하는 압을 알려 주면 관리 범위를 조절합니다. 88마사지는 의료 행위가 아니므로 통증 치료나 질환 개선을 약속하지 않습니다."
  $body += Section "요금과 변경 기준" "요금은 관리 시간과 서비스 종류, 이동 거리, 시간대에 따라 상담 단계에서 안내합니다. $($a.name)처럼 생활권이 넓은 지역은 같은 시 안에서도 출장비가 달라질 수 있습니다. 심야 예약, 원거리 이동, 악천후, 주차 불가 상황은 배정 가능 여부에 영향을 줍니다. 예약 변경이 필요하면 가능한 빨리 알려 주세요. 관리사 이동 후 취소는 별도 기준이 적용될 수 있습니다."
  $body += Section "안전한 이용 안내" "방문 전 공간을 정리하고 귀중품을 보관해 주세요. 음주 직후, 발열, 외상, 급성 통증, 피부 이상이 있다면 이용을 미루는 것이 좋습니다. 관리 중 불편한 느낌이 있으면 즉시 말해야 하며, 관리사는 고객의 요청에 따라 압과 자세를 조절합니다. 무리한 요구나 예약 범위를 벗어난 요청은 진행하지 않습니다. 건전한 휴식 관리가 유지될 때 서비스 품질도 안정됩니다."
  $body += Section "작성·검수 기준" "이 페이지는 $($a.name) 지역의 권역명과 이동 조건을 바탕으로 작성했습니다. 지역명만 바꾸는 복사 문단을 피하기 위해 $($a.zones) 생활권과 실제 예약 변수를 본문에 반영했습니다. 고객센터 운영팀이 작성과 검수를 맡으며, 문의 패턴이 달라지면 내용을 갱신합니다. 구조화 데이터는 실제 페이지 내용과 일치하는 서비스 안내 범위로만 사용합니다."
  $body += Section "$($a.name) 상담 메모" "$($a.name) 예약에서는 '$($a.zones) 중 어느 생활권인지'가 첫 확인 항목입니다. $($a.scene) 따라서 주소가 확정되지 않은 상태에서는 가능 여부가 넓게 보일 수 있지만, 실제 배정은 도로 흐름과 출입 조건을 확인해야 정확합니다. 회사 숙소, 아파트, 호텔, 단기 임대 공간은 방문 절차가 서로 다릅니다. 관리사가 도착한 뒤 출입이 막히면 고객과 관리사 모두 시간이 손실되므로 예약 전 안내가 중요합니다. 88마사지는 이런 변수를 숨기지 않고 상담 단계에서 가능한 범위와 추가 확인이 필요한 범위를 나눠 설명합니다."
  $body += Section "$($a.name) 현장 확인 기준" "$($a.name)에서는 예약 직전 위치 확인이 특히 중요합니다. $($a.zones) 권역은 생활권이 넓거나 도로 흐름이 달라 같은 시 안에서도 이동 시간이 크게 차이 날 수 있습니다. 고객이 숙소명을 알고 있어도 실제 입구가 다른 경우가 있고, 아파트 단지는 방문자 등록 위치가 별도로 운영되기도 합니다. 상담 단계에서 이런 내용을 확인하면 현장 대기를 줄이고 관리 시간을 온전히 사용할 수 있습니다. 88마사지는 방문이 어렵다고 판단되는 상황을 숨기지 않고, 가능한 시간으로 조정하거나 예약을 보류하는 방식으로 안내합니다."
  $body += Section "$($a.name) 예약자 체크리스트" "문의 전에는 $($a.zones) 중 실제 위치, 방문 공간의 종류, 엘리베이터와 주차 조건, 원하는 관리 시간을 알려 주세요. $($a.name)은 $($a.scene) 이 특성이 있어 상담 단계의 정보가 도착 시간과 출장비 안내에 직접 영향을 줍니다. 주소가 아직 확정되지 않았다면 가까운 기준 지점을 먼저 공유하고, 확정 후 다시 확인하는 방식이 좋습니다."
  $body += FaqBlock @(
    @{q="$($a.name) 외곽도 방문 가능한가요?"; a="세부 주소와 시간대에 따라 다릅니다. 상담 시 이동 가능 여부와 예상 도착 시간을 확인합니다."},
    @{q="당일 예약도 가능한가요?"; a="가능한 경우가 있지만 배정 상황에 따라 달라집니다. 희망 시간보다 여유 있게 문의하는 편이 좋습니다."},
    @{q="출장비는 왜 지역 안에서도 다른가요?"; a="거리, 주차, 도로 상황, 심야 여부가 달라 실제 이동 시간이 달라지기 때문입니다."}
  )
  return Layout "$($a.name) 출장마사지 | $brand $($a.parent) 지역 안내" "$($a.name) 출장마사지 예약 전 $($a.zones) 권역의 이동 조건, 요금 기준, 준비 사항을 안내합니다." "/areas/$($a.slug)/" $body "Service" "$($a.parent) $($a.name)"
}

$pages = @()
$pages += @{path="index.html"; url="/"; html=(Build-Main); title="$brand 메인"; desc="전국 출장마사지 예약 안내"}
$pages += @{path="services/index.html"; url="/services/"; html=(Build-ServicesIndex); title="전국 출장마사지 서비스 안내"; desc="스웨디시, 아로마테라피, 딥티슈, 타이마사지, 스포츠마사지, 림프마사지 서비스 안내"}
foreach ($svc in $services) {
  $path = "services/$($svc.slug)/index.html"
  $pages += @{path=$path; url="/services/$($svc.slug)/"; html=(Build-Service $svc); title="$($svc.name) 출장마사지"; desc="$($svc.name) 서비스 안내"}
}
foreach ($r in $regions) {
  $path = "areas/$($r.slug)/index.html"
  $pages += @{path=$path; url="/areas/$($r.slug)/"; html=(Build-Region $r); title="$($r.name) 출장마사지"; desc="$($r.name) 지역 안내"}
}
foreach ($d in $districts) {
  $path = "areas/seoul/$($d.slug)/index.html"
  $pages += @{path=$path; url="/areas/seoul/$($d.slug)/"; html=(Build-District $d); title="$($d.name) 출장마사지"; desc="$($d.name) 지역 안내"}
}
foreach ($a in $adminAreas) {
  $path = "areas/$($a.slug)/index.html"
  $pages += @{path=$path; url="/areas/$($a.slug)/"; html=(Build-AdminArea $a); title="$($a.name) 출장마사지"; desc="$($a.name) 지역 안내"}
}

foreach ($page in $pages) {
  Write-Utf8 $page.path $page.html
}

$sitemapItems = ($pages | ForEach-Object {
  "  <url><loc>$(XmlEscape "$siteUrl$($_.url)")</loc><lastmod>$today</lastmod><changefreq>weekly</changefreq><priority>0.8</priority></url>"
}) -join "`n"
$sitemap = "<?xml version=`"1.0`" encoding=`"UTF-8`"?>`n<urlset xmlns=`"http://www.sitemaps.org/schemas/sitemap/0.9`">`n$sitemapItems`n</urlset>`n"
Write-Utf8 "sitemap.xml" $sitemap
Write-Utf8 "sitemap1.xml" $sitemap

$rssItems = ($pages | Select-Object -First 30 | ForEach-Object {
  "    <item><title>$(XmlEscape $_.title)</title><link>$(XmlEscape "$siteUrl$($_.url)")</link><guid>$(XmlEscape "$siteUrl$($_.url)")</guid><description>$(XmlEscape $_.desc)</description><pubDate>$([DateTime]::Now.ToUniversalTime().ToString("r"))</pubDate></item>"
}) -join "`n"
$rss = "<?xml version=`"1.0`" encoding=`"UTF-8`"?>`n<rss version=`"2.0`"><channel><title>$(XmlEscape $brand)</title><link>$siteUrl</link><description>출장마사지 서비스와 지역 안내 업데이트</description>`n$rssItems`n</channel></rss>`n"
Write-Utf8 "rss.xml" $rss

$robots = @"
User-agent: *
Allow: /

User-agent: Googlebot
Allow: /

User-agent: Yeti
Allow: /

User-agent: NaverBot
Allow: /

User-agent: Daumoa
Allow: /

Sitemap: $siteUrl/sitemap.xml
Sitemap: $siteUrl/sitemap1.xml
Sitemap: $siteUrl/rss.xml
"@
Write-Utf8 "robots.txt" $robots

$css = @"
:root{--ink:#191714;--muted:#6e665b;--line:#e8dfd2;--paper:#fffaf1;--cream:#f8efe1;--gold:#b1843f;--green:#24483d;--red:#9d3e32}
*{box-sizing:border-box}body{margin:0;font-family:Arial,'Noto Sans KR',sans-serif;color:var(--ink);background:var(--paper);line-height:1.75}a{color:inherit;text-decoration:none}.site-header{position:sticky;top:0;z-index:10;display:flex;align-items:center;justify-content:space-between;gap:24px;padding:16px 5vw;background:rgba(255,250,241,.94);border-bottom:1px solid var(--line);backdrop-filter:blur(10px)}.logo{font-weight:800;font-size:22px}.logo span{display:inline-grid;place-items:center;width:40px;height:40px;margin-right:8px;border-radius:8px;background:var(--green);color:#fff}.main-nav{display:flex;gap:18px;font-size:14px;align-items:center}.nav-group{position:relative}.submenu{position:absolute;top:100%;left:0;display:none;min-width:180px;padding:10px;background:#fff;border:1px solid var(--line);border-radius:8px;box-shadow:0 14px 34px rgba(0,0,0,.12)}.submenu a{display:block;padding:8px 10px;color:var(--ink)}.nav-group:hover .submenu,.nav-group:focus-within .submenu{display:block}.menu-button{display:none}.hero{min-height:560px;display:flex;align-items:center;background:linear-gradient(90deg,rgba(15,31,26,.92) 0%,rgba(15,31,26,.82) 38%,rgba(15,31,26,.42) 68%,rgba(15,31,26,.22) 100%),linear-gradient(0deg,rgba(15,31,26,.28),rgba(15,31,26,.28)),url('/assets/hero-wellness.png');background-size:cover;background-position:center right;padding:72px 5vw;color:#fff}.hero-inner{max-width:780px;text-shadow:0 2px 18px rgba(0,0,0,.28)}.eyebrow{color:#f4c36b;font-weight:700;letter-spacing:0}.hero h1{font-size:56px;line-height:1.1;margin:12px 0 20px}.lead{font-size:20px;max-width:760px}.hero-actions{display:flex;gap:12px;margin-top:28px}.primary,.secondary,.sticky-cta a{display:inline-flex;align-items:center;justify-content:center;min-height:46px;padding:0 18px;border-radius:8px;font-weight:700}.primary{background:#f1bd5a;color:#22180d;text-shadow:none}.secondary{border:1px solid rgba(255,255,255,.58);color:#fff;background:rgba(15,31,26,.2);text-shadow:none}.content-section,.grid-section{max-width:1080px;margin:0 auto;padding:54px 5vw;border-bottom:1px solid var(--line)}h2{font-size:30px;line-height:1.25;margin:0 0 18px}.content-section p{margin:0;font-size:17px}.card-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px}.link-card{display:block;min-height:150px;padding:22px;border:1px solid var(--line);border-radius:8px;background:#fff}.link-card strong{display:block;font-size:20px;margin-bottom:10px}.link-card span{color:var(--muted)}.pill{display:inline-flex;margin:0 8px 8px 0;padding:10px 14px;border:1px solid var(--line);border-radius:999px;background:#fff}.faq details{border:1px solid var(--line);border-radius:8px;background:#fff;margin:12px 0;padding:14px 18px}.faq summary{cursor:pointer;font-weight:700}.site-footer{padding:42px 5vw 86px;background:#1d211e;color:#f8efe1}.site-footer p{max-width:980px;color:#d9cdbd}.sticky-cta{position:fixed;left:0;right:0;bottom:0;display:flex;gap:8px;justify-content:center;padding:10px;background:rgba(255,250,241,.94);border-top:1px solid var(--line)}.sticky-cta a:first-child{background:var(--red);color:#fff}.sticky-cta a:last-child{background:var(--green);color:#fff}@media(max-width:760px){.menu-button{display:block;border:1px solid var(--line);background:#fff;border-radius:8px;width:42px;height:42px}.main-nav{display:none;position:absolute;left:0;right:0;top:73px;flex-direction:column;align-items:flex-start;padding:18px 5vw;background:#fff;border-bottom:1px solid var(--line)}.main-nav.open{display:flex}.nav-group{width:100%}.submenu{position:static;display:block;box-shadow:none;border:0;padding:6px 0 0 12px;background:transparent}.hero{min-height:500px;padding:56px 5vw;background-position:center}.hero h1{font-size:38px}.lead{font-size:17px}.hero-actions{flex-direction:column}.card-grid{grid-template-columns:1fr}.content-section,.grid-section{padding:38px 5vw}h2{font-size:25px}}
"@
Write-Utf8 "styles.css" $css

$js = @"
const button=document.querySelector('.menu-button');
const nav=document.querySelector('.main-nav');
if(button&&nav){button.addEventListener('click',()=>nav.classList.toggle('open'));}
document.querySelectorAll('.main-nav a').forEach(a=>a.addEventListener('click',()=>nav&&nav.classList.remove('open')));
"@
Write-Utf8 "script.js" $js

Ensure-Dir "assets"
$favicon = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="12" fill="#24483d"/><text x="32" y="41" text-anchor="middle" font-size="28" font-family="Arial" font-weight="700" fill="#f1bd5a">88</text></svg>'
Write-Utf8 "assets/favicon.svg" $favicon
$og = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630"><defs><linearGradient id="g" x1="0" x2="1"><stop stop-color="#24483d"/><stop offset="1" stop-color="#9d3e32"/></linearGradient></defs><rect width="1200" height="630" fill="url(#g)"/><circle cx="960" cy="130" r="110" fill="#f1bd5a" opacity=".28"/><text x="90" y="240" font-size="86" font-family="Arial" font-weight="800" fill="#fff">88마사지</text><text x="94" y="330" font-size="36" font-family="Arial" fill="#f8efe1">전국 출장마사지 예약 안내</text><text x="94" y="398" font-size="28" font-family="Arial" fill="#f1bd5a">휴식 관리 · 지역 확인 · 투명한 상담</text></svg>'
Write-Utf8 "assets/og-image.svg" $og

$reportRows = foreach ($page in $pages) {
  $text = [regex]::Replace($page.html, "<script[\s\S]*?</script>", "")
  $text = [regex]::Replace($text, "<style[\s\S]*?</style>", "")
  $text = [regex]::Replace($text, "<[^>]+>", "")
  $text = [System.Net.WebUtility]::HtmlDecode($text)
  $chars = ($text -replace "\s+", "").Length
  [pscustomobject]@{Path=$page.path; Chars=$chars}
}
$report = ($reportRows | ForEach-Object { "$($_.Path),$($_.Chars)" }) -join "`n"
Write-Utf8 "content-length-report.csv" "path,chars`n$report`n"
Write-Host "Generated $($pages.Count) pages."
$bad = $reportRows | Where-Object { $_.Chars -lt 2000 -or $_.Chars -gt 2500 }
if ($bad) {
  Write-Host "Pages outside 2000-2500 chars:"
  $bad | Format-Table | Out-String | Write-Host
} else {
  Write-Host "All pages are within 2000-2500 visible text chars."
}
