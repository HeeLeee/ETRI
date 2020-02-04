/*
문제5.
      1) 문자열, 시작위치, 종료위치를 매개변수로 주면
         주어진 문자열의 시작위치부터 종료위치 직전까지의 문자열을 결과로 반환하는 함수를 작성하고
	 실행결과를 제시하시오(주의: built in 함수를 쓰지말고 직접 함수를 구현합니다.)
	 예) 함수("abcdefghijk",3,7) = "defg"

   2) 문자열, 치환전문자, 치환후문자 를 매개변수로 주면
   주어진 문자열 내에 존재하는 치환전문자를 모두 치환후문자로 바꿔주는 함수를 구현하고
실행결과를 제시하시오 (주의: replace와 같은 built-in 기능을 쓰지말고 직접 구현)
예) 함수("abcdacdadgnfagha","a","_") = "_bcd_cd_dgnf_gh_"
*/

//1)
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

//2)
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
