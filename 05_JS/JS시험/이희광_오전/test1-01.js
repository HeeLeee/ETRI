var memb = [
  {id:'etri020101', 이름:'김단비', 별명:'찰떡', 성별:'여', 취미:'드라마보기'},
  {id:'etri020102', 이름:'박수호', 별명:'동동이', 성별:'여', 취미:'포켓몬고'},
  {id:'etri020103', 이름:'박승규', 별명:'강아지', 성별:'남', 취미:'잠'},
  {id:'etri020104', 이름:'이우정', 별명:'우동', 성별:'여', 취미:'넷플릭스'},
  {id:"etri020201", 이름:"이희광", 별명:"블랙팬서", 성별:"남", 취미:"와칸다포에버"},
  {id:"etri020202", 이름: "최재원", 별명:"재원쓰", 성별:"남", 취미:"사진"},
  {id:"etri020203", 이름:"이경요", 별명:"경요", 성별:"여", 취미:"유투브"},
  {id:"etri020204", 이름:"김동현", 별명:"아이언맨", 성별:"남", 취미:"자비스"},
  {id:"etri020301",이름:"이승학", 별명: "너구리", 성별:"남",취미:"게임"},
  {id:"etri020302",이름:"박소희",별명: "공룡", 성별:"여",취미:"독서"},
  {id:"etri020303",이름:"이원희",별명: "다람쥐",성별:"남",취미:"영화관람"},
  {id:"etri020304",이름:"송세희",별명: "상어", 성별:"여",취미:"집보기"},
  {id:"etri020401",이름:"김민정",별명:"박명수",성별:"여",취미:"독서"},
  {id:"etri020402",이름:"김은진",별명:"미친개",성별:"여",취미:"노래부르기"},
  {id:"etri020403",이름:"최혜원",별명:"금붕어",성별:"여",취미:"음악감상"},
  {id:"etri020404",이름:"홍민영",별명:"영민홍",성별:"여",취미:"tv보기"},
  {id:"etri020501", 이름:"김동현", 별명:"없음", 성별:"남", 취미:"공중부양"},
  {id:"etri020503", 이름:"유승민", 별명:"근육", 성별:"남", 취미:"다리떨기"},
  {id:"etri020502", 이름:"문수진", 별명:"팔자", 성별:"여", 취미:"모름"},
  {id:"etri020504", 이름:"윤도훈", 별명:"포켓맨", 성별:"남", 취미:"놀라기"},
  {id:"etri020505", 이름:"이준범", 별명:"멋쟁이", 성별:"여", 취미:"남자인척하기"},
  {id:"etri020601", 이름:"권유림", 별명:"권율", 성별:"여", 취미:"영화" },
  {id:"etri020602", 이름:"김영주", 별명:"춘", 성별:"여", 취미:"드라마" },
  {id:"etri020603", 이름:"김흥범", 별명:"하이", 성별:"남", 취미:"영화" },
  {id:"etri020604", 이름:"이준", 별명:"준", 성별:"남", 취미:"수영" },
  {id:'etri020701',이름:"이한구",성별:"남",별명:"한구",취미:"게임"},
  {id:"etri020702",이름:"이종석",성별:"남",별명:"써기",취미:"유도"},
  {id:"etri020703",이름:"조형우",성별:"남",별명:"남",취미:"독서"},
  {id:"etri020801",이름:"박수은",별명:"수은",성별:"여",취미:"영화"},
  {id:"etri020802",이름:"김기민",별명:"기민",성별:"남",취미:"독서"},
  {id:"etri020803",이름:"조영욱",별명:"영욱",성별:"남",취미:"농구"},
  {id:"etri020804",이름:"안혁",별명:"혁",성별:"남",취미:"명상"},
  {id:"etri020805",이름:"조원섭",별명:"원섭",성별:"남",취미:"음악감상"},
  {id:"etri020901", 이름 : "이강민", 별명 : "강민", 성별 : "남", 취미 : "게임"},
  {id:"etri020902", 이름 : "김윤정", 별명 : "윤정", 성별 : "여", 취미 : "독서"}
];

var team =   [
  {tid:1, 조명:"1조", 위치:"출입구옆", 조장:"박승규" },
  {tid:2, 조명:"2조", 위치:"작은기둥앞", 조장:"이경요" },
  {tid:3, 조명:"3조", 위치:"작은기둥옆", 조장:"이원희" },
  {tid:4, 조명:"4조", 위치:"좌측라인끝", 조장:"김민정" },
  {tid:5, 조명:"5조", 위치:"창가앞", 조장:"유승민" },
  {tid:6, 조명:"6조", 위치:"우측라인끝", 조장:"권유림" },
  {tid:7, 조명:"7조", 위치:"큰기둥뒤", 조장:"이한구" },
  {tid:8, 조명:"8조", 위치:"큰기둥앞", 조장:"조원섭" },
  {tid:9, 조명:"9조", 위치:"큰기둥옆", 조장:"김윤정" }
];


// textarea
var ta1 = document.getElementById('ta1');
var ta2 = document.getElementById('ta2');

// 입력창
var name_search = document.getElementById('i-search');

// 조 번호 창
var index_window = document.getElementById('index');

// 인덱스 셀렉터 (현재 선택된 조 번호 갖는 전역변수)
var idx = 1;

// 1번창에 t조 데이터 검색해 표출
function searchTeam(t) {
  if (team[t - 1] == undefined) {
    ta1.value = "잘못된 인덱스입니다(SearchTeam)";
    ta2.value = "";
    return -1;
  }
  ta1.value = ""; // 입력 초기화
  let displayStr = "";

  displayStr += "id : " + team[t - 1].tid + ", "+
          "조명: " + team[t - 1].조명 + ", "+
          "위치: " + team[t - 1].위치 + ", "+
          "조장: " + team[t - 1].조장 + "\n";
  ta1.value = displayStr;

  searchTeamMember(t);
  idx = t;
}

// t조에 포함된 조원 표출
function searchTeamMember(t) {
  ta2.value = "";
  let displayStr = "";
  for (m in memb) {
    if (memb[m].id.slice(6, 8) == Number(t)) { // id에서 조 정보 해당 부분 추출해 ㅂ교
      displayStr += "id : " + memb[m].id + ", "+
              "이름: " + memb[m].이름 + ", "+
              "별명: " + memb[m].별명 + ", "+
              "성별: " + memb[m].성별 + ", "+
              "별명:" + memb[m].취미 +"\n";
    }
  }
  ta2.value += displayStr;
}

// 검색 함수 (이름 또는 인덱스, return = 검색된 인덱스, -1인경우 검색실패)
function search() {
  if(!name_search.value) {
    if (team[index_window.value] == undefined) {
      ta1.value = "잘못된 인덱스 입니다(Search)";
      ta2.value = "";
      return -1;
    } else {
      searchTeam(index_window.value);
    }
  } else {
    let t = teamNameToIdx(name_search.value);
    if(t < 0) {
      ta1.value = "팀 이름을 찾지 못했습니다"
      ta2.value = "";
    } else {
      searchTeam(t);
      displayIdx();
    }
  }
}

// 조명을 찾아 해당 팀 번호로 반환 (t조 아닌 형태의 조 이름에 대응 가능)
function teamNameToIdx(tn) {
  for (t in team) {
    if(team[t].조명 == tn) {
      return Number(t) + 1;
    }
  }
  return -1; // 조 이름과 일치되는 것 찾지 못함
}

// 인덱스 표출(인덱스 창 리프레쉬)
function displayIdx() {
  index_window.value = idx;
}

// 다음 인덱스
function toNext() {
  idx++;
  displayIdx();
  searchTeam(idx);
}

// 이전 인덱스
function toPrev() {
  idx--;
  displayIdx();
  searchTeam(idx);
}

// 첫 인덱스
function toFirst() {
  idx = 1;
  displayIdx();
  searchTeam(idx);
}

// 끝 인데스
function toLast() {
  idx = team.length;
  displayIdx();
  searchTeam(idx);
}
