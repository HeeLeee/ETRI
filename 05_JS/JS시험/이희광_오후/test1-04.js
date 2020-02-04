/*
문제4.
      1) 일반형 변수와 참조형 변수의 차이를 설명할 수 있는 함수를 작성하여
      실행 결과를 제시하고 실행결과가 나오는 과정을 설명하시오
      2) 참조형 변수의 변경과 재정의시 일어나는 차이를 설명할 수 있는 프로그램을 작성하여
      결과를 제시하고 결과가 다르게 나오는 이유를 기술하시오
*/


//1)
var normal = "original"; // 일반 변수
var ref = { data: "original" }; // 참조형 변수

function test() {
  let a = normal; // normal변수의 값이 a에 저장
  a = "changed"; // a의 값 조작
  let b = ref; // ref객체의 위치가 b에 저장
  b.data = "changed" //b가 가리키는 위치에 있는 ref.data 조작
}

test();
console.log("normal: " + normal); // original
console.log("ref: " + ref.data); // changed

/*
일반형 변수는 그 값을 새로운 변수에 할당하면, 새로운 변수는 독립적인 위치와 값을 갖지만
참조형 변수값을 새로운 변수에 할당시에는 새로운 변수와 원래의 변수가 같은 위치를 갖고 있어
양 쪽 모두에서 동일한 데이터에 대한 조작을 하게 된다.
*/

//2)
var ref1 = { data: "original" };
var ref2 = ref; // ref2에 참조형 변수 복사
ref1.data = "changed"; // ref1 조작
console.log("ref1: " + ref1.data); // changed
console.log("ref2: " + ref2.data); // changed

var ref3 = { data: "original" };
var ref4 = ref3; // ref4에 참조형 변수 복사
ref3 = { data: "changed" }; // ref3 재정의(ref3에 새로운 참조값 매핑)
console.log("ref3: " + ref3.data); // changed
console.log("ref4: " + ref4.data); // original

/*
ref2의 경우 ref1과 동일한 위치에 대한 참조를 하고 있어
ref1을 통해 데이터를 조작하면 ref2를 통한 데이터 접근에서도 같은 변화가 일어난다.

ref4의 경우 ref3과 동일한 위치에 대한 참조를 하다가
ref3을 재정의 하면서 ref3은 새로운 위치에 대한 참조를 하기 때문에,
ref3과 ref4의 참조 위치는 서로 다른 상태가 된다.

따라서, ref3를 통한 데이터 조작시 ref4를 통해 그 변화를 확인할 수 없다.
*/
