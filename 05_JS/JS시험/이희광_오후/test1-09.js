/*
문제9.
     1) 문제7의 객체와 같은 기능을 수행하는 클로져 정의

     2) 클로져를 이용해 2개의 객체를 관리하는 샘플을 작성하고 정상작동 여부를 확인할 수 있는 명령문 작성
*/

//1)
function MyArray() { // 생성자
  //private data
  var data =[];

  function method1(a, i1, i2) { // 추가
    if (a instanceof Array) { // 추가 대상이 배열인 경우
      data.push(a);
    } else { // 추가 대상이 배열이 아닌 경우
      if (i1 == undefined) { // 인덱스를 입력 안한경우
        throw new Error("Myarray.method1(a, i1, i2): Wrong Input")
      } else if ( data[i1] == undefined ) { // i1인덱스 잘못된경우 에러처리
        throw new Error("Myarray.method1(a, i1, i2): i1 index is not exist")
      } else { // 추가 대상이 원소 하나인경우 해당 위치에 입력(또는 대체)
        data[i1][i2] = a;
      }
    }
  };
  function method2(i1, i2) { // 삭제
    if (i2 == undefined) { // i1만 입력
      data.splice(i1, 1); // i1번째 요소 삭제
    } else {
      data[i1].splice(i2, 1); // i1-i2 요소 삭제
    }
  };
  function method3() { // 전체 반환
    return data;
  };
  function method4(i) { // 특정 요소 반환
    return data[i];
  };
  return { // 클로저를 통한 public 메소드
    a_add: method1,
    a_del: method2,
    a_displayAll: method3,
    a_display: method4
  }
}

myArray = new MyArray();

// 명령문
myArray.a_add([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
myArray.a_add([10, 11, 12, 13, 14, 15, 16, 17, 18, 19]);
myArray.a_add([20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
myArray.a_add("I'm 25", 2, 5);
myArray.a_display(2); // [20, 21, 22, 23, 24, "I'm 25", 26, 27, 28, 29]
myArray.a_del(0, 9);
myArray.a_display(0); // [0, 1, 2, 3, 4, 5, 6, 7, 8]
myArray.a_del(0); // 0~9 삭제
myArray.a_del(1); // 20~29 삭제
myArray.a_displayAll(); // [10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
