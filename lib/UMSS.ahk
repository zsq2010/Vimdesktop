/*
#Warn
#NoEnv  ; # 禁用环境变量检查:不检查空变量是否为"环境变量"，可以极大地提高效率
#Hotstring EndChars  ◎ ; # 热字串终止符号设置:只把空格作为终止符,(文档上所说是不能单独用空格的,最多是空格之外再加一个,所以用◎充数)
#Hotstring ? O Z
SetTitleMatchMode 2 ;# Title匹配模式:Title只需要包含即可匹配
*/

test1:=new UMSS("Numpad1","1")
return



Class UMSS{
static AccountCounter:=0
TA:=0
LongPressLoop :=Ceil(500/10) ;# 如果你懂可以改,其实就是通过循环控制时间的,对内置的计时器函数不太熟,所以用了这个方法。
;---------------------------------------------------------------------------------------------------------------
MySendMode:="2" ;默认模式是2

;### 选择要变成修饰键的按键
keys:="Numpad1"

;### 一键设置替代组合键(默认关闭)
OtherTabndemKey:=""

FF:="F13" ;# 下一步:实现引用统计

Timeout:=5 ;单位是s

;## 为模式1设置参数

LongPressWT:=500 ;### 判断为长按的时间
TandemWT:=180 ;### 进入发送模式后,第一个发送与连发的间隔
TabndemSpeed:=35 ;### 进入连发模式后,连发之间的间隔

;## 为模式3设置参数

;### 功能组合键等待时间(过了等待时间不会响应功能组合键)
OldTimeout:=5 ;单位是s

;## 为模式2设置参数

;### 按键等待时间(过了等待时间,松手也不会发送按键本身,也不会响应功能,-1代表无限)
Timeout2:=3 ;单位是s,-1代表无限(实际上<=0都代表无限),默认为3s
;----------------------------------------------------------------------
MyKeyFunction_V:=0
OtherTabndem_V:=0
;----------------------------------------------------------------------

__New(Keys:="NumPad1",MySendMode:=1){
	
	FFsub := SubStr(this.FF,2 ,2)
		if (FFsub>24)
		throw Exception("FF Out Of Bounds")
	FFsub+=UMSS.AccountCounter
	UMSS.AccountCounter++
	this.FF:=FF:="F" FFsub
	this.MySendMode:=MySendMode
	this.Keys:=Keys

	if(this.MySendMode=1)
	{
		MyKeyFunction_V:=this.MyKeyFunction_V:=ObjBindMethod(this,"MyKey")
		Hotkey,% this.Keys,% MyKeyFunction_V,I99
	}
else if(this.MySendMode=2)
{
	MyKeyFunction_V:=this.MyKeyFunction_V:=ObjBindMethod(this,"MyKey2")
	Hotkey,% this.Keys,% MyKeyFunction_V,I99
}
else if(this.MySendMode=3)
{
	MyKeyFunction_V:=this.MyKeyFunction_V:=ObjBindMethod(this,"OldMyKey")
	Hotkey,% this.Keys,% MyKeyFunction_V,I99
}
else
{
	MsgBox,16,模式选择出现错误,% "`r`n错误参数是`r`nthis.MySendMode:=" this.MySendMode
	return
;~ ExitAPP
}


;# 拼接this.Timeout2
if (this.Timeout2>0)
	this.Timeout2:="T" . this.Timeout2
else
	this.Timeout2:=-1

;如果不为空就注册热键,用于修饰键自身的连发
if !(this.OtherTabndemKey=""){
	OtherTabndem_V:=this.OtherTabndem_V:=ObjBindMethod(this,"OtherTabndem")
	Hotkey,% this.keys " & " this.OtherTabndemKey,% OtherTabndem_V,I0
}

return this
} ;# New Function End


;# 以下是3个核心方法
;---------------------------------------------------------------------------------------------------------------


;# 这是旧版发送方式,较为简洁
OldMyKey(){
	local
Keys:=this.Keys
FFDown:="{" FF:=this.FF " Down}"
FFUp:="{" this.FF " Up}"

OldTimeout:=this.OldTimeout
	Send,% FFDown

	KeyWait,% Keys,% "T" OldTimeout
	{
		Send,% FFUp
	}
return
} ;# 函数结束


;# Send模式2 的函数 发送模式2
MyKey2(){
FFDown:="{" this.FF " Down}"
FFUp:="{" this.FF " Up}"

	Keys:=this.Keys
	Timeout2:=this.Timeout2
	Send,% FFDown ;# 这里被理解为向下了
	;## 等待被松开
	;### 如果是-1那么就一直等,如果不是就等"Timeout2"秒
	if (this.Timeout2=-1)
		KeyWait,% Keys
	else{
		;# 这里又是同样的翻车问题,看来只要涉及到命令,最好都先local化。太坑爹
	KeyWait,% Keys,% Timeout2
	;~ KeyWait,% this.Keys,% this.Timeout2
	}
	;### 如果超时了
	if (ErrorLevel=1){
		;~ MsgBox,超时
		;#### 释放%FF%
		Send,% FFUp
		;#### 重置计数器
		this.RT()
		return
	}
	else
	{
		;~ MsgBox 6
		;## 松开了如果功能已经触发则不发出原按键,否则就发出

		;### 如果松开之后功能已经触发
		if (this.TA==1){
			;#### 释放%FF%
			Send,% FFUp
			;#### 重置计数器
			this.RT()

		}
		;### 如果松开之后功能并触发,那么就发出原按键即可
		else
		{

			;#### 释放%FF%
			Send,% FFUp
			;#### 重置计数器
			this.RT()
			MySend(this.keys)

			return
		}
	}

} ;#函数结束


MyKey(){
	local
	
	FFDown:="{" FF:=this.FF " Down}"
	
	FFUp:="{" this.FF " Up}"
	LongPressLoop:=this.LongPressLoop
	keys:=this.keys
	Timeout:=this.Timeout
	TandemWT:=this.TandemWT
	TabndemSpeed:=this.TabndemSpeed


	;# 先按下%FF%(便于后面的捕获)
	Send,% FFDown

	;# 循环十次 如果出了循环之后说明用户是在单独长按,企图发送连续的Keys
	loop,%LongPressLoop% {
		;功能激活在没有检测到keys被松开的时候功能激活了
		if (this.TA=1){
			KeyWait, %keys%,T%Timeout%
			{
				Send,% FFUp
				this.RT()
				return
			}

		;重置触发器
			Send,% FFUp
		this.RT()
		return
	}
	;不管是最后Tab等到了释放,或者是过了10秒,程序就结束了
	;重置触发器

	;如果发现功能没有被激活,那就检查是否Keys已经被松开,如果是的话,再检查一下触发器,如果没有触发,那么说明他只是想发送一个单独的Keys,如果触发了,那就释放%FF%,结束程序
	;如果发现功能没有被激活,先检查一下Keys是否被松开,如果被松开了那么再确认一下功能是否被激活,如果确认激活了,那么松开即可,如果没有被激活发送一个Keys松开

	;中途突然发现keys被松开了
	if !(GetKeyState(keys,"P")){

		if (this.TA=0){
			Send,% FFUp
			MySend(keys)
			this.RT()
			return
		}

		;离开的同时去了其他线程,既然已经离开了，那么就直接释放%FF%,什么我感觉还是可以的
		Send,% FFUp
		this.RT()
		return
	}

	;我发现既没激活,都没有被松开,那么就等待50毫秒,如此重复,500毫秒过去之后,说明用户是想长按
	Sleep,10

}
Send,% FFUp
MySend(keys)
Sleep,%TandemWT%
loop {
	if !(GetKeyState(keys,"P")){
		this.RT()
		return
		break ;如果中途松开，那就跳出循环,	程序也就结束了
	}

	;如果一直不松开，就一直发送下去,
	else {
		MySend(keys)
		Sleep,%TabndemSpeed%
	}
}

this.RT()
  return  ;# 大坑,方法的一切必须放入其中,不能独立出return,坑爹
} ;# 函数结束



;以上是所有核心方法
;----------------------------------------------------------------------


;# 下面是替代连发热键
OtherTabndem(){
		local
	;修改1
	MySend(this.keys)
	return
}

EnableClick(){
		local
	;## 开放单击(模式2开,模式3不开,这就是他们之间的主要区别)
	MySend(this.keys)
	return
}


;重置触发器 Reset Trigger RT函数
RT(){
		local
this.TA:=0
return
}


;设置触发器 Set Trigger ST函数
ST(){
		local
	this.TA:=1
	return
}

} ;# UMSS Class End


;---------------------------------------------------------------------------------------------------------------

;# 以下是不用交互的函数

;# 检测目前CapsLock状态
CheckCapsLock(){
	;开着是1,关掉是0
	return GetKeyState("CapsLock","T")
}


;---------------------------------------------------------------------------------------------------------------


;# 针对CapsLock等可切换热键的针对性优化Send函数
MySend(ukey){

	;# 如果发现是3种切换键,那么不使用Send,而是直接切换,速度会快很多很多
	if(FastSwap(ukey)==1)
	return
	;# 如果CapsLock没开,那么就直接发送即可
	if(CheckCapsLock()=0){
	Send,{%ukey%}
	return
}
;~ /*
;如果发现并非单字符字母键，那么不在该使用场景内，直接发送原版，结束程序
else if !(StrLen(ukey)==1){
	Send,{%ukey%}
	return
}
;如果大写是开启的，那么转换为大写再发送一下
;~ */
else
{
	StringUpper,ukey,ukey
	Send,{%ukey%}
}
return
}

;---------------------------------------------------------------------------------------------------------------

;# 如果发现是"可切换"按键,那么就切换一下,0代表不是"可切换"按键,1代表发送了切换的指令
;## 特别提示,AHK1.3.0新特性,支持用 0/1 代表 OFF/On 但是为了照顾兼容性还是用了字符串
;## 由来:不知道为什么，如果直接Send这些可切换键的话，切换会特别慢(帮助文件上说可以这么搞),让人以为是锁定住了,那没办法，只能用另外的方法。

FastSwap(ByRef ukey){
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


;---------------------------------------------------------------------------------------------------------------


;# CheckOfukey 函数 检查"可切换按键"的状态
CheckOfukey(ByRef ukey,returnname:="0"){
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



;---------------------------------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------------------------------


; # checkString 函数 检查某字符串中是否含有某关键词(可以是多个,用|隔开即可) 如果有则return 1,没有return 0
; ## 这个函数的最大优点就是简便快捷,检查多个检查关键词的时候不需要用到数组什么的
; # 默认是不检查数量的,可以在后面添加参数,检查数量,用处还是很大的
; # 默认是不区分大小写的,可以通过更改CaseSensitive改变
; # 检查数量的那个选项如果为ReturnKey,意思就是检查到词汇之后返回该词汇,目前支持"ReturnNumber"关闭模式
; ## 如果反字符串的那个检查不到返回的是空字符串不再是0
checkString(WaitCheck,TheKey,ReturnNumber:=false,ReturnKey:=false,CaseSensitive:=false){

	;# 默认不检查数量(速度快)
	if(returnNumber=0){
	loop,Parse,TheKey,`|
	{
		if(InStr(WaitCheck,A_LoopField,CaseSensitive,1,1)){
		if (returnKey){
			return %A_LoopField%
		}

		return 1
	}

}
; 如果检查不到就反空字串
if (returnKey)
	return,% ""
return 0
}
;# 检查数量
else{

	loop,Parse,TheKey,`|
	{
		if(InStr(WaitCheck,A_LoopField,CaseSensitive,1,1))
		returnNumber++
	}
	;# 因为如果开启这个功能的话，默认值是1,所以最后输出的时候就-1
	returnNumber--
	return returnNumber

}

}
