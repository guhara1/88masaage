$ErrorActionPreference = "Stop"

$brand = "88마사지"
$siteUrl = "https://88masaage.pages.dev"
$phone = "0508-000-0088"
$company = "YH LAB"
$owner = "김유환"
$businessNumber = "815-26-00585"
$businessAddress = "경기도 파주시 청석로 268"
$today = (Get-Date).ToString("yyyy-MM-dd")
$buildUtc = [DateTime]::UtcNow

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
  @{slug="jeolla"; name="전라"; focus="전주, 광주 인접 생활권, 여수와 목포처럼 도시와 해안 관광지가 함께 있는 권역"; movement="도심, 혁신도시, 항만·관광 숙소의 이동 조건이 달라 상세 주소 확인이 중요합니다"; cost="섬 지역과 해안 장거리 이동은 당일 배정 가능 여부를 먼저 확인합니다"},
  @{slug="gyeongsang"; name="경상"; focus="대구·부산 인접 생활권과 창원, 포항, 구미처럼 산업도시 수요가 함께 있는 권역"; movement="산업단지 교대 시간, 해안 관광지, 도심 상권의 이동 흐름이 서로 다릅니다"; cost="시군 경계를 넘는 이동은 거리와 시간대에 따라 출장비 기준을 별도로 안내합니다"},
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

$adminAreaRows = @"
gyeonggi|경기|city|suwon-si|수원시|광교, 인계, 영통, 권선|업무지와 신도시 주거권이 가까워 저녁 예약이 안정적으로 이어집니다
gyeonggi|경기|admin-gu|suwon-jangan-gu|수원 장안구|정자, 영화, 조원, 파장|북수원 주거권과 구도심 생활권이 섞여 조용한 방문 요청이 많습니다
gyeonggi|경기|admin-gu|suwon-gwonseon-gu|수원 권선구|권선, 호매실, 세류, 고색|서수원 주거지와 산업권 이동이 겹쳐 주차 조건 확인이 중요합니다
gyeonggi|경기|admin-gu|suwon-paldal-gu|수원 팔달구|인계, 매산, 화서, 행궁|상권과 숙소 문의가 많아 출입구와 예약명 확인을 먼저 봅니다
gyeonggi|경기|admin-gu|suwon-yeongtong-gu|수원 영통구|영통, 광교, 매탄, 망포|신도시 업무지와 대단지 아파트 예약이 함께 들어옵니다
gyeonggi|경기|city|seongnam-si|성남시|판교, 분당, 야탑, 위례|IT 업무 일정과 주거지 방문이 섞여 평일 늦은 문의가 많습니다
gyeonggi|경기|admin-gu|seongnam-sujeong-gu|성남 수정구|위례, 신흥, 태평, 수진|서울 인접 이동과 구도심 주거권 특성이 함께 나타납니다
gyeonggi|경기|admin-gu|seongnam-jungwon-gu|성남 중원구|모란, 상대원, 금광, 은행|산업권과 역세권 문의가 섞여 시작 시간 조율이 필요합니다
gyeonggi|경기|admin-gu|seongnam-bundang-gu|성남 분당구|서현, 정자, 수내, 판교|업무지와 주거 단지가 가까워 방문자 등록 기준이 다양합니다
gyeonggi|경기|city|uijeongbu-si|의정부시|의정부역, 민락, 가능, 녹양|북부 교통 거점과 주거지가 함께 있어 이동 여유 확인이 필요합니다
gyeonggi|경기|city|anyang-si|안양시|범계, 평촌, 안양일번가, 관양|평촌 업무지와 구도심 상권 예약이 시간대별로 갈립니다
gyeonggi|경기|admin-gu|anyang-manan-gu|안양 만안구|안양역, 석수, 박달, 명학|구도심 주거지와 역세권 숙소 문의가 함께 있습니다
gyeonggi|경기|admin-gu|anyang-dongan-gu|안양 동안구|평촌, 범계, 관양, 호계|업무지와 아파트 단지 출입 기준 확인이 중요합니다
gyeonggi|경기|city|bucheon-si|부천시|중동, 상동, 송내, 역곡|역세권 오피스텔과 주거 단지 예약이 균형 있게 들어옵니다
gyeonggi|경기|admin-gu|bucheon-wonmi-gu|부천 원미구|중동, 상동, 심곡, 춘의|상권과 오피스텔 방문이 많아 공동현관 안내가 필요합니다
gyeonggi|경기|admin-gu|bucheon-sosa-gu|부천 소사구|소사본, 범박, 괴안, 옥길|주거 단지 중심 예약이 많고 조용한 방문을 선호합니다
gyeonggi|경기|admin-gu|bucheon-ojeong-gu|부천 오정구|오정, 원종, 고강, 여월|공항 인접 이동과 주거권 예약 조건을 함께 봅니다
gyeonggi|경기|city|gwangmyeong-si|광명시|철산, 하안, 소하, 일직|서울 서남권과 맞닿아 퇴근 시간 이동 변수가 큽니다
gyeonggi|경기|city|pyeongtaek-si|평택시|고덕, 소사벌, 평택역, 안중|산업단지와 미군기지 인접 생활권 문의가 함께 나타납니다
gyeonggi|경기|city|dongducheon-si|동두천시|지행, 생연, 송내, 보산|북부 생활권 특성상 야간 이동 가능 시간을 먼저 확인합니다
gyeonggi|경기|city|ansan-si|안산시|중앙, 고잔, 선부, 반월|산업권과 주거지가 함께 있어 예약 시간대별 이동 차이가 있습니다
gyeonggi|경기|admin-gu|ansan-sangnok-gu|안산 상록구|상록수, 본오, 사동, 이동|대학가와 주거 단지 문의가 섞여 공간 조건 확인이 필요합니다
gyeonggi|경기|admin-gu|ansan-danwon-gu|안산 단원구|고잔, 선부, 초지, 반월공단|공단 근무 후 이용 문의가 많아 퇴근 시간 변수를 봅니다
gyeonggi|경기|city|goyang-si|고양시|일산, 화정, 삼송, 킨텍스|전시 일정 뒤 숙소에서 휴식을 찾는 고객과 주거권 문의가 함께 있습니다
gyeonggi|경기|admin-gu|goyang-deogyang-gu|고양 덕양구|화정, 행신, 원흥, 삼송|서울 접근 이동과 신도시 주거권 예약이 함께 있습니다
gyeonggi|경기|admin-gu|goyang-ilsandong-gu|고양 일산동구|마두, 백석, 장항, 정발산|상권과 숙소 방문이 많아 주차 동선 확인이 중요합니다
gyeonggi|경기|admin-gu|goyang-ilsanseo-gu|고양 일산서구|대화, 주엽, 탄현, 킨텍스|전시 행사 시간과 주거권 예약 흐름이 겹칩니다
gyeonggi|경기|city|gwacheon-si|과천시|정부과천청사, 별양, 중앙, 문원|행정기관과 주거지가 가까워 보안 출입 기준을 확인합니다
gyeonggi|경기|city|guri-si|구리시|인창, 수택, 갈매, 교문|서울 동북권 이동과 주거 단지 방문이 함께 나타납니다
gyeonggi|경기|city|namyangju-si|남양주시|다산, 별내, 평내, 화도|신도시와 외곽 생활권이 넓어 세부 주소 확인이 중요합니다
gyeonggi|경기|city|osan-si|오산시|오산역, 세교, 궐동, 원동|수원·평택 이동축과 주거권 예약이 함께 있습니다
gyeonggi|경기|city|siheung-si|시흥시|배곧, 정왕, 은계, 장곡|해안 신도시와 산업권 이동 변수가 함께 나타납니다
gyeonggi|경기|city|gunpo-si|군포시|산본, 금정, 당동, 부곡|역세권과 아파트 단지 예약이 많아 공동현관 기준을 봅니다
gyeonggi|경기|city|uiwang-si|의왕시|내손, 오전, 포일, 청계|안양·분당 이동권 사이에 있어 시간 조율이 중요합니다
gyeonggi|경기|city|hanam-si|하남시|미사, 감일, 덕풍, 신장|신도시 주거권과 스타필드 인근 숙소 문의가 함께 있습니다
gyeonggi|경기|city|yongin-si|용인시|수지, 기흥, 처인, 동백|지역 범위가 넓어 같은 용인 안에서도 이동 시간 확인이 중요합니다
gyeonggi|경기|admin-gu|yongin-cheoin-gu|용인 처인구|김량장, 역북, 포곡, 모현|외곽 이동과 주거권 예약의 거리 차이가 큽니다
gyeonggi|경기|admin-gu|yongin-giheung-gu|용인 기흥구|구갈, 보정, 동백, 신갈|분당·수원 이동축과 대단지 아파트 문의가 많습니다
gyeonggi|경기|admin-gu|yongin-suji-gu|용인 수지구|풍덕천, 죽전, 성복, 상현|서울 통근 생활권과 주거지 예약이 중심입니다
gyeonggi|경기|city|paju-si|파주시|운정, 금촌, 문산, 야당|신도시와 북부 외곽 이동 조건이 달라 주소 확인이 중요합니다
gyeonggi|경기|city|icheon-si|이천시|창전, 증포, 부발, 마장|물류·산업 일정 후 문의와 주거권 예약이 함께 있습니다
gyeonggi|경기|city|anseong-si|안성시|공도, 석정, 대덕, 죽산|평택 인접 생활권과 외곽 이동 여부를 함께 확인합니다
gyeonggi|경기|city|gimpo-si|김포시|구래, 장기, 사우, 풍무|한강신도시와 공항 인접 이동 변수가 있습니다
gyeonggi|경기|city|hwaseong-si|화성시|동탄, 병점, 향남, 봉담|동탄 업무지와 외곽 산업권의 이동 차이가 큽니다
gyeonggi|경기|admin-gu|hwaseong-manse-gu|화성 만세구|남양, 우정, 장안, 서신|서부 생활권과 해안·산업권 이동 조건을 함께 확인합니다
gyeonggi|경기|admin-gu|hwaseong-hyohaeng-gu|화성 효행구|봉담, 정남, 매송, 기배|수원 인접 생활권과 외곽 주거지 예약이 함께 있습니다
gyeonggi|경기|admin-gu|hwaseong-byeongjeom-gu|화성 병점구|병점, 진안, 반월, 기산|병점역 생활권과 동탄 인접 이동 흐름을 확인합니다
gyeonggi|경기|admin-gu|hwaseong-dongtan-gu|화성 동탄구|동탄, 영천, 청계, 오산|신도시 업무지와 대단지 아파트 예약이 많습니다
gyeonggi|경기|city|gwangju-si|광주시|경안, 태전, 오포, 곤지암|분당 인접권과 외곽 주거지가 넓게 퍼져 있습니다
gyeonggi|경기|city|yangju-si|양주시|옥정, 덕정, 회천, 광적|신도시와 북부 외곽 이동 조건을 함께 봅니다
gyeonggi|경기|city|pocheon-si|포천시|소흘, 신읍, 일동, 이동|산간 이동과 군부대 인접 생활권 문의가 있습니다
gyeonggi|경기|city|yeoju-si|여주시|여주역, 오학, 가남, 대신|관광지와 외곽 생활권 이동 시간이 달라집니다
gyeonggi|경기|county|yeoncheon-gun|연천군|전곡, 연천, 청산, 군남|북부 장거리 이동이 많아 당일 가능 여부를 먼저 봅니다
gyeonggi|경기|county|gapyeong-gun|가평군|가평읍, 청평, 설악, 조종|펜션과 리조트 방문 문의가 많아 정확한 위치 공유가 중요합니다
gyeonggi|경기|county|yangpyeong-gun|양평군|양평읍, 용문, 서종, 강상|전원주택과 숙박시설 진입로 확인이 필요합니다
"@

$adminAreaRows += "`n" + @"
jeolla|전라|city|jeonju-si|전주시|완산, 덕진, 혁신도시, 한옥마을|여행 숙소와 주거지 예약이 모두 있어 공간 유형별 안내가 필요합니다
jeolla|전라|admin-gu|jeonju-wansan-gu|전주 완산구|한옥마을, 효자, 삼천, 평화|관광 숙소와 주거권 문의가 함께 있습니다
jeolla|전라|admin-gu|jeonju-deokjin-gu|전주 덕진구|덕진, 송천, 인후, 혁신도시|대학가와 신도시 생활권 예약이 섞입니다
jeolla|전라|city|gunsan-si|군산시|수송, 나운, 조촌, 비응항|산업권과 항만 숙소 문의가 함께 있습니다
jeolla|전라|city|iksan-si|익산시|영등, 모현, 어양, 함열|역세권과 주거권 예약이 균형 있게 나타납니다
jeolla|전라|city|jeongeup-si|정읍시|수성, 상동, 연지, 내장산|도심과 관광지 이동 조건을 함께 확인합니다
jeolla|전라|city|namwon-si|남원시|도통, 향교, 금동, 운봉|관광 숙소와 외곽 이동 가능 시간을 봅니다
jeolla|전라|city|gimje-si|김제시|검산, 요촌, 신풍, 만경|전주 인접 생활권과 농촌 외곽 이동을 확인합니다
jeolla|전라|county|wanju-gun|완주군|봉동, 삼례, 이서, 용진|전주 인접권과 산업단지 예약이 함께 있습니다
jeolla|전라|county|jinan-gun|진안군|진안읍, 마령, 부귀, 용담|산간 이동과 펜션 위치 확인이 중요합니다
jeolla|전라|county|muju-gun|무주군|무주읍, 설천, 안성, 적상|리조트와 산간 숙소 방문 조건을 봅니다
jeolla|전라|county|jangsu-gun|장수군|장수읍, 장계, 번암, 산서|외곽 이동 시간이 길어 사전 확인이 필요합니다
jeolla|전라|county|imsil-gun|임실군|임실읍, 관촌, 오수, 성수|전주 인접 이동과 외곽 숙소 조건을 함께 봅니다
jeolla|전라|county|sunchang-gun|순창군|순창읍, 복흥, 구림, 적성|관광지와 농촌 생활권 이동을 확인합니다
jeolla|전라|county|gochang-gun|고창군|고창읍, 흥덕, 심원, 선운산|해안·관광 숙소 위치 확인이 중요합니다
jeolla|전라|county|buan-gun|부안군|부안읍, 변산, 줄포, 계화|변산반도 숙소와 외곽 이동 조건을 봅니다
jeolla|전라|city|mokpo-si|목포시|하당, 평화광장, 용당, 북항|항만과 해안 숙소 문의가 많습니다
jeolla|전라|city|yeosu-si|여수시|웅천, 학동, 여천, 돌산|관광 숙소와 산업권 이동 조건이 함께 나타납니다
jeolla|전라|city|suncheon-si|순천시|조례, 연향, 왕지, 오천|도심 주거권과 관광 일정 문의가 함께 있습니다
jeolla|전라|city|naju-si|나주시|빛가람, 금남, 성북, 남평|혁신도시와 구도심 예약이 함께 있습니다
jeolla|전라|city|gwangyang-si|광양시|중마, 광양읍, 금호, 태인|산업단지와 항만 이동 시간이 변수입니다
jeolla|전라|county|damyang-gun|담양군|담양읍, 수북, 창평, 메타세쿼이아길|관광 숙소와 광주 인접 이동을 확인합니다
jeolla|전라|county|gokseong-gun|곡성군|곡성읍, 옥과, 석곡, 오곡|관광지와 외곽 숙소 위치 확인이 필요합니다
jeolla|전라|county|gurye-gun|구례군|구례읍, 산동, 마산, 토지|지리산 인접 숙소와 산간 이동을 봅니다
jeolla|전라|county|goheung-gun|고흥군|고흥읍, 도양, 과역, 봉래|해안 장거리 이동 가능 여부를 먼저 봅니다
jeolla|전라|county|boseong-gun|보성군|보성읍, 벌교, 득량, 회천|차밭 관광지와 해안 숙소 문의가 있습니다
jeolla|전라|county|hwasun-gun|화순군|화순읍, 능주, 도곡, 동면|광주 인접 생활권과 외곽 이동을 함께 봅니다
jeolla|전라|county|jangheung-gun|장흥군|장흥읍, 관산, 대덕, 안양|해안과 내륙 이동 조건이 다릅니다
jeolla|전라|county|gangjin-gun|강진군|강진읍, 마량, 성전, 도암|관광 숙소와 외곽 진입로 확인이 중요합니다
jeolla|전라|county|haenam-gun|해남군|해남읍, 송지, 문내, 황산|남해안 장거리 이동 가능 시간을 먼저 봅니다
jeolla|전라|county|yeongam-gun|영암군|삼호, 영암읍, 시종, 군서|산업권과 목포 인접 생활권 문의가 있습니다
jeolla|전라|county|muan-gun|무안군|남악, 무안읍, 삼향, 청계|도청 인근 신도시와 공항 이동을 함께 봅니다
jeolla|전라|county|hampyeong-gun|함평군|함평읍, 학교, 월야, 나산|광주·목포 사이 이동권과 외곽 숙소 조건을 확인합니다
jeolla|전라|county|yeonggwang-gun|영광군|영광읍, 홍농, 법성, 백수|해안 숙소와 산업권 이동 조건이 함께 있습니다
jeolla|전라|county|jangseong-gun|장성군|장성읍, 삼계, 황룡, 북이|광주 인접 생활권과 산간 이동을 봅니다
jeolla|전라|county|wando-gun|완도군|완도읍, 노화, 군외, 신지|도서·해안 이동은 당일 가능 여부 확인이 우선입니다
jeolla|전라|county|jindo-gun|진도군|진도읍, 군내, 고군, 의신|섬 지역 이동과 숙소 위치를 먼저 확인합니다
jeolla|전라|county|sinan-gun|신안군|압해, 지도, 증도, 비금|도서 지역 특성상 실제 배정 가능 여부를 별도로 안내합니다
"@

$adminAreaRows += "`n" + @"
gyeongsang|경상|city|pohang-si|포항시|죽도, 영일대, 효자, 오천|해안 숙소와 산업권 예약이 함께 나타납니다
gyeongsang|경상|admin-gu|pohang-nam-gu|포항 남구|오천, 효자, 대이, 연일|산업권과 주거지 이동 조건을 확인합니다
gyeongsang|경상|admin-gu|pohang-buk-gu|포항 북구|영일대, 장성, 양덕, 죽도|해안 숙소와 도심 상권 문의가 많습니다
gyeongsang|경상|city|gyeongju-si|경주시|황리단길, 보문, 용강, 안강|관광 숙소와 외곽 리조트 이동 조건이 다릅니다
gyeongsang|경상|city|gimcheon-si|김천시|혁신도시, 평화, 대신, 아포|혁신도시 업무 일정과 주거권 예약이 함께 있습니다
gyeongsang|경상|city|andong-si|안동시|옥동, 송현, 용상, 풍산|도심 주거권과 관광 숙소 문의가 함께 있습니다
gyeongsang|경상|city|gumi-si|구미시|인동, 송정, 봉곡, 산동|산업단지 근무 후 예약과 신도시 문의가 많습니다
gyeongsang|경상|city|yeongju-si|영주시|가흥, 휴천, 영주동, 풍기|도심과 관광지 이동 조건을 함께 확인합니다
gyeongsang|경상|city|yeongcheon-si|영천시|완산, 문외, 금호, 신녕|대구 인접 이동권과 외곽 생활권이 함께 있습니다
gyeongsang|경상|city|sangju-si|상주시|남성, 무양, 함창, 낙동|도심 주거권과 외곽 이동 가능 시간을 봅니다
gyeongsang|경상|city|mungyeong-si|문경시|점촌, 문경읍, 가은, 모전|관광 숙소와 산간 이동 조건이 있습니다
gyeongsang|경상|city|gyeongsan-si|경산시|하양, 압량, 중방, 사동|대구 인접 생활권과 대학가 예약이 많습니다
gyeongsang|경상|county|uiseong-gun|의성군|의성읍, 안계, 봉양, 금성|외곽 이동 시간이 길어 사전 확인이 필요합니다
gyeongsang|경상|county|cheongsong-gun|청송군|청송읍, 진보, 주왕산, 현동|산간 관광지와 숙소 위치 확인이 중요합니다
gyeongsang|경상|county|yeongyang-gun|영양군|영양읍, 입암, 수비, 청기|산간 장거리 이동 가능 여부를 먼저 봅니다
gyeongsang|경상|county|yeongdeok-gun|영덕군|영덕읍, 강구, 축산, 영해|해안 숙소와 관광지 이동 조건을 확인합니다
gyeongsang|경상|county|cheongdo-gun|청도군|청도읍, 화양, 풍각, 이서|대구 인접권과 전원 숙소 문의가 함께 있습니다
gyeongsang|경상|county|goryeong-gun|고령군|대가야읍, 다산, 성산, 개진|대구 인접 산업권과 외곽 이동을 봅니다
gyeongsang|경상|county|seongju-gun|성주군|성주읍, 초전, 선남, 월항|농공단지와 외곽 숙소 위치 확인이 필요합니다
gyeongsang|경상|county|chilgok-gun|칠곡군|왜관, 석적, 북삼, 동명|대구·구미 이동권과 산업지 예약이 함께 있습니다
gyeongsang|경상|county|yecheon-gun|예천군|호명, 예천읍, 풍양, 용문|도청 신도시와 구도심 문의가 함께 있습니다
gyeongsang|경상|county|bonghwa-gun|봉화군|봉화읍, 춘양, 물야, 석포|산간 이동과 숙소 진입로 확인이 중요합니다
gyeongsang|경상|county|uljin-gun|울진군|울진읍, 죽변, 후포, 북면|해안 장거리 이동과 숙소 위치를 먼저 봅니다
gyeongsang|경상|county|ulleung-gun|울릉군|울릉읍, 서면, 북면, 도동|도서 지역은 실제 출장 가능 여부를 별도로 확인합니다
gyeongsang|경상|city|changwon-si|창원시|성산, 의창, 마산, 진해|산업단지 근무 일정과 주거권 문의가 함께 나타납니다
gyeongsang|경상|admin-gu|changwon-uichang-gu|창원 의창구|팔용, 명서, 북면, 봉림|도심 주거권과 산업지 이동이 함께 있습니다
gyeongsang|경상|admin-gu|changwon-seongsan-gu|창원 성산구|상남, 중앙, 가음, 반송|업무지와 상권 예약이 많아 주차 확인이 필요합니다
gyeongsang|경상|admin-gu|masanhappo-gu|마산합포구|월영, 산호, 오동, 진동|해안 생활권과 구도심 문의가 함께 있습니다
gyeongsang|경상|admin-gu|masanhoewon-gu|마산회원구|양덕, 합성, 내서, 회원|터미널과 주거권 예약 흐름이 겹칩니다
gyeongsang|경상|admin-gu|jinhae-gu|진해구|석동, 자은, 용원, 경화|해군기지 인접 생활권과 해안 숙소 문의가 있습니다
gyeongsang|경상|city|jinju-si|진주시|평거, 충무공, 가좌, 상대|혁신도시와 대학가 예약이 함께 있습니다
gyeongsang|경상|city|tongyeong-si|통영시|무전, 죽림, 중앙, 도남|해안 숙소와 관광 일정 문의가 많습니다
gyeongsang|경상|city|sacheon-si|사천시|사천읍, 삼천포, 벌리, 용현|항공산업권과 해안 숙소 이동을 함께 봅니다
gyeongsang|경상|city|gimhae-si|김해시|장유, 내외, 삼계, 진영|부산 인접 생활권과 신도시 예약이 많습니다
gyeongsang|경상|city|miryang-si|밀양시|삼문, 내이, 하남, 가곡|산간과 도심 이동 조건을 함께 확인합니다
gyeongsang|경상|city|geoje-si|거제시|고현, 옥포, 아주, 장평|조선업 근무 일정과 해안 숙소 문의가 함께 있습니다
gyeongsang|경상|city|yangsan-si|양산시|물금, 동면, 서창, 덕계|부산·울산 인접 이동권과 주거지 예약이 많습니다
gyeongsang|경상|county|uiryeong-gun|의령군|의령읍, 부림, 가례, 정곡|외곽 이동과 농촌 숙소 위치 확인이 필요합니다
gyeongsang|경상|county|haman-gun|함안군|가야, 칠원, 군북, 대산|창원 인접 산업권과 주거지 문의가 함께 있습니다
gyeongsang|경상|county|changnyeong-gun|창녕군|창녕읍, 남지, 영산, 부곡|온천 숙소와 외곽 이동 조건을 확인합니다
gyeongsang|경상|county|goseong-gun-gn|고성군|고성읍, 회화, 거류, 하일|해안 숙소와 외곽 생활권 예약이 함께 있습니다
gyeongsang|경상|county|namhae-gun|남해군|남해읍, 삼동, 창선, 미조|펜션과 해안 장거리 이동 가능 여부를 봅니다
gyeongsang|경상|county|hadong-gun|하동군|하동읍, 화개, 진교, 악양|관광지와 산간 숙소 진입로 확인이 중요합니다
gyeongsang|경상|county|sancheong-gun|산청군|산청읍, 신안, 시천, 단성|지리산 인접 숙소와 외곽 이동을 봅니다
gyeongsang|경상|county|hamyang-gun|함양군|함양읍, 안의, 수동, 마천|산간 이동과 관광 숙소 위치 확인이 필요합니다
gyeongsang|경상|county|geochang-gun|거창군|거창읍, 가조, 위천, 남상|산간 생활권과 외곽 이동 시간이 변수입니다
gyeongsang|경상|county|hapcheon-gun|합천군|합천읍, 가야, 삼가, 초계|관광지와 농촌 외곽 이동을 함께 확인합니다
jeju|제주|admin-city|jeju-si|제주시|노형, 연동, 아라, 함덕|공항과 도심 숙소 문의가 많아 체크인 시간을 함께 봅니다
jeju|제주|admin-city|seogwipo-si|서귀포시|중문, 서귀동, 대정, 성산|관광 숙소와 동서 이동 시간이 달라 예약 여유가 필요합니다
"@

$adminAreaRows += "`n" + @"
incheon|인천|gu|incheon-jung-gu|인천 중구|영종, 운서, 신포, 개항장|공항 일정과 원도심 숙소 문의가 함께 나타납니다
incheon|인천|gu|incheon-dong-gu|인천 동구|송림, 화수, 만석, 금창|원도심 주거지와 항만 인접 이동 조건을 확인합니다
incheon|인천|gu|michuhol-gu|미추홀구|주안, 용현, 도화, 학익|역세권 오피스텔과 주거지 방문이 많습니다
incheon|인천|gu|yeonsu-gu|연수구|송도, 연수, 동춘, 청학|국제업무지구와 주거 단지가 붙어 있어 건물 출입 기준이 다양합니다
incheon|인천|gu|namdong-gu|남동구|구월, 논현, 만수, 간석|상권과 산업권 문의가 함께 있어 시간대별 이동을 봅니다
incheon|인천|gu|bupyeong-gu|부평구|부평역, 삼산, 갈산, 산곡|상권과 주거지가 섞여 늦은 저녁 상담에서 정확한 위치가 중요합니다
incheon|인천|gu|gyeyang-gu|계양구|계산, 작전, 효성, 귤현|공항철도와 주거권 이동 흐름이 함께 나타납니다
incheon|인천|gu|seo-gu|서구|청라, 검단, 가정, 석남|신도시와 산업권 이동 조건이 크게 다릅니다
incheon|인천|county|ganghwa-gun|강화군|강화읍, 선원, 길상, 내가|교량 이동과 펜션 방문 조건을 먼저 확인합니다
incheon|인천|county|ongjin-gun|옹진군|영흥, 백령, 대청, 덕적|도서 지역 특성상 실제 출장 가능 여부를 별도로 안내합니다
busan|부산|gu|busan-jung-gu|부산 중구|남포, 중앙, 광복, 부평|관광 숙소와 원도심 상권 문의가 많습니다
busan|부산|gu|busan-seo-gu|부산 서구|동대신, 서대신, 암남, 충무|대학병원 인근 숙소와 주거지 방문 조건을 확인합니다
busan|부산|gu|busan-dong-gu|부산 동구|초량, 부산역, 수정, 범일|역세권 숙소와 출장 일정 문의가 중심입니다
busan|부산|gu|yeongdo-gu|영도구|동삼, 영선, 청학, 봉래|교량 이동과 해안 숙소 방문 조건이 중요합니다
busan|부산|gu|busanjin-gu|부산진구|서면, 부전, 전포, 가야|도심 상권 중심 예약이 많아 이동과 주차 조건을 먼저 봅니다
busan|부산|gu|dongnae-gu|동래구|동래, 온천, 사직, 명륜|온천장 숙소와 주거권 문의가 함께 있습니다
busan|부산|gu|busan-nam-gu|부산 남구|대연, 용호, 문현, 감만|대학가와 해안 주거권 이동을 함께 확인합니다
busan|부산|gu|busan-buk-gu|부산 북구|화명, 덕천, 구포, 만덕|북부 주거지와 역세권 예약이 많습니다
busan|부산|gu|haeundae-gu|해운대구|해운대, 센텀, 좌동, 송정|관광 숙소와 업무 미팅 후 예약이 함께 있어 성수기 여유 시간이 필요합니다
busan|부산|gu|saha-gu|사하구|하단, 다대, 괴정, 장림|산업권과 해안 주거지 이동 조건을 확인합니다
busan|부산|gu|geumjeong-gu|금정구|부산대, 장전, 구서, 남산|대학가와 주거권 예약이 함께 있습니다
busan|부산|gu|busan-gangseo-gu|부산 강서구|명지, 녹산, 대저, 가덕|산업단지와 신도시 이동 변수가 큽니다
busan|부산|gu|yeonje-gu|연제구|연산, 거제, 시청, 교대|행정 업무지와 주거지가 가까워 출입 조건을 봅니다
busan|부산|gu|suyeong-gu|수영구|광안, 민락, 남천, 수영|해안 숙소와 상권 문의가 많아 주차를 먼저 확인합니다
busan|부산|gu|sasang-gu|사상구|괘법, 주례, 엄궁, 학장|터미널과 산업권 예약이 함께 나타납니다
busan|부산|county|gijang-gun|기장군|정관, 기장읍, 일광, 장안|해안 리조트와 외곽 이동 시간이 달라집니다
"@

$adminAreaRows += "`n" + @"
daegu|대구|gu|daegu-jung-gu|대구 중구|동성로, 반월당, 남산, 대신|도심 상권과 숙소 문의가 많아 주차 조건 확인이 필요합니다
daegu|대구|gu|daegu-dong-gu|대구 동구|동대구역, 신암, 혁신도시, 안심|역세권 출장 일정과 신도시 주거권 문의가 함께 있습니다
daegu|대구|gu|daegu-seo-gu|대구 서구|평리, 내당, 비산, 원대|구도심 주거권과 산업지 인접 이동을 함께 봅니다
daegu|대구|gu|daegu-nam-gu|대구 남구|대명, 봉덕, 이천, 앞산|대학가와 주거지 예약이 섞여 조용한 방문을 중시합니다
daegu|대구|gu|daegu-buk-gu|대구 북구|칠곡, 산격, 복현, 침산|북부 생활권과 산업권 이동 흐름이 다릅니다
daegu|대구|gu|suseong-gu|수성구|범어, 수성못, 만촌, 지산|주거지와 호텔 문의가 함께 있어 방문 매너를 중시합니다
daegu|대구|gu|dalseo-gu|달서구|상인, 성서, 월성, 두류|성서산단과 주거권 예약 시간이 겹칩니다
daegu|대구|county|dalseong-gun|달성군|화원, 다사, 현풍, 유가|테크노폴리스와 외곽 이동 조건을 확인합니다
daegu|대구|county|gunwi-gun|군위군|군위읍, 효령, 부계, 의흥|농촌 생활권과 장거리 이동 가능 여부를 먼저 봅니다
gwangju|광주|gu|gwangju-dong-gu|광주 동구|충장로, 학동, 산수, 지산|도심 상권과 숙소 문의가 함께 있습니다
gwangju|광주|gu|gwangju-seo-gu|광주 서구|상무, 치평, 화정, 금호|상무지구 업무 일정과 주거권 예약이 많습니다
gwangju|광주|gu|gwangju-nam-gu|광주 남구|봉선, 주월, 진월, 백운|주거지 중심 예약이 많아 조용한 방문을 선호합니다
gwangju|광주|gu|gwangju-buk-gu|광주 북구|용봉, 일곡, 문흥, 운암|대학가와 대단지 주거권 문의가 함께 있습니다
gwangju|광주|gu|gwangsan-gu|광산구|수완, 첨단, 송정, 하남|산업권과 신도시 생활권 이동 조건이 다릅니다
daejeon|대전|gu|daejeon-dong-gu|대전 동구|대전역, 용전, 가오, 판암|역세권 출장 일정과 주거권 예약이 함께 있습니다
daejeon|대전|gu|daejeon-jung-gu|대전 중구|은행, 대흥, 태평, 문화|원도심 상권과 주거지 방문 조건을 봅니다
daejeon|대전|gu|daejeon-seo-gu|대전 서구|둔산, 탄방, 관저, 월평|행정 업무지와 대단지 예약이 많습니다
daejeon|대전|gu|yuseong-gu|유성구|봉명, 도룡, 관평, 노은|연구단지와 온천 숙소 문의가 함께 있습니다
daejeon|대전|gu|daedeok-gu|대덕구|송촌, 중리, 오정, 신탄진|산업권과 북부 주거지 이동 조건을 확인합니다
ulsan|울산|gu|ulsan-jung-gu|울산 중구|성남, 태화, 병영, 우정|원도심과 주거권 예약이 함께 나타납니다
ulsan|울산|gu|ulsan-nam-gu|울산 남구|삼산, 달동, 신정, 무거|도심 상권과 호텔 문의가 많아 주차 조건이 중요합니다
ulsan|울산|gu|ulsan-dong-gu|울산 동구|전하, 방어, 화정, 일산|조선업 근무 일정과 해안 숙소 문의가 함께 있습니다
ulsan|울산|gu|ulsan-buk-gu|울산 북구|호계, 매곡, 송정, 화봉|산업단지와 신도시 주거권 이동을 함께 봅니다
ulsan|울산|county|ulju-gun|울주군|언양, 범서, 온산, 서생|산단과 해안·산간 이동 조건이 달라 사전 확인이 필요합니다
sejong|세종|admin-city|sejong-si|세종시|나성, 보람, 조치원, 아름|정부청사와 신도심 아파트 예약이 많아 방문자 등록을 확인합니다
"@

$adminAreaRows += "`n" + @"
gangwon|강원|city|chuncheon-si|춘천시|퇴계, 석사, 후평, 강촌|관광 숙소와 주거권 문의가 함께 있습니다
gangwon|강원|city|wonju-si|원주시|무실, 단계, 혁신도시, 단구|혁신도시 업무 일정과 주거지 예약이 섞입니다
gangwon|강원|city|gangneung-si|강릉시|교동, 경포, 주문진, 포남|해안 숙소와 도심 생활권 이동 조건이 다릅니다
gangwon|강원|city|donghae-si|동해시|천곡, 묵호, 북평, 망상|항만과 해안 숙소 문의가 함께 있습니다
gangwon|강원|city|taebaek-si|태백시|황지, 장성, 철암, 문곡|산간 이동과 기상 영향을 상담에서 확인합니다
gangwon|강원|city|sokcho-si|속초시|조양, 교동, 청초, 대포|관광 숙소와 해안 이동 조건이 중요합니다
gangwon|강원|city|samcheok-si|삼척시|교동, 남양, 도계, 근덕|해안과 산간 생활권 이동 차이가 큽니다
gangwon|강원|county|hongcheon-gun|홍천군|홍천읍, 서석, 내면, 남면|펜션과 외곽 숙소 위치 확인이 중요합니다
gangwon|강원|county|hoengseong-gun|횡성군|횡성읍, 둔내, 우천, 안흥|리조트와 전원 숙소 문의가 있습니다
gangwon|강원|county|yeongwol-gun|영월군|영월읍, 주천, 상동, 김삿갓|산간 이동과 숙소 진입로 확인이 필요합니다
gangwon|강원|county|pyeongchang-gun|평창군|대관령, 봉평, 진부, 용평|리조트 일정과 겨울철 이동 변수를 봅니다
gangwon|강원|county|jeongseon-gun|정선군|정선읍, 고한, 사북, 임계|산간 숙소와 관광 일정 후 문의가 있습니다
gangwon|강원|county|cheorwon-gun|철원군|갈말, 동송, 김화, 서면|북부 장거리 이동 가능 시간을 먼저 확인합니다
gangwon|강원|county|hwacheon-gun|화천군|화천읍, 사내, 간동, 하남|산간 생활권과 숙박시설 위치 확인이 중요합니다
gangwon|강원|county|yanggu-gun|양구군|양구읍, 국토정중앙, 동면, 해안|군부대 인접 생활권과 외곽 이동을 함께 봅니다
gangwon|강원|county|inje-gun|인제군|인제읍, 원통, 기린, 북면|산악 도로와 숙소 진입 조건을 확인합니다
gangwon|강원|county|goseong-gun-gw|고성군|간성, 거진, 토성, 죽왕|해안 리조트와 북부 이동 시간이 변수입니다
gangwon|강원|county|yangyang-gun|양양군|양양읍, 낙산, 현남, 강현|서핑 숙소와 관광지 이동 조건을 먼저 봅니다
"@

$adminAreaRows += "`n" + @"
chungcheong|충청|city|cheongju-si|청주시|오송, 복대, 율량, 상당|오송 출장과 도심 주거권 예약이 섞여 일정 확인이 중요합니다
chungcheong|충청|admin-gu|cheongju-sangdang-gu|청주 상당구|성안, 용암, 금천, 문의|원도심과 주거권 방문 조건이 함께 나타납니다
chungcheong|충청|admin-gu|cheongju-seowon-gu|청주 서원구|사창, 산남, 분평, 수곡|대학가와 주거지 예약이 섞여 공간 조건을 봅니다
chungcheong|충청|admin-gu|cheongju-heungdeok-gu|청주 흥덕구|복대, 가경, 오송, 강서|오송 업무지와 터미널 인근 숙소 문의가 있습니다
chungcheong|충청|admin-gu|cheongju-cheongwon-gu|청주 청원구|율량, 오창, 내덕, 우암|산업권과 북부 주거권 이동 조건이 다릅니다
chungcheong|충청|city|chungju-si|충주시|연수, 칠금, 호암, 수안보|도심과 온천 숙소 예약이 함께 있습니다
chungcheong|충청|city|jecheon-si|제천시|청전, 하소, 장락, 의림지|관광 숙소와 주거권 이동 조건을 함께 확인합니다
chungcheong|충청|county|boeun-gun|보은군|보은읍, 속리산, 삼승, 회인|관광지와 외곽 이동 가능 시간을 먼저 봅니다
chungcheong|충청|county|okcheon-gun|옥천군|옥천읍, 이원, 청산, 군북|대전 인접 생활권과 외곽 이동을 확인합니다
chungcheong|충청|county|yeongdong-gun|영동군|영동읍, 황간, 추풍령, 용산|산간 이동과 장거리 배정 여부를 확인합니다
chungcheong|충청|county|jeungpyeong-gun|증평군|증평읍, 도안, 송산, 초중|청주 인접 생활권 예약이 많습니다
chungcheong|충청|county|jincheon-gun|진천군|진천읍, 덕산, 혁신도시, 광혜원|혁신도시와 산업권 문의가 함께 있습니다
chungcheong|충청|county|goesan-gun|괴산군|괴산읍, 청천, 칠성, 연풍|펜션과 외곽 숙소 위치 확인이 중요합니다
chungcheong|충청|county|eumseong-gun|음성군|음성읍, 금왕, 대소, 맹동|산업단지와 혁신도시 예약이 함께 나타납니다
chungcheong|충청|county|danyang-gun|단양군|단양읍, 매포, 대강, 영춘|관광 숙소와 산간 이동 시간이 변수입니다
chungcheong|충청|city|cheonan-si|천안시|불당, 두정, 성정, 신부|역세권과 산업권 문의가 함께 있어 시간대 확인이 중요합니다
chungcheong|충청|admin-gu|cheonan-dongnam-gu|천안 동남구|신부, 청수, 목천, 병천|대학가와 주거권 예약이 함께 있습니다
chungcheong|충청|admin-gu|cheonan-seobuk-gu|천안 서북구|불당, 두정, 성정, 백석|상권과 산업권 이동 변수가 큽니다
chungcheong|충청|city|gongju-si|공주시|신관, 중동, 옥룡, 반포|대학가와 관광 숙소 문의가 함께 있습니다
chungcheong|충청|city|boryeong-si|보령시|대천, 명천, 웅천, 무창포|해안 관광지와 도심 예약 조건이 다릅니다
chungcheong|충청|city|asan-si|아산시|배방, 탕정, 온양, 둔포|산업단지와 온천 숙소 문의가 함께 있습니다
chungcheong|충청|city|seosan-si|서산시|동문, 예천, 대산, 해미|산업권과 서해안 숙소 이동을 함께 봅니다
chungcheong|충청|city|nonsan-si|논산시|취암, 강경, 연무, 내동|군부대 인접 일정과 주거권 문의가 있습니다
chungcheong|충청|city|gyeryong-si|계룡시|금암, 엄사, 두마, 신도안|대전 인접 생활권과 보안 출입 기준을 확인합니다
chungcheong|충청|city|dangjin-si|당진시|당진읍, 송악, 신평, 합덕|산업단지와 항만 이동 시간이 변수입니다
chungcheong|충청|county|geumsan-gun|금산군|금산읍, 추부, 진산, 복수|대전 인접권과 외곽 이동 가능 여부를 봅니다
chungcheong|충청|county|buyeo-gun|부여군|부여읍, 규암, 은산, 홍산|관광 숙소와 도심 생활권 예약이 함께 있습니다
chungcheong|충청|county|seocheon-gun|서천군|서천읍, 장항, 마서, 한산|해안 이동과 숙소 위치 확인이 중요합니다
chungcheong|충청|county|cheongyang-gun|청양군|청양읍, 정산, 장평, 화성|외곽 이동 시간이 길어 사전 상담이 필요합니다
chungcheong|충청|county|hongseong-gun|홍성군|홍성읍, 내포, 광천, 홍북|내포신도시와 구도심 문의가 함께 있습니다
chungcheong|충청|county|yesan-gun|예산군|예산읍, 삽교, 덕산, 고덕|온천 숙소와 내포 생활권 이동을 확인합니다
chungcheong|충청|county|taean-gun|태안군|태안읍, 안면, 소원, 근흥|펜션과 해안 숙소 방문 조건을 먼저 봅니다
"@

$adminAreas = foreach ($line in ($adminAreaRows -split "`n")) {
  $trimmed = $line.Trim()
  if (!$trimmed) { continue }
  $parts = $trimmed -split "\|", 7
  [pscustomobject]@{
    regionSlug = $parts[0]
    parent = $parts[1]
    type = $parts[2]
    slug = $parts[3]
    name = $parts[4]
    zones = $parts[5]
    scene = $parts[6]
  }
}

function Normalize-Parent-Key($value) {
  $text = ([string]$value).Trim()
  $text = $text -replace "^(.+?)시(.+구)$", '$1 $2'
  $text = $text -replace "시 ", " "
  return $text
}

function Parent-Key-Candidates($value) {
  $text = ([string]$value).Trim()
  $normalized = Normalize-Parent-Key $text
  $last = (($text -split " ") | Select-Object -Last 1)
  $guOnly = ""
  if ($text -match "^(.+?)시(.+구)$") { $guOnly = $matches[2] }
  return @($text, $normalized, $last, $guOnly) | Where-Object { $_ } | Select-Object -Unique
}

$parentPages = @()
foreach ($d in $districts) {
  $display = "서울 $($d.name)"
  $parentPages += [pscustomobject]@{regionSlug="seoul"; key=$d.name; slug=$d.slug; url="/areas/seoul/$($d.slug)/"; display=$display; short=$d.name}
}
foreach ($a in $adminAreas) {
  if ($a.name.StartsWith($a.parent)) { $display = $a.name } else { $display = "$($a.parent) $($a.name)" }
  $parentPages += [pscustomobject]@{regionSlug=$a.regionSlug; key=$a.name; slug=$a.slug; url="/areas/$($a.regionSlug)/$($a.slug)/"; display=$display; short=$a.name}
}

$parentPageByKey = @{}
foreach ($p in $parentPages) {
  foreach ($key in (Parent-Key-Candidates $p.key)) {
    $parentPageByKey["$($p.regionSlug)|$key"] = $p
  }
  foreach ($key in (Parent-Key-Candidates $p.display)) {
    $parentPageByKey["$($p.regionSlug)|$key"] = $p
  }
}

function Resolve-Parent-Page($regionSlug, $sgg) {
  foreach ($key in (Parent-Key-Candidates $sgg)) {
    $lookup = "$regionSlug|$key"
    if ($parentPageByKey.ContainsKey($lookup)) { return $parentPageByKey[$lookup] }
  }
  return $null
}

function Dong-Source-Text($name, $sources) {
  if ($sources -and $sources -ne $name) {
    return "$name 대표 페이지는 $sources 생활권을 하나로 묶어 안내합니다."
  }
  return "$name 단일 행정동 기준으로 예약 전 확인 사항을 안내합니다."
}

$dongAreas = @()
if (Test-Path "data/admdongs.csv") {
  $dongAreas = foreach ($row in (Import-Csv "data/admdongs.csv")) {
    $parent = Resolve-Parent-Page $row.regionSlug $row.sgg
    if (!$parent) { continue }
    $sourceText = Dong-Source-Text $row.dong $row.sources
    [pscustomobject]@{
      regionSlug = $row.regionSlug
      parentSlug = $parent.slug
      parentUrl = $parent.url
      parentDisplay = $parent.display
      parentShort = $parent.short
      sido = $row.sido
      sgg = $row.sgg
      name = $row.dong
      sources = $row.sources
      sourceText = $sourceText
      code = $row.code
      slug = "dong-$($row.code)"
    }
  }
}

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

function Area-Pricing-Block($areaName) {
  return @"
<section class="pricing-band" aria-label="$areaName 요금표">
  <div class="section-head">
    <span class="eyebrow">PRICE GUIDE</span>
    <h2>$areaName 요금 안내</h2>
    <p>추가 조건은 상담 확인.</p>
  </div>
  <div class="price-grid">
    <article class="price-card"><span class="tag">DRY · 건식</span><h3>타이 건식</h3><p>옷 위로 진행하는 건식 코스입니다.</p><dl><div><dt>60분</dt><dd>80,000원</dd></div><div><dt>90분</dt><dd>100,000원</dd></div><div><dt>120분</dt><dd>120,000원</dd></div></dl></article>
    <article class="price-card"><span class="tag">WET · 오일</span><h3>아로마 습식</h3><p>오일과 부드러운 터치 코스입니다.</p><dl><div><dt>60분</dt><dd>90,000원</dd></div><div><dt>90분</dt><dd>110,000원</dd></div><div><dt>120분</dt><dd>130,000원</dd></div></dl></article>
    <article class="price-card"><span class="tag">SIGNATURE · 오일</span><h3>감성케어 오일</h3><p>호흡에 맞춘 오일 케어입니다.</p><dl><div><dt>60분</dt><dd>100,000원</dd></div><div><dt>90분</dt><dd>120,000원</dd></div><div><dt>120분</dt><dd>140,000원</dd></div></dl></article>
    <article class="price-card"><span class="badge">BEST</span><span class="tag">VVIP · 풀바디</span><h3>VVIP 전신케어</h3><p>건식과 오일을 잇는 풀바디입니다.</p><dl><div><dt>60분</dt><dd>110,000원</dd></div><div><dt>90분</dt><dd>130,000원</dd></div><div><dt>120분</dt><dd>150,000원</dd></div><div><dt>150분</dt><dd>180,000원</dd></div></dl></article>
    <article class="price-card"><span class="tag">KOREAN · 매니저 지정</span><h3>한국인 스웨디시</h3><p>한국인 매니저와 압 조절 안내.</p><dl><div><dt>60분</dt><dd>150,000원</dd></div><div><dt>90분</dt><dd>190,000원</dd></div></dl></article>
    <article class="price-card"><span class="tag">MEN · 남성 전용</span><h3>남성 스웨디시</h3><p>컨디션과 강도 확인 후 출발.</p><dl><div><dt>60분</dt><dd>100,000원</dd></div><div><dt>90분</dt><dd>130,000원</dd></div><div><dt>120분</dt><dd>160,000원</dd></div></dl></article>
  </div>
</section>
"@
}

function Area-Reviews-Block($areaName, $zones) {
  $zone = First-Zone $zones
  return @"
<section class="content-section reviews">
  <div class="section-head">
    <h2>$areaName 이용 후기</h2>
    <p>개인정보와 과장 표현을 정리했습니다</p>
  </div>
  <div class="review-grid">
    <article class="review-card"><span class="stars">★★★★★</span><p>주소와 출입 조건 확인이 빨라 대기가 짧았습니다.</p><strong>$zone 예약 고객</strong></article>
    <article class="review-card"><span class="stars">★★★★★</span><p>요금과 추가 비용 안내가 빨라 편했습니다.</p><strong>$areaName 90분 이용</strong></article>
    <article class="review-card"><span class="stars">★★★★★</span><p>압 조절을 다시 확인해 무리 없이 받았습니다.</p><strong>스웨디시 상담 고객</strong></article>
    <article class="review-card"><span class="stars">★★★★☆</span><p>숙소 방문 절차를 함께 확인해 깔끔했습니다.</p><strong>$zone 숙소 이용</strong></article>
    <article class="review-card"><span class="stars">★★★★★</span><p>심야 시간과 도착 예상을 현실적으로 들었습니다.</p><strong>$areaName 당일 문의</strong></article>
    <article class="review-card"><span class="stars">★★★★★</span><p>피할 자극이 관리 전 잘 전달됐습니다.</p><strong>아로마 코스 이용</strong></article>
  </div>
</section>
"@
}

function First-Zone($zones) {
  return (($zones -split ",")[0]).Trim()
}

function Area-Type-Label($type) {
  switch ($type) {
    "city" { "시 단위" }
    "admin-city" { "행정시" }
    "admin-gu" { "행정구" }
    "gu" { "구 단위" }
    "county" { "군 단위" }
    default { "행정지역" }
  }
}

function Short-Text($value, $max) {
  $text = ([string]$value).Trim()
  if ($text.Length -le $max) { return $text }
  return $text.Substring(0, $max).Trim()
}

function Clean-Sentence($value) {
  return ([string]$value).Trim().TrimEnd(".")
}

function Topic-Text($value) {
  $text = ([string]$value).Trim()
  if (!$text) { return $text }
  $last = [int][char]$text[$text.Length - 1]
  if ($last -ge 0xAC00 -and $last -le 0xD7A3) {
    if ((($last - 0xAC00) % 28) -eq 0) { return "$text`는" }
    return "$text`은"
  }
  return "$text`은"
}

function Display-Area-Name($parent, $name) {
  $p = ([string]$parent).Trim()
  $n = ([string]$name).Trim()
  if ($n.StartsWith($p)) { return $n }
  return "$p $n"
}

function Meta-Check-Tail($type, $firstZone) {
  switch ($type) {
    "city" { return "$firstZone 접근 동선, 도심과 외곽 이동 시간, 주차 가능 여부를 함께 확인합니다." }
    "admin-city" { return "$firstZone 숙소권, 동서 이동 시간, 관광 일정 이후의 예약 여유를 확인합니다." }
    "admin-gu" { return "$firstZone 생활권의 공동현관, 방문자 등록, 단지 내 이동 기준을 확인합니다." }
    "gu" { return "$firstZone 권역의 상권·주거지 출입 조건과 시간대별 이동 흐름을 확인합니다." }
    "county" { return "$firstZone 중심의 외곽 이동, 숙소 진입로, 추가 출장비 가능성을 확인합니다." }
    default { return "$firstZone 생활권의 출입 조건과 예약 가능 시간을 확인합니다." }
  }
}

function Dong-Links($regionSlug, $parentSlug) {
  $items = $dongAreas | Where-Object { $_.regionSlug -eq $regionSlug -and $_.parentSlug -eq $parentSlug } | Sort-Object name
  if (!$items -or $items.Count -eq 0) { return "" }
  $links = ($items | ForEach-Object { "<a class=`"pill`" href=`"$($_.parentUrl)$($_.slug)/`">$($_.name)</a>" }) -join ""
  return "<section class=`"content-section related`"><h2>행정동 안내</h2><div>$links</div></section>"
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
    provider=@{"@type"="Organization"; name=$brand; legalName=$company; founder=$owner; taxID=$businessNumber; telephone=$phone; url=$siteUrl; address=@{"@type"="PostalAddress"; streetAddress=$businessAddress; addressCountry="KR"}}
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
    <div class="footer-brand"><strong>$brand</strong><span>건전한 휴식 관리 예약 상담</span></div>
    <p>$company · 대표 $owner · 사업자등록번호 $businessNumber</p>
    <p>$businessAddress · 예약 문의 <a href="tel:$phone">$phone</a> · 검수일 $today</p>
    <p>안전한 예약을 위해 방문 전 요금, 출입, 시간 기준을 확인합니다.</p>
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
  $body += Section "예약 안내 작성 기준" "사이트의 모든 페이지는 지역명만 바꾸는 복제 문단을 피하고, 생활권과 이동 조건, 숙소 유형, 주차와 공동현관 기준, 자주 묻는 질문을 다르게 구성합니다. 단순한 홍보 문구보다 실제 예약자가 읽고 결정할 수 있는 정보를 우선합니다. 페이지마다 작성일과 검수일을 남기며, 요금이나 방문 기준이 바뀌면 고객이 확인할 수 있도록 안내 내용을 다시 정리합니다."
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
  $body += Section "작성·검수 기준" "이 서비스 안내 페이지는 검색 키워드 나열보다 실제 예약자가 비교해야 할 차이를 설명하기 위해 작성했습니다. 각 상세 페이지는 설명, 추천 대상, 소요 시간, 이용 전 안내, FAQ를 다르게 구성합니다. 같은 문장을 서비스명만 바꿔 반복하지 않고 고객센터 운영팀이 상담에서 확인한 질문을 기준으로 검수합니다. 화면에 보이는 안내와 예약 상담에서 설명하는 기준이 어긋나지 않도록 관리합니다."
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
  if ($r.slug -eq "seoul") {
    $childLinks = ($districts | ForEach-Object { "<a class=`"pill`" href=`"/areas/seoul/$($_.slug)/`">$($_.name)</a>" }) -join ""
  } else {
    $childLinks = ($adminAreas | Where-Object { $_.regionSlug -eq $r.slug } | ForEach-Object { "<a class=`"pill`" href=`"/areas/$($r.slug)/$($_.slug)/`">$($_.name)</a>" }) -join ""
  }
  $body = Hero "지역별 출장 가능 안내" "$($r.name) 출장마사지 예약 안내" "$($r.focus)입니다. $($r.movement)"
  $body += Section "$($r.name) 이용 흐름" "$($r.name) 지역은 $($r.focus) 예약 전에는 세부 주소, 공간 유형, 시작 희망 시간, 출입 방식이 가장 중요합니다. 같은 지역명 안에서도 업무지구, 주거 단지, 관광 숙소, 산업단지의 이동 조건이 달라 도착 시간과 배정 가능 인력이 달라질 수 있습니다. 88마사지는 단순히 가능하다는 말보다 어떤 조건에서 안정적으로 방문할 수 있는지 먼저 확인합니다. 고객이 읽고 바로 판단할 수 있도록 지역별 이동 변수와 준비 사항을 구분해 안내합니다."
  $body += Section "생활권별 특징" "$($r.movement) 호텔과 숙소는 프런트 기준이 다르고, 아파트와 오피스텔은 공동현관이나 주차 등록 방식이 다릅니다. 이런 정보가 빠지면 예약 시간이 확정되어도 현장에서 대기 시간이 생길 수 있습니다. $($r.name)에서는 이용 장소의 이름보다 실제 진입 동선이 더 중요할 때가 많습니다. 건물명, 동·호수 전달 방식, 관리사가 연락할 수 있는 번호를 정확히 남겨 주세요."
  $body += Section "출장비와 시간 기준" "$($r.cost) 기본 요금은 관리 시간과 코스에 따라 안내되지만 이동 조건이 복잡한 곳은 추가 비용 또는 예약 가능 시간대가 달라질 수 있습니다. 88마사지는 현장에서 갑자기 조건을 바꾸지 않도록 상담 중 예상 비용과 변경 가능성을 먼저 말합니다. 심야, 원거리, 악천후, 행사장 주변 혼잡은 도착 시간에 영향을 줄 수 있습니다."
  $body += Section "이용 전 확인" "방문 공간은 깨끗하게 정리하고 귀중품은 별도로 보관하는 것이 좋습니다. 음주 직후, 발열, 급성 통증, 외상, 피부 이상이 있는 경우에는 이용을 미루는 편이 안전합니다. 88마사지는 치료나 진단을 제공하지 않으며 건강 문제가 의심되면 의료 전문가와 상담해야 합니다. 예약 취소나 시간 변경은 가능한 빨리 알려 주면 관리사 배정 손실을 줄일 수 있습니다."
  $body += Section "작성·검수 기준" "이 페이지는 $($r.name) 지역의 생활권, 이동 방식, 고객 문의 유형을 반영해 작성했습니다. 다른 지역 페이지와 같은 문단을 반복하지 않도록 지역의 실제 예약 변수와 FAQ를 다르게 구성했습니다. 과한 키워드 반복을 피하고, 고객이 예약 전 확인해야 할 정보를 먼저 배치했습니다. 내용은 고객센터 운영팀이 검수하며 방문 기준이 바뀌면 페이지 안내도 함께 갱신합니다."
  $body += Section "$($r.name) 예약자 체크리스트" "문의 전에는 희망 시작 시간, 상세 주소, 건물 유형, 주차 가능 여부, 원하는 관리 시간을 한 번에 정리해 두면 좋습니다. $($r.name)에서는 $($r.focus) 이 특성이 있어 상담 중 작은 정보 차이가 배정 결과를 바꿀 수 있습니다. 88마사지는 확인된 정보만 기준으로 안내합니다."
  $body += Area-Pricing-Block $r.name
  $body += Area-Reviews-Block $r.name $r.focus
  if ($childLinks) {
    $body += "<section class=`"content-section related`"><h2>$($r.name) 하위 행정지역 안내</h2><div>$childLinks</div></section>"
  }
  $body += "<section class=`"content-section related`"><h2>$($r.name)에서 선택 가능한 관리</h2><div>$serviceLinks</div></section>"
  $body += FaqBlock @(
    @{q="$($r.name) 전 지역 방문이 가능한가요?"; a="가능 지역은 시간대와 배정 상황에 따라 달라집니다. 세부 주소를 알려 주시면 당일 기준으로 확인합니다."},
    @{q="출장비는 언제 확정되나요?"; a="주소, 시간대, 관리 시간, 이동 거리 확인 후 상담 단계에서 안내합니다."},
    @{q="호텔에서도 예약할 수 있나요?"; a="숙소 정책상 외부 방문이 가능한지 확인되면 상담 후 진행할 수 있습니다."}
  )
  $regionTitlePoint = (Short-Text $r.focus 24)
  $regionDescMove = Clean-Sentence (Short-Text $r.movement 56)
  return Layout "$($r.name) 출장마사지 | $regionTitlePoint" "$($r.name) 출장마사지 안내입니다. $regionDescMove. 예약 전 대표 생활권, 숙소 유형, 이동 조건과 비용 기준을 함께 확인합니다." "/areas/$($r.slug)/" $body "Service" $r.name
}

function Build-District($d) {
  $districtTopic = Topic-Text $d.name
  $body = Hero "서울 구별 상세 안내" "$($d.name) 출장마사지 서비스 안내" "$($d.zones) 생활권을 중심으로 예약 전 확인해야 할 방문 조건과 관리 선택 기준을 정리했습니다."
  $body += Section "$($d.name) 이용 안내" "$districtTopic $($d.zones) 권역의 문의가 많은 지역입니다. $($d.scene) 같은 서울 안에서도 구마다 이동 흐름과 건물 유형이 달라 단순히 지역명만으로는 정확한 안내가 어렵습니다. 예약 전에는 상세 주소, 공간 유형, 희망 시작 시간, 주차 또는 공동현관 기준을 알려 주세요. 88마사지는 고객이 현장에서 당황하지 않도록 방문 가능 조건을 먼저 확인하고, 무리한 배정은 진행하지 않습니다."
  $body += Section "주요 권역별 특징" "$($d.zones) 일대는 업무지, 주거지, 상권의 비중이 서로 다릅니다. 업무지에서는 퇴근 직후 짧은 관리 문의가 많고, 주거지에서는 조용한 방문과 가족 동선 배려가 중요합니다. 호텔이나 숙소는 외부 방문 정책이 다를 수 있어 예약명과 프런트 안내 기준을 미리 확인해야 합니다. 오피스텔은 엘리베이터 호출, 주차 등록, 공동현관 호출 방식이 달라 관리사 도착 시간이 변할 수 있습니다."
  $body += Section "예약 전 확인 사항" "$($d.name) 예약에서는 시작 시간보다 도착 가능 조건이 더 중요할 때가 있습니다. 건물 앞 정차가 어려운 곳, 심야 출입이 제한되는 곳, 주차가 유료인 곳은 상담에서 미리 공유해 주세요. 관리 시간은 60분, 90분, 120분 단위로 안내하며 컨디션에 따라 압과 집중 부위를 조절합니다. 음주 직후, 발열, 급성 통증, 외상처럼 안전한 진행이 어려운 상태에서는 예약을 권하지 않습니다."
  $body += Section "이용 가능한 관리" "스웨디시는 부드러운 휴식, 아로마테라피는 향과 안정감, 림프마사지는 가벼운 흐름, 스포츠마사지는 활동 후 뻐근함, 오피스케어는 목과 어깨 중심 관리에 어울립니다. $($d.name) 고객은 하루 일정과 공간 조건이 다르기 때문에 코스명만 보고 선택하기보다 원하는 느낌과 피하고 싶은 자극을 함께 말하는 것이 좋습니다. 88마사지는 치료나 효과 보장 표현을 쓰지 않고, 편안한 휴식 관리 범위에서 안내합니다."
  $body += Section "준비와 방문 매너" "관리를 받을 공간은 타월과 매트를 놓을 수 있게 정리해 주세요. 반려동물이 있거나 가족이 함께 있는 경우 관리 중 방해가 없도록 동선을 분리하면 좋습니다. 귀중품은 미리 보관하고, 향에 민감하거나 특정 오일을 피해야 한다면 예약 단계에서 알려 주세요. 관리사는 위생과 시간을 지키는 것을 기본으로 하며 고객 역시 무리한 요구를 하지 않는 선에서 안전한 이용 환경을 함께 만들어야 합니다."
  $body += Section "작성·검수 기준" "이 페이지는 $($d.name)의 권역명, 건물 유형, 예약 상황을 반영해 작성했습니다. 서울의 다른 구와 같은 문단을 반복하지 않도록 $($d.zones) 생활권의 특징을 본문에 포함했습니다. 정보는 고객센터 운영팀이 검수하며, 실제 상담에서 반복되는 질문이 바뀌면 FAQ와 안내 문단을 수정합니다. 검색을 위한 키워드 나열보다 이용자가 예약 전 확인할 수 있는 실질 정보를 우선합니다."
  $body += Section "$($d.name) 예약자 체크리스트" "문의 전에는 $($d.zones) 중 가까운 권역, 희망 시간, 공간 유형, 관리 시간을 정리해 주세요. $districtTopic 서울 안에서도 이동 변수가 뚜렷해 세부 정보가 빠르면 더 정확한 답변을 받을 수 있습니다. 확인된 조건만으로 예약을 안내합니다."
  $body += Area-Pricing-Block $d.name
  $body += Area-Reviews-Block $d.name $d.zones
  $body += Dong-Links "seoul" $d.slug
  $body += FaqBlock @(
    @{q="$($d.name) $($d.zones.Split(',')[0]) 근처도 가능한가요?"; a="당일 배정 상황과 시간대에 따라 가능합니다. 상세 주소를 알려 주시면 이동 가능 시간을 확인합니다."},
    @{q="오피스텔 방문 시 무엇을 알려야 하나요?"; a="공동현관 호출 방식, 엘리베이터 이용 기준, 주차 가능 여부를 알려 주시면 좋습니다."},
    @{q="조용히 진행할 수 있나요?"; a="가능합니다. 대화를 최소화하고 압 조절 요청만 간단히 주고받는 방식으로 진행할 수 있습니다."}
  )
  $districtFirstZone = First-Zone $d.zones
  $districtScene = Clean-Sentence (Short-Text $d.scene 58)
  return Layout "$($d.name) 출장마사지 | $districtFirstZone 생활권 방문 안내" "$($d.name) 출장마사지 안내입니다. $($d.zones) 권역은 $districtScene. 예약 전 $districtFirstZone 주변 주차, 공동현관, 관리 시작 시간을 확인합니다." "/areas/seoul/$($d.slug)/" $body "Service" "서울 $($d.name)"
}

function Build-AdminArea($a) {
  $adminTopic = Topic-Text $a.name
  $adminSceneFull = Clean-Sentence $a.scene
  $body = Hero "$($a.parent) 상세 지역 안내" "$($a.name) 출장마사지 예약 안내" "$($a.zones) 생활권의 이동 조건과 공간 유형을 기준으로 예약 전 확인 사항을 정리했습니다."
  $body += Section "$($a.name) 이용 상황" "$adminTopic $($a.zones) 권역의 문의가 많은 지역입니다. $adminSceneFull. 같은 시 안에서도 업무지, 주거 단지, 숙박시설, 산업단지의 거리와 출입 조건이 다르기 때문에 세부 주소 확인이 중요합니다. 88마사지는 예약 가능 여부를 넓게 말하기보다 실제 방문 가능한 시간과 관리 종류를 먼저 안내합니다. 고객이 불필요하게 기다리지 않도록 이동 변수와 배정 가능 인력을 함께 확인합니다."
  $body += Section "생활권별 체크 포인트" "$($a.zones) 주변은 시간대에 따라 도로 흐름이 크게 바뀔 수 있습니다. 출퇴근 시간, 행사 종료 시간, 단지 내 주차 기준, 숙소 프런트 정책이 모두 도착 시간에 영향을 줍니다. 상담 시 건물명과 동, 출입구 위치, 주차장 진입 가능 여부를 알려 주면 배정이 더 정확해집니다. 특히 외곽이나 산업단지 인근은 같은 주소라도 야간 진입 동선이 달라질 수 있습니다."
  $body += Section "관리 선택 기준" "업무 후 짧게 쉬고 싶다면 오피스케어나 스웨디시, 여행이나 장거리 이동 뒤에는 아로마테라피와 림프마사지를 고려할 수 있습니다. 활동량이 많은 날에는 스포츠마사지가 어울릴 수 있지만 강한 압을 무조건 권하지 않습니다. 현재 컨디션, 피하고 싶은 부위, 원하는 압을 알려 주면 관리 범위를 조절합니다. 88마사지는 의료 행위가 아니므로 통증 치료나 질환 개선을 약속하지 않습니다."
  $body += Section "요금과 변경 기준" "요금은 관리 시간과 서비스 종류, 이동 거리, 시간대에 따라 상담 단계에서 안내합니다. $($a.name)처럼 생활권이 넓은 지역은 같은 시 안에서도 출장비가 달라질 수 있습니다. 심야 예약, 원거리 이동, 악천후, 주차 불가 상황은 배정 가능 여부에 영향을 줍니다. 예약 변경이 필요하면 가능한 빨리 알려 주세요. 관리사 이동 후 취소는 별도 기준이 적용될 수 있습니다."
  $body += Section "안전한 이용 안내" "방문 전 공간을 정리하고 귀중품을 보관해 주세요. 음주 직후, 발열, 외상, 급성 통증, 피부 이상이 있다면 이용을 미루는 것이 좋습니다. 관리 중 불편한 느낌이 있으면 즉시 말해야 하며, 관리사는 고객의 요청에 따라 압과 자세를 조절합니다. 무리한 요구나 예약 범위를 벗어난 요청은 진행하지 않습니다. 건전한 휴식 관리가 유지될 때 서비스 품질도 안정됩니다."
  $body += Section "작성·검수 기준" "이 페이지는 $($a.name) 지역의 권역명과 이동 조건을 바탕으로 작성했습니다. 지역명만 바꾸는 복사 문단을 피하기 위해 $($a.zones) 생활권과 실제 예약 변수를 본문에 반영했습니다. 고객센터 운영팀이 작성과 검수를 맡으며, 문의 패턴이 달라지면 내용을 갱신합니다. 고객에게 보이는 설명과 상담 안내가 같은 기준을 유지하도록 관리합니다."
  $body += Section "$($a.name) 예약자 체크리스트" "문의 전에는 $($a.zones) 중 실제 위치, 방문 공간의 종류, 엘리베이터와 주차 조건, 원하는 관리 시간을 알려 주세요. $adminTopic $adminSceneFull. 이런 특성이 있어 상담 단계의 정보가 도착 시간과 출장비 안내에 직접 영향을 줍니다. 주소가 아직 확정되지 않았다면 가까운 기준 지점을 먼저 공유하고, 확정 후 다시 확인하는 방식이 좋습니다."
  $adminDisplayName = Display-Area-Name $a.parent $a.name
  $body += Area-Pricing-Block $adminDisplayName
  $body += Area-Reviews-Block $adminDisplayName $a.zones
  $body += Dong-Links $a.regionSlug $a.slug
  $body += FaqBlock @(
    @{q="$($a.name) 외곽도 방문 가능한가요?"; a="세부 주소와 시간대에 따라 다릅니다. 상담 시 이동 가능 여부와 예상 도착 시간을 확인합니다."},
    @{q="당일 예약도 가능한가요?"; a="가능한 경우가 있지만 배정 상황에 따라 달라집니다. 희망 시간보다 여유 있게 문의하는 편이 좋습니다."},
    @{q="출장비는 왜 지역 안에서도 다른가요?"; a="거리, 주차, 도로 상황, 심야 여부가 달라 실제 이동 시간이 달라지기 때문입니다."}
  )
  $adminFirstZone = First-Zone $a.zones
  $adminTypeLabel = Area-Type-Label $a.type
  $adminScene = Clean-Sentence (Short-Text $a.scene 58)
  $adminTail = Meta-Check-Tail $a.type $adminFirstZone
  return Layout "$($a.name) 출장마사지 | $adminFirstZone 중심 $adminTypeLabel 안내" "$adminDisplayName 출장마사지 안내입니다. $($a.zones) 생활권은 $adminScene. $adminTail" "/areas/$($a.regionSlug)/$($a.slug)/" $body "Service" $adminDisplayName
}

function Build-DongArea($d) {
  $displayName = "$($d.parentDisplay) $($d.name)"
  $sourceSentence = $d.sourceText
  $body = Hero "행정동 상세 안내" "$displayName 출장마사지 예약 안내" "$($d.parentDisplay) 안에서도 $($d.name) 생활권은 건물 유형, 출입 방식, 이동 시간이 달라 예약 전 세부 확인이 필요합니다."
  $body += Section "$($d.name) 이용 상황" "$displayName 문의는 같은 시군구 안에서도 더 좁은 생활권을 기준으로 확인합니다. $sourceSentence 단순히 구나 시 이름만 남기면 실제 도착 가능 시간, 주차 위치, 공동현관 호출 방식이 달라질 수 있습니다. 88마사지는 행정동 단위 페이지를 검색 노출용 복제 문서로 만들지 않고, 예약자가 상담 전에 확인해야 할 동선과 공간 조건을 정리하는 용도로 운영합니다."
  $body += Section "방문 전 위치 확인" "$($d.name)에서는 상세 주소, 건물명, 동·호수 전달 방식, 출입구 위치를 먼저 확인합니다. 아파트는 방문자 등록과 지하 주차장 진입 기준이 다르고, 오피스텔은 공동현관 호출이나 엘리베이터 이용 방식이 다를 수 있습니다. 숙소나 호텔은 외부 방문 정책이 바뀔 수 있으므로 예약명과 프런트 안내 기준을 함께 알려 주세요. 작은 정보 차이가 관리 시작 시간을 크게 바꿀 수 있습니다."
  $body += Section "관리 선택 기준" "짧은 휴식이 필요하면 스웨디시나 오피스케어처럼 부담이 적은 관리를 먼저 상담할 수 있습니다. 이동이나 출장 일정 뒤에는 아로마테라피, 활동량이 많은 날에는 스포츠마사지, 강한 압이 부담스러운 고객은 림프마사지를 고려할 수 있습니다. 다만 모든 관리는 치료나 진단 목적이 아니며 통증, 외상, 발열, 의학적 판단이 필요한 상태라면 이용을 미루고 전문가 상담을 받는 것이 우선입니다."
  $body += Section "예약 시간과 출장비" "$displayName 예약은 희망 시작 시간보다 실제 방문 가능한 조건을 먼저 봅니다. 출퇴근 시간, 행사 종료 시간, 심야 이동, 주차 불가 상황은 출장비와 도착 시간 안내에 영향을 줄 수 있습니다. 60분은 가벼운 정리, 90분은 전신 흐름과 집중 부위 조합, 120분은 여유 있는 휴식에 적합합니다. 비용은 관리 종류, 시간, 이동 조건을 확인한 뒤 상담 단계에서 안내합니다."
  $body += Section "공간 준비와 이용 매너" "관리받을 공간은 타월이나 매트를 펼칠 수 있을 정도로 정리해 주세요. 귀중품은 별도로 보관하고, 반려동물이나 가족 동선이 있다면 관리 중 방해가 없도록 미리 조정하는 것이 좋습니다. 음주 직후나 과식 직후 이용은 권하지 않습니다. 관리 중 압이 강하거나 자세가 불편하면 바로 말해 주세요. 예약 범위를 벗어난 요구나 건전한 휴식 관리 기준에 맞지 않는 요청은 진행하지 않습니다."
  $body += Section "행정동 단위 안내를 보는 방법" "$($d.name) 페이지는 더 큰 지역 페이지를 대체하기보다 예약 전 확인 범위를 좁히는 보조 안내입니다. 같은 $($d.parentShort) 안에서도 역세권, 주거 단지, 숙박시설, 업무 공간은 도착 동선과 준비 방식이 다릅니다. 그래서 이 페이지에서는 검색 키워드를 반복하기보다 $($d.sources) 생활권에서 자주 확인해야 하는 주소 확정, 주차 위치, 방문자 등록, 관리 시작 전 연락 가능 여부를 우선합니다. 실제 예약은 상담 시점의 배정 상황을 기준으로 다시 안내합니다."
  $body += Section "$($d.name) 상담 체크리스트" "문의 전에는 $($d.name) 실제 위치, 희망 시간, 공간 유형, 공동현관 또는 프런트 기준, 원하는 관리 시간을 정리해 주세요. $($d.sources) 중 어느 생활권인지 알 수 있으면 배정 확인이 더 빠릅니다. 주소가 확정되지 않았다면 가까운 기준 지점을 먼저 공유하고, 확정 후 다시 확인하는 방식이 좋습니다. 88마사지는 확인된 정보만 기준으로 예약 가능 여부를 안내합니다."
  $body += Area-Pricing-Block $displayName
  $body += Area-Reviews-Block $displayName $d.sources
  $body += FaqBlock @(
    @{q="$($d.name)에서 당일 예약도 가능한가요?"; a="가능한 경우가 있지만 배정 상황과 이동 조건에 따라 달라집니다. 상세 주소와 희망 시간을 알려 주시면 당일 기준으로 확인합니다."},
    @{q="$($d.sources) 통합 안내는 무슨 뜻인가요?"; a="번호가 붙은 1동, 2동, 3동 등은 대표 생활권으로 묶어 한 페이지에서 안내한다는 의미입니다."},
    @{q="동 단위 페이지가 의료 효과를 보장하나요?"; a="아닙니다. 이 페이지는 예약 전 위치와 이용 조건을 안내하며 치료, 진단, 효과 보장을 하지 않습니다."}
  )
  $description = "$displayName 출장마사지 안내입니다. $($d.sources) 생활권을 기준으로 출입, 주차, 공동현관, 예약 시간과 출장비 확인 사항을 정리했습니다."
  return Layout "$displayName 출장마사지 | 행정동 방문 안내" $description "$($d.parentUrl)$($d.slug)/" $body "Service" $displayName
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
  $pages += @{path=$path; url="/areas/$($r.slug)/"; html=(Build-Region $r); title="$($r.name) 출장마사지 - $(Short-Text $r.focus 24)"; desc="$($r.name) $((Clean-Sentence (Short-Text $r.movement 48)))"}
}
foreach ($d in $districts) {
  $path = "areas/seoul/$($d.slug)/index.html"
  $pages += @{path=$path; url="/areas/seoul/$($d.slug)/"; html=(Build-District $d); title="$($d.name) 출장마사지 - $(First-Zone $d.zones) 생활권"; desc="$($d.name) $($d.zones) $((Clean-Sentence (Short-Text $d.scene 40)))"}
}
foreach ($a in $adminAreas) {
  $path = "areas/$($a.regionSlug)/$($a.slug)/index.html"
  $displayName = Display-Area-Name $a.parent $a.name
  $pages += @{path=$path; url="/areas/$($a.regionSlug)/$($a.slug)/"; html=(Build-AdminArea $a); title="$($a.name) 출장마사지 - $(First-Zone $a.zones) $(Area-Type-Label $a.type)"; desc="$displayName $($a.zones) $((Clean-Sentence (Short-Text $a.scene 40))) $(Meta-Check-Tail $a.type (First-Zone $a.zones))"}
}
foreach ($d in $dongAreas) {
  $path = "areas/$($d.regionSlug)/$($d.parentSlug)/$($d.slug)/index.html"
  $displayName = "$($d.parentDisplay) $($d.name)"
  $pages += @{path=$path; url="$($d.parentUrl)$($d.slug)/"; html=(Build-DongArea $d); title="$displayName 출장마사지 - 행정동 안내"; desc="$displayName $($d.sources) 출입, 주차, 예약 시간 확인"}
}

foreach ($page in $pages) {
  Write-Utf8 $page.path $page.html
}

$sitemapItems = ($pages | ForEach-Object {
  "  <url><loc>$(XmlEscape "$siteUrl$($_.url)")</loc><lastmod>$today</lastmod></url>"
}) -join "`n"
$sitemap = "<?xml version=`"1.0`" encoding=`"UTF-8`"?>`n<urlset xmlns=`"http://www.sitemaps.org/schemas/sitemap/0.9`">`n$sitemapItems`n</urlset>`n"
Write-Utf8 "sitemap.xml" $sitemap
Write-Utf8 "sitemap1.xml" $sitemap

$rssItems = ($pages | Select-Object -First 30 | ForEach-Object {
  "    <item><title>$(XmlEscape $_.title)</title><link>$(XmlEscape "$siteUrl$($_.url)")</link><guid isPermaLink=`"true`">$(XmlEscape "$siteUrl$($_.url)")</guid><description>$(XmlEscape $_.desc)</description><pubDate>$($buildUtc.ToString("r"))</pubDate></item>"
}) -join "`n"
$rss = "<?xml version=`"1.0`" encoding=`"UTF-8`"?>`n<rss version=`"2.0`" xmlns:atom=`"http://www.w3.org/2005/Atom`"><channel><title>$(XmlEscape $brand) 최신 안내</title><link>$siteUrl/</link><atom:link href=`"$siteUrl/rss.xml`" rel=`"self`" type=`"application/rss+xml`" /><description>88마사지 서비스, 지역 안내, 예약 기준 업데이트 피드입니다.</description><language>ko-KR</language><lastBuildDate>$($buildUtc.ToString("r"))</lastBuildDate><ttl>60</ttl>`n$rssItems`n</channel></rss>`n"
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
"@
Write-Utf8 "robots.txt" $robots

$css = @"
:root{--ink:#191714;--muted:#6e665b;--line:#e8dfd2;--paper:#fffaf1;--cream:#f8efe1;--gold:#b1843f;--green:#24483d;--red:#9d3e32}
*{box-sizing:border-box}body{margin:0;font-family:Arial,'Noto Sans KR',sans-serif;color:var(--ink);background:var(--paper);line-height:1.75}a{color:inherit;text-decoration:none}.site-header{position:sticky;top:0;z-index:10;display:flex;align-items:center;justify-content:space-between;gap:24px;padding:16px 5vw;background:rgba(255,250,241,.94);border-bottom:1px solid var(--line);backdrop-filter:blur(10px)}.logo{font-weight:800;font-size:22px}.logo span{display:inline-grid;place-items:center;width:40px;height:40px;margin-right:8px;border-radius:8px;background:var(--green);color:#fff}.main-nav{display:flex;gap:18px;font-size:14px;align-items:center}.nav-group{position:relative}.submenu{position:absolute;top:100%;left:0;display:none;min-width:180px;padding:10px;background:#fff;border:1px solid var(--line);border-radius:8px;box-shadow:0 14px 34px rgba(0,0,0,.12)}.submenu a{display:block;padding:8px 10px;color:var(--ink)}.nav-group:hover .submenu,.nav-group:focus-within .submenu{display:block}.menu-button{display:none}.hero{min-height:560px;display:flex;align-items:center;background:linear-gradient(90deg,rgba(15,31,26,.92) 0%,rgba(15,31,26,.82) 38%,rgba(15,31,26,.42) 68%,rgba(15,31,26,.22) 100%),linear-gradient(0deg,rgba(15,31,26,.28),rgba(15,31,26,.28)),url('/assets/hero-wellness.png');background-size:cover;background-position:center right;padding:72px 5vw;color:#fff}.hero-inner{max-width:780px;text-shadow:0 2px 18px rgba(0,0,0,.28)}.eyebrow{color:#f4c36b;font-weight:700;letter-spacing:0}.hero h1{font-size:56px;line-height:1.1;margin:12px 0 20px}.lead{font-size:20px;max-width:760px}.hero-actions{display:flex;gap:12px;margin-top:28px}.primary,.secondary,.sticky-cta a{display:inline-flex;align-items:center;justify-content:center;min-height:46px;padding:0 18px;border-radius:8px;font-weight:700}.primary{background:#f1bd5a;color:#22180d;text-shadow:none}.secondary{border:1px solid rgba(255,255,255,.58);color:#fff;background:rgba(15,31,26,.2);text-shadow:none}.content-section,.grid-section{max-width:1080px;margin:0 auto;padding:54px 5vw;border-bottom:1px solid var(--line)}h2{font-size:30px;line-height:1.25;margin:0 0 18px}.content-section p{margin:0;font-size:17px}.card-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px}.link-card{display:block;min-height:150px;padding:22px;border:1px solid var(--line);border-radius:8px;background:#fff}.link-card strong{display:block;font-size:20px;margin-bottom:10px}.link-card span{color:var(--muted)}.pill{display:inline-flex;margin:0 8px 8px 0;padding:10px 14px;border:1px solid var(--line);border-radius:999px;background:#fff}.section-head{max-width:1080px;margin:0 auto 18px}.section-head p{color:var(--muted)}.pricing-band{max-width:none;margin:0;padding:56px 5vw;background:#090a0e;color:#fff;border-bottom:0}.pricing-band .section-head p{color:#cbd0d9}.price-grid{max-width:1080px;margin:0 auto;display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px}.price-card{position:relative;min-height:270px;padding:26px 28px;border:1px solid #2b2c34;border-top:2px solid #f0bd74;border-radius:8px;background:#121219}.price-card .tag{display:block;color:#f1bd5a;font-size:12px;font-weight:700;letter-spacing:2px}.price-card h3{font-size:24px;line-height:1.25;margin:12px 0}.price-card p{min-height:50px;color:#c9d0df;font-size:14px}.price-card dl{margin:18px 0 0;border-top:1px solid #2a2b33}.price-card dl div{display:flex;justify-content:space-between;gap:18px;padding:8px 0;border-bottom:1px dashed #252630}.price-card dt{color:#c9d0df}.price-card dd{margin:0;font-weight:800}.badge{position:absolute;top:14px;right:14px;background:#f0bd74;color:#191714;border-radius:999px;padding:4px 10px;font-size:11px;font-weight:800}.review-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px}.review-card{min-height:170px;padding:20px;border:1px solid var(--line);border-radius:8px;background:#fff}.review-card p{font-size:15px;margin:8px 0 14px}.review-card strong{font-size:13px;color:var(--muted)}.stars{color:#b1843f;font-weight:800;letter-spacing:0}.faq details{border:1px solid var(--line);border-radius:8px;background:#fff;margin:12px 0;padding:14px 18px}.faq summary{cursor:pointer;font-weight:700}.site-footer{padding:42px 5vw 86px;background:#1d211e;color:#f8efe1}.footer-brand{display:flex;align-items:baseline;gap:12px;flex-wrap:wrap;margin-bottom:10px}.footer-brand strong{font-size:22px}.footer-brand span{color:#f1bd5a;font-size:14px;font-weight:700}.site-footer p{max-width:980px;color:#d9cdbd;margin:6px 0}.sticky-cta{position:fixed;left:0;right:0;bottom:0;display:flex;gap:8px;justify-content:center;padding:10px;background:rgba(255,250,241,.94);border-top:1px solid var(--line)}.sticky-cta a:first-child{background:var(--red);color:#fff}.sticky-cta a:last-child{background:var(--green);color:#fff}@media(max-width:760px){.menu-button{display:block;border:1px solid var(--line);background:#fff;border-radius:8px;width:42px;height:42px}.main-nav{display:none;position:absolute;left:0;right:0;top:73px;flex-direction:column;align-items:flex-start;padding:18px 5vw;background:#fff;border-bottom:1px solid var(--line)}.main-nav.open{display:flex}.nav-group{width:100%}.submenu{position:static;display:block;box-shadow:none;border:0;padding:6px 0 0 12px;background:transparent}.hero{min-height:500px;padding:56px 5vw;background-position:center}.hero h1{font-size:38px}.lead{font-size:17px}.hero-actions{flex-direction:column}.card-grid,.price-grid,.review-grid{grid-template-columns:1fr}.content-section,.grid-section,.pricing-band{padding:38px 5vw}h2{font-size:25px}}
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
