class StoreValidator{
  String? validateName(String? value){
    if( value == null || value.isEmpty){
      return '매장명을 입력해주세요';
    } else if(value.length < 2){
      return 'UserName is too short';
    } else {
      return null;
    }
  }

  String? validateLocation(String? value){
    if( value == null || value.isEmpty){
      return '매장 위치를 입력해주세요';
    } else if(value.length < 2){
      return 'UserName is too short';
    } else {
      return null;
    }
  }

  String? validatePhone(String? value){
    if( value == null || value.isEmpty){
      return '매장 전화번호를 입력해주세요';
    } else if(value.length < 2){
      return 'UserName is too short';
    } else {
      return null;
    }
  }

  String? validateTime(String? value){
    if( value == null || value.isEmpty){
      return '매장 운영시간을 입력해주세요';
    } else {
      return null;
    }
  }

  String? validatePayday(String? value){
    if( value == null || value.isEmpty){
      return '급여 지급일을 입력해주세요';
    } else {
      return null;
    }
  }

  String? validateStartDayOfWeek(String? value){
    if( value == null || value.isEmpty) {
      return '근무표 시작 날짜를 입력해주세요';
    } else {
      return null;
    }
  }

  String? validateDeadlineOfSubmit(String? value){
    if( value == null || value.isEmpty) {
      return '근무표 제출 마감 날짜를 입력해주세요';
    }else {
      return null;
    }
  }
}