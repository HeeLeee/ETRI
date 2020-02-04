/*
문제6.
      1) 5번에서 만든 두 함수 리터럴을 배열에 저장하고 배열에 저장된 함수를 실행시켜
      다음 문제의 실행 결과를 제시하시오
      "ABCDABCDABCD" 의 0번 index에서 7번 index 까지의 문자중 "C" 를 space로 바꾼결과
      2) 객체를 프로퍼티의 값으로 갖는 서로 다른 객체 2개를 선언하고 해당 객체 값들을 불러내는
          서로 다른 방법을 두 가지를 이용해 값을 불러내시오.
*/
//1)

// from test1-05.js
function mySlice(str, start_i, end_i) {
  let l = str.length; // 문자열 길이(end_i가 길이 이상이더라도 길이 이상의 루프 회피 위함)
  if (start_i < 0) { start_i = 0 } // start_i가 음수일 때 예외처리
  if (typeof str != 'string') { // 에러반환: 스트링 아닐 때
    throw new Error("mySlice(str, start_i, end_i): str is now a string");
  } else if (start_i > end_i) { // 에러반환: end_i가 더 작을때
    throw new Error("mySlice(str, start_i, end_i): end_i cannot be bigger than start_i");
  } else { // 정상동작
    let result = "";
    for (let i = start_i; i < end_i && i < l; i++) {
      result += str[i];
    }
    return result;
  }
}
function myReplace(str, toFind, toReplace) {
  let result = "";
  if (typeof str != 'string') { // 에러반환: 스트링 아닐 때
    throw new Error("myReplace(str, toFind, toReplace): str is now a string");
  } else if(toFind.length != 1 || toReplace.length != 1) {
    throw new Error("myReplace(str, toFind, toReplace): toFind, toReplace shoud be one charactor")
  } else {
    for (i in str) {
      if (str[i] == toFind) { // 문자 찾기
        result += toReplace; // 치환문자 삽입
      } else {
        result += str[i]; // 원래문자 삽입
      }
    }
    return result;
  }
}

var strFunc = [mySlice, myReplace];
var iStr = "ABCDABCDABCD";

console.log(
  strFunc[1](
      strFunc[0](iStr, 0, 8), //  자른 문자를 치환 함수 인수로
      "C",
      " "
  )
)

// 2)
var mainObj = {
  subObj1: {
    data: "hello"
  },
  subObj2: {
    data: "hi"
  }
}

console.log(mainObj.subObj1.data); // 방법1
console.log(mainObj['subObj2']['data']); // 방법2 (따옴표 없으면 변수)
