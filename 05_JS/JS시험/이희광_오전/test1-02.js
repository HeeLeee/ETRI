/*
문제2.
     1) 매개변수로 숫자 두 개를 받아 첫번째 값을 두번째 값으로 나눈 나머지를 반환하는 함수리터럴을 작성하고 함수와 실행결과 제출
     2) 메소드가 한 개이상 포함된 객체를 정의하고 메소드를 호출해 실행한 결과를 제시하시오.
*/

// 1, 2번 포괄 (객체 메소드가 나눗셈)
function Test(_a, _b) {
  this.a = _a;
  this.b = _b;
  this.doDiv = function() {
    return (this.a / this.b);
  }
}

function div(x, y) {
  var t = new Test(x, y);
  return t.doDiv();
}

div(100, 10) // 10
