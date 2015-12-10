import 'package:angular/angular.dart';
import 'package:angular_ui/angular_ui.dart';
import 'dart:convert';
import 'dart:html';
import 'BaseComponents.dart';

@Component(
    selector: 'login_comp',
    templateUrl: 'Users/login.html',
    useShadowDom: false
)
class LoginComponent extends BaseComponent {
  String email="";
  String password="";

  String backdrop = 'true';
  //@NgTwoWay('isHttpLoading')
  bool isHttpLoading = false;
  @NgTwoWay('isCollapsed')
  bool isCollapsed = true;
  String errorMessage ="message";
  NgRoutingHelper locationService;

  void loginUser(String email, String password) async {
    String url = "${scope.rootScope.context.mdtServerApiRootUrl}/users/v1/login";
    var userLogin = {"email":"$email", "password":"$password"};
    isHttpLoading = true;
    var response =  await mainComp().sendRequest('POST', url, body:'username=${email}&password=${password}', contentType:'application/x-www-form-urlencoded');
    if (response.status == 200){
      //hide popup
      mainComp().isUserConnected= true;
      mainComp().currentUser = response.responseText["data"];
      mainComp().hidePopup();
      locationService.router.go('apps',{});
    }else  if (response.status == 401){
      isCollapsed = false;
      errorMessage = "Login failed, Bad login or password.";
    }else {
      isCollapsed = false;
      errorMessage = "Login failed, Error :${response.responseText}";
    }
  }

  LoginComponent(this.locationService){
    print("LoginComponent created: ");
   // mainComp = scope.parentScope.context;
  }
}

@Component(
  selector: 'register_comp',
  templateUrl: 'Users/register.html',
  exportExpressions: const ["registerUser", "displayRegisterPopup","isHttpLoading","isCollapsed"],
  useShadowDom: false
)
class RegisterComponent extends BaseComponent  {
  String username ="";
  String email="";
  String password="";
  String backdrop = 'true';
  //@NgTwoWay('isHttpLoading')
  //bool isHttpLoading = false;
  @NgTwoWay('isCollapsed')
  bool isCollapsed = true;
  String message ="mesage";

  void registerUser(String username,String email, String password) async {
    print("register ${scope.rootScope.context.globalValue}");
    String url = "${scope.rootScope.context.mdtServerApiRootUrl}/users/v1/register";
    var userRegistration = {"email":"$email", "password":"$password", "name":"$username"};
    isHttpLoading = true;
    var response =  await mainComp().sendRequest('POST', url, body:JSON.encode(userRegistration));
    isHttpLoading = false;
    isCollapsed = false;
    if (response.status == 200){
      message = "Registration completed :${response.responseText["data"]}";
    }else {
      message = "Registration failed :${response.responseText}";
    }
  }

  RegisterComponent(){
    print("RegisterComponent created: ");
  }
}

@Component(
    selector: 'main_comp',
    templateUrl: 'main_page.html',
    useShadowDom: false)
class MainComponent implements ScopeAware {
  Boolean isUserConnected = false;
  Boolean isHttpLoading = false;
  Map currentUser = null;
  final Http _http;
  var lastAuthorizationHeader = '';

  Modal modal;
  ModalInstance modalInstance;
  Scope scope;
 // String backdrop = 'true';

  void displayRegisterPopup(){
    displayPopup("<register_comp></register_comp>");
    //modalInstance = modal.open(new ModalOptions(template:, backdrop: backdrop), scope);
  }
  void displayLoginPopup(){
    displayPopup("<login_comp></login_comp>");
  }


  void displayPopup(String template){
    modalInstance = modal.open(new ModalOptions(template:template, backdrop: true),scope);
  }

  void hidePopup(){
    modal.hide();
  }


  Map allHeaders({String contentType}){
    var requestContentType = contentType!=null ? contentType : 'application/json; charset=utf-8';
    var initialHeaders = {"content-type": requestContentType,"accept":'application/json'/*,"Access-Control-Allow-Headers":"*"*/};
    if (lastAuthorizationHeader.length > 0){
      initialHeaders['authorization'] = lastAuthorizationHeader;
    }else {
      initialHeaders.remove('authorization');
    }
    return initialHeaders;
  }

  MainComponent(this._http,this.modal){
    print("Main component created $this");
  }

  displayErrorFromResponse(HttpResponse response){

  }

  http.Response sendRequest(String method, String url, {String query, String body,String contentType}) async {
    //var url = '$baseUrlHost$path';
    Http http = this._http;
    if (query != null){
      url = '$url$query';
    }
    var headers = contentType == null? allHeaders(): allHeaders(contentType:contentType);
    var httpBody = body;
    if (body ==null) {
      httpBody ='';
    }
    try{
    switch (method) {
      case 'GET':
        return await http.get(url,headers:allHeaders(contentType:contentType));
      case 'POST':
        return await http.post(url,httpBody,headers:headers);
      case 'PUT':
        return await http.put(url,httpBody,headers:headers);
      case 'DELETE':
        return await http.delete(url,headers:headers);
    }
    } catch (e) {
      print("error $e");
      return e;
    }
    return null;
  }
}
