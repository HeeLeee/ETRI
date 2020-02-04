/*
문제7. 다음 정보를 관리할 수 있는 객체를 정의하고 객체가 정상 작동하는 것을 확인할 수 있는
명령문을 작성하세요
    요구사항 :
      1) 2차원 배열정보를 관리할 수 있어야 합니다.
      2) 요구 메소드의 기능
         메소드1(원소, index1, index2) 배열 원소를 매개변수로 전달하면 해당 원소가 배열인 경우 바로 배열에 push
	         배열이 아닌 경우 index 정보를 이용해 인덱스에 해당하는 배열 원소에 push
		 배열원소가 아니면서 index 가 전달되지 않은 경우 에러 반환
         메소드2(index1,index2) index1만 전달되면 해당원소 배열 삭제
	         index1, index2가 모두 전달되면 해당 2차원 원소 삭제
         메소드3() 배열전체 정보를 반환
	 메소드4(index) index 위치에 해당하는 1차원 배열정보 반환
      3) 위의 배열관리 객체가 정상하는지 확인하는 확인용 명령문
*/

var myArray = {
  data: [],
  method1: function(a, i1, i2) { // 추가
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
  },
  method2: function(i1, i2) { // 삭제
    if (i2 == undefined) { // i1만 입력
      this.data.splice(i1, 1); // i1번째 요소 삭제
    } else {
      this.data[i1].splice(i2, 1); // i1-i2 요소 삭제
    }
  },
  method3: function() { // 전체 반환
    return this.data;
  },
  method4: function(i) { // 특정 요소 반환
    return this.data[i];
  }
}

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
