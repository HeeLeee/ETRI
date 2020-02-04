/*
문제8. 문제7의 객체를 만들어낼 수 있는 객체 생성자 정의하고 객체 생성 결과 제시
*/

function MyArray() { // 생성자
  this.data = [];
  this.method1 = function(a, i1, i2) { // 추가
    if (a instanceof Array) { // 추가 대상이 배열인 경우
      this.data.push(a);
    } else { // 추가 대상이 배열이 아닌 경우
      if (i1 == undefined) { // 인덱스를 입력 안한경우
        throw new Error("Myarray.method1(a, i1, i2): Wrong Input")
      } else if ( this.data[i1] == undefined ) { // i1인덱스 잘못된경우 에러처리
        throw new Error("Myarray.method1(a, i1, i2): i1 index is not exist")
      } else { // 추가 대상이 원소 하나인경우 해당 위치에 입력(또는 대체)
        this.data[i1][i2] = a;
      }
    }
  };
  this.method2 = function(i1, i2) { // 삭제
    if (i2 == undefined) { // i1만 입력
      this.data.splice(i1, 1); // i1번째 요소 삭제
    } else {
      this.data[i1].splice(i2, 1); // i1-i2 요소 삭제
    }
  };
  this.method3 = function() { // 전체 반환
    return this.data;
  };
  this.method4 = function(i) { // 특정 요소 반환
    return this.data[i];
  }
}

var myArray = new MyArray(); // 객체 생성

// 명령문
myArray.method1([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
myArray.method1([10, 11, 12, 13, 14, 15, 16, 17, 18, 19]);
myArray.method1([20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
myArray.method1("I'm 25", 2, 5);
myArray.method4(2); // [20, 21, 22, 23, 24, "I'm 25", 26, 27, 28, 29]
myArray.method2(0, 9);
myArray.method4(0); // [0, 1, 2, 3, 4, 5, 6, 7, 8]
myArray.method2(0); // 0~9 삭제
myArray.method2(1); // 20~29 삭제
myArray.method3(); // [10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
