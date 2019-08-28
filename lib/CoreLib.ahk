
;清除SciTE中控制台的信息
SciTEConsoleEmpty(){
local
if (IsObject(CreatSciTEObj()))
	try{
SendMessage,CreatSciTEObj().Message(0x111,420)
}
catch{
}
return
}

;---------------------------------------------------------------------- 
;在这里建立一个SciTEObj,之后都用这个就行了，免得每次print都要重新搞一个对象，耗时耗力
SciTEObj:="",CreatSciTEObj()

;如果发现SciTE进程存在并且SciTEObj为空,那么就生成SciTEObj(全局)并且返回SciTEObj
	;如果发现SciTE进程存在SciTEObj不为空,那么就直接返回SciTEObj
		;如果发现SciTE进程不存在,那么返回false

CreatSciTEObj(){
global SciTEObj
	
if ((SciTEObj="") and (WinExist("ahk_exe SciTE.exe"))){
SciTEObj:= ComObjActive("SciTE4AHK.Application")
return SciTEObj
}

else if((SciTEObj!="") and (WinExist("ahk_exe SciTE.exe")))
return SciTEObj

else if (!(WinExist("ahk_exe SciTE.exe"))){
return false
}


}


;---------------------------------------------------------------------- 
Class InputFromText{
;---------------------------------------------------------------------- 
;# 成员变量区
TheRegEx:="",B_FormatText:="",IndexSA:=[],SASplitBaseOnIdentifier:=[]
;---------------------------------------------------------------------- 
;# 构造方法区
__New(FormatText,TheRegEx){
this.TheRegEx:=TheRegEx ;存好标识符的RegEx特征
this.FormatText:=FormatText ;在这一步,对于FormatText进行自动化分组
return this
}
;---------------------------------------------------------------------- 
;# 属性区
FormatText[]{ 
get {
return this.B_FormatText
}
set {
local
	;检查数据是否为String
	if Not(isStr(value,0))
	throw Exception("The Value is not Text(String).")
	
	SA:=this.TextToSA(value)
	
	;根据RegEx识别模式,制作模式IndexSA
	this.IndexSA:=GetSAElementIndexByRegExMatch(SA,this.TheRegEx)
	
	;检查数据格式:生成IndexSA(模式出现的位置)后,检查SA
	this.CheckIndexSA()
	
	;去除数组中的模式标识符(通过数组替换方法)
	SA:=StrReplaceInSA(SA,this.TheRegEx,"",true)
	
	;通过IndexSA,分隔数组,形成二维数组
	this.SASplitBaseOnIdentifier:=SplitSABaseOnIndex(SA,this.IndexSA,true) ;制作以标识符分隔开的数组(数组的第一个元素就是原标识符元素)
	
	;将原文本成员成员变量中
	return this.B_FormatText:=value
}
} ;FormatText[] End
;---------------------------------------------------------------------- 
;# 成员方法区
CheckIndexSA(){
local
if (this.IndexSA=false)
	throw Exception("Get IndexSA Failed.Not Found Identifier.")
if Not(isSA(this.IndexSA,0))
	throw Exception("Para#1 is not SA.")
if (this.IndexSA[1]!=1)
	throw Exception("Not Found Identifier In First String.")
return true
}

TextToSA(TheText,Delimiter:="`n"){
local
;~ println("TextToSA Running")
if Not(isStr(TheText,0))
throw Exception("Para#1:TheText is not String.")
try{
AS:=StringGroupParseToSimpleArray(TheText,Delimiter)
}
Catch{
throw Exception("Not Found Delimiter.")
}
return AS
}
} ;InputFromText Class End
;---------------------------------------------------------------------- 
;抛出可自定义信息的异常
MyThrow(Message){
throw Exception(Message)
}
;---------------------------------------------------------------------- 
;通过复制获取关键词
 ;复制失败之后,可以调用FuncObject
	;最常见的就是调用MyInputBox,让用户自行输入
	
GetKeyByCopy(GetFromFuncObjWhenCopyFailed,ThrowWhenGetkeyFromFuncObjFailed:=true){
local
if (Not(IsObject(GetFromFuncObjWhenCopyFailed)) AND Not(GetFromFuncObjWhenCopyFailed=False))
	throw Exception("Para#1 is not a Object or Boolean-false,is invalid.")
try{
SearchKey := supercopy()
;如果搜索到的都是空字符组成的String,对这个场景来说,这是毫无意义,所以也抛出异常
if ((SearchKey="") OR (RegExMatchAndGetRest(SearchKey,"\s+")=""))
	MyThrow("Get Empty Char String.")	
}
catch Ex{
	if(GetFromFuncObjWhenCopyFailed){
			try{
		SearchKey := GetFromFuncObjWhenCopyFailed.Call()
		}
		catch Ex{
			if(ThrowWhenGetkeyFromFuncObjFailed)
		throw Ex
		else
			return false
		}
	}
	;如果 GetFromFuncObjWhenCopyFailed 没开启,那么直接就throw
		else
		throw Exception("Copy Failed.")
	}
	return SearchKey
}
;---------------------------------------------------------------------- 
SeazenLiteFunc(Obj,BrowserPath){
local
global Seazen
if isObject(Obj){
if (Obj.Count()<1)
throw Exception("There are not Key-Value in Para#1.")	
}
else
throw Exception("Para#1 is not an Object.")
BrowserPath:="C:\Users\Administrator\AppData\Local\360Chrome\Chrome\Application\360chrome.exe"
MyinputBoxObj:=GetBindFuncObj("MyInputBox",obj.TextOnInputBox,"请输入搜索关键词",DeFaultText:="UseClipboard")
GetKeyByCopyObj:=GetBindFuncObj("GetKeyByCopy",MyinputBoxObj)
if(Obj.UserFunc) ;如果是用户了一个自定义的Func,那么就把Obj抛给用户处理
	ResultObj:=Obj.UserFunc.Bind(GetKeyByCopyObj)
else
ResultObj:=GetKeyByCopyObj
NewSeazenObj:=new Seazen(obj.ProcessText,ResultObj,false) ;false指的是不让浏览器在新窗口中打开
ObjBindMethodForHotKey:=ObjBindMethod(NewSeazenObj,"Search","All",BrowserPath)
Hotkey,% obj.KeyName,%ObjBindMethodForHotKey%
return true
}
;---------------------------------------------------------------------- 
DeBugDeepPrintln(Obj:="",prefix:="",postfix:=""){
local
println(prefix DeepObjectToString(Obj) postfix)
return
}
;---------------------------------------------------------------------- 
DeepPrintln(Obj){
local
println(DeepObjectToString(Obj))
return
}
;---------------------------------------------------------------------- 
StringReturn_DeepObjectToString(TheType,String){
if (TheType="NullString")
	return "**NullString**"
else if (InStr(TheType,"String")) 
	return String
else 
	return ["NotString"]
}
DeepObjectToString(Obj){
	local
	ResultString:="",SAString:="",SAString.= "[",ObjectString:="",ObjectString.="{"
	
	;判定类型
	TheType:=ObjectTypeDetect(Obj)
	
	
	if Not(isObject(DS:=StringReturn_DeepObjectToString(TheType,Obj)))
	return DS
	;由于是ToString,如果发现是String则直接return
else if (TheType="SimpleArray") ;如果是SA,那么开头应该是"["
	ResultString:=SAString
else if (InStr(TheType,"Object")) ;如果是Obj数组,那么开头应该是"{"
	ResultString:=ObjectString
	
	
if (TheType="SimpleArray"){
for index,v in Obj{
	
vType:=ObjectTypeDetect(v)
if (A_Index!=1)
	symbol:=","
else 
	symbol:=""
	
if ((vType="SimpleArray") OR (InStr(vType,"Object"))){ 
		if (v.count()=0)
		ResultString.=symbol "{**ObjectWithNotKey-Value**}"
		else
		ResultString.=symbol DeepObjectToString(v)
}
	
else if Not(isObject(DS:=StringReturn_DeepObjectToString(vType,v))){
	ResultString.=symbol DS
}
else
	throw Exception("The " index "th element in the array is invalid.")
	
}
	 ResultString.= "]" ;添加右侧的中括号并出厂		 
return ResultString
}
		
	
else if (InStr(TheType,"Object")){
	
	if (Obj.count()=0)
		return "{**ObjectWithNotKey-Value**}"
	
for key,v in Obj{
	
vType:=ObjectTypeDetect(v)
if (A_Index!=1)
	symbol:=","
else 
	symbol:=""
	
	
if ((vType="SimpleArray") OR (InStr(vType,"Object"))){ ;key一定是用""包裹的,value则不
		if (v.count()=0)
	v:="{**ObjectWithNotKey-Value**}"
	else
	v:=DeepObjectToString(v)
	TheSubString=%symbol%"%key%":%v%
	ResultString.=TheSubString
} 
else if Not(isObject(DS:=StringReturn_DeepObjectToString(vType,v))){
	TheSubString=%symbol%"%key%":%DS%
	ResultString.=TheSubString
}
else{
throw Exception("The " key " element in the array is invalid.")
}
	
	
}
 ResultString.= "}"
return ResultString
}
	
}
;---------------------------------------------------------------------- 
;按照IndexSA移除SA中的元素
RemoveSAElement(SA,indexSA){
	local
	NewSA:=SA.Clone()
for i,v in indexSA {
	theindex:=v-i+1
NewSA.RemoveAt(theindex)
}
return NewSA
}
;---------------------------------------------------------------------- 
;获取SA中含有可以成功匹配RegEx的字符串的IndexSA(只要匹配出来不是空就行)
	;如果一个也没找到,则返回False
	;RegEx默认忽略大小写,默认加前缀"i)"
GetSAElementIndexByRegExMatch(SA,TheRegex:="^(;)"){
	local
IndexSA:=[]
for i,v in SA
{
if(isStr(v,true,false)=true){
	if(RegExMatchAndGetRest(v,TheRegex,RegExOption:="i)")!=false){
	IndexSA.Push(i)
	}
}
}
if(IndexSA.Length()<1)
return false
else
return IndexSA
}
;---------------------------------------------------------------------- 
ssjHotkeyMsgBox(){
MsgBox,% ";srj 已经改为`t;ssd (SearchSoftDownloadURL)`r`n`r`n另外还建立了`r`n搜编程内容`t;sfc`t(SearchForCode)`r`n搜网盘`t;snd`t(SoftInNetworkDisk)`r`n搜优惠券`t;sq`t(SearchFor券)`r`n之后还会建立更多.^_^"
return
}
;---------------------------------------------------------------------- 
;已更改
SearchEngine_Seazen(URL,SA,SearchKey,BrowserPath:="",Postfix:="",OpenInNewWin:="Auto"){
	local
isSA(SA)
NewSA:=[]
PostfixIsSA:=(isSA(Postfix,0)=1) ;如果Postfix是SA,那么就遍历并加入,如果不是那么就直接加入
thepostfix:=Postfix
for i,v in SA {
	
	if(v="Null") ;如果传入的是Null,代表空字符
		v:=""
if(PostfixIsSA=1){
thepostfix:=Postfix[i]
}
TheResultKey=%SearchKey%%A_Space%%v%%A_Space%%thepostfix%
NewURL:=StrReplace(URL,"`%TheResultKey`%",TheResultKey)
NewSA.Push(NewURL)
}
RunURL(NewSA,BrowserPath,OpenInNewWin)
return
}
;---------------------------------------------------------------------- 
;已更改
Google_Seazen(SA,SearchKey,BrowserPath:="",Postfix:="",OpenInNewWin:="Auto"){
	local
	URL=http://www.google.com/search?q=`%TheResultKey`%&safe=off&cad=h
SearchEngine_Seazen(URL,SA,SearchKey,BrowserPath,Postfix,OpenInNewWin)
return
}
;---------------------------------------------------------------------- 
;已更改
Baidu_Seazen(SA,SearchKey,BrowserPath:="",Postfix:="",OpenInNewWin:="Auto"){
	local
	URL=https://www.baidu.com/baidu?&ie=utf-8&word=`%TheResultKey`%
SearchEngine_Seazen(URL,SA,SearchKey,BrowserPath,Postfix,OpenInNewWin)
return
}
;---------------------------------------------------------------------- 
;已更改
GoogleInSite_Seazen(SA,SearchKey,BrowserPath:="",Postfix:="",OpenInNewWin:="Auto"){
	local
	
isSA(SA),NewSA:=[],postfixArr:=[]
for i,v in SA {
thepostfix=site:%v%
postfixArr.Push(thepostfix)
NewSA.Push("Null")
}
Google_Seazen(NewSA,SearchKey,BrowserPath,postfixArr,OpenInNewWin)
return
}
;---------------------------------------------------------------------- 
;已更改
GoogleByFileType_Seazenn(SA,SearchKey,BrowserPath:="",Postfix:="",OpenInNewWin:="Auto"){
	local
isSA(SA),NewSA:=[],postfixArr:=[]
for i,v in SA {
thepostfix=filetype:%v%
postfixArr.Push(thepostfix)
NewSA.Push("Null")
}
Google_Seazen(NewSA,SearchKey,BrowserPath,postfixArr,OpenInNewWin)
return
}
;---------------------------------------------------------------------- 
;已更改
Normal_Seazen(SA,SearchKey,BrowserPath:="",Postfix:="",OpenInNewWin:="Auto"){
	local
isSA(SA)
NewSA:=[]
for i,v in SA {
URL:=StrReplace(v,"%s%",SearchKey)
NewSA.Push(URL)
}
RunURL(NewSA,BrowserPath,OpenInNewWin)
return
}
;---------------------------------------------------------------------- 
;已更改
RunURL_Seazen(SA,SearchKey,BrowserPath:="",Postfix:="",OpenInNewWin:="Auto"){
	local
isSA(SA)
NewSA:=SA
Normal_Seazen(NewSA,SearchKey:="",BrowserPath,Postfix,OpenInNewWin)
return
}
;---------------------------------------------------------------------- 
;轻松搜索Class Seazen Class 
	;ProcessText是用`n进行分割的文本,每一行代表1个数据,开头为M:Funcname的行指定其下方数据的传入的Func
	;使用Seazen.Search(way)的方法调用搜索,way可以是Funcname的数组或以‘|’分割的字符串,也可传入"ALL",那么就代表所有的数据都执行
	;OpenInNewWin指的是是否命令浏览器在新的窗口中打开搜索页面,"Auto"是自动的,当方法执行的时候，第一个M执行时一定是在新窗口打开的,后面的M执行时根据时间决定,如果间隔大于6秒,则在新窗口中,否则在原窗口中。
Class Seazen extends InputFromText {
	
;----------------------------------------------------------------------- 
;构造方法区
__New(FormatText,SearchKey,OpenInNewWin:="Auto"){
	local
base.__New(FormatText,"^(M:)")
this.CreatFuncObjectNameSA()
this.OpenInNewWin:=OpenInNewWin
this.SearchKey:=SearchKey
return this
}
;----------------------------------------------------------------------- 
;# 成员变量区
OpenInNewWin:="Auto",B_FormatText:="",B_SearchKey:="",SearchKey_Str:=""
FuncObjectSA:=[],FuncObjectNameSA:=[]
;----------------------------------------------------------------------- 
CreatFuncObjectNameSA(){
	this.FuncObjectNameSA:=[] ;使用之前应清空
	
	for i,v in this.SASplitBaseOnIdentifier{
if (ObjectTypeDetect(v[1])="FunctionNameString"){
this.FuncObjectNameSA.push(v[1])
}
else 
throw Exception("Not Found Func:" i ".")
	}
	
return this.FuncObjectNameSA
}
;----------------------------------------------------------------------- 
;这个是应该在用户发起搜索的时候就应该获取,获取一次就够了
SearchKey[]{
get {
if(IsObject(this.B_SearchKey)){ ;如果是Func,那么就调用并且返回值
this.SearchKey_Str:=this.B_SearchKey.Call()
}
else{
	this.SearchKey_Str:=this.B_SearchKey
}
return this.SearchKey_Str
}
set {
;可以有这么几种情况  1,非空String 2,Func3,FuncBindObj(无法检测,所以就不检测了)
if (isStr(value,0,0)){
}
else if(value=""){
throw Exception("SearchKey is NullString.")
}
this.B_SearchKey:=value
return this.B_SearchKey
	}
}
;----------------------------------------------------------------------- 
;# 成员方法区
;---------------------------------------------------------------------- 
SearchAll(BrowserPath:=""){
local
return this.Search(this.FuncObjectNameSA,BrowserPath)
}
;---------------------------------------------------------------------- 
Search(way,BrowserPath:=""){ ;支持SA数组/或者以‘|’分隔的StringGroup
	local
	
	if (way="All",BrowserPath){
	this.SearchAll(BrowserPath)
	return
	}
	
		try{
	theSearchKey:=this.SearchKey
	}
catch Ex{
if (Ex.message!="User Cancel Input`r`n用户取消输入"){
throw Ex
}
return
	}
	
	theFuncObjectSA:=[]
	;在这里生成函数对象,便于之后的调用
		for i,v in this.SASplitBaseOnIdentifier{
						if (BrowserPath="")
	throw Exception("BrowserPath is NullString.")
			else {
				TheURLArray:=v.Clone()
				TheURLArray.RemoveAt(1) ;终于知道为什么第一次想要第二次不行了,因为AHK中复制,数组还是传引用的,但是如果放入函数中就是传值。
				TheFuncName:=this.FuncObjectNameSA[i]
		TempFuncObject:=GetBindFuncObj(TheFuncName,TheURLArray,theSearchKey,BrowserPath,Postfix:="",this.OpenInNewWin)		
			}
	
	if (IsObject(TempFuncObject)){
	theFuncObjectSA.Push(TempFuncObject)
	} 
	else {
		throw Exception("Func:" i "Created Failed.")
	}
	}
	
	;保存函数对象
	
	this.FuncObjectSA:=theFuncObjectSA
	WaySA:=[]
	try{
	isSA(way)
	WaySA:=way
	}
catch{
	try{
	isString(way)
	try{
	WaySA:=StringGroupParseToSimpleArray(way)
	}
	catch{
	WaySA.push(way)
	}
	}
catch{
throw Exception("way is invalid,not SA OR String.")
}
}
;这个地方WaySA诞生了
NotFindWaySA:=[]
for i,v in WaySA{
	
if (FuncObjectIndex:=StrIncludeInSA(v,this.FuncObjectNameSA)){  ;FuncObjectIndex是个数组,也要遍历
for ii,vv in FuncObjectIndex{
this.FuncObjectSA[vv].Call()
}
} 
	
else 
	NotFindWaySA.push(v)
}
if (NotFindWaySA.length()=0)
	return true
else 
	return NotFindWaySA
}
;----------------------------------------------------------------------- 
} ;Seazen Class END

;---------------------------------------------------------------------- 
;用指定浏览器运行URL,SA是URL数组,BrowserPath是浏览器地址,newWindows参数决定是否在新窗口中打开,Auto会根据时间来自动判断,1每次都在新窗口中,0每次都不在新窗口中。
RunURL(SA,BrowserPath:="",OpenInNewWin:="Auto"){
	local
	static thetime:=0
	static thetimetemp:=0
	isSame:=false
	threshold:=6000 ;阈值是6秒
	thetime:=TimeCounter()
	different:=thetime-thetimetemp
	if (different<threshold)
		isSame:=true
	else
		isSame:=false
		if (OpenInNewWin="Auto"){
		}
		else if (OpenInNewWin=="1")
			isSame:=false
		else if(OpenInNewWin=="0")
			isSame:=true
		else
			throw Exception("OpenInNewWin ParaMeter is invalid.")
		thetimetemp:=thetime
isSA(SA) ;这个是指运行的不进行任何替换等其他操作
isStr(BrowserPath,1,1)
if (BrowserPath=""){
for i,v in SA {
Run,%v% 
}
return
}
else{
if (isSame){
}
else{
SA.InsertAt(1,"--new-window")
}
RunBySpecificSoftware(BrowserPath,SA)
return
}
return
}
;---------------------------------------------------------------------- 
isPath(s){ ;其实就是简单的判断一下有没有前置盘符
local
	if (RegExMatchAndGetRest(s,"^([A-Z]:(\\|\/))")=false)
		return false
	else 
		return true
}
;---------------------------------------------------------------------- 
isURL(s){ ;判断是否为URL 其实就是简单判断一下里面有没有相关的关键词
	local
	Arr:=[(RegExMatchAndGetRest(s,"^(HTTP)")!=false),InStr(s,".com"),InStr(s,".cn"),InStr(s,"www."),InStr(s,".net"),InStr(s,".org")]
	sum:=0
	for i,v in Arr{
	sum+=v
	}
	
	if (sum=0) 
		return false
	else 
		return true
}
;---------------------------------------------------------------------- 
;自己封装的函数对象生成方法,执行了更严格的检查,以免出现各种逻辑错误。
GetBindFuncObj(functionName,p*){
	local
isStr(functionName)
FuncObject:=Func(functionName)
if !(IsObject(FuncObject))
	Throw Exception("BindMethodObj Created Failed.May Be because MethodName is invalid or too few ParaMeters.`r`n函数对象创建失败,可能是因为函数名无效.")
if (FuncObject.MinParams>p.Length())
	Throw Exception("Error01:BindMethodObj Created Failed.too few ParaMeters.`r`n函数绑定对象创建失败,因为参数过少.")
if (FuncObject.MaxParams<p.Length()) AND (!(FuncObject.IsVariadic))
	Throw Exception("Error02:too many parameters `r`n参数过多.")
BindFuncObj:=FuncObject.Bind(p*)
if !(IsObject(BindFuncObj))
	Throw Exception("Error03:Parameter bind failed.")
return BindFuncObj
}
;---------------------------------------------------------------------- 
;找出SA中的Str,并返回indexSA
StrIncludeInSA(str,SA){
	
	local
	isSA(SA)
	isstr(str,1)
	indexSA:=[]
	
for i,v in SA{
if (str=v)
	indexSA.push(i)
}
if (indexSA.length()>0){
return indexSA
}
else {
return false
}
}
;---------------------------------------------------------------------- 
;根据 indexSA 分隔SA
;SaveSplitChar开启则保留index所在元素,否则就不
SplitSABaseOnIndex(SA,IndexSA,SaveSplitChar:=false){
	local
	NewSA:=[] 
loop,% IndexSA.length()-1{
	
different:=IndexSA[A_Index+1]-IndexSA[A_Index]
if (different<0)
	throw Exception("IndexSA Sort Error.")
	if (different>1-SaveSplitChar){
		fromindex:=IndexSA[A_Index]+1-SaveSplitChar
		toindex:=IndexSA[A_Index+1]-1
	SubSA:=SACopyOfRange(SA,fromindex,toindex)
	NewSA.push(SubSA)
	} ;最少有一个元素被分割出来
}
if (IndexSA[1]!=1){
NewSA.Insert(1,SACopyOfRange(SA,1,IndexSA[1]-1))
}
if (IndexSA[IndexSA.length()]!=SA.length()){
NewSA.push(SACopyOfRange(SA,IndexSA[IndexSA.length()]+1-SaveSplitChar,SA.length()))
}
return NewSA
}
;---------------------------------------------------------------------- 
;检测数组是否符合Two_D_SAtoObject(SA)的要求,要求如下1,SA是SimpleArray 2,SA是二维数组 3,SA的第二维中的第一个因为要做Key,所以必须是String
Two_D_SAtoObject_PreCheck(SA){
	local
for i,v in SA{
	
isSA(v)
try{
	visString:=(isString(v[1]))
}
catch{
return false
}
if NOT((v.length()>1) AND (visString))
	return false
}
return true
}
;---------------------------------------------------------------------- 
DeepPrintSA(SA){
	local
	s:=DeepSAtoString(SA)
print(s)
return s
}
;---------------------------------------------------------------------- 
DeepPrintlnSA(SA){
	local
	s:=DeepSAtoString(SA)
println(s)
return s
}
;~ */;---------------------------------------------------------------------- 
DeepSAtoString(SA){
	local
	isSA(SA)
	
	;# 初始化本地变量
	TheArrayString:=""
	 TheArrayString.= "["
	
for index,v in SA{
	
if (ObjectTypeDetect(v)="SimpleArray")
	TheArrayString.="," DeepSAtoString(v)
else if ((ObjectTypeDetect(v)="String") Or (ObjectTypeDetect(v)="NullString"))
	TheArrayString.="," v
else
	throw Exception("The " index "th element in the array is invalid.")
	
}
;## 去掉尾部多余的","
				TheArrayString := StrReplace(TheArrayString, "," , "", OutputVarCount,1)
				 TheArrayString.= "]"
return TheArrayString
}
;~ */
;---------------------------------------------------------------------- 
;复制并返回数组的一部分
SACopyOfRange(SA,FromIndex,ToIndex){
	
	local
	
	NewSA:=[] 
	
		if (FromIndex<1) OR (ToIndex>SA.Length()){
	throw Exception ("Array Out Of Bound.")
	}
	
			if (FromIndex>ToIndex){
	throw Exception ("FromIndex is bigger than ToIndex.")
	}
	
	for index,v in SA{
	if ((index>=FromIndex) AND (index<=ToIndex))
		NewSA.push(v)
	}
		
return NewSA
}
;----------------------------------------------------------------------- 
;New017 启动IDEA前先询问(默认为否)
RunIDEA(){
	msgbox,% 4+256,启动IDEA,真的要启动IDEA吗？
IfMsgBox,Yes
{
Run,"C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2018.3.2\bin\idea64.exe"
}
return
}
;----------------------------------------------------------------------- 
;New016 杀死DeBug程序并且重启
KillDeBugANDReload()
{
local
;开启隐藏窗口检测,并且备份好数据,处理完之后再关闭
TempConfig:=A_DetectHiddenWindows
DetectHiddenWindows On
	WinGet, active_id, PID, SciTEDebug.ahk
	Run, taskkill /PID %active_id% /F,,Hide
	TrayTip,精准狙杀,已经杀死SciTEDebug.ahk
	DetectHiddenWindows,% TempConfig
	PostMessage, 0x112, 0xF060,,,% "ahk_exe SciTE.exe"
	Sleep,25
	PostMessage, 0x112, 0xF060,,,% "ahk_exe SciTE.exe"
	; Sleep,100
	; Process,close,SciTE.exe
;# 杀之后再重启
run,D:\AHKs\Dev\_MainScript.ahk
run,C:\Program Files\AutoHotkey\SciTE\SciTE.exe
Return
}
;----------------------------------------------------------------------- 
;New015 检查是否为字符串数组
isStrSA(SrcSA){
isSA(SrcSA)
for index,value in SrcSA{
try{
	isString(value,true)
}
Catch ex{
	throw Exception("The SA is Not StringSA.")
}
}
return true 
}
;----------------------------------------------------------------------- 
;New014 字符串数组替换
StrReplaceInSA(SrcSA,SearchText,ReplaceText,isRegEx:=false){
isStrSA(SrcSA),isStr(SearchText),isStr(ReplaceText,1),isStr(isRegEx,1)
NewSA:=SrcSA.Clone()
for i,v in SrcSA{
if(isRegEx)
Newv:=RegExReplace(v,SearchText,ReplaceText)
else
Newv:=StrReplace(v,SearchText,ReplaceText)
NewSA[i]:=Newv
}
return NewSA ;AHK数组传入函数是传值,非引用,所以不用提前clone
}
;----------------------------------------------------------------------- 
;New013 把一个SA,变成两个SA的形式,两个SA可以交叉成原来那个,就像十个手指变成五个手指一样
ToCrossSA(SrcSA,ForcedAlign:=true){ ;这个参数的意思是"强制对齐",默认是开启的,如果数组长度不是偶数,那么会throw
	local
	;先检查是否为SA
	isSA(SrcSA)
	ArrayLength:=SrcSA.length()
	Align:=(mod(ArrayLength,2)=0) ;长度是偶数那么就是对齐了
	if !(Align)
	throw Exception("The Length Of Array is odd,it is not Aligned.`r`n数组的长度是奇数,数组未对齐.(强制对齐可以关闭,把第二个参数设为false即可.)")
	;先建立两个新的SA备用
NewSA1:=[],NewSA2:=[]
for index,Value in SrcSA{
if (mod(index,2)=1){
NewSA1.push(Value)
}
else{
	NewSA2.push(Value)
}
} ;循环结束
return [NewSA1,NewSA2] 
}
;----------------------------------------------------------------------- 
;New012 一键检查某数据是否为SimpleArray(非空) 
	;如果为SimpleArray则返回true
	;如果不为SimpleArray,默认是直接Throw,如果想返回ObjectType,可以更改第二个参数为false
isSA(TheDate,EableThrow:=true){
	local
return isSimpleArray(TheDate,EableThrow) ;存在的主要目的就是为了变量名简单
}
;----------------------------------------------------------------------- 
;New011 一键检查某数据是否为SimpleArray(非空) √
	;如果为SimpleArray则返回true
	;如果不为SimpleArray,默认是直接Throw,如果想返回ObjectType,可以更改第二个参数为false
isSimpleArray(TheDate,EableThrow:=true){
	local
	ObjectType:=ObjectTypeDetect(TheDate) 
	if (RX:=(ObjectType="SimpleArray"))
	return true
	else if EableThrow 
	throw Exception("SrcDate is not SimpleArray.`r`nIt is " ObjectType "源数据不是简单数组，不符合要求.")
	else
	return ObjectType
}
;----------------------------------------------------------------------- 
;New009 正则表达式匹配，并且返回剩余部分  √
	;常用于检查标识字符串的格式以及获取某标识字符串的信息
	;主要就是检查String是否符合某种格式,如果符合的话那么就返回rest(替换掉匹配部分后的剩余部分),所以可以直接判断.
		;如果不符合则返回False
		RegExMatchAndGetRest(TheString,TheRegEx,RegExOption:="i)"){
local
isString(TheString)
	RegExMatch(TheString,RegExOption TheRegEx,MatchedPart)
	;我发现最后的匹配部分不是flase,那不就替换掉匹配部分,返回rest(剩余部分)
	if (MatchedPart!=""){ 
	Return rest:=RegExReplace(TheString,RegExOption TheRegEx)
	}
	else {
	return false
	}
		}
;----------------------------------------------------------------------- 
	isStr(TheDate,AllowNullString:=false,Enablethrow:=true){
		local
		return isString(TheDate,AllowNullString,Enablethrow)
	}
;----------------------------------------------------------------------- 
;New008 一键检查某数据是否为String 
	;如果为String则返回true
	;如果不为String,默认是直接Throw,如果想返回ObjectType,可以更改第二个参数为false
isString(TheDate,AllowNullString:=false,Enablethrow:=true){
	local
	ObjectType:=ObjectTypeDetect(TheDate) 
	if (AllowNullString)
	RX:=(InStr(ObjectType,"string"))
	Else
	RX:=(InStr(ObjectType,"string")) AND (ObjectType!="NullString")
	CR:="`r"
	if (AllowNullString)
	Mes=SrcDate is not String,but is %ObjectType%.%CR% 源数据不是字符串，而是 %ObjectType% ,不符合要求.
	Else
	Mes=SrcDate is not Non-Null string,but is %ObjectType%.%CR% 源数据不是非空字符串，而是 %ObjectType% ,不符合要求.
	;空字符串的英文就是NullString,而不是EmptyString
    Ex:=Exception(Mes)
	if (RX)
	return true
	else{
		if(Enablethrow)
		throw Ex
		else
		return false
	}
}
;----------------------------------------------------------------------- 
;New007 一键返回获取的选中变量的println形式 
	;主要就是用作调试
GetPrintlnCode(Prefix:="Var*"){
	local
TheText:=SuperCopy()
; ResultString=println("%Prefix% %TheText%=" %TheText%)
;必须要忠实的呈现变量名?
ResultString=println(%TheText%)
return ResultString
}
;----------------------------------------------------------------------- 
;New006 一键返回获取的窗口title GetWinTitle函数
GetWinTitle(WinTitle:="A",EnableTipANDWriteInClipBoard:=false){
	local
	TheTitle:=""
	WinGetTitle,TheTitle,% WinTitle
	if (EnableTipANDWriteInClipBoard){
	clipboard=%TheTitle%
	TrayTip,AHK,已将程序窗口的标题复制到剪切板`n%TheTitle%
	}
return TheTitle
}
;----------------------------------------------------------------------- 
;New005 切换窗口的置顶状态 SwapWinTopState函数
;切换窗口的置顶状态 
SwapWinTopState(t:="Auto",WinTitle:="A",EnableMsgBox:=false){
	local
	;获取目标窗口的初始置顶状态
	WinTopStateBeforeOperation:=GetWinTopState(WinTitle)
;默认是自动模式,也就是如果置顶就取消置顶,反之则置顶
if (t="Auto")
;切换置顶状态
WinSet, AlwaysOnTop ,Toggle,% WinTitle
if WinTopStateBeforeOperation
thetext:="已被取消置顶"
else
thetext:="已被置顶"
TheWinTitle:=GetWinTitle()
	TrayTip,活动窗口%thetext%,%thetext%的窗口标题为:`n%TheWinTitle%,,1
	return
}
;----------------------------------------------------------------------- 
;New005 GetWinTopState函数 获取窗口的置顶状态
;获取窗口的置顶状态
GetWinTopState(WinTitle:="A"){
	WinGet, ExStyleOutputVar , ExStyle,% WinTitle
if (ExStyleOutputVar & 0x8)  ; 0x8 is WS_EX_TOPMOST.
   return true
   else 
	return false
}
;----------------------------------------------------------------------- 
;New004 GetSystemUptime_Format函数 获取系统正常运行的时间 可以自定义格式化方法
GetSystemUptime_Format(Format := "d'd':hh:mm:ss"){
local
;获取以秒为单位的Uptime
; Uptime_s:=GetSystemUptime()
Uptime_s:=GetSystemUptime("s")
;如果为空字串或者小于1,说明有问题,那么就throw
if (Uptime_s="") OR (Uptime_s<1){
throw Exception ("GetSystemUptime_Format Error01:GetSystemUptime Error.")
}
;如果没问题就依次调用 FormatSeconds2|FormatSeconds 其中一个有返回值就可以输出
if ((Uptime_Format:=FormatSeconds2(Uptime_s,Format))="")
if ((Uptime_Format:=FormatSeconds(Uptime_s,Format))="")
	throw Exception ("GetSystemUptime_Format Error02:Uptime_s Format failure.") ;如果两个函数调用之后，返回的结果都为空,那么就抛出异常
	;如果其中的一个函数调用是有结果的,那么就返回该结果
return Uptime_Format
}
;The Solution is From URL:https://autohotkey.com/boards/viewtopic.php?t=376 
;Thanks to @just me AND @jNizM
FormatSeconds2(NumberOfSeconds, Format := "d'd':hh:mm:ss") {
	local
   ; http://msdn.microsoft.com/en-us/library/windows/desktop/dd318091(v=vs.85).aspx
   VarSetCapacity(Out, 128, 0)
   DllCall("Kernel32.dll\GetDurationFormat", "UInt", 0x400
                                           , "UInt", 0
                                           , "Ptr", 0
                                           , "Int64", NumberOfSeconds * 10000000
                                           , "WStr", Format
                                           , "WStr", Out
                                           , "Int", 64)
						
   Return Out
}
; /*
FormatSeconds(NumberOfSeconds, TimeFormat := "HH:mm:ss") {
	local
    Time = 19990101
    Time += %NumberOfSeconds%, Seconds
    FormatTime, Output1, %Time%, %TimeFormat%
	FormatTime, Output2, %Time%, YDay
    return Output2-1 "d:" Output1
}
; */
;----------------------------------------------------------------------- 
/*
;New003 GetSystemUptime函数 获取系统正常运行的时间 单位是“分” 
		
GetSystemUptime(FormatFloat:="0.2"){
	local
		return GetSystemUptime(FormatFloat)/60
}
;************************************************************
*/
;----------------------------------------------------------------------- 
;----------------------------------------------------------------------- 
;New002 GetSystemUptime函数 获取系统正常运行的时间 单位是秒 
		;特别要注意的是 FormatFloat 是不能用 数值 的 ,必须用 字符串,因为格式化过程是不受控的(AHK要先从数值转字符串) ,如果用数值,那么很可能报错
GetSystemUptime(unit:="s",FormatFloat:="0.2"){
	local
	;unit是单位的意思
	FormatFloatTemp := A_FormatFloat ;备份原浮点格式
		SetFormat,Float,% FormatFloat ;设置浮点格式
		;生成分母
		if (unit="ms") ;毫秒
		Denominator:=1
		else if (unit="s") ;秒
		Denominator:=1000
		else if (unit="m") ;分钟
		Denominator:=1000*60
		else if (unit="h") ;小时
		Denominator:=1000*60*60
		else if (unit="d") ;天
		Denominator:=1000*60*60*24
		else if (unit="w") ;周
		Denominator:=1000*60*60*24*7
		else
		throw Exception("GetSystemUptime Error01 :The unit  """ unit """is invalid.`r`n" "GetSystemUptime:您输入的单位 """ unit """是无效的.`r`n")
if ((Uptime:=DllCall("GetTickCount") / Denominator)="")
		;如果没获取到，那就换用 GetTickCount64
	if ((Uptime:=DllCall("GetTickCount64") / Denominator)="")
		;如果还是没有成功获取,那么就只能throw了
		throw Exception("GetSystemUptime Error02 :GetTickCout Error.")
	SetFormat,Float,% A_FormatFloat ;设置浮点格式 ;还原浮点格式	
		if (Denominator=1) ;如果发现是"毫秒",那么先取整再return,因为获取的原始数据就是int
		Uptime:=Ceil(Uptime)
		return Uptime
}
;************************************************************
;----------------------------------------------------------------------- 
;New001 SetToggleCommentBlock函数
;#设置块注释 添加块注释 添加注释 注释包裹
SetToggleCommentBlock(){
local
Normal0:="/*`r`n",Normal1:="`r`n*/",temp:=""
Critical ;保证线程不被中断
temp:=SuperCopy(25)
SendByClip(MakeDeBugAnnotation(temp,Normal0,Normal1))
return
}
;************************************************************
				;1↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\ActiveControlIsOfClass.ahk
/*
# ActiveControlIsOfClass函数说明书(apidoc)
## 功能介绍(默认下) :
就是判断目前的Focus(Active)控件的Class或者ClassNN是否和传入的参数相同,有点类似于WinActive的效果,可以用来做语境约束
## 参数介绍
### Class:需要比对的Class/ClassNN字符串
### Option:默认返回Class,如果改为"ClassNN"那么就返回这个的ClassNN
;---------------------------------------------------------------------------------------------------------------
# 借鉴:https://wyagd001.github.io/zh-cn/docs/commands/_If.htm#Examples
# 版本信息
v0.1 : 草创
*/
;---------------------------------------------------------------------------------------------------------------
/*
;# 写一下我对这个东西的认识和学习(如何实现控件的语境约束)
;# 目的:实现控件的语境约束
;## 语境约束需要什么样的东西?要是可以返回true或者false的函数都是可以的。由于在AHK中没有预先定义，所以需要自己包装
;## 如何获取当前控件的信息?(获取信息之后，就可以和输入地进行比对,从而包装成一个类似WinActive的东西)
;### 那么首先要说一下有哪些信息,一个是该控件的Class(也就是实例的"类"),另外就是"示例的编号",这两者合起来叫做ClassNN(控件的类名和实例编号)。用Windows Spy查到的就是这个ClassNN,所以我对他的印象就是最容易暴露的"窗口控件"信息。
;### 我的猜想,如果是约束特定的控件实例,那么ClassNN无疑就是最好的,但如果想对于整个类下面的实例全部进行约束,那么就只能用Class,由于没有直接获取焦点Class的方法,所以要通过侧面迂回。
;### ClassNN如何获取?ControlGetFocus就是专门干这个事情的,它会获取某窗口下的"焦点控件" 
;### 单独的Class如何获取？是通过WinGetClass获取,从名字上就知道这是专门获取Class的东西,可以通过输入ahk_id(ClassNN)来获取
(每个窗口或控件都含有唯一 ID, 也称为 HWND(即窗口句柄的缩写). 即使在窗口或控件的标题改变时也可用这个 ID 来识别它. 
https://wyagd001.github.io/zh-cn/docs/misc/WinTitle.htm#ahk_id)
;### 那么如何获取ID?使用ControlGet输入ClassNN获取唯一ID
;### 所以整个过程就结束了
*/
;# 最关键的东西,这个东西其实就相当于控件的winActive,不过AHK有没有自带需要自己封装
ActiveControlIsOfClass(Class,Option:="Class") {
	return,% GetActiveControlIsOfClass(Option)=Class
}
;************************************************************
				;2↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\ArrayToString.ahk
/*
# ArrayToString函数说明书(apidoc)
## 功能介绍(默认下) :
将一维字符串数组转化为直观的String
## 参数介绍
### obj 源数组
### MsgBoxOrTrayTip 1,会通过MsgBox显示要返回的结果 2,会通过TrayTip显示要返回的结果 0,什么也不做(默认)
;---------------------------------------------------------------------------------------------------------------
# 版本信息
v0.1 : 草创
*/
;---------------------------------------------------------------------------------------------------------------
/*
# 经验和花絮(非必须):我对 ArrayToString函数 的认识和学习过程
# 目的:
# 展望:
# 过程:
##
*/
 ArrayToString(obj,MsgBoxOrTrayTip:=false){
	local
	;# 初始化本地变量
	TheArrayString:=""
	 TheArrayString.= "["
 For k, v in obj
{
 
    TheArrayString.="," v
	
}
;## 去掉尾部多余的","
				TheArrayString := StrReplace(TheArrayString, "," , "", OutputVarCount,1)
				 TheArrayString.= "]"
; /*
				 if (MsgBoxOrTrayTip=1)
MsgBox % TheArrayString
else	 if (MsgBoxOrTrayTip=2)
TrayTip,从托盘通知打印数组String,% TheArrayString
; */
;# 不管是否打印通知，最后肯定要返回String
return,% TheArrayString
 }
;************************************************************
				;3↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\BracketDelete.ahk
	BracketDelete(ByRef t,theOp=0,enableTip=1){
	local
		;## 只要theop中含有0就替换中括号 
		;### 所以这里留下了充足的潜力,之后可以替换各种号
		if(checkString(theOp,"0")){
	t:= StrReplace(t,"[","", TheOutputVarCount,-1)
	t:= StrReplace(t,"]","", TheOutputVarCount,-1)
	t:= StrReplace(t,"】","", TheOutputVarCount,-1)
	t:= StrReplace(t,"【","", TheOutputVarCount,-1)
}
if(enableTip==1){
	;复制替换后会弹出提示通知，如果不需要就注释掉
	TrayTip,括号自动删除,删除后的内容为:`n%t%,,1
}
return
}
;************************************************************
				;4↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\CheckOfukey.ahk
;# CheckOfukey函数 检查并且返回"可切换按键"(比如CapsLock)的状态 
CheckOfukey(ByRef ukey,returnname:="0"){
local
	TheShow :=""
	; # 提取按键字符 只有returnname不等于0 才会返回按键的第一个字母的小写形式
	if(returnname!="0"){
	TheShow := SubStr(ukey,1,1)
	StringLower, TheShow, TheShow
}
if(ukey="CapsLock")
return % TheShow GetKeyState("CapsLock","T")
if(ukey="NumLock")
return % TheShow GetKeyState("NumLock","T")
if(ukey="ScrollLock")
return % TheShow GetKeyState("ScrollLock","T")
else 
	;错误代码0001
	return,% "0001_输入的按键不是可切换键"
}
;************************************************************
				;5↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\CheckString.ahk
/*
;# checkString函数说明书
;## 功能介绍(默认下)
检查某字符串中是否含有某关键词(可以是多个,用|隔开即可) 如果有则return 1,没有return 0
;# 参数介绍
; ## CaseSensitive 默认是不区分大小写的,可以通过更改CaseSensitive改变
; ## ReturnKey 开启之后不返回1/0 如果检查到了之后，那就返回匹配的"TheKeys",否则就返回空""
; ## ReturnNumber
开启之后在"ReturnKey"不开启的情况下可以返回"TheKeys"匹配成功的次数(TheKeys数量>=次数>0)(因为如果开了返回次数,传过来的内容需要全部检查)
如果参数为"Mode2",则返回"TheKeys"在String中找到的所有次数的综合
举例子:Mode1(true)开启时 checkString("ABCCCC","C","Mode1") 结果是 1
Mode2开启时 checkString("ABCCCC","C","Mode2") 结果是 4
--------------要兼容("Mode1")这种写法 + 更新版本信息
; ## 这个函数的最大优点就是简便快捷,检查多个检查关键词的时候不需要用到数组什么的
;---------------------------------------------------------------------------------------------------------------
;# 版本信息
v0.5 :修复一个低级错误,由于true和false写翻了,所以在某些状况下，会出现结果正好相反的情况
v1.0:支持SimpleArray和String两种TheKeys(自动判断)
v1.5:进行判断的时候(用户还是可以输入的，因为要先转换一下)彻底放弃StringGroup,以后尽量的使用SimpleArray
*/
CheckString(HayStack,TheKeys,ReturnNumber:=false,ReturnKey:=false,CaseSensitive:=false){
local
	;# 首先检查HayStack一下到底是Array还是String
	ItIsObj:=IsObject(TheKeys)
	;# 如果是String先转换一下
	if (ItIsObj=false){
		TheKeys:=StringGroupParseToSimpleArray(TheKeys,"`|",false,false)
		ItIsObj:=IsObject(TheKeys)
		if (ItIsObj=false)
			throw Exception("ParaMeter TheKeys Error")
	}
	;# 默认不检查数量(速度快)
	;## 如果不检查数量的话，那么就运行这个
	if (returnNumber=false) {
		loop,% TheKeys.Length()
		{
			if (InStr(HayStack,TheKeys[A_Index] ,CaseSensitive,1,1)){
				;# 一旦找得到就返回return或者字符串
				;## 要求返回字符串，那么就直接返回字符串 ,如果没有要求，那就返回 true
				if (returnKey){
					return TheKeys[A_Index]
				}
				else
					return true
			}
		}
		;## 跳出循环体，只有一个可能性就是所有的TheKeys都没有匹配上,这样的话就会返回""(空字符串)或者是false
		; ## 如果检查不到就反空字串
		if (returnKey)
			return, ""
		return false
	}
	;# 检查数量 一个是返回数量 只要返回数量了，就不能再返回(匹配到的字符串) (以后可以设置为返回数组,但是今天用不到，先算了吧)
	;# Mode1和true一个效果
	else if (returnNumber=true) || (returnNumber="Mode1") || (returnNumber="Mode2")  {
		;# 如果请求匹配大小写，那么就打开
		if (CaseSensitive)
	StringCaseSense,On
		TheNumber:=0
		;# 这是那个更精确的数据(Mode2)
		TheNumber2:=0
		loop,% TheKeys.Length()
		{
			;~ if(InStr(HayStack,TheKeys[A_Index],CaseSensitive,1,1))
			;# 采用替换的方法,这样我们就可以获得次数
			;~ temp := StrReplace(Haystack, TheKeys[A_Index] ,% TheKeys[A_Index] "$", OutputVarCount, -1)
			temp := StrReplace(Haystack, TheKeys[A_Index] ,TheKeys[A_Index], OutputVarCount, -1)
			if (OutputVarCount){
				TheNumber2+=OutputVarCount
				TheNumber++
			}
			
		}
		;# 如果请求匹配大小写，匹配结束之后就关闭
		if (CaseSensitive)
			StringCaseSense,Off
		if (returnNumber="Mode2")
		return TheNumber2
		else	if (returnNumber=true) || (returnNumber="Mode1")
		return TheNumber
		else
			throw Exception("Mode Error")
	}
}
;************************************************************
				;6↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\CollectionException.ahk
;# 一键把Exception想法写入本地txt文件中
;1代表开启Cut模式,0代表不开启
CollectionException(Path,CutMode:=false,RemoveLines:=false){
local
global tempc
try
{
if (CutMode)
thetext:=SuperCut()
else
thetext:=SuperCopy()
;## 存起来,作为一个反悔机制可以用
tempc:=thetext
}
catch
{
;## 鼠标左键 三连击+剪切
	;可以在检测之前3连击(在OneNote中是选中段落的意思)
	Send,{LButton 3}
	try
	{
	thetext:=SuperCopy()
	tempc:=thetext
	}
	catch
	{
	MsgBox,内容抓取失败
	return
	}
	Clipboard:=Clipboard
	Sleep 10
}
;# 去除多余的换行
if (RemoveLines)
thetext:=RemoveAllBlankLines(thetext)
FileAppend,`r`n%thetext%,% Path,UTF-8
return
}
;************************************************************
				;8↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\ExActivateAndOpen.ahk
; # ExActivateAndOpen函数
; ## 功能介绍:可以为窗口设置激活/最小化(还可以打开隐藏老板键模式)的快捷键/热字串(激活后可设置最大化),如果发现对应窗口不存在，还可以通过Run拉起程序,有丰富的自定义功能,可以极大的提高程序切换效率。
; ## 各个参数的介绍
; ### t 意思是title,指的是程序的标题或者class/exe
; ### p 意思是path,指的是程序的路径,如果程序不存在的话，就会Run运行(可以开启CMD模式)
; ### ex 意思是排除的title,比如,如果你想给一个叫做"清单"的窗口设置一个激活的快捷键,那是你不希望激活"清单 - 搜索",那么你就可以添加"搜索"到ex中。
; ### option 指的标题匹配选项,一共有三组,"1|2|RegEx"/"fast|slow"/"on|off",每组最多填写一个,也可以不填，那么就按照默认的方式查找
; ### NoMax 指的是非自动最大化的title,在激活程序之后，默认是要将它最大化的,你可以设置黑名单。支持通过|分隔实现多项检测,比如:"AutoHotKey|Lisr|Ra2"。
; ### WinDelay 指的窗口操作的延迟,如果不更改会依照默认来运行,如果未更改(自动执行端和该线程之前)那么默认就是100毫秒,-1是无延迟,具体请参阅帮助文档。
; # 之后的改进(通过OP开启):1,Run可以改为CMD模式2,老板键模式(通过OP开启),4,名字去掉Ex 5,支持NoRun模式(NoRun后,不只是Run,CMD也不能运行) 6,支持老板键隐藏静音模式 7,支持Ex通过(|)实现多参(通过外部方式,自己封装一个,函数函数,里面会先匹配出ex相关的布尔变量(local),可以直接调试,而不是内置命令方式,降低调试难度,命令太难用)
;### 关于NoMax和AAOWinDelay,这是该方法的两个隐藏参数,因为这两个往往是全局性的,非要通过专门的方法来更改
;### EnableFunction是开启函数的调用
;--------------------------------------------------------------------------------------------------------------- 
;# 提示:如果需要同一热键/热字串的多线程,请在调用端加入#MaxThreadsPerHotkey %Number%    Number的范围是:[(Number>=2)&&(Number<=20)] 
;--------------------------------------------------------------------------------------------------------------- 
ExActivateAndOpen(t,p
,ex:=""
,option:=""
,UD_NoMax:=""
,UD_AAOWinDelay:=""
,WinWaitTime:="5",EnableCMD:=false
,EnableFunction:=false){
local
;# 两个选项一般是全局的,很难想象针对某个热键单独定义NoMax或AOOWinDelay,所以没有给出单独定义的方案
global NoMax,AAOWinDelay ;NoMax,不自动最大化的窗口(可以使用‘|’分隔多个关键词);AOOWinDelay在该函数内设置窗口操作的延迟
;## 默认是全局的,不需要预先声明局部变量,如果你开了#Warn,程序报告错误(和全局变量冲突),可以想办法开启
	;~ local OldDetectHiddenWindows,OldTitleMatchModeSpeed,OldTitleMatchMode,TMM_O,TMM,DHW,DHW_O,TMMS,TMMS_O
	;# 如果最后的两个东西一起开了那么要报错
if (EnableCMD+EnableFunction=2)
	throw Exception("EnableCMD和EnableFunction不允许同时开启")
	SetWinMaxMode:=true
	SetWinDelayMode:=true
	
	if (UD_NoMax="") AND (NoMax="")
		SetWinMaxMode:=false
	;## 用户是空的 全局不是 那么用全局
	else if ((UD_NoMax="") AND (NoMax!=""))
		UD_NoMax:=NoMax
	;## 剩下的可能性就是都有,或者仅仅UD_NoMax有,都不用东
	
		UD_NoMax:=t
	;## 用户没填(为空)  ##全局的没有(为空)  那么就什么也不动
	if ((UD_AAOWinDelay="") AND (AAOWinDelay=""))
		SetWinDelayMode:=false
	;## 用户没填(为空)   ##全局的有(不是没有) 那么就用全局的
	else if ((UD_AAOWinDelay="") AND (AAOWinDelay!=""))
		UD_AAOWinDelay:=AAOWinDelay
		;## 用户填了  ##全局的有 那么用户的(什么也不用动)
;~ MsgBox,1
	;## 设置WinDelay并且把原来的设置备份在Old_AAOWinDelay
if (SetWinDelayMode){
	Old_AAOWinDelay:=A_WinDelay
	SetWinDelay %UD_AAOWinDelay%
}
		
			;# 总入口,如果发现option为空,那么直接跳过这一大段
		if (option!=""){		
;#### 检查一下"1|2|RegEx"/"Fast|Slow"/"OFF|On" 每组选项不能超过1个,如果是那就备份好,到函数结尾之后还原，避免函数的运行，影响到之后的语句。
TMM:=(checkString(option,"1|2|RegEx",true))
if (TMM>1)
	throw Exception("Too many(>1) TitleMatchMode Option")
else if (TMM=1){
TMM_O:=(checkString(option,"1|2|RegEx",,true))
OldTitleMatchMode:=A_TitleMatchMode
SetTitleMatchMode % TMM_O
}
TMMS:=(checkString(option,"fast|slow",true))
if (TMMS>1)
throw Exception("Too many(>1) TitleMatchModeSpeed Option")
else if (TMMS=1){
TMMS_O:=(checkString(option,"fast|slow",,true))
OldTitleMatchModeSpeed:=A_TitleMatchModeSpeed
SetTitleMatchMode % TMMS_O
}
DHW:=(checkString(option,"on|off",true))
if (DHW>1)
throw Exception("Too many(>1) DetectHiddenWindows Option")
else if (DHW=1){
DHW_O:=(checkString(option,"on|off",,true))
OldDetectHiddenWindows:=A_DetectHiddenWindows
DetectHiddenWindows % DHW_O
}
	}
	
;# 如果找不到的话，这里开始运行了
	if (ExActivate(t,ex)=0)
	{
		;如果发现是cmd 那最小化运行
		if InStr(p,".bat"){
			if (EnableCMD)
			UseCMD(p)
			else if (EnableFunction)
				%p%()
			else 
			Run,"%p%",,min
		}
		else {
			if (EnableCMD)
			UseCMD(p)
			else if (EnableFunction)
				%p%()
			else 
			Run,"%p%"
		}
;# 这个地方主要是为了窗口最大化
		WinWait,%t%,,%WinWaitTime%,%ex%
		if (ErrorLevel=1){
			;# 这个总是提示蛮烦的,但是是一个很有用的东西,以后可以设置一个黑名单,也就是不弹出这个tip(但是前面的等待后面的激活不要管,没这个必要,激活去掉之后麻烦更多)
		;~ TrayTip,,已等待超过%WinWaitTime%秒 但未找到窗口"%t%"`n可能是路径(p)设置错误`n或者该程序运行后不会立即打开对应窗口(这种情况如何符合要求忽视即可) 或程序运行后被杀死`n%p%
		;~ MsgBox,1
		}
		;## 等待窗口出现，等待5秒,如果最后没出现就终止,如果出现了，先检查一下是否是活动窗口,如果不是的话，那就拉起,如果是的话，就直接最大化
		if ! WinActive(t,,ex){
			;8月27日：show是刚刚加上的出现意外就注释掉
			if(A_DetectHiddenWindows="On"){
			WinShow,%t%,,%ex%
			}			
			WinActivate,%t%,,%ex%
			;~ MsgBox,SetWinMaxMode%SetWinMaxMode%
			;## 一旦发现有东西在UD_NoMax名单之中就不放大,什么时候全局不最大化？UD_NoMax为"UD_NoMax"时
			if (SetWinMaxMode){
			if !(checkString(t,UD_NoMax))
			WinMaximize,%t%,,%ex%
			}
			else 
				WinMaximize,%t%,,%ex%
			
		;# 只有不包含在UD_NoMax列表中的软件才会最大化	
		}
		;## 如果窗口存在了，但是已经是被激活的状态,那就直接最大化
		if (SetWinMaxMode){
			if !(checkString(t,UD_NoMax))
			WinMaximize,%t%,,%ex%
			}
			else 
				WinMaximize,%t%,,%ex%
	}
	
;# return走之前都恢复一下之前的设置,避免对之后造成影响(设置还原)
;## 只要不是都没填就起作用
if (SetWinDelayMode){
SetWinDelay %Old_AAOWinDelay%
}
if (option!=""){
if (DHW=1)
DetectHiddenWindows %OldDetectHiddenWindows%
if (TMMS=1)
SetTitleMatchMode %OldTitleMatchModeSpeed%
if (TMM=1)
SetTitleMatchMode %OldTitleMatchMode%
}
	return ;## 到这里整个函数就结束了
} ;## 这是这个函数的最后一个代码块
;#  ExActivate函数 (常常在"ExActivateAndOpen函数"内使用)
ExActivate(t,ex:=""){
	if WinActive(t,,ex){
		WinMinimize,%t%,,%ex%
		return
	}
	if WinExist(t,,ex){
		;## 如果搜隐藏窗口就show,否则就不
if (A_DetectHiddenWindows="On") {
	WinShow,%t%,,%ex%
}
		WinActivate,%t%,,%ex%
		return true
	}
	return false
}
;************************************************************
				;9↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\ExcelSend.ahk
;# 在Excel中实现像滴答清单中那种发送前缀的效果
ExcelSend(t){
local
/*
;# 61是编辑模式
EXCEL61
;# 71是未编辑模式
EXCEL71
*/
;# 如果处在未编辑模式(也就是只是选中)采取以下的策略
if (ActiveControlIsOfClass("EXCEL71",Option:="ClassNN") ){
;# 先发送F2键击,进入编辑模式
SendInput {F2}
Sleep 0
;# 然后再回到文本顶部
SendInput ^{Home}
}
;# 如果已经在编辑模式中,那么先发出Home键击,回到该行文字的顶部
else if (ActiveControlIsOfClass("EXCEL61",Option:="ClassNN") ){
SendInput {Home}
Sleep 0
}
;# 到达正确位置之后，发送文本
SendText(t)
return
}
;************************************************************
				;10↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\FastSwap.ahk
;# FastSwap函数 快速切换某个"可切换按键",并且返回一个数字 return 1代表,字符串属于可切换按键,已经发送了切换的指令,return 0代表不属于可切换按键。
;## 特别提示,AHK1.3.0新特性,支持用 0/1 代表 OFF/On 但是为了照顾兼容性还是用了字符串
;## 由来:不知道为什么，如果直接Send这些可切换键的话，切换会特别慢(帮助文件上说可以这么搞),让人以为是锁定住了,那没办法，只能用另外的方法。
FastSwap(ByRef ukey){
local
thetemp:=CheckOfukey(ukey,1)
if (thetemp="0001_输入的按键不是可切换键")
	return 0
else if (SubStr(thetemp,1,1)="c")
	{
SetCapsLockState,% GetKeyState("CapsLock","T") ? "OFF" : "On"
	return 1
}
else if (SubStr(thetemp,1,1)="n")
{
		SetNumLockState,% GetKeyState("NumLock","T") ? "OFF" : "On"
	return 1
}
else if (SubStr(thetemp,1,1)="s")
	{
	SetScrollLockState,% GetKeyState("ScrollLock","T") ? "OFF" : "On"
	return 1
}
return 0
}
;************************************************************
				;11↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\FilePathSplit.ahk
/*◆
# Library 库名 : FilePathSplit
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
输入FilePath输出由FileDir和FileName组成的Simple数组
比如 println(ArrayToString(FilePathSplit("D:\XDA\88888.jpg")))
输出的结果就是 [D:\XDA,88888.jpg]
# ParaMetersList	参数列表 :
FilePath
# Author	& AHK Version	AHK版本&作者 :
AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
如果该文侵犯了您的权利，请联系我解决。
欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
v1.0 : FilePathSplit 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
[请填写依赖库名]
# 常见问题 :
有没有实战案例?
一定有至少一个[11月21日起]
如果有更多大型复杂案例会放在这里
https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
[请填写出厂品控检测结果]
*/
FilePathSplit(FilePath){ 
    local
	;请求软件的根目录FileDir(不含结尾'\') 以及 请求软件的名字(含扩展名)
	FileDir:="null"
	FoundPos_0 := InStr(FilePath, "/" ,false,0,1)
	FoundPos_1 := InStr(FilePath, "\" ,false,0,1)
	;找到最后一个斜杠的位置
	FoundPos:=(FoundPos_0>=FoundPos_1)?FoundPos_0:FoundPos_1
	;提取出调用者本身的名字(前面带着斜杠),并且对可能存在的反斜杠转义
	FileName:=StrReplace(SubStr(FilePath,FoundPos),"\","\\")
	;使用正则替换掉调用者本身(使用正则仅仅替换掉最后一个被匹配的)
	FileDir:=RegExReplace(FilePath,"(" FileName ")$" )
	;去除正反斜杠得到真正的FileName
	FileName:=StrReplace((FileName:=StrReplace(FileName,"\","")),"/","")
	return [FileDir,FileName]
}
;************************************************************
				;13↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\GetActiveControlIsOfClass.ahk
/*
# GetActiveControlIsOfClass函数说明书(apidoc)
## 功能介绍(默认下) :
获取当前已经激活的控件的Class/ClassNN
## 参数介绍
### Option:默认返回Class,如果改为"ClassNN"那么就返回这个的ClassNN
;---------------------------------------------------------------------------------------------------------------
# 版本信息
v0.1 : 草创
*/
;---------------------------------------------------------------------------------------------------------------
/*
# 经验和花絮(非必须):我对 GetActiveControlIsOfClass函数 的认识和学习过程
# 目的:
# 展望:
# 过程:但是我是为了解决"印象笔记控件"语境约束的问题来查的资料,在这个官方文档中得到了答案,然后对于命令的意思也进行了查证,最后封装成了"ActiveControlIsOfClass"函数
# 来源 https://wyagd001.github.io/zh-cn/docs/commands/_If.htm#Examples
##
*/
;# GetControlIsOfClass 获取控件类名Class或者ClassNN
GetActiveControlIsOfClass(Option:="Class"){
local
    ControlGetFocus, FocusedControl, A
	if (Option="ClassNN")
	return,% FocusedControl
    ControlGet, FocusedControlHwnd, Hwnd,, %FocusedControl%, A
    WinGetClass, FocusedControlClass, ahk_id %FocusedControlHwnd%
    return,% FocusedControlClass
}
;************************************************************
				;14↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\isNumber.ahk
/*
# isNumber函数说明书(apidoc)
## 功能介绍(默认下) :
检查一个字符串是否为数字,是则true,否则返回false
## 参数介绍
### WaitCheckString 待检查的字符串
;---------------------------------------------------------------------------------------------------------------
# 版本信息
v0.1 :草创
*/
;---------------------------------------------------------------------------------------------------------------
/*
# 经验和花絮(非必须):我对 isNumber函数 的认识和学习过程
# 目的:
# 展望:
# 过程:
##
*/
;# 检查是否为数字
isNumber(WaitCheckString){
	local
	return % RegExMatch(WaitCheckString,"[0-9]+")
}
;************************************************************
				;15↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\JumpAndSearch.ahk
/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 脚本名称：一键跳转并搜索选中文字(JumpAndSearch)(用印象笔记作为例子)
; AHK版本：	1.1.30
; 语言：中文
; 作者：心如止水<QQ:2531574300>   <Autohotkey高手群（348016704)> 
; 参考了 交流群里"九九归一"的《用Everything搜索选中文字》
;# 灵感来自交流群里"九九归一"的《用Everything搜索选中文字》,我觉得印象笔记也需要这么一个热键,所以就简单移植了一下。后来干脆做成通用的了。
;# 改进方面:1,采用了SuperCopy的函数,兼容性更好,更易用。2,通用化。3,支持很多复杂情况。
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# JumpAndSear函数说明书 AHK版本：	1.1.30
# 语言：中文
# 作者：心如止水<QQ:2531574300>   <Autohotkey高手群（348016704)> 
## 功能介绍(默认下) :
一键跳转并且填写文字到控件,可以用于Everthing/印象笔记等的一键搜索
## 参数介绍
### WinTitle 要跳转的窗口名称
### TextControlClassNN 要发送点击并且填写文字的控件名称(ClassNN)
### ThisPath 程序路径(如果没有找到程序的话，先run程序)
### EnableInPutBox (是否在没有复制到文本的情况下弹出InputBox手动输入文本)
### TextOnInputBox (在InputBox上再加上一些字符串来说明)
### Prefix (在set到control的text之前可以加入前缀)
### TheSoftName 要跳转到的那个软件的名称(主要是为了TrayTip提示的方便)
### EnableOnlyClickMode 开启这个模式之后，在InputBox对话框中可以直接按下Ctrl/Alt跳转到对应的应用而不发送text到控件
### OnlyInputBox 开启这个模式之后只能通过InputBox而不是通过Copy获取用户输入
;---------------------------------------------------------------------------------------------------------------
; ^_^： 如果您有什么新的想法和改进的建议,或者是发现了BUG,欢迎加我的QQ,一起探讨改进 ：^_^
;# 以下是版本信息
v1.5 Beta 1,Class和控件变量化 2,SuperCopy的fast参数改为5 3,TrayTip内容优化 4,注释掉"MsgBox,% path",调试用的,忘记注释了 5,路径变量化 6,对于错误的处理更好
v1.6 Beta 修复变量漏下忘记用导致的控件使用错误问题
v1.7 Beta 1,可以在字符串前面加内容,比如印象笔记中经常用到标题搜索"intitle:" 2,lib化
v2.0.1,修复了当程序不存在的时候开启后不 Set Text 的问题 2,增加OnlyClick模式 也就是说在没有复制的内容，而开启文本框之后,如果再按一下Ctrl或者Alt那么就直接跳转,而不填入内容(有时候我们只是需要跳转而已) 3,lib化,参数直接调用函数传入即可。
v2.1 优化了InputBox上面的文字提示
v2.2 1,前缀会显示在input上 2,增加了对于仅仅使用inputbox而不不使用复制的选项
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
JumpAndSearch(WinTitle,TextControlClassNN,ThisPath,EnableInPutBox:=1,TextOnInputBox:="",Prefix:="",TheSoftName:="",EnableOnlyClickMode:=true,OnlyInputBox:=false){
local
InputBoxTitle:="JumpAndSearch : 复制失败"
if (EnableOnlyClickMode){
InputBoxTitle.="(支持Alt/Ctrl仅跳转)"
Hotkey, If, WinActive("(支持Alt/Ctrl仅跳转)")
Hotkey,Ctrl,jtjt,T5
Hotkey, If, WinActive("(支持Alt/Ctrl仅跳转)")
Hotkey,Alt,jtjt,T5
;# 这里为什么关闭?
OnlyClick:=false
}
try
{
	;# 这个是故意利用异常捕获的语句,通过这个禁用掉复制功能,还能触发Catch
	if (OnlyInputBox){
	ControlGet,◆◇TmTi◇◆, Line, ◆◇TmTi, ◆◇TmTi,◆◇TmTi
	}
	;# 这就是故意开启"legacy",因为保留在剪贴板上是有用的,因为可能下一分钟你就需要了
TheText:=SuperCopy(5,,true) 
}
catch
{
	 if(EnableInPutBox=1){
	 if (EnableOnlyClickMode)
	InputBox,t2,%InputBoxTitle%,% "未能复制到内容，请输入文本(默认文本是剪切板上面的)`r`n(按下取消程序就结束,输入文本按下Enter或OK会继续搜索`)`r`n`r`n按下Ctrl/Alt可以仅仅跳转聚焦而不会把Text填入控件中`r`n" TextOnInputBox,,,,,,,,%Clipboard%
	else
			InputBox,t2,%InputBoxTitle%,% "未能复制到内容，请输入文本(默认文本是剪切板上面的)`r`n(按下取消程序就结束,输入文本按下Enter或OK会继续搜索`)`r`n" TextOnInputBox,,,,,,,,%Clipboard%
	;如果发现用户取消了，那么什么也不做
	if (ErrorLevel=1){
		return
	}
	;# Ruo给用户没有取消
    else {
	TheText:=t2
	;# 如果◇仅跳转聚焦◇的话，并且用户填入了EnableOnlyClickMode,那就开启这个
	if (TheText="◇仅跳转聚焦◇") AND (EnableOnlyClickMode=true)
		;# 如果用户按下了Ctrl/Alt这个就改为true,表示之后不填写只是聚焦
	OnlyClick:=true
	}
    
	 }
	 ;# 如果发现报错,但是box选项没开启,那就干脆直接清零，防止错误
	 else{
	 TheText:=""
	 }
}
; # 在这里加上前缀
if !(prefix="")
	TheText:=prefix TheText
;## 如果发现对应窗口存在则激活并且填入
ifwinexist %WinTitle%
{
WinActivate %WinTitle%
WinMaximize %WinTitle%
SetTextAndClick(WinTitle,TextControlClassNN,TheText,,OnlyClick)
/*
;# 如果注册过热键,走之前应该全消除掉
;# 11月10日 改用特殊标题+语境约束实现了
if (EnableOnlyClickMode){
Hotkey,Ctrl,jtjt,Off
Hotkey,Alt,jtjt,Off
}
*/
}
;## 如果发现存在,开启之后激活并且填入
Else
      {
         TrayTip,在%TheSoftName%内搜索,找不到%TheSoftName%的Class%WinTitle%`n将会先启动%TheSoftName%,,1               
		try
	 {
     Run, %thispath%
	 }
	   catch
	 {
	 MsgBox,16,错误,没有找到路径或没有权限运行`n路径如下`n%thispath%
	 return
	 }
	WinWait,%WinTitle%,,3
if (ErrorLevel=1)
{
		;~ MsgBox,5
	 MsgBox,16,错误,路径存在,但%TheSoftName%窗口并未出现(或超时)
	 return
	 }
WinActivate %WinTitle%
WinMaximize %WinTitle%
;# 如果窗口出现 则跳转并填入
SetTextAndClick(WinTitle,TextControlClassNN,TheText,,OnlyClick)
/*
;# 如果注册过热键,走之前应该全消除掉
;# 11月10日 改用特殊标题+语境约束实现了
if (EnableOnlyClickMode){
Hotkey,Ctrl,jtjt,Off
Hotkey,Alt,jtjt,Off
}
*/
Return
      }
Return
 }
;--------------------------------------------------------------------------------------------------------------- 
jtjt(){
local
SendByClip("◇仅跳转聚焦◇")
Sleep 50
Send,{Enter}
return
}
;--------------------------------------------------------------------------------------------------------------- 
;# 为HotKey命令提前建立 "#If 表达式" ,因为HotKey命令只是能够用现有的"#If 表达式"实现语境约束的效果。
#If WinActive("(支持Alt/Ctrl仅跳转)") 
#If 
;--------------------------------------------------------------------------------------------------------------- 
;************************************************************
				;16↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\KeysExtract.ahk
/*◆
# Library 库名 : KeysExtract.ahk
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	一键从字符串中提取含有某关键字(字符串)的行
# ParaMetersList	参数列表 :
Str是输入的字符串
TheKeys是需要去检查匹配的"关键词",可以使用‘|’设立多个关键词(是‘或’的关系)
EnablereturnArray 打开之后,不返回合并好的String,而是返回String二维数组,关闭则返回String一维数组。[1]是匹配的,[2]是不匹配的。
ModifyMode是修改模式,当使用复制调用该函数的时候,可以直接修改对应文本。0代表关闭模式,1只留下不匹配的UnMatchedString(最常用),2,只留下匹配的,MatchedString。改参数只有EnablereturnArray打开时才有效果。
EnableWriteClip是否放到剪贴板上,这个必须在ModifyMode开启的情况下才有用,开启之后部分内容替换原来选中的内容,剩下的内容放到剪切板上。
EnableTrayTip,这个不用多说，很简单,就是"是否开启托盘通知",默认是开的
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : KeysExtract.ahk 的第一个版本上线了 O(∩_∩)O~
	v2.0:修复了`n无法被分割,导致程序运行异常的问题
# 依赖库 :
	[请填写依赖库名]
# 常见问题 :
	有没有实战案例?
		不一定每个都有，如果有就在这里 https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
	√
*/
KeysExtract(Str,TheKeys,EnableReturnArray:=false,ModifyMode:=false,EnableWriteClip:=false,EnableTrayTip:=true){
local
MatchedNumber:=0,UnMatchedNumber:=0
;# 如果修改模式打开着,并且返回数组模式也打开着,那么就报错
if !(ModifyMode!=false) AND (EnableReturnArray)
throw ("ModifyMode只在EnableReturnrray关闭时才生效")
;# 创建数组后, 初始为空
MatchedArray := [] 
UnMatchedArray := [] 
;# `n转为`r`n
Str:=RegExReplace(Str,"\R","`r`n")
;# 去除空行
Str:=RemoveAllBlankLines(Str)
;# 以行为单位,分割为数组(源数组)
ScrArray := StrSplit(Str,"`r`n") 
;# 检测
loop % ScrArray.MaxIndex()
{
;# 拿出每个行的字符串来
substring := ScrArray[a_index]
;# 检测看看包含不包含指定词汇
SuBkey:=checkString(substring,TheKeys)
;# 如果包含那就加进MatchedArray,否则加进UnMatchedArray
;## 进行统计
if (SuBkey){
MatchedArray.Push(substring)
MatchedNumber++
}
else{
UnMatchedArray.Push(substring)
UnMatchedNumber++
}
}
;# 出了检测循环之后,用一下tarytip提示一下数量
if (EnableTrayTip)
TrayTip,关键词提取匹配数量,%MatchedNumber%行成功匹配`r`n%UnMatchedNumber%行未能匹配
;# 如果要求返回数组，那就直接返回
if (EnableReturnArray){
return [MatchedArray,UnMatchedArray]
}
;# 如果不要求，那就重新合成行,并且返回一个数组,分别带有匹配的行组成的String,和不匹配的
else{
	;# 初始化一下
MatchedString:=""
UnMatchedString:=""
;# 制作匹配的String
;# 从数组还原为换行文本(MatchedString)
loop % MatchedArray.MaxIndex()
{
MatchedString:=MatchedString "`r`n" MatchedArray[A_Index] 
}
loop % UnMatchedArray.MaxIndex()
{
UnMatchedString:=UnMatchedString "`r`n" UnMatchedArray[A_Index] 
}
;# 开始发送修改 
;## 模式1留下不匹配的
if (ModifyMode=1){
	Sleep 150
SendByClip(UnMatchedString)
Sleep 0
;## 如果开启剪切板写入，那就把剩下的放到上面
if (EnableWriteClip)
Clipboard:=MatchedString
}
	
;## 模式2留下匹配的
else if (ModifyMode=2){
		Sleep 150
SendByClip(MatchedString)
Sleep 0
;## 如果开启剪切板写入，那就把剩下的放到上面
if (EnableWriteClip)
Clipboard:=UnMatchedString
}
	
;# 把两个字符串合并成一个大数组
TwoStringArray := [MatchedString,UnMatchedString]
;# 返回二维数组
return TwoStringArray
}
}
;************************************************************
				;17↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\MakeDeBugAnnotation.ahk
/*
# MakeDeBugAnnotation函数说明书(apidocAHK版本：	1.1.30
# 语言：中文
# 作者：心如止水<QQ:2531574300>   <Autohotkey高手群（348016704)>
## 功能介绍(默认下) :
[功能介绍]
## 参数介绍
### [参数1]
;---------------------------------------------------------------------------------------------------------------
# 借鉴
# 版本信息
v0.1 : 草创
*/
;---------------------------------------------------------------------------------------------------------------
/*
# 经验和花絮(非必须):我对 MakeDeBugAnnotation函数 的认识和学习过程
# 目的:
# 展望:
# 过程:
##
*/
;# MakeDeBugAnnotation
MakeDeBugAnnotation(ScrText,Annotation0,Annotation1){
	local
;# 先把原文复制出来
try
{
ScrText:=supercopy(60) ;√√
}
;# 复制失败抛出异常
catch
{
throw Exception("未能复制到内容`r`n请重新选择")
return
}
;# 如果复制成功了,那么制作新的字符串
ResultString:=Annotation0 ScrText Annotation1
;# 返回字符串
return,% ResultString
}
;************************************************************
				;18↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\MyInputBox.ahk
/*
# MyInputBox函数说明书(apidoc) AHK版本：	1.1.30
# 语言：中文
# 作者：心如止水<QQ:2531574300> <AHK持续学习者沙龙(928220639)> <Autohotkey高手群(348016704)>
## 功能介绍(默认下) :
[功能介绍]
## 实例
## 参数介绍
### [参数1]
;---------------------------------------------------------------------------------------------------------------
# 版本信息
v1.0 : 第一个版本上线了 ^_^
*/
;---------------------------------------------------------------------------------------------------------------
MyInputBox(InputBoxTitle,TextOnInputBox,DeFaultText:="UseClipboard",Prefix:=""){
	
local
if (DeFaultText="UseClipboard") ;默认使用剪切板
DeFaultText:=Clipboard
InputBox,UserInput,%InputBoxTitle%,%TextOnInputBox%,,,,,,,,%DeFaultText%
	if (ErrorLevel=1){ ;必须立即判断，不能有间隔
throw Exception("User Cancel Input`r`n用户取消输入")
	}
	
UserInput:=Prefix UserInput ;给用户输入的内容增加前缀
Return UserInput
 }
;************************************************************
				;19↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\ObjectToSimpleArray.ahk
/*◆
# Library 库名 : ObjectToSimpleArray
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	[请填写功能介绍]
# ParaMetersList	参数列表 :
	[示例参数列表]
	HayStack - 被搜索的字符串
	Count - 循环次数
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : ObjectToSimpleArray 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	[请填写依赖库名]
# 常见问题 :
	有没有实战案例?
	一定有至少一个[11月21日起]
	如果有更多大型复杂案例会放在这里
	https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果]
*/
;通过枚举器把非线性变成线性的
ObjectToSimpleArray(Obj){
    local
	OC:=ObjectTypeDetect(Obj)
	if Not(InStr(TheType,"Object"))
		throw Exception("Obj is not a AssociativeArray.`r`nIt is " . OC . "`r`n" . "传入的参数并不是一个关联数组.")
	;~ if (Obj.Count()!="") OR (Obj.Count()!=0)
		;~ throw Exception("There are not elements in the Obj " . OC . "`r`n" . "传入的参数并不是一个关联数组.")
	newArr:=[]  ;建立一个新对象
	for k, v in Obj
	{
		newArr.push(v)
	}
	return newArr
		;~ tempArr:=Obj
	;~ Obj:=newArr
}
;************************************************************
				;20↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\ObjectTypeDetect.ahk
/*◆
# Library 库名 : ObjectTypeDetect
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
# ParaMetersList	参数列表 :
	[示例参数列表]
	HayStack - 被搜索的字符串
	Count - 循环次数
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : ObjectTypeDetect 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	[请填写依赖库名]
# 常见问题 :
	有没有实战案例?
	一定有至少一个[11月21日起]
	如果有更多大型复杂案例会放在这里
	https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果] 未测试
*/
ObjectTypeDetect(TheObj){
local
RX_c:=""
;String 类型测试
	if Not(isObject(TheObj)){
		if (TheObj="")
			return ("NullString")
		else if (TheObj=true)
			return ("BooleanString_true")
		else if (TheObj=false)
			return ("BooleanString_false")
		else if (IsFunc(TheObj))
			return ("FunctionNameString")
		else
		return ("String")
	}
;---------------------------------------------------------------------- 
;Custom_Objects 类型测试
TheInit:=TheObj.Base.__Init.Name,TheClassName:=TheObj.Base.__Class,:=RegExMatch(TheInit,"(__Init)$",RX),RX_c:=RX="__Init"
if (RX_c) AND (TheClassName!=""){
	return "Custom_Objects"
}
;Custom_Classes 类型测试
TheInit:=TheObj.__Init.Name,TheClassName:=TheObj.__Class,RegExMatch(TheInit,"(__Init)$",RX),RX_c:=RX="__Init"
if (RX_c) AND (TheClassName!=""){
		return "Custom_Classes"
}
;---------------------------------------------------------------------- 
;SimpleArray 类型测试
len:=TheObj.Length(),keyCount:=TheObj.Count() ;计算长度和Key键数,如果一致,那么必定是SimpleArray
if (len=keyCount) AND (keyCount!=0)
	return "SimpleArray"
;---------------------------------------------------------------------- 
;FuncObject 类型测试
if (TheObj.Name!="") AND (TheObj.IsOptional(1)!="")
	return "FuncObject"
;FileObject 类型测试
F1:=TheObj.Length=TheObj.Length(),F2:=TheObj.AtEOF!="",F3:=TheObj.Pos!="",FC:=F1+F2+F3=3
if (FC)
	return "FileObject"
;---------------------------------------------------------------------- 
;如果以上都不是，那么就是“未知类型”,如果count是0,要特别提示一下
if (TheObj.count()=0)
return "ObjectWithNotKey-Value"
else
return "UnknownObjectType"
}
;************************************************************
				;21↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\OneNoteSend.ahk
;# 这个只要是有换行都可以用(建议但建议加上实体框线)
;# 在Excel中实现像滴答清单中那种发送前缀的效果
;## 实现的是仿照滴答清单的效果 
;## 1,先回到行首 2,添加相关关键词 3,再回到下一行
OneNoteSend(t:="",ToNext:=true){
local
;# 回到本区域行首
;# 不是原理很简单就是^{Up},不过为了防止本来就在第一个产生干扰,所以说先向右移动一下
Sleep 0
OneNoteToHome()
;# 到达行首区域，后把内容给粘贴上
Sleep 0
SendByClip(t)
;# 默认是开启ToNext的,这个很简单，其实就是^{Down}
Sleep 0
if (ToNext)
OneNoteToNextHome()
return
}
;# 一键回到行尾 √
OneNoteToEnd(){
local
Send,^a
Sleep 0
Send,{Right}
}
;# 一键回到本行行首 √
OneNoteToHome(){
local
Send,^a
Sleep 0
Send,{Left}
return
}
;# 一键回到上一行行首(如果已经在行首，那么就是回上一个的行首,SendRight开启是一个变通的方案)
OneNoteToLastHome(){
local
	;## 先回到本行行首
OneNoteToHome()
;## 然后按住Ctrl按下Up,回到上一行行首了
Sleep 0
send,{Ctrl Down}
Sleep 25
send,{up}
Send,{Ctrl Up}
return
}
;# 一键回到下一行行首(这个最简单,就是按下CTRL之后，再按方向下)
OneNoteToNextHome(){
local
Send,^{Down}
return
}
;************************************************************
				;22↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\print.ahk
/*◆
# Library 库名 : print
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	输出到SciTE控制台
# ParaMetersList	参数列表 :
	text需要输出的文本
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : print 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	[请填写依赖库名]
# 常见问题 :
	有没有实战案例?
		不一定每个都有，如果有就在这里 https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
*/
;下面列出了两种方案,一个是AHK自带的标准输出,一个是利用SciTE的COM,最后还是选择了后者
	;后者的问题在于不会自动刷新,但是前者的自动刷新也仅限于手动点击SciTE的时候
		;后者可能通过调用COM方法清除,但是我目前不知道怎么操作,应该是可以的
;standard output 的缩写是stdout
stdoutln(TheText,Encoding:="UTF-8"){
stdout(TheText "`r`n",Encoding)
return
}
stdout(TheText,Encoding:="UTF-8"){
FileAppend,% TheText,*,% Encoding
return
}


print(TheText){
local
if (IsObject(CreatSciTEObj()))
SendMessage,CreatSciTEObj().Output(TheText)
return
}

println(TheText){
local
text:=TheText "`r`n"
print(text)
return
}	
;************************************************************
				;25↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\Puritytest.ahk
/*
# Puritytest函数说明书(apidoc) AHK版本：	1.1.30
# 语言：中文
# 作者：心如止水<QQ:2531574300> <AHK持续学习者沙龙(928220639)> <Autohotkey高手群(348016704)>
## 功能介绍(默认下) :
检查HayStack中是否包含"Array_1"或"Array_2"的元素关键词,根据有无一共有四种情况,检查之后会返回字符串
## 参数介绍
### HayStack 被检查的字符串
### Array_1 关键词数组1
### Array_2 关键词数组2
;---------------------------------------------------------------------------------------------------------------
# 借鉴
# 版本信息
v0.1 : 草创
*/
;---------------------------------------------------------------------------------------------------------------
/*
# 经验和花絮(非必须):我对 Puritytest函数 的认识和学习过程
# 目的:
# 展望:
# 过程:
##
*/
Puritytest(HayStack,Array_1,Array_2){
	local
/*
	HayStack:="88a44*4de"
	Array_1:=["a"],["b"]
	Array_2:=["#"],["@"]
*/
	R1:=checkString(HayStack,Array_1)
	R2:=checkString(HayStack,Array_2)
	;# 情况一:√√"Find 1AND2"
	;# 情况二:√"Only Find 1"
	;# 情况三: √"Only Find 2"
	;# 情况四:  "Not Find"
	if (R1+R2)=0
		return "Not Find"
	else if (R1+R2)=2
		return "Find 1AND2"
	else if (R1)
		return "Find 1"
	else if (R2)
		return "Find 2"
	else
		Exception("Puritytest:UnKnownError01")
	Exception("Puritytest:UnKnownError02")
}
;************************************************************
				;26X ↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\RegexEscape.ah
;EscapeChar是转义字符,WaitEscapeArr是需要被转义的字符数组(仅接受简单数组),String待转义文本
Escape(EscapeChar,WaitEscapeArr,String){
local
;检查String\EscapeChar格式
isString(EscapeChar)
isString(String,true)
if (String="")
	return ;return 和 return "" 等价
if !(ObjectTypeDetect(WaitEscapeArr)="SimpleArray")
	Exception("WaitEscapeArr is not SimpleArray")
WaitEscapeArr.InsertAt(1,EscapeChar) ;把转义字符本身放在第一位
;遍历TheArray,如果发现有匹配,则全部替换为’\‘
for index,p in WaitEscapeArr{
if instr(String,p){
	Newp:="\" . p
String:=StrReplace(String,p,Newp)
}
}
return String
}
;************************************************************
				;26↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\RegexEscape.ah
RegexEscapeInAS(AS){
local
for key,s in AS{
AS[key]:=RegexEscape(s)
}
return AS
}
;************************************************************
				;26↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\RegexEscape.ah
RegexEscape(s){
local
RegArr:=[".","?","+","$","^","[","]","(",")","{","}","*","/","|"]
return Escape("\",RegArr,s)
}
;************************************************************
				;26NN ↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\RegexEscape.ah
;普通转义解析
NormalEscapeParse(s){
local
return NormalEscape(s,1)
}
;************************************************************
				;26N ↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\RegexEscape.ah
;普通转义
NormalEscape(s,Negative:=0){
	
local
SearchArray:=["\","`n","`r","`t"]
ReplaceArray:=["\\","\n","\r","\t"]
News:=StringReplaceBaseOnArray(s,SearchArray,ReplaceArray,0,Negative)
return News
}
;************************************************************
				;27↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\RemoveAllBlankLines.ahk
;# 去除多余的空行(支持深度清洁,也就是不只是换行，段首空白符也一起干掉)
;# Remove all blank lines from the text in a variable:
RemoveAllBlankLines(MyString,EnableDeepClean:=false){
	local
if (EnableDeepClean)
MyString:=RemoveBlankChar(MyString)
;# 这个意思是"多于1个(或者说2个以上)的换行符字符"串,全部替换为1个换行符
result := RegExReplace(MyString, "\R+\R", "`r`n")
return,%result%
}
;# 移除段首空白字符(除换行/回车/垂直制表符之外)
RemoveBlankChar(MyString){
	local
;# 这个意思只要"换行符后面跟着空白字符"的字符串就,全部替换为1个换行符
;~ result := RegExReplace(MyString, "\R\s*", "`r`n")
;# 匹配"空格"+"换页符"+"水平制表符" 如果匹配全部的\s,那么容易误伤
result := RegExReplace(MyString, "\R[ \f\t]*", "`r`n")
return,%result%
}
/*
;# 这是个老的方案，先不用了(效果不如上面,差距很大很大)
RemoveAllBlankLines(MyString){
	exitc:=0
	;# 刚才查了一下，之所以只用第二个失败的原因就是,可能有些是`n而有些却是`r`n,正则表达式都可以匹配，所以第一个直接用是行的。但是为了彻底一点，我还是都用吧。原理我还没有搞清楚，以后有时间的话，仔细的研究研究。
	;# 统一替换为`n了
Loop
{
	;~ https://autohotkey.com/board/topic/115962-regex-to-remove-blank-lines/
    StringReplace, MyString, MyString, `r`n`r`n, `r`n, UseErrorLevel
	  if ErrorLevel = 0  ; No more replacements needed.
        exitc++
    StringReplace, MyString, MyString, `n`n, `r`n, UseErrorLevel
    if ErrorLevel = 0  ; No more replacements needed.
        exitc++
	if (exitc++>1)
		break
}
return,%MyString%
}
*/
;************************************************************
				;28↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\ReplaceiThoughtsMarkDownTitle.ahk
/*◆
# Library 库名 : ReplaceiThoughtsMarkDownTitle
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	[请填写功能介绍]
# ParaMetersList	参数列表 :
	[示例参数列表]
	HayStack - 被搜索的字符串
	Count - 循环次数
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : ReplaceiThoughtsMarkDownTitle 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	[请填写依赖库名]
# 常见问题 :
	有没有实战案例?
		不一定每个都有，如果有就在这里 https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果]
*/
ReplaceiThoughtsMarkDownTitle(Amount:=1){
	local
	;设置该线程不会被中断(加上了之后，果然速度嗖嗖的)
	Critical
	s:=""
	SendInput,{F2}
	SendInput,^a
try{
	Haystack:=SuperCopy(10)
SendInput,{Delete}
}
catch{
Haystack:=""
}
if (Haystack!="")
Haystack:=RegExReplace(Haystack,"#+\s")
	SendInput,^{Home}
;采用数组，希望能够提高些速度
s:=["#","##","###","####","#####","######","#######","########"] 
if (Haystack!="")
return s[Amount] . " " . Haystack
else
return s[Amount] . " " 
}






;************************************************************
				;29↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\ReturnDate.ahk
;# EnableEscape是"开启转义"的意思
ReturnDate(Format,SimpleModel:=false,EnableEscape:=false){
local
	if (SimpleModel){ ;# 简洁模式IF开启
	
	;# 月日
if (Format="yr"){
	FormatTime, CurrentDateTime,,MM/dd
	return,% CurrentDateTime
}
;# 年月日
else if (Format="nyr"){
	FormatTime, CurrentDateTime,, yy/MM/dd
			return,% CurrentDateTime
}
;# 月日时分
else if (Format="yruf"){
	FormatTime, CurrentDateTime,,MM/dd_HH:mm
	}
	
;# 年月日时分
else if (Format="nyruf"){
	if EnableEscape
	{
		FormatTime, CurrentDateTime,,yy/MM/dd\_HH:mm
	return,% CurrentDateTime
	}
	FormatTime, CurrentDateTime,,yy/MM/dd_HH:mm
	return,% CurrentDateTime
	}
	
	
	} ;# 简洁模式IF结束
else if (SimpleModel=false){ ;#复杂模式ELSE开启
;# 月日
if (Format="yr"){
	FormatTime, CurrentDateTime,,MM月dd日
	return,% CurrentDateTime
}
;# 年月日
else if (Format="nyr"){
	FormatTime, CurrentDateTime,, yyyy年MM月dd日
			return,% CurrentDateTime
}
;# 月日时分
else if (Format="yruf"){
	FormatTime, CurrentDateTime,,MM月dd日_HH时mm分
	return,% CurrentDateTime
	}
	
;# 年月日时分
else if (Format="nyruf"){
	FormatTime, CurrentDateTime,,yyyy年MM月dd日_HH时mm分
	return,% CurrentDateTime
	}
	;# 年月日时分秒
else if (Format="nyrufm"){
	FormatTime, CurrentDateTime,,yyyy年MM月dd日_HH时mm分ss秒
	return,% CurrentDateTime
	}
	
		;# 日时分秒
else if (Format="rufm"){
	FormatTime, CurrentDateTime,,dd日_HH时mm分ss秒
	return,% CurrentDateTime
	}
	
;# 年月日时分(思维导图协作专用)xz=协作
else if (Format="xz"){
	FormatTime, CurrentDateTime,,yy/MM/dd_HH:mm
	return,% CurrentDateTime
	}
} ;# 复杂模式ElSE结束
	
;# 如果那么多条件筛选之后都没有出现return,那么很可能是格式错误
throw Exception("The Format Parameter Error")
}
;************************************************************
				;30↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\RunBySpecificSoftware.ahk
/*
# Library 库名
RunBySpecificSoftware
# Specification(Default ParaMeters)	功能介绍(默认下)
用户输入exe程序路径和文档路径(用‘|’分隔,支持批量)
用指定exe打开这些文档
# ParaMetersList	参数列表
SoftPath - exe程序路径
FileStringGroup - 文档路径(用‘|’分隔,支持批量)
# Author	作者
心如止水
# AHK Version AHK版本
1.1.30
# Library Version 库版本
%库版本%
v1.0 : UseCMDRun 的第一个版本上线了 ^^
# 依赖库 : 
	StringGroupParseToSimpleArray
	UseCMD3
# Quality Test	出厂品控检测
√ 合格
# Copyright  版权声明
如果我的分享侵犯了您的权利，请尽快联系我解决。
欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上展示原文地址。
*/
RunBySpecificSoftware(SoftPath,FileStringGroup){
	local
	if (IsObject(FileStringGroup)){
		;# 如果发现本来就是数组,那么赋值就可以了
		FilePathArray:=FileStringGroup
	}
	else{
		;# 如果传入的是StringGroup则转为数组
		FilePathArray:=StringGroupParseToSimpleArray(FileStringGroup,"`|")
	}
	;# 用户输入软件路径之后合成Command头部
	FilePathString=start "" %SoftPath%
	
	Command:=FilePathString
	;# 遍历数组合成最终Command
	loop % FilePathArray.Length(){
		;# 字符串拼接
		;# 用引号把每一个路径都包裹起来，并且在每一个的前面加入空格
		;~ if ((isURL(FilePathArray[A_Index])) OR (isPath(FilePathArray[A_Index]))){
		if (true){ ;原来所有的都可以加双引号,一开始我以为 --new-window 这种不行,所以提前判断,现在看来没必要
		Command.=" "
		Command.="""" . FilePathArray[A_Index] . """"
		}
		;~ else{
		;~ Command.=" " . FilePathArray[A_Index]
		;~ }
	}
;~ MsgBox,% Command
	UseCMD3(Command)
	;## 运行结束返回
	return
}
;************************************************************
				;31↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\SendByclip.ahk
;# RestoreClip的意思是,"还原剪切板",因为通过这个方法复制的时候,需要从剪贴板里走,开启这个的话，那么剪切板就还原成没操作之前的样子(应该是完全一样的,格式也不会丢失,因为用的是ClipboardAll)
SendByClip(var_string,HomeOrEnd:=0,LeftOrRight:=0,RestoreClip:=true,HomeOrEnd_AfterSending:=0,EnableTrayTip:=0){
    local
    Critical ;保证线程不被中断
    ;# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ;                                                          特别注意,修改参数列表时，不要忘记修改SendByClip_s1函数
;~ /*
;# 突然发现只有Ditto会出现那种情况，其他的就不会出现，多此一举
    ;# 如果是在SciTE中,点击编辑区域,防止焦点在搜索/替换框中,导致粘贴内容失败
    if WinActive("ahk_class SciTEWindow"){
        Sleep 0
        Send,{Esc 2}
    }
;~ */
    Sleep 5
    
	;## 简单模式:如果是简单模式的话(就是后面两个参数根本没填) 那就干脆直接发送并return 应该能节约不少时间
	if ((HomeOrEnd+LeftOrRight)=0){
	SendByClip_s1(var_string,RestoreClip)
	return
	}
    
 ;# 发送Home/End(!!! 这个是在发送之前移动)
 ;## 只有在不为零并且不为空的情况下才可以继续进行
if (HomeOrEnd!=0) AND (HomeOrEnd!=""){
    ;## 如果是1或者"Home"发送"Home"
if (HomeOrEnd=1) Or (HomeOrEnd="Home")
  send,{Home}
     ;## 如果是-1或者"End"发送"End"
else if (HomeOrEnd=-1) Or (HomeOrEnd="End") 
  send,{End}  
}
;# Home或End是在字符串没有发送之前send的 , Left或者Right是之后
SendByClip_s1(var_string,RestoreClip,EnableTrayTip)
    
 ;# 发送Home/End(!!! 这个是在发送之前移动)
 ;## 只有在不为零并且不为空的情况下才可以继续进行
if (HomeOrEnd_AfterSending!=0) AND (HomeOrEnd_AfterSending!=""){
    ;## 如果是1或者"Home"发送"Home"
if (HomeOrEnd_AfterSending=1) Or (HomeOrEnd_AfterSending="Home")
  send,{Home}
     ;## 如果是-1或者"End"发送"End"
else if (HomeOrEnd_AfterSending=-1) Or (HomeOrEnd_AfterSending="End") 
  send,{End}  
  Sleep 30
}
;# 发送LeftOrRight(!!!Left或者Right是发送之后)
 ;## 只有在不为零并且不为空的情况下才可以继续进行
  if (LeftOrRight!=0) AND (LeftOrRight!=""){
    ;## 检测一下输入的字符串符合哪种格式
  L_RE := RegExMatch(LeftOrRight,"L[0-9]+")
  R_RE := RegExMatch(LeftOrRight,"R[0-9]+")
  ;## 如果两种格式均不匹配，那么就返回错误
    if (L_RE+R_RE=0)
    throw Exception ("""LeftOrRight"" Parameter Error")
    ;## 如果有匹配的，那么就继续进行
    ;### 下面else块的作用就是搞清楚到底Left还是Right被匹配了，如果匹配成功的话，那就按次数发送
else{
   ;## 计算发送次数
     ;### 删除可能的L或R(根据模式)
     if (L_RE){
     times := StrReplace(LeftOrRight,"L", "") 
     Send,{Left %times%}
     }
        else{
        times := StrReplace(LeftOrRight,"R", "") 
                Send,{Right %times%}
        }
}
} ;# 发送LeftOrRight结束
return
}
;# 把纯发送单独拿出来了
SendByClip_s1(var_string,RestoreClip,EnableTrayTip:=0){
local
   ;# 先把剪切板上旧的给存起来
   if (RestoreClip){
    ClipboardOld = %ClipboardAll%
   }
    
    ;把需要粘贴的赋值到剪切板,赋值后检测是否一致 。如果一致的话，那就输出；如果不一致，那么就延长时间，尝试5次
Loop,5
{
    Sleep 35
    Clipboard := ""
    ;至少停顿五毫秒,如果不行，那就延长时间
    if(A_Index>1)
    {
    Sleep,% (A_Index*50)
    }
    Sleep 25
    Clipboard := var_string
    ;~ 如果发现一致，就可以跳出循环
    if(Clipboard=var_string)
    {
    break
    }
}
    Sleep 5
	;~ ClipWait
send ^v
    Sleep 150
    ;这个停顿可能是非常关键的,因为在有些软件里按下^v后可能还没反应过来呢,剪切板就已经变回去了，导致发送失败
    ;# 然后再把旧的给还原
       if (RestoreClip){
    Clipboard := ClipboardOld  ; Restore previous contents of clipboard.
}
    Sleep 5
    if (EnableTrayTip)
TrayTip,%A_ScriptName% 提醒,剪切板中的内容已经成功被发送
    return
}
;************************************************************
				;32↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\SendText.ahk
;把这个命令包装成为函数,替换原有的SendText()十分方便
; {Text}%st%中间千万不要加空格,这个空格并不会被忽略
	;若传入的var_string是"simpleArray",进入热字串专用发送模式,[1]是第一个字符串,[2]是剩下的,最后加入空格,自动调节SendLevel到100  
;# 全面改造为SendByClip的多选项形式,不过由于这个不存在粘贴的兼容性问题,不需要事先检测SciTE按下E扫
SendText(var_string,HomeOrEnd:=0,LeftOrRight:=0,SE:=0){
	local
    
;用于发送热字串的专用模式
if (ObjectTypeDetect(var_string)="SimpleArray"){
		Sleep 25
		tempSendLevel:=A_SendLevel
	SendLevel 99 
	SimpleArray:=var_string
	P1:="",P2:="",P1:=SimpleArray[1],P2:=SimpleArray[2]
	SendInput,{text}%P1%
	Sleep 75
	println("P1:" p1)
	println("P2:" p2)
	SendEvent,{text}%P2%%A_Space%
	Sleep 75
	SendLevel %tempSendLevel% ;虽然只是在线程内有用,但是防止干扰同一个线程的内容,还是调回来好
	Sleep 90
	return
}
Critical ;保证线程不被中断.开启之后容易出现连续发送时顺序颠倒的问题,所以只在不发送热字串的时候使用
	;## 简单模式:如果是简单模式的话(就是后面两个参数根本没填) 那就干脆直接发送并return 应该能节约不少时间
	if ((HomeOrEnd+LeftOrRight)=0){
	SendText_s1(var_string,SE)
	return
	}
if (HomeOrEnd!=0) AND (HomeOrEnd!=""){
    ;## 如果是1或者"Home"发送"Home"
if (HomeOrEnd=1) Or (HomeOrEnd="Home")
  ;~ send,{Home}
                     ModeChangeSend("{Home}",se)
     ;## 如果是-1或者"End"发送"End"
else if (HomeOrEnd=-1) Or (HomeOrEnd="End")
  ;~ send,{End}  
                     ModeChangeSend("{End}",se)
}
;# Home或End是在字符串没有发送之前send的 , Left或者Right是之后
SendText_s1(var_string,SE)
;# 发送LeftOrRight
 ;## 只有在不为零并且不为空的情况下才可以继续进行
  if (LeftOrRight!=0) AND (LeftOrRight!=""){
    ;## 检测一下输入的字符串符合哪种格式
  L_RE := RegExMatch(LeftOrRight,"L[0-9]+")
  R_RE := RegExMatch(LeftOrRight,"R[0-9]+")
  ;## 如果两种格式均不匹配，那么就返回错误
    if (L_RE+R_RE=0)
    throw Exception ("""LeftOrRight"" Parameter Error")
    ;## 如果有匹配的，那么就继续进行
    ;### 下面else块的作用就是搞清楚到底Left还是Right被匹配了，如果匹配成功的话，那就按次数发送
else{
   ;## 计算发送次数
     ;### 删除可能的L或R(根据模式)
     if (L_RE){
     times := StrReplace(LeftOrRight,"L", "") 
     ;~ Send,{Left %times%}
                     ModeChangeSend("Left" . times,se)
     }
        else{
        times := StrReplace(LeftOrRight,"R", "") 
                ;~ Send,{Right %times%}
                ModeChangeSend("Right" . times,se)
        }
}
}
return
}
SendText_s1(var_string,se){
	local
;~ SendInput  {Text}%var_string%
ModeChangeSend("{Text}" . var_string,se)
;~ MsgBox,% " {Text}" . var_string
return
}  
ModeChangeSend(s,se){
  local
if (se){
  SendEvent %s%
  println(se)
  }
else
  SendInput %s%
return
}
;************************************************************
				;33↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\SetTextAndClick.ahk
/*◆
# Library 库名 : SetTextAndClick
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	主要服务于JumpAndSearch
# ParaMetersList	参数列表 :
	[示例参数列表]
	HayStack - 被搜索的字符串
	Count - 循环次数
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : SetTextAndClick 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	[请填写依赖库名]
# 常见问题 :
	有没有实战案例?
	一定有至少一个[11月21日起]
	如果有更多大型复杂案例会放在这里
	https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果]
*/
;--------------------------------------------------------------------------------------------------------------- 
;# EnableSleep是开启延迟(为了兼容性,默认开启)
;# OnlyClick是不给Control Set文本(默认是关闭,只在特殊情况下开启)
SetTextAndClick(WinTitle,TextControlClassNN,TheText,EnableSleep:=true,OnlyClick:=false){
	local
	if (EnableSleep)
	Sleep 80
	;# 如果并非只是点击,那么就setText
	if (OnlyClick=false)
ControlSetText, %TextControlClassNN% , %TheText%, %WinTitle%
	if (EnableSleep)
	Sleep 80
	; 点击一次是全选，点击两次就是焦点位于输入框右侧
ControlClick , %TextControlClassNN%,%WinTitle%,, L, 1, NA
ControlClick , %TextControlClassNN%,%WinTitle%,, L, 1, NA
return
}
;************************************************************
				;34↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\StringCutter.ahk
/*
# StringCutter函数说明书(apidoc)
## 功能介绍(默认下) :
从某字符串中提取出两个字符串之间的内容(支持多组)
## 参数介绍
### srctext:源字符串(要被Cut的字符串)
### key key2 分别是头尾两端,中间的就是返回的字符串
;---------------------------------------------------------------------------------------------------------------
# 版本信息
v0.1 :
最初版本建立(之前的时候是个半成品，虽然基本能用了，但是很多地方都没考虑到,这次想用的时候重新包装了一下)
*/
;---------------------------------------------------------------------------------------------------------------
/*
# 经验和花絮(非必须):我对 %TheFunctionName%函数 的认识和学习过程
# 目的: 
# 展望: 
# 过程:
## 
*/
; # StringCutter函数 字符串切割机
StringCutter(srctext,key,key2,CutTimes:="∞")
{
	local
	;# 第一件事情就是检查一下两个关键词是否存在于SrcText,必须两个都存在，才能继续运行,否则的话throw
	keyexist:=checkString(srctext,key)
	key2exist:=checkString(srctext,key2)
;# IF层级1:开始
	;# 确实有错误 则编织字符串  准备报错
	if ((keyexist+key2exist)!="2"){
		if  ((keyexist+key2exist)="0")
			ResultString:="key和key2都不存在"
		else if (keyexist)
			ResultString:="key2不存在"
		else if (key2exist)
			ResultString:="key不存在"
		else
			ResultString:="StringCutter 参数检查阶段 未知错误"
		throw Exception(ResultString) ;#结束
	} ;# IF层级1:结束
	;# 输入的key如果没有错误可以继续
	 ;# Else层级1(主):开始
	else{
		TheArray := []
		;# 先检查一下输入的CutTimes是否符合数字形式(如果是无穷"∞"就去这条路)
;# IF层级2:开始
		if (CutTimes="∞"){
			loop
			{ ;# 循环开始
				Pos=1 ;不变,1是起点
				c:=A_Index
				FoundPos := InStr(srctext,key,false,Pos,c) ;# 找到第一个关键词的位置
				;# 如果发现关键词找不到(在AHK中,之所以数组index默认从1开始,很重要的一个原因就是把0留出来当作错误,把>0当成是正确)
				if (FoundPos=0)
					break ;# 如果是0,说明找不着了,就退出循环
				;# 如果没有关键词被匹配了,那么循环就跳出
				;# 找到之后留下来做比对,因为这个函数c如果超了,那么就返回上一个，并不会报错,所以可以通过这种方法测算
				LastFoundPos:=FoundPos
				Pos2:=FoundPos+StrLen(key) ;#计算出寻找第二个关键词的起始位置
				c2=1 ;不变
				FoundPos2 := InStr(srctext,key2,false,Pos2,1)
								if (FoundPos2=0)
					break ;# 如果是0,说明找不着了,就退出循环
				textlength:=StrLen(key)+1
				textlength:=FoundPos2-FoundPos-textlength
				distance:=FoundPos2-Pos2
				TheSubStr:=SubStr(srctext,Pos2,distance)
				;# 写入到TheArray数组
				TheArray.Push(TheSubStr)
			} ;#循环跳出
		} ;# If层级2结束
		;# 如果不是无穷大的话，就走这条路
		;# Else层级2开始
		else ;#Else层级2开始
		{
			;# 先检查符合不符合格式
			CheckResult:= isNumber(CutTimes)
			;# 如果符合的话就进行,如果不符合就报错
			if (CheckResult){
				loop,%CutTimes%
				{ ;# 循环开始
					Pos=1 ;不变,1是起点
					c:=A_Index
					FoundPos := InStr(srctext,key,false,Pos,c) ;# 找到第一个关键词的位置
					if (FoundPos=0)
						break ;# 如果是0,说明找不着了,就退出循环
					;# 如果没有关键词被匹配了,那么循环就跳出
					;# 找到之后留下来做比对,因为这个函数c如果超了,那么就返回上一个，并不会报错,所以可以通过这种方法测算
					LastFoundPos:=FoundPos
					Pos2:=FoundPos+StrLen(key) ;#计算出寻找第二个关键词的起始位置
					c2=1 ;不变
					FoundPos2 := InStr(srctext,key2,false,Pos2,1)
						if (FoundPos2=0)
					break ;# 如果是0,说明找不着了,就退出循环
					
					textlength:=StrLen(key)+1
					textlength:=FoundPos2-FoundPos-textlength
					distance:=FoundPos2-Pos2
					TheSubStr:=SubStr(srctext,Pos2,distance)
					;# 写入到TheArray数组
					TheArray.Push(TheSubStr)
				} ;#循环跳出
			}
			;# 不符合就报错
			else
			{
				throw,Exception("CutTimes Parameter Error`r`n""分割次数""参数错误")
				;# 程序终结
			}
		} ;#Else2 层级结束
	} ;#Else1层级结束√
TheArrayString:=ArrayToString(TheArray)
	;# 返回数组程序终结
	TrayTip,Cutter出的数组,%TheArrayString%
	return TheArray
} ;#整个函数彻底结束
;---------------------------------------------------------------------------------------------------------------
;# 之前带注释的原版放在下面了,该函数如果想继续改进,要么有一个带注释的版本，会轻松不少
/*
; # StringCutter函数 字符串切割机
#Warn
;提取关键词
;方案1:渐进删除 首先找到.text提取出来,追加到字符串后面,然后再找到EndWith删除前面的所有内容, ;√
;改进1:支持开启正则匹配
;# 原文本
;~ srctext=
;~ (
;~ BBBACCCA
;~ )
srctext=
(
BBATTCBBAXXCCCTTCBBATDC
)
;# 关键词1
key:="BBA"
;# 关键词2
key2:="C"
loop,3{
;# 第一个关键词是从头找,推进是靠c的变化,而不是推移
Pos=1 ;不变,1是起点
;~ c:=1+((A_Index-1)*2) ;不断推移和变化(这里由于特殊情况去奇数)
c:=A_Index ;不断推移和变化(这里由于特殊情况去奇数)
;~ MsgBox,% c
FoundPos := InStr(srctext,key,false,Pos,c) ;# 找到第一个关键词的位置
;~ MsgBox,找到的key1的地点是%FoundPos%
;~ MsgBox,找到的key1的地点是%FoundPos%
;~ Pos2:=FoundPos+StrLen(key) ;#计算出寻找第二个关键词的起始位置
Pos2:=FoundPos+StrLen(key) ;#计算出寻找第二个关键词的起始位置
;~ MsgBox,那么下一个搜索地点是%Pos2%
;# 第二个关键词主要是靠第一个定位之后,通过推移来定位,而不是靠c,所以c=1
c2=1 ;不变
;~ Pos2:=FoundPos+StrLen(key);不断推进
FoundPos2 := InStr(srctext,key2,false,Pos2,1)
;~ FoundPos2 := InStr(srctext,key2,false,FoundPos+Len-1,1)
;~ MsgBox,找到的key2的地点是%FoundPos2%
;~ Pos2:=FoundPos+StrLen(key)
;~ MsgBox,那么下一个搜索地点是%Pos2%
;~ MsgBox % SubStr(srctext,Len,1) ; 返回 abc
textlength:=StrLen(key)+1
textlength:=FoundPos2-FoundPos-textlength
distance:=FoundPos2-Pos2
;~ MsgBox,% distance
;~ TheSubStr:=SubStr(srctext,FoundPos,textlength) ; 返回 abc
TheSubStr:=SubStr(srctext,Pos2,distance) ; 返回 abc
;~ MsgBox,% TheSubStr
}
*/
;************************************************************
				;35↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\StringGroupParseToSimpleArray.ahk
/*
# StringGroupParseToSimpleArray函数说明书(apidoc) AHK版本：	1.1.30
# 语言：中文
# 作者：心如止水<QQ:2531574300> <AHK持续学习者沙龙(928220639)> <Autohotkey高手群(348016704)>
## 功能介绍(默认下) :
把StringGroup切换为SimpleArray
## 参数介绍
### HayStack 待分割字符串
### Delimiters 分隔符(默认为"`|")
### EnableMsgBoxPrint 用MsgBox打印数组(默认为false)
### EnableTrim 删去两头的Delimiters
### EnableDelimitersSingle 删去重复的Delimiters
;---------------------------------------------------------------------------------------------------------------
# 借鉴
# 版本信息
v0.1 : 草创
*/
;---------------------------------------------------------------------------------------------------------------
StringGroupParseToSimpleArray(HayStack
,Delimiters:="`|"
,EnableThrow=true
,EnableMsgBoxPrint:=false
,EnableTrim:=true
,EnableDelimitersSingle:=true){
/* ;如果发现太长的搜不到的话,可以加一个这样的注释就搜得到了
StringGroupParseToSimpleArray(HayStack){
	}
*/
	
	local
	;# 检测是否为String,并且含有Delimiters 验收:
	;# 如果EnableThrow开启的话就抛出异常,关闭就原样返回(默认抛出异常).
	;## 检测是不是对象 
isString(HayStack)
	;## 检测一下String中是否含有分隔符 
	if NOT InStr(HayStack, Delimiters){
		if (Enablethrow)
			throw Exception("Error01:Not Find Delimiters in HayStack`r`n在您输入的字符串中，没有发现分隔符")
	}
	;# 确认无误之后，开始进行替换
	;# 如果发现有重复的，先变成一个(选项开启时)
	if (EnableDelimitersSingle){
		DelimitersInRegex:=RegexEscape(Delimiters) ;使用正则表达式之前,先要进行转义
		HayStack := RegExReplace(Haystack,DelimitersInRegex "{2,}" ,Delimiters)
	}
	;# 如果发现头部和尾部有分隔符那么清除掉的(选项开启时)(清除两头的东西，要在清除重复的东西之后)
	if (EnableTrim){
		HayStack :=  Trim(HayStack,Delimiters)
	}
	;## 建立空SimpleArray
	SimpleArray:=[]
  ;特别提示,之所以把传入的 Delimiters 改为单个字符  ▓ 是因为AHK自带的这个命令只能解析“字符”,如果输入的是“字符串”,那么它就会看成多个“字符”同时为分隔符,所以就会出现问题。
HayStack:=StrReplace(HayStack,Delimiters,"▓")
	;## 解析字符串
	loop,Parse,HayStack,% "▓"
	{
		;## 加入数组中
		SimpleArray.Push(A_LoopField)
	}
	;## 用MsgBox打印数组(可选)
	if (EnableMsgBoxPrint)
		PrintSA(SimpleArray)
	return SimpleArray
}
/*
出厂检测信息:√
是√否×合格?
*/
;************************************************************
				;36↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\StringInsertAt.ahk
/*◆
# Library 库名 : StringInsertAt
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
[请填写功能介绍]
# ParaMetersList	参数列表 :
[示例参数列表]
HayStack - 被搜索的字符串
Count - 循环次数
# Author	& AHK Version	AHK版本&作者 :
AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
如果该文侵犯了您的权利，请联系我解决。
欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
v1.0 : StringInsertAt 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
[请填写依赖库名]
# 常见问题 :
有没有实战案例?
不一定每个都有，如果有就在这里 https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
[请填写出厂品控检测结果]
*/
/*
# StringInsertAt函数说明书(apidoc) AHK版本：	1.1.30
# 语言：中文
# 作者：心如止水<QQ:2531574300> <AHK持续学习者沙龙(928220639)> <Autohotkey高手群(348016704)>
## 功能介绍(默认下) :
添加一个字符串到指定的位置(Index),可以选择index前/后以及替换对应index字符
## 实例
## 参数介绍
### HayStack 被插入的字符串
### Index 插入地点
### SubString 插入进去的字符串
### ReplaceMode 替换模式,开启之后对应Index的地方会被删除,所以说也就没有前后之分了,在该模式下RearMode失效
这个替换模式，可能比前后理解起来要更加的自然和灵活,比如说我想把第二个字符串s前面加一个◇,我直接可以替换s为◇s
### RearMode 在后方插入的模式(ReplaceMode关闭时才有效果)
;---------------------------------------------------------------------------------------------------------------
# 版本信息
v1.0 : StringInsertAt 的第一个版本上线了 ^_^
v2.0 : 1,加入替换模式ReplaceMode(放在参数列表的第四位,可选参数的第一位) 2,删除原来的DeBugMode(不利于后期参数列表扩展)
*/
;---------------------------------------------------------------------------------------------------------------
StringInsertAt(HayStack,Index,SubString,ReplaceMode:=0,RearMode:=0){
local
	if (ReplaceMode){
		if (StrLen(HayStack)<index)
			throw Exception("IndexOutOfBoundsException`r`n字符串Index越界")
		;# 既然是替换模式，那就没什么前后之分了
		S1 := SubStr(HayStack,1 ,index-1)
		S1_Search := SubStr(HayStack,1 ,index)
		S2 := StrReplace(Haystack, S1_Search , "", , 1)
		Result:=S1 SubString S2
	}
	;# 如果不是替换模式
	else{
		;# 默认是在前面加 如果RearMode开启则在后面加
		;# 如果index越界,发出错误提示
		if (StrLen(HayStack)<(index+RearMode))
			throw Exception("IndexOutOfBoundsException`r`n字符串Index越界")
		S1 := SubStr(HayStack,1 ,index-1+RearMode)
		S2 := StrReplace(Haystack, S1 , "", , 1)
		Result:=S1 SubString S2
	}
	return Result
}
;************************************************************
				;37↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\StringReplaceBaseOnArray.ahk
/*
# StringReplaceBaseOnArray函数说明书(apidoc) AHK版本：	1.1.30
# 语言：中文
# 作者：心如止水<QQ:2531574300> <AHK持续学习者沙龙(928220639)> <Autohotkey高手群(348016704)>
## 功能介绍(默认下) :
对照替换:对照A数组元素在HayStack中替换B数组元素
例如:
;数组对照替换
HayStack:="123|321"
A:=["1","2","3"] 
B:=["A","B","C"] 
输入进去切换完了
HayStack="ABC|CBA"
## 参数介绍
### HayStack 待替换字符串
### SearchArray
### ReplaceArray
### EnableReverseSwitch 反向替换
;---------------------------------------------------------------------------------------------------------------
# 借鉴
# 版本信息
v0.1 : 草创
*/
;---------------------------------------------------------------------------------------------------------------
StringReplaceBaseOnArray(HayStack,SearchArray,ReplaceArray,RegexMode:=false,EnableReverseSwitch:=false){
	local
;# 先检测一下是不是一样长
if !(SearchArray.Length()=ReplaceArray.Length()){
throw Exception("SearchArray/ReplaceArray Array Length is different `r`nA/B数组的长度不一")
}
;# 如果用户需要可以"反向替换"
if (EnableReverseSwitch){
temp:=SearchArray
SearchArray:=ReplaceArray
ReplaceArray:=temp
}
	
;# 在HayStack中把A中的元素替换为B(全部)
if (RegexMode){
	
loop,% SearchArray.Length(){
HayStack:=RegExReplace(HayStack,SearchArray[A_Index],ReplaceArray[A_Index])
}
}
else{
	
loop,% SearchArray.Length(){
HayStack:=StrReplace(HayStack,SearchArray[A_Index],ReplaceArray[A_Index],,-1)
}	
}
;~ MsgBox,% HayStack
return HayStack
}
/*
出厂检测(每一个lib出厂之前必须从外部调用测试) 
是否合格: √
(√|×|○) ○是指"刻意没有检测",如果是这种情况，请在下一行说明原因.
*/
;************************************************************
				;38↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\StringSwap.ahk
/*
# StringSwap函数说明书(apidoc)
## 功能介绍(默认下) :
字符串切换,也就是如果发现字符串S1则切换为S2,反之如果发现S2,则替换为S1(全部替换还是部分替换可选),之后把替换完的Text返回
## 参数介绍
### Text是输入的原文本
### S1和S2是两个应该互相切换的字符串
#### S1是先检查的,所以S1的优先级更高,如果S1和S2是有重叠部分,那么范围更大的应该放入S1,更小的放入S2
### Limit指的是替换时的替换次数,-1是全部的意思,是默认值。
;---------------------------------------------------------------------------------------------------------------
# 借鉴
# 版本信息
v0.1 : 草创
*/
;---------------------------------------------------------------------------------------------------------------
/*
# 经验和花絮(非必须):我对 StringSwap函数 的认识和学习过程
# 目的:
# 展望:
# 过程:
##
*/
StringSwap(Text,S1,S2,Limit:=-1,EnableThrow:=false){
	;# 局部变量模式
local
if (checkstring(Text,S1)){
Text := StrReplace(Text, S1 , S2, OutputVarCount, Limit)
return,% Text
}
else if (checkstring(Text,S2)){
Text := StrReplace(Text, S2 , S1, OutputVarCount, Limit)
return,% Text
}
else
{
		;# 这里有两个策略,一个是，如果都没发现的话，抛出异常,另外是返回原文
	if (EnableThrow)
	throw Exception("NotFoundThoseTwoString`r`n在Text中没有发现那两个字符")
else if (EnableThrow=false)
return,% Text
}
	throw Exception("StringSwap:UnKnownError01")
}
;************************************************************
				;39↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\StringToCharArray.ahk
/*◆
# Library 库名 : StringToCharArray
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	转换AHK字符串为AHK字符(串)数组
# ParaMetersList	参数列表 :
	S:需要被转换的字符串
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : StringToCharArray 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	[请填写依赖库名]
# 常见问题 :
	有没有实战案例?
	一定有至少一个[11月21日起]
	如果有更多大型复杂案例会放在这里
	https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果]
*/
	StringToCharArray(S){
		
	local
	
	TheArray:=[],Sub:=""
	
	if(S="")
return TheArray
else{
	loop,% StrLen(S)
	{
		Sub:=SubStr(S,A_Index,1)
		TheArray.Push(Sub)
	}
}
return TheArray
}
;************************************************************
				;40↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\SuperCopy.ahk
;# 超级复制 SuperCopy函数
SuperCopy(fast:=20,EnableTaryTip:=true,LeaveInClip:=true,EableInput:=false,EableSleep:=true){
	local
	Critical ;保证线程不被中断
;# 如果发现是对象,那么就启动EnableCut
if (IsObject(fast)){
Fast:=fast[1]
TheKey=^x
}
else{
TheKey=^c
}
	;# 建立Exception
	SuperCopyExC:=Exception("CopyFail")
	Sleep 50
	old := ClipboardAll
	Sleep 50
	Clipboard :=""
	Sleep 50
	if (EableSleep)
		Sleep 100
	Send,%TheKey%
	;测试
	;## 只要发现fast不是0就开启快速模式,如果开启fast那么就可以通过循环控制这个触发时间
	if(fast!=0){
	loop,%fast%{
		Sleep 10
		;### 检测剪切板上是否还有内容
		theruslt:=(Clipboard=="")
		;如果发现不为空(为1),立即跳出
		if !(theruslt){
			Sleep 15
			show := Clipboard
			if (EnableTaryTip){
			TrayTip,超级复制 %fast%模式,复制出的内容为:`n%show%,,1
			}
			
;~ /*
			;# 如果不是传统模式，就不用把旧的内容放到剪切板上
				if !(LeaveInClip)
					Clipboard := old
;~ */
			Sleep 15
			return %show%
		}
	} ;循环结束,如果没发现就throw Exception
	Clipboard = %old%
	Sleep 35
	;~ throw Exception("CopyFail")
	;# 如果Input开启,那么调用MyInputBox
	if (EableInput){
		try
		{
				return MyInputBox("复制失败","复制失败,您还可以输入文本")
		}
catch
{
throw Exception("CopyFail And User Cancel InputBox`r`n复制失败，并且用户退出了输入框")
}
	}
	else{
			throw SuperCopyExC
	}
	return
}
;## 如果没有开启快速模式,那么等待1秒钟,如果剪切板没收到才会发送错误代码
else
	ClipWait,1
;防误触暂停
Sleep 50
if(ErrorLevel = 1){
;~ TrayTip,超级复制,剪切失败,,1
Clipboard = %old%
Sleep 35
;## 没复制到，那么就抛出异常
;~ throw Exception("CopyFail")
throw SuperCopyExC
return
}
;防误触暂停
Sleep 15
show := Clipboard
if (EnableTaryTip)
	TrayTip,超级复制(普通模式),复制出的内容为:`n%show%,,1
;~ /*
;# 如果不是传统模式，就不用把旧的内容放到剪切板上
if !(LeaveInClip)
	Clipboard := old
;~ */
Sleep 15
return %show%
}
;---------------------------------------------------------------------- 
;************************************************************
				;41↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\SuperCut.ahk
/*◆
# Library 库名 : SuperCut
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	一个高度自定义的剪切函数
# ParaMetersList	参数列表 :
	参考 SuperCopy
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : SuperCut 的第一个版本上线了 O(∩_∩)O~
	v2.0 : SuperCut可以说和SuperCopy基本上是一样的,所以采用了一种新的办法让他们更能复用了。
# 依赖库 :
	SuperCopy
# 常见问题 :
	有没有实战案例?
		不一定每个都有，如果有就在这里 https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果]√
*/
;# 超级剪切 SuperCut函数
SuperCut(fast:=20,EnableTaryTip:=true,LeaveInClip:=false,EableInput:=false,EableSleep:=true){	
local
fast:=[fast]
return SuperCopy(fast,EnableTaryTip,LeaveInClip,EableInput,EableSleep)
}
;************************************************************
				;42↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\SwitchBetweenChineseAndEnglishQuotationMarks.ahk
/*
# SwitchBetweenChineseAndEnglishQuotationMarks函数说明书(apidoc) AHK版本：	1.1.30
# 语言：中文
# 作者：心如止水<QQ:2531574300> <AHK持续学习者沙龙(928220639)> <Autohotkey高手群(348016704)>
## 功能介绍(默认下) :
英文引号标记:替换英文引号中的左边的符号为特殊符号
单引号 "░"
双引号 "▓"
## 实例
## 参数介绍
### HayStack 被替换的字符串
### Char 仅预留
### ToChinese 仅预留
;---------------------------------------------------------------------------------------------------------------
# 版本信息
v1.0 : SwitchBetweenChineseAndEnglishQuotationMarks 的第一个版本上线了 ^_^
*/
;---------------------------------------------------------------------------------------------------------------
SwitchBetweenChineseAndEnglishQuotationMarks(HayStack,Char:=0,ToChinese:=0){
local
/*
;# 需要查找的 - 找到需要更换的英文双引号
Search:=""""
;# 需要查找的 - 找到需要更换的英文单引号
Search_single:="'"
;# 双引号的奇数替代品
Needle:="."
;# 单引号的奇数替代品
Needle_single:="○◇○"
*/
;# 需要查找的 - 找到需要更换的英文单引号
Search_single:="'"
;# 需要查找的 - 找到需要更换的英文双引号
Search:=""""
;# 特别要注意的是,只能用一个字符,不能用多个,具体原因未知。这些已经够用,等确实需要时再修改。
;# 单引号的奇数替代品
Needle_single:="░"
;# 双引号的奇数替代品
Needle:="▓"
;# 初始化
StartingPos := 1
;# 采用逐步推进法一直到结束
loop
{
FoundPos := InStr(Haystack, Search , CaseSensitive := false, StartingPos,1)
;# 如果找不到，那就结束
if (FoundPos=false){	
;~ MsgBox,任务结束
break
}
if (mod(A_Index,2)){
Haystack:=StringInsertAt(HayStack,FoundPos,Needle,1)
}
;# 在找到的位置发起精确打击
;# 从刚发现的后面一个找起(不应该+1,而是还要加String上的那些)
StartingPos := FoundPos+StrLen(Needle)
}
;--------------------------------------------------------------------------------------------------------------- 
;# 初始化
StartingPos := 1
loop
{
FoundPos := InStr(Haystack, Search_single , CaseSensitive := false, StartingPos,1)
;# 如果找不到，那就结束
if (FoundPos=false){	
;~ MsgBox,任务结束
break
}
if (mod(A_Index,2)){
Haystack:=StringInsertAt(HayStack,FoundPos,Needle_single,1)
}
;# 在找到的位置发起精确打击
;# 从刚发现的后面一个找起(不应该+1,而是还要加String上的那些)
StartingPos := FoundPos+StrLen(Needle_single)
}
return,Haystack
}
				;45↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\TimeCounter.ahk
/*◆
# Library 库名 : TimeCounter
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	返回本周已经过去的时间(精确到毫米)
	可以用来进行计时(取两个函数返回值的差值)
# ParaMetersList	参数列表 :
	[示例参数列表]
	无参
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : TimeCounter 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	[请填写依赖库名]
	无依赖库
# 常见问题 :
	有没有实战案例?
		不一定每个都有，如果有就在这里 https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果]
*/
;# 计时器(毫秒)
TimeCounter(){
	local
	;# 计算当前时间(毫秒)
	;# 本来是计算今年的已过时间,后来觉得没这个必要，计算速度会慢很多，那么就计算本周已过好了
;~ TimeCount:=(A_Sec + (A_Min*60) +(A_Hour*60*60) +(A_YDay*60*60*24))*1000+A_MSec
TimeCount:=(A_Sec + (A_Min*60) +(A_Hour*60*60) +(A_WDay*60*60*24))*1000+A_MSec
return TimeCount
}
;************************************************************
				;46↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\TxtBackUp.ahk
;# TxtBackUp函数 生成文本备份
/*
;# 示例
Path:="D:\程序与机动文档\重要文档\行动管理文档\A收集箱(打断&Exception)整理\收集箱KeysExtract备份(按日期)\收集箱KeysExtract备份_" ReturnDate("nyruf") ".txt"
TxtBackUp("来测试一下",Path)
*/
TxtBackUp(TheText,ThePath,EnableTrayTip:=true){
;# 局部变量声明
local
;# 检测是否已经存在
;## FileExist这个函数如果发现存在的话，会返回很多属性,如果不存在的话，返回""(空)
if (FileExist(ThePath)!=""){
	;# 如果已经存在，就提醒，并且在加入新内容之前加入分隔段落
	if (EnableTrayTip)
	TrayTip,文本备份,文件已经存在`n将在该文件后方追加文本`n%ThePath%
	theffge:="`n--------------------------在同分钟内重复写入,以下是最新内容-------------------------------`n"
FileAppend,%theffge%,%ThePath%,UTF-8
FileAppend,%thetext%,%ThePath%,UTF-8
}
else{
	;# 如果不存在，那就直接生成并写入(这个命令在发现没有的时候就会直接写入)
FileAppend,%thetext%,% ThePath,UTF-8
if (EnableTrayTip)
TrayTip,文本备份,已成功备份`n%ThePath%
}
return,%ThePath%
}
;--------------------------------------------------------------------------------------------------------------- 
;************************************************************
				;47↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\UseCMD.ahk
; 来源:https://autohotkey.com/boards/viewtopic.php?t=48132&p=215348
; 【后台静默运行cmd命令缓存文本取值 @hui-Zz】
;~ ;## CMD命令支持模块(静默运行) UseCMD函数
UseCMD(command){
local
	CMDreturn:=""
	cmdFN:="RunAnyCtrlCMD"
	try{
		RunWait,% ComSpec " /C " command " > ""%Temp%\" cmdFN ".log""",, Hide
	FileRead, CMDreturn, %A_Temp%\%cmdFN%.log
	FileDelete,%A_Temp%\%cmdFN%.log
}catch{}
return CMDreturn
}
;************************************************************
				;48↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\UseCMD2.ahk
; 来源:https://autohotkey.com/boards/viewtopic.php?t=48132&p=215348
; 【返回cmd命令的结果值 @hui-Zz】（闪动命令框）
;## CMD命令支持模块(非静默运行) UseCMD2函数
UseCMD2(command) {
local
	; WshShell 对象: http://msdn.microsoft.com/en-us/library/aew9yb99
	shell := ComObjCreate("WScript.Shell")
	; 通过 cmd.exe 执行单条命令
	exec := shell.Exec(ComSpec " /C " command)
	; 读取并返回命令的输出
	return exec.StdOut.ReadAll()
}
;************************************************************
				;49↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\UseCMD3.ahk
/*
【隐藏运行cmd命令并将结果存入剪贴板后取回 @hui-Zz】
  来源:https://autohotkey.com/boards/viewtopic.php?t=48132&p=215348
*/
;---------------------------------------------------------------------------------------------------------------
UseCMD3(command){
local
    cmdInfo:=""
    Clip_Saved:=ClipboardAll
    try{
        Clipboard:=""
        Run,% ComSpec " /C " command " | CLIP", , Hide
        ClipWait,2
        cmdInfo:=Clipboard
    }catch{}
    Clipboard:=Clip_Saved
    return cmdInfo
}
;************************************************************
				;50↓↓↓↓↓↓D:\_AHKLib\AHKPublicLib\PublicFunction\UseCMDRun.ahk
/*
# Library 库名
UseCMDRun(RunBySpecificSoftware马甲)
# 库名解释
用CMD命令运行某些文件(支持批量)
# Specification(Default ParaMeters)	功能介绍(默认下)
用户输入exe程序路径和文档路径(用‘|’分隔,支持批量)
用指定exe打开这些文档
# ParaMetersList	参数列表
SoftPath - exe程序路径
FileStringGroup - 文档路径(用‘|’分隔,支持批量)
# Author	作者
心如止水
# AHK Version AHK版本
1.1.30
# Library Version 库版本
%库版本%
v1.0 : UseCMDRun 的第一个版本上线了 ^^
# Quality Test	出厂品控检测
√ 合格
# Copyright  版权声明
如果我的分享侵犯了您的权利，请尽快联系我解决。
欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上展示原文地址。
*/
UseCMDRun(SoftPath,FileStringGroup){
local
	;本来这个地方是搞重了的,这里主要是为了查找的方便,也是为了防止删除之后出现问题,所以就不直接删除这个库了,采用映射的办法解决一下,以后如果要对整个库进行重构的话再说.
RunBySpecificSoftware(SoftPath,FileStringGroup)
	return
}
;打印数组 
;************************************************************
				;NEW10
PrintlnSA(obj,MsgBox:=false){
	local
	isSimpleArray(obj)
		if (MsgBox){
MsgBox,% (ArrayToString(obj)) "`r`n"
	}
println(ArrayToString(obj))
return
 }
;************************************************************
				;NEW09
PrintSA(obj,MsgBox:=false){
	local
	isSimpleArray(obj)
	if (MsgBox){
MsgBox,% (ArrayToString(obj))
	}
print(ArrayToString(obj))
return
 }
;************************************************************
				;NEW06
;## 一键回到文本顶部 toceil函数
;如果输入o为除了1的任意数值,那么发出换行
toceil(o:=1){
	local
	Send,{Ctrl Down}
	Send,{Home}
	Send,{Ctrl Up}
	if !(o=1){
		Send,{Enter}
		Sleep 25
		Send,{Up}
		return
	}
	return
}
;************************************************************
				;NEW05
;## 一键回到文本顶部 tofloor函数
;如果输入o为除了1的任意数值,那么发出换行
tofloor(o:=1){
	local
	Send,{Ctrl Down}
	Send,{End}
	Send,{Ctrl Up}
	if !(o=1){
		Send,{Enter}
		Sleep 25
		; Send,{Up}
		return
	}
	return
}
;************************************************************
				;NEW04
;发送AHK脚本的模板
Send_Script_Template(){
local
;%%%%%%%% 延续片段:Script_Head %%%%%%%%
Script_Head=
(
/*
# AHK标准表头开始
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Warn ; # 加上错误检查机制,可以很大程度上避免由于AHK的灵活语法导致的逻辑错误
#NoEnv  ; # 不检查空变量是否为"环境变量"，可以极大地提高效率
SetTitleMatchMode 2 ; # 设置标题查找模式
#Hotstring EndChars  ◎ ; # 热字串设置 只是把空格作为终止符,(◎是我找了一个最字符来充数的,主要就是为了实现单独用空格作为热字串终止服符,因为按照帮助文档上所说是不能单独用空格的)
#Hotstring ? O Z ; # 热字串设置 c 区分大小写 o 删除停止符号 Z重置计数器 ?可以混在单词中
; #Hotstring NoMouse ; #让鼠标不打扰热字串触发(副作用是 "也阻止了热字串需要的鼠标钩子")
Process, Priority,, High ;提高脚本程序的优先级
#Warn ClassOverwrite ;#类覆盖警告
#SingleInstance force ; #允许脚本的多个实例运行。 会跳过对话框并自动替换旧实例, 效果类似于 Reload 命令.。
;# 更改脚本的工作目录到"脚本所在目录的绝对路径"
SetWorkingDir %A_ScriptDir%
FileEncoding , UTF-8
SetFormat,Float,0.2 ; # 设置数值转字符串的字符串格式
SendMode Input ;#Input: 让 Send, SendRaw, Click 和 MouseMove/Click/Drag 切换到 SendInput 方法. //容易产生兼容性问题,但是准备继续用,因为很快就要重构,要以这个为基础
;# 同一个热键/热字串最多允许5线程(!!确实需要再开，可能会引起各种问题)
;#MaxThreadsPerHotkey 5
; ExitApp ;#
return ;# 自动执行段结束
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
# AHK标准表头结束
*/
) ;# ;"延续片段:Lib_Script_Head"结束
;----------------------------------------------------------------------- 
;%%%%%%%% 延续片段:Script_Tail %%%%%%%%
	
Script_Tail=  ;#结尾部分
(`%
^l:: 
           ;~ ) ;# 延续片段还在继续
return ;# 延续片段还在继续
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; #设置重启当前脚本的热字串 ;rl
#If WinActive(A_ScriptName)
;###保存并重启当前脚本
:?:;rl::
	;# 增加这个主要是为了防止和全局的那个重启冲突,结果以为重启了，其实没有,造成各种问题
	MsgBox ,4,重启%A_ScriptName%,真的要重启"%A_ScriptName%"吗？, 10
	IfMsgBox,Yes
	{
		Sleep 100
		Send ^s
		Sleep 100
		Reload
	}
	else
	{
		TrayTip,重启%A_ScriptName%,"重启%A_ScriptName%"的任务已经取消
	}
return
#If
	) 
;# ;"延续片段:Script_Tail"结束
;----------------------------------------------------------------------- 
    ;先回到文章顶部
	toceil()
    ;然后发送通用#include
	Sendtext(["/","il"])
    ;通过粘贴的方法发送脚本头部
	SendByClip(Script_Head)
	Sleep 20
    ;回到文章底部
	tofloor()
    ;发送脚本尾部
	SendByClip(Script_Tail)
		Sleep 10
        ;# 计算出脚本尾部的长度,以便于可以通过Send Up 移动光标到合适的位置
		Script_Tail := StrReplace(Script_Tail, "`n" , "回车",OutputVarCount,-1)
        UpConut:=OutputVarCount
	    Send,{Up %UpConut%}
    return ;# 发送结束
}
;************************************************************
				;NEW03
;发送AHKLib脚本的模板
Send_Lib_Script_Template(){
local
;----------------------------------------------------------------------- 
;# 先切割出文件名作为默认函数名
Sleep 50
WinGetTitle, DefaultFunctionName ,SciTE4AutoHotkey
Sleep 50
;# 先赋上一个空值 避免#Warn报错
NameArr:=""
try
{
NameArr:=StringCutter(DefaultFunctionName ,"\lib\",".ahk")
}
catch
{
	try{
		NameArr:=StringCutter(DefaultFunctionName ,"\AHK脚本\",".ahk")
	}
catch
{
TrayTip,生成libdoc,未能从标题中找到可能的函数名(FunctionName)`r`n请自行输入
}
}
;# 返回的是数组，要转换一下
DefaultFunctionName:=NameArr[1]
; MsgBox,% DefaultFunctionName
InputBox,TheFunctionName,生成libdoc文件头,请输入该函数的名字,,,,,,,,%DefaultFunctionName%
if (ErrorLevel=1){
	TrayTip,,已取消
	return
}
else{
	lib名 :=TheFunctionName
}
Sleep 0
;"切割出文件名作为默认函数名" 步骤结束
;----------------------------------------------------------------------- 
;%%%%%%%% 延续片段:Lib_Script_Head %%%%%%%%
Lib_Script_Head=  
(
/*◆
# Library 库名 : %lib名%
# Specification(Default ParaMeters)	功能介绍(默认参数下) : 
	[请填写功能介绍] 
# ParaMetersList	参数列表 : 
	[示例参数列表] 
	HayStack - 被搜索的字符串
	Count - 循环次数
	
# Author	& AHK Version	AHK版本&作者 : 
	AHKv1.1.30 & 心如止水(QQ:2531574300)
	
# Copyright  版权声明  : 
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。		
# Library Version 库版本 : 
	v1.0 : %lib名% 的第一个版本上线了 O(∩_∩)O~
# 依赖库 : 
	[请填写依赖库名] 
# 常见问题 : 
	有没有实战案例? 
	一定有至少一个[11月21日起] 
	如果有更多大型复杂案例会放在这里
	https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 : 
	[请填写出厂品控检测结果] 
*/
) ;"延续片段:Lib_Script_Head"结束
;----------------------------------------------------------------------- 
    ;首先回到文章顶部
	toceil()
    ;在粘贴内容之前留下200毫秒延迟
	Sleep 200
    ;粘贴内容
	SendByClip(Lib_Script_Head)
    ;向上移动光标位置
	Send,{Up 2}
return ;# 自动发送表头(lib)结束
}
;----------------------------------------------------------------------- 
;************************************************************
				;NEW02
	;倒计时十秒，关闭所有窗口(用户也可以选择取消)			
CloseAllWindows_Main(){
FormatTime, CurrentDateTime,,h:mm
MsgBox,4,关闭所有窗口,现在是北京时间 %CurrentDateTime%  `n该休息了，所有窗口将在10秒之内全部关闭 `n如果按下"Yes"键，将立即关闭 `n如果按下"Yes"键，将立即关闭；如果按下"No"键会立即退出，不执行关闭
IfMsgBox,yes
{
cw()
	Sleep,100
	return
}
IfMsgBox,No
{
Exit
}
	
	Sleep,2000
		TrayTip,提醒,还剩8秒
Sleep,4000
	TrayTip,提醒,还剩4秒
	Sleep,2000
	TrayTip,提醒,还剩2秒
	Sleep,3000
	TrayTip,提醒,还剩1秒
	Sleep,1000
	Sleep,100
	cw()
	Sleep,100
return
}
;# 一键关闭所有窗口的方法
	cw()
	{
	;关闭窗口 但是忽略"桌面番茄"和"Program Manager"
WinGet, id, list, , , Program Manager
Loop, %id% 
{
	StringTrimRight, this_id, id%a_index%, 0
	WinGetTitle, this_title, ahk_id %this_id%
	
	;# 发送关闭命令之前先检查
	if (checkString(this_title,"滴答清单|青蛙列表|工作计划表|火绒|- AutoHotkey v|- Everything|桌面番茄|Program Manager")) {
	continue  ;如果发现有那么就跳过
	}
	PostMessage, 0x112, 0xF060,,,%this_title%
	Sleep 30
}
Return
	}
;----------------------------------------------------------------------- 
;************************************************************
				;NEW01 
;# 写作助手 PaperHelper
PaperHelper_Initialize(){
	global
;文章编写自动化 PaperHelper
Y1ToY4:="",Y1ToY2:="",Y3ToY4:=""
;这里是从配置文件中加载数据.数据应该是有日期标识的,也就是说，只要创建了一次，无论今天重启过多少次，只要文件没丢，都是可以直接载入的.
;我觉得这个很对，应该把他加入自动执行段的.
LoadDataFromConfig()
ProduceHotstringByData()
return
} 
PaperHelper_Main(){
	local
try{
	;# 提示用户手动输入语素,并写入配置文件
GeneratingElement()
}
catch{
TrayTip,提醒,% "语素输入被取消"
return
}
;# 从配置文件中将数据从载入全局变量
LoadDataFromConfig()
; 询问是否生成热字串+文章依赖文件
InputBox,UserInput,标题,是否生成热字串/依赖文件?`r`n‘1’和‘2’分别代表""生成热字串""和""生成依赖文件"",,,,,,,,1/2
if (ErrorLevel=1){
TrayTip,%A_ScriptName% 输入被取消,用户已终止"生成热字串+文章依赖文件"
MsgBox,输入被取消,用户已终止"生成热字串+文章依赖文件"
return
}
if (Instr(UserInput,"1")){
;# 生成热字串
ProduceHotstringByData()
}
if (Instr(UserInput,"2")){
;# 生成文章依赖文件
ProduceArticleFileByData()
}
return
}
	;*******以下为纯函数区*******
;---------------------------------------------------------------------- 
;# 检查配置文件中的数据是否存在
CheckDataOnConfigExist(Date:="TODAY",EnableTip:=false){
	local
		global Y1ToY2,Y1ToY4,Y3ToY4
FileRead, DataOnConfig, Config-PaperHelper.ini
if(Date="TODAY")
Date=%A_YYYY%-%A_MM%-%A_DD%
CheckResult:=InStr(DataOnConfig,Date)
if (EnableTip){
	if (CheckResult)
	TrayTip,%A_ScriptName% 提醒,配置文件中的数据存在`r`n%Date%
	else
	TrayTip,%A_ScriptName% 提醒,配置文件中的数据不存在`r`n%Date%
}
return
}
;---------------------------------------------------------------------- 
;# 从配置文件中,载入变量(Y1/Y2/Y3/Y4)
LoadDataFromConfig(EableTrayTip:=false){
		global Y1ToY2,Y1ToY4,Y3ToY4
		IniSection=%A_YYYY%-%A_MM%-%A_DD%
loop 4{
IniRead,Y%A_Index%,Config-PaperHelper.ini,%IniSection%,Y%A_Index%,错误
;# 一旦发现值为空就提醒

if (Y%A_Index%="ERROR")OR(Y%A_Index%="错误"){ ;我在这里不经意间用了伪数组。。。
	;这个地方在刚刚启动的时候,再入要小心,也就是说刚刚启动的时候，很可能本来就是没有今日配置,可以用一个参数,开机自启的时候自动的就不载入
MsgBox,% "今日未配置,系统将退出`r`n清先建立配置再操作"
return
}

}
DeBugDeepPrintln(Y3,"Y3 >>> ")
DeBugDeepPrintln(Y4,"Y4 >>> ")
DeBugDeepPrintln(Y1,"Y1 >>> ")
DeBugDeepPrintln(Y2,"Y2 >>> ")
;tap(文章标题+)  Title of article Plus
Y1ToY4:=Y3 Y4 "-" Y1 " " Y2
;ta(文章标题) Title of article
Y1ToY2:=Y1 " " Y2
;tae(文章示例) Example 
Y3ToY4:="示例" "-" Y3 "" Y4 "-"
if (EableTrayTip)
TrayTip,%A_ScriptName% 提醒,根据配置文件，已生成相关变量
return
}
;---------------------------------------------------------------------- 
;# 依据数据生成热字串
/*
*****************AHK文章编写自动化热字串含义的解释*****************
;# ta的意思是 title ahk 也就是"AHK标题"的意思
	;标准AHK标题
/ta : [基础] AHK函数对象系列-对象属性与数据域保护
	;带序号的AHK标题
/tap : AB009-[基础] AHK函数对象系列-对象属性与数据域保护
	;AHK示例标题 example(示例)
/tae : 示例-AB009-
	;AHK实战案例标题 uivj(实战)
/tau : [实战案例-示例-AB009-1] 案例标题
*/
ProduceHotstringByData(){
		global Y1ToY2,Y1ToY4,Y3ToY4
;# 根据配置文件建立的热字串.
todo_ta:=Func("SendByClip").Bind(Y1ToY2)
; p=path 完整路径式(是不是这个意思我已经忘的差不多了)
todo_tap:=Func("SendByClip").Bind(Y1ToY4)
; e=example 示例,例子
todo_tae:=Func("SendByClip").Bind(Y3ToY4 "x:标题")
; u=ui=实战,
todo_tau:=Func("SendByClip").Bind("实战案例-" Y3ToY4)
实战案例=[实战案例-%Y3ToY4%1] 案例标题
;~ todo_tau:=Func("SendByClip").Bind("实战案例-" Y3ToY4)
todo_tau:=Func("SendByClip").Bind(实战案例)
Hotstring("::/ta",todo_ta)
Hotstring("::/tap",todo_tap)
Hotstring("::/tae",todo_tae)
Hotstring("::/tau",todo_tau)
return
}
;---------------------------------------------------------------------- 
;# 依据数据生成文章依赖文件
ProduceArticleFileByData(){
		global Y1ToY2,Y1ToY4,Y3ToY4
;# 读取配置并且存入全局变量(Y1-Y4)
新目录=D:\程序与机动文档\重要文档\知识输出\%Y1ToY4%
模板目录=D:\程序与机动文档\重要文档\知识输出\模板\Y1ToY4
FileRead,MarkDownDoc,%模板目录%\Y1ToY4.md
MarkDownDoc:="`r`n_" . Y1ToY4 . "_" . MarkDownDoc
MarkDownDoc:="# " . Y1ToY2 . MarkDownDoc
try{
FileRecycle,%新目录%
TrayTip,%A_ScriptName% 目录创建,% 新目录 "`r`n处已存在目录`r`n" "...故已经移动其到回收站"
}
catch{
}
FileCreateDir,%新目录%
FileAppend , % MarkDownDoc, %新目录%\%Y1ToY4%.md,UTF-8
;~ FileCopy, %模板目录%\*.txt,%新目录%\%Y1ToY4%.txt
FileCopy, %模板目录%\[群宣] Y1ToY4.md,%新目录%\[群宣] %Y1ToY4%.md
FileCopy, %模板目录%\*.ahk,%新目录%\%Y1ToY4%.ahk
TrayTip,%A_ScriptName% 提醒,根据"语素配置文件"`r`n已建立"文章创作后备库"
return
}
;---------------------------------------------------------------------- 
;# 手动输入生成语素
GeneratingElement(){
	local
		global Y1ToY2,Y1ToY4,Y3ToY4
s:=""
Yindex:=""
;## 读取计数器
IniRead, TheCount, Config-PaperHelper.ini,Counter,Count,错误
TheCount++
DefaultString:="[基础] |◇标题◇|AB|00" TheCount
;## 让用户填写语素
InputBox,StringGroup,填写语素,% "标题头|标题|编号头|编号",,,,,,,,% DefaultString
if (ErrorLevel=1){
	TrayTip,%A_ScriptName% 输入被取消,用户已经取消填写语素
	throw Exception("用户取消输入""语素""")
	return
}
TheCount:=SubStr(TheCount,StrLen(TheCount))
;将用户输入的字符串分割成简单数组
UserDateArray:=StringGroupParseToSimpleArray(StringGroup)
;## 根据语素生成今天的配置文件
loop,% UserDateArray.Length() {
	s.=%平行简单数组% . "=" . UserDateArray[A_Index]  . "`r`n" ;一直往上累加写入s
}
;## 写入配置(1,覆盖同section 2,不干扰其他section)
IniWrite,% s,Config-PaperHelper.ini,%A_YYYY%-%A_MM%-%A_DD%
;## 写入新的count
IniWrite,%TheCount%,Config-PaperHelper.ini,Counter,Count
TrayTip,%A_ScriptName% 提醒,语素和配置文件已建立
return
}
;----------------------------------------------------------------------- 
;************************************************************
				;1↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\Excel_Locate.ahk
;# Excel_Locatesition 定位
;t=文本 c=按下回车的次数
Excel_Locate(t,c) ;方法验收成功
{
	;打开搜索框
	Send ^f
	Sleep,200
	;复制粘贴上要搜索的内容
	SendByClip(t)
	Sleep,150
	;按下回车的次数
	loop,%c%{
		Send {Enter}
		Sleep,50
	}
	;退出
	Send,{Esc}
	;定位成功
	return
}
;************************************************************
				;2↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\Excel_LocateAndSendFormatDates.ahk
;# Excel内自动格式化表格内容(最上层方法，一般直接调用这个即可) Excel_LocateAndSendFormatDates函数
;d=0代表明天，+1后天，-1昨天
Excel_LocateAndSendFormatDates(j){
	;定位到日期栏
	Excel_Locate("日期栏","1")
	Sleep,100
	Send,{Down 2}
	Sleep,100
	;替换之前尽可能等待时间长一点
	Sleep,300
	;发送nyr
	SendByClip(Excel_ReturnFormatDates(j,"nyr"))
	Sleep,100
;给TD先赋值
td:=0
	EnvAdd,td,1,Days
	FormatTime, tdO,% td, 工作计划表_yyyy年M月d日
	Send {F12}
	WinWait,另存为
	{
		Sleep,500
		;~ SendByClip(tdO)
		SendByClip(Excel_ReturnFormatDates(j,"nyrn"))
		Sleep, 50
	}
return
}
;************************************************************
				;3↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\Excel_ReturnFormatDates.ahk
;# 返回格式化日期方法 Excel_ReturnFormatDates函数
Excel_ReturnFormatDates(t,n){ ;# 作为一个陈年老函数就不独立了
	Sleep 15
	;To指的就是今天，和今天校准
	;现在是，在今天的基础上,对日期进行加减操作,用户输入的t是多少就改多少
	To := A_Now
	if (n = "nyr")
	{
		;在今天的基础上改日期
		EnvAdd,To,%t%,Days
		Sleep 15
		;输出字符串
		FormatTime, nyr,%To%, yyyy年M月d日
		return nyr
	}
	if (n = "nyrn")
	{
		;在今天的基础上改日期
		EnvAdd,To,%t%,Days
		Sleep 15
		;输出字符串
		FormatTime, nyrn,%To%,工作计划表_yyyy年M月d日
		nyrn .= ".xlsm"
		return nyrn
	}
	if (n = "nyrp")
	{
		;在今天的基础上改日期
		EnvAdd,To,%t%,Days
		Sleep 15
		;输出字符串
		FormatTime, nyrp,%To%,D:\程序与机动文档\重要文档\行动管理文档\A工作计划表\工作计划表_yyyy年M月d日
		nyrp .= ".xlsm"
		return nyrp
	}
	if (n = "qwnyrp")
	{
		;在今天的基础上改日期
		EnvAdd,To,%t%,Days
		Sleep 15
		FormatTime, qwnyrp,%To%,D:\程序与机动文档\重要文档\行动管理文档\A青蛙列表\青蛙列表_yyyy年M月d日起
		qwnyrp .= ".xlsx"
		return qwnyrp
	}
	else
		return,错误
}
;************************************************************
				;4↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\Excel_RunGZJH.ahk
;运行工作计划表 Excel_RunGZJH函数
Excel_RunGZJH(){
	local
	;如果工作计划表已经存在，那就只是激活
	if WinExist("工作计划表_") AND WinExist("ahk_exe EXCEL.EXE"){
		;默认不做任何操作，根据不同的场景也可以选择,激活
		;~ WinActivate,工作计划表,,AutoHotkey
		return
	}
	Run,% Excel_ReturnFormatDates(0,"nyrp"),,UseErrorLevel
	;如果运行失败，那么循环运行50次直到成功
	;到这一步说明不就是彻底失败，不就是和今天不符合
	if !(ErrorLevel=0){
		;cc计数器为0
		cc := 0
		;没循环1次，cc计数器-1，cc绝对值就是目前和找到的工作计划表的差值
		loop,30{
			cc --
			;直接返回对应差值的文件路径
			Run,% Excel_ReturnFormatDates(cc,"nyrp"),,UseErrorLevel
			;如果运行成功就，就结束
			if (ErrorLevel=0){
				break
			}
		}
		;出了循环之后，有两种情况，1，循环次数已经到了，还没找到，那么就没戏了 2，找到了，但是既然进入循环，一定不是今天的，晚上的"晚间回顾工作"没搞好
		if !(ErrorLevel=0){
			MsgBox,运行失败,运行了50次还是没找到，运行失败
			return
		}
		;虽然成功了，但是循环了很多次，说明今天的是没有的
		else if Not(cc=-1){
			;等等工作计划表窗口出现
			Sleep 100
			WinWait,工作计划表,,2,ahk_class wndclass_desked_gsk
			Sleep 100
			jbtm := Excel_ReturnFormatDates(0,"nyr")
			find := Excel_ReturnFormatDates(cc,"nyr")
			zotm := Excel_ReturnFormatDates(-1,"nyr")
			;今天和找到的日期的差值的绝对值
			cca := Abs(cc)
			Sleep 10
			;问问是否需要立即格式化和切换
			;原来是检查今天有没有就弹出,现在是检查今天和昨天,因为原每晚回顾改到早上了
			WinWait,青蛙列表_,,3
			if (ErrorLevel=1)
			{
				Sleep 500
				MsgBox ,4,超时,超时0x3(没有成功打开"青蛙列表")！`n没找到今天(%jbtm%)或昨天(%zotm%)的 `n只找到了%cca%天前(%find%)和的`n是否需要格式化并切换到今天？
			}
			else
			{
				Sleep 500
				MsgBox ,4, 运行提示,请确认 `n没找到今天(%jbtm%)或昨天(%zotm%)的 `n只找到了%cca%天前(%find%)和的`n是否需要格式化并切换到今天？
			}
			;如果是就等其展开后，启动自动格式化程序
			IfMsgBox,Yes
			{
				Sleep 100
				WinWait,工作计划表,,2,ahk_class wndclass_desked_gsk
				Sleep 100
				WinMaximize
				;如果工作计划表在活动就运行格式化，不在活动，就自动让其活动并且格式化，如果还没置顶就发送失败
				if WinActive("工作计划表") AND WinActive("ahk_class XLMAIN")
				{
					Sleep 100
					Excel_LocateAndSendFormatDates(0)
				}
				else
				{
					Sleep 100
					;函数和命令的颜色是不一样的，函数是浅绿，命令是深绿，这个太容易混淆了，他们差别很大，试试河许人的皮肤如何
					WinActivate,工作计划表,,ahk_class wndclass_desked_gsk
					if WinActive("工作计划表") AND WinActive("ahk_class XLMAIN")
					{
						Sleep 100
						Excel_LocateAndSendFormatDates(0)
					}
					else
					{
						Sleep 50
						MsgBox,工作计划表未能处于活动中，无法格式化
					}
				}
			}
			;如果不是就最大化
		}
		;如果一次性运行成功，那就等等窗口出现，最大化之
		Sleep 100
		WinWait,工作计划表,,2,ahk_class wndclass_desked_gsk
		Sleep 100
		WinMaximize
		;~ return
	}
	return
}
;************************************************************
				;5↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\Excel_RunQW.ahk
;运行青蛙列表 Excel_RunQW函数
Excel_RunQW(EnableRunGZJH:=false){ ;#函数"运行青蛙列表"(在box中包含工作计划表的运行)
	local
	;如果青蛙列表已经存在，那就只是激活/不做任何操作;铬铁
	if WinExist("青蛙列表_") AND WinExist("ahk_exe EXCEL.EXE"){
		;~ WinActivate,青蛙列表,,AutoHotkey
		Sleep 25
		if (EnableRunGZJH){
Excel_RunGZJH()
}
		return
	}
	Sleep 150
	Run,% Excel_ReturnFormatDates(0,"qwnyrp"),,UseErrorLevel
	;如果发现有今天的,那就运行工作计划表，然后结束,如果没有发现今天的那么继续执行下面的任务
	if (ErrorLevel=0){
		Sleep 15
		if (EnableRunGZJH){
Excel_RunGZJH()
}
		return
	}
	if !(ErrorLevel=0){
		;从明天的开始检查,Excel_ReturnFormatDates参数默认值是0也就是今天,1的意思是明天
		ccqw := 1
		;循环1次，cc计数器-1，就是往前天一直倒
		loop,30{
			Run,% Excel_ReturnFormatDates(ccqw,"qwnyrp"),,UseErrorLevel
			;如果运行成功就，就结束
			if (ErrorLevel=0){
				;如果发现是明天,那就提示一下
				if (ccqw=1)
				{
					WinWait,青蛙列表_
					{
						Sleep 500
						MsgBox,这个"青蛙表格"是明天的,请留意
					}
			}
			break
		}
		ccqw --
	}
}
;出了循环之后,如果这个内置变量还是零,要么就是运行失败
if !(ErrorLevel=0){
	WinWait,青蛙列表_
	{
		Sleep 500
		MsgBox ,4, 运行提示,运行失败,没有找到30天之内的"青蛙列表"`n 点击 是 打开"工作计划表"
	}
	IfMsgBox,Yes
	{
		Sleep 15
		if (EnableRunGZJH){
Excel_RunGZJH()
}
	}
return
}
else if (Abs(ccqw)>=7){
	WinWait,青蛙列表_
	{
		Sleep 500
		MsgBox ,4, 运行提示,% "虽然运行成功了 但是这个内容是 " Abs(ccqw) "天之前的东西 请仔细确认！ `n 点击 是 打开 工作计划表 "
	}
	IfMsgBox,Yes
	{
		if (EnableRunGZJH){
Excel_RunGZJH()
}
	}
return
}
else{
	if (EnableRunGZJH){
Excel_RunGZJH()
}
	return
}
}
;************************************************************
				;6↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\PDFstart.ahk
/*
# Library 库名 : PDFstart
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	WPS用一键打开预设好的docm文件
# ParaMetersList	参数列表 :
	无参
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : PDFstart 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	RunBySpecificSoftware
# 常见问题 :
	有没有实战案例? - 如果有，就在云盘同目录下或同平台文章中
	该库的依赖库在哪里? - 在云盘同目录下或同平台文章中
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果]
*/
PDFstart(){
local 
FileStringGroup=D:\程序与机动文档\Java学习书籍\Java语言程序设计(基础篇) 第10版【中文OCR文字版复合PDF+英文文字版PDF+编程练习题源码+测试题答案(官方网站上有)】\Java语言程序设计_基础篇_原书第10版 ,梁勇著 ,P656_【OCR】(自带OCR,很精确).pdf|D:\程序与机动文档\机动文档\《疯狂Java讲义(第3版)》.(李刚)［福昕OCR］.pdf|D:\程序与机动文档\Java学习书籍\Java语言程序设计(基础篇) 第10版【中文OCR文字版复合PDF+英文文字版PDF+编程练习题源码+测试题答案(官方网站上有)】\Java核心技术_卷1_带书签已OCR.pdf|D:\程序与机动文档\Java学习书籍\[中文文字PDF] Java 编程思想 第4版 - Bruce Eckel.pdf
;~ FileStringGroup=D:\程序与机动文档\机动文档\《疯狂Java讲义(第3版)》.(李刚)［福昕OCR］.pdf|D:\程序与机动文档\Java学习书籍\Java语言程序设计(基础篇) 第10版【中文OCR文字版复合PDF+英文文字版PDF+编程练习题源码+测试题答案(官方网站上有)】\Java语言程序设计_基础篇_原书第10版 ,梁勇著 ,P656_【OCR】(自带OCR,很精确).pdf
SoftPath="C:\Program Files (x86)\Foxit Software\Foxit Reader\FoxitReader.exe"
RunBySpecificSoftware(SoftPath,FileStringGroup)
return
}
;************************************************************
				;7↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\TyporaSend.ahk
;# 这个只要是有换行都可以用(建议但建议加上实体框线)
;# 在Excel中实现像滴答清单中那种发送前缀的效果
;## 实现的是仿照滴答清单的效果 
;## 1,先回到行首 2,添加相关关键词 3,再回到下一行
TyporaSend(t:="",NotToNext:=false){
	;# 
Sleep 0
TyporaToHome()
;~ MsgBox,回到首页执行完毕
;~ Sleep 100
Sleep 0
SendByClip(t)
;~ MsgBox,字符串发送完毕
;~ Sleep 100
Sleep 0
;# 如果"不调到下一行"不开启就跳到下一行行首
if !(NotToNext){
TyporaToNextHome()
;~ MsgBox,"跳到下一行行首"的命令执行完毕
}
return
}
;# 一键回到下一行行首 √
TyporaToNextHome(){
Send,^{Down}
Send,{Home}
return
;~ Send,^{up}
}
;# 一键回到本行行首(如果已经在行首，那么就是回上一个的行首,SendRight开启是一个变通的方案)
TyporaToHome(){
	;# 先回到下一行行首
TyporaToNextHome()
;# 然后再上来
Send,^{up}
return
}
;# 一键回到行尾(方案1)
TyporaToEnd(){
Send,{End}
Send,^{Down}
Send,^{up}
return
}
;************************************************************
				;8↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\WordSend.ahk
;# 这个只要是有换行都可以用(建议但建议加上实体框线)
;# 在Word(WPS也是兼容的)中实现像滴答清单中那种发送前缀的效果
;## 实现的是仿照滴答清单的效果 
;## 1,先回到行首 2,添加相关关键词 3,再回到下一行
;## 复制完成之后默认是调到下一行的,所以ToNext是开着的。
;## ToEnd的意思是,不是回到行首粘贴,而是行尾粘贴
WordSend(t:="",ToNext:=true,ToEnd:=false){
if (ToEnd){
WordToEnd()
}
;# 回到本区域行首
;# 不是原理很简单就是^{Up},不过为了防止本来就在第一个产生干扰,所以说先向右移动一下
else if (ToEnd=false){
WordToHome()
}
;# 到达行首区域，后把内容给粘贴上
Sleep 0
SendByClip(t)
;# 默认是开启ToNext的,这个很简单，其实就是^{Down}
Sleep 0
if (ToNext)
WordToNextHome()
return
}
;# 一键回到本行行首(如果已经在行首，那么就是回上一个的行首,SendRight开启是一个变通的方案)
WordToHome(){
	Sleep 0
send,{Right}
Sleep 25
Send,^{Up}
return
}
;# 一键回到上一行行首(如果已经在行首，那么就是回上一个的行首,SendRight开启是一个变通的方案)
WordToLastHome(){
WordToHome()
Sleep 0
send,{Ctrl Down}
Sleep 25
send,{up}
Send,{Ctrl Up}
return
}
;[调试] # 应该就是这个地方出的问题[调试结论] # 
WordToNextHome(){
;~ send,{Ctrl Down}
;~ Sleep 25
;~ Send,{Down}
;~ Send,{Ctrl Up}
Send,^{Down}
return
}
;# 一键回到行尾(方案1) 
;# 也就是回到下一行的行首,再向左移动一次
WordToEnd(){
	Sleep 0
WordToNextHome()
Sleep 0
send,{Left}
return
}
;# 一键回到行尾(方案2)
WordToEnd2(){
	Sleep 0
send,^{PgDn}
Sleep 0
send,{Left}
return
}
;************************************************************
				;9↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\WPSstart.ahk
/*
# Library 库名 : WPSstart
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
	WPS用一键打开预设好的docm文件
# ParaMetersList	参数列表 :
	无参
# Author	& AHK Version	AHK版本&作者 :
	AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  :
	如果该文侵犯了您的权利，请联系我解决。
	欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
	v1.0 : WPSstart 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
	RunBySpecificSoftware
# 常见问题 :
	有没有实战案例? - 如果有，就在云盘同目录下或同平台文章中
	该库的依赖库在哪里? - 在云盘同目录下或同平台文章中
# Quality Test	出厂品控检测 :
	[请填写出厂品控检测结果]
*/
/*
WPSstart(){
local 
FileStringGroup=D:\程序与机动文档\重要文档\后备资料站\MD输出者\[ToDoList] 柿子.docm|D:\程序与机动文档\重要文档\后备资料站\MD输出者\[ToDoList] 快速青蛙和甜点.docm|D:\程序与机动文档\重要文档\后备资料站\MD输出者\[收集箱] 青蛙(仅立即安排).docm|D:\程序与机动文档\重要文档\后备资料站\MD输出者\[收集箱] 青蛙-待处理.docm|D:\程序与机动文档\重要文档\后备资料站\MD输出者\[临时区域] 收集箱处理临时区域.docm|D:\程序与机动文档\重要文档\后备资料站\MD输出者\[收集箱] 青蛙辅助资料(仅小条目).docm
SoftPath="F:\gAPP\WPSOffice2018\office6\wps.exe"
RunBySpecificSoftware(SoftPath,FileStringGroup)
return
}
*/

WPSstart(){
local 
FileStringGroup=D:\程序与机动文档\重要文档\行动管理文档\A信息中转站\[ToDoList] 柿子.docm|D:\程序与机动文档\重要文档\行动管理文档\A信息中转站\[收集箱] 资料.docm
SoftPath="F:\gAPP\WPSOffice2018\office6\wps.exe"
RunBySpecificSoftware(SoftPath,FileStringGroup)
return
}
;************************************************************
				;10↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\中括号前缀转青蛙专用前缀.ahk
/*◆
# Library 库名 : 中括号前缀转青蛙专用前缀
# Specification(Default ParaMeters)	功能介绍(默认参数下) :
把‘[]’形式的青蛙条目,转换成### `r`n 格式的
# ParaMetersList	参数列表 :
Str - 需要进行操作的字符串
/
# Author	& AHK Version	AHK版本&作者 :
AHKv1.1.30 & 心如止水(QQ:2531574300)
# Copyright  版权声明  
如果该文侵犯了您的权利，请联系我解决。
欢迎转载/改变，如果您觉得我的分享有帮助，希望您能在作品上标注原文地址。
# Library Version 库版本 :
v1.0 : 中括号前缀转青蛙专用前缀 的第一个版本上线了 O(∩_∩)O~
# 依赖库 :
RemoveAllBlankLines
# 常见问题 :
有没有实战案例?
一定有至少一个[11月21日起]
如果有更多大型复杂案例会放在这里
https://pan.baidu.com/s/1EHeg3MhQm5MRPgIR-l928Q
# Quality Test	出厂品控检测 :
√
*/
;# 中括号前缀转青蛙专用前缀
中括号前缀转青蛙专用前缀(Str){
local
substring:="`r`n"
;~ substring:=""
	;# 去除空行
	Str:=RemoveAllBlankLines(Str)
	;# 以行为单位,分割为数组(源数组)
	ScrArray := StrSplit(Str,"`r`n")
	;# 检测
	loop % ScrArray.MaxIndex(){
		;# 拿出每个行的字符串来	
substring.=中括号前缀转青蛙专用前缀_单行操作(ScrArray[a_index]) "`r`n"
}
	return substring
}
中括号前缀转青蛙专用前缀_单行操作(HayStack){
local
	;~ HayStack=SuperCopy(50)
	;# 首先是把第一个‘[’替换为"### "
	HayStack:=StrReplace(HayStack,"[","### ",,1)
	;# 然后是把第一个‘]’替换为 `r`n
	HayStack:=StrReplace(HayStack,"]","`r`n",,1)
	return HayStack
}
;************************************************************
				;11↓↓↓↓↓↓D:\_AHKLib\AHKPrivateLib\PrivateFunction\行动管理条目前缀消除.ahk
行动管理条目前缀消除(Haystack,key){
if checkstring(key,"§"){
Haystack := RegExReplace(Haystack,"§[^\n]*§","",,-1,1)
Haystack := RegExReplace(Haystack,"§\s*§","",,-1,1)
}
if (checkstring(key,"〕") OR checkstring(key,"〔")) {
Haystack := RegExReplace(Haystack,"〔[^\n]*〕","",,-1,1)
Haystack := RegExReplace(Haystack,"〔\s*〕","",,-1,1)
}
if checkstring(key,"※"){
Haystack := RegExReplace(Haystack,"※[^\n]*※","",,-1,1)
Haystack := RegExReplace(Haystack,"※\s*※","",,-1,1)
}
if checkstring(key,"∷"){
Haystack := RegExReplace(Haystack,"∷[^\n]*∷","",,-1,1)
Haystack := RegExReplace(Haystack,"∷\s*∷","",,-1,1)
}
return,% Haystack
}
