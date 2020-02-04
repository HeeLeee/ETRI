/*


문제10. 단가와 수량을 멤버로 가진 객체 생성자를 정의합니다
       객체 생성자 프로토타입에 this.단가와 this.수량 정보를 이용해 두 값의 곱을 계산해 금액을 돌려주는 멤버를 추가합니다
       vset의 단가와 수량을 곱한 총 합을 구하고자 합니다.
       앞에서 선언한 객체생성자를 이용해 객체를 한 개만 생성하여 품목들의 총 금액을 계산해 결과를 보여주는 함수를 작성하시오
*/
var set = [
          {item:"pencil", up: 100, qty: 9},
          {item:"eraser", up: 200, qty: 7},
          {item:"notebook", up: 500, qty: 3},
          {item:"compass", up: 300, qty: 2}
        ];

function Product(_up, _qty){ // 생성자
  this.up = _up,
  this.qty = _qty
};

Product.prototype.calc = function(){ // 한 물건의 총 금액 구하는 메소드
  return (this.up * this.qty);
};

var p = new Product(); // 객체생성
var sum = 0;
for (i in set) {
  sum += p.calc.apply(set[i]);
}
console.log("Toal: " + sum); // 4400
