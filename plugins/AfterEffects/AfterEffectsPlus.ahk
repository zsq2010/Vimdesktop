#WinActivateForce ;强制激活窗口
#InstallKeybdHook
#InstallMouseHook
#SingleInstance Force
#NoEnv
#Persistent
#MaxThreads 255
#MaxHotkeysPerInterval 400
#MenuMaskKey vk07
Process, Priority, , High						;脚本高优先级
;Process, Priority,, Realtime
SendMode Input
DetectHiddenWindows, on
;DetectHiddenText, on
SetTitleMatchMode 2
SetWinDelay, 100
CoordMode,Mouse,Screen
SetControlDelay -1
;SetBatchLines -1  ;脚本全速执行
SetKeyDelay, -1    ;控件修改命令自动延时,-1无延时，0最小延时
; SetWorkingDir %A_ScriptDir%
; CreatTrayMenu()
;;GUI
GV_ReloadTimer := % 1000*60*5
CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
Gui,Ae:  +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui,Ae: Color, %CustomColor%
WinSet, TransColor, %CustomColor% 220
Gui,Ae:Font,s8,Tahoma,q5

; Menu, Tray, Icon, %A_ScriptDir%\AfterEffectsPlus.ico


;;Windows Groups
GroupAdd, AfterEffects, ahk_exe AfterFX.exe
GroupAdd, AfterEffects, ahk_class AE_CApplication_14.1
GroupAdd, AfterEffects, ahk_class AE_CApplication_15.1
GroupAdd, AfterEffects, ahk_class AE_CApplication_16.1
GroupAdd, AfterEffects, ahk_class AutoHotkeyGUI

;;AfterEffects
#IfWinActive ahk_group AfterEffects

;;GUI
CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
WinSet, TransColor, %CustomColor% 255
Gui,Font,s7,Tahoma,q5

;;Drop Down Lists 下拉列表
;Gui,Ae: Add, DropDownList, x246 y52 w100 h20 R100 gAeModifierSwitch vModifierList Choose 1, Modifier List...||EditPoly|EditSpline
;Gui,Ae: Add, DropDownList, x146 y52 w100 h20 R100 gAeObjectSwitch vObjectList Choose 1, 创建 列表...||合成组|固态层|调节层
;Gui,Ae: Add, DropDownList, x346 y52 w100 h20 R100 gAeScriptSwitch vScriptList Choose 1, 脚本 列表...||Script1|Script2|Script3|

;;Tabs
Gui,Ae: Add, Tab, x236 y93 w180 h18 -BackgroundTrans,Basic|Render|Delete|Tools ;|Test |Tools ;Spline

Gui,Ae: Tab, Render
Gui,Ae: Add, Button,x236 y112 w90 gImmigrationREG, 批量导入素材
Gui,Ae: Add, Button,x326 y112 w90 gBatchReplaceFile, 批量替换素材
Gui,Ae: Add, Button,x236 y136 w180 gRENDER, 动作/方向
Gui,Ae: Add, Button,x236 y160 w180 gNameRENDER, 名字/动作/方向
Gui,Ae: Add, Button,x236 y184 w180 gNameDirection, 名字/方向
Gui,Ae: Add, Button,x236 y208 w180 gName, 名字 
Gui,Ae: Add, Button,x236 y232 w180 gRenderGarden, RenderGarden 
Gui,Ae: Tab, Tools
Gui,Ae: Add, Button,x236 y112 w90 gProjectConver, TSV转换
Gui,Ae: Add, Button,x326 y112 w90 gSaveCompAsProject, 导出合成组
Gui,Ae: Add, Button,x236 y136 w90 gCompDuplicator, 塌陷合成组
Gui,Ae: Add, Button,x326 y136 w90 gPropertiesToFxControls, 调节层控制
Gui,Ae: Add, Button,x236 y160 w90 gBatchRename, 批量重命名
Gui,Ae: Add, Button,x326 y160 w90 gBakeExpressionsKey, ExpToKey

; Gui,Ae: Add, Button, vB1 w32 h32 hwndHBT1 gCopy,
; 	Opt1 := { 1:0, 2:0xECEFF3, 7:0xBCC4D0, icon:{file:A_ScriptDir "\ui\icon\copy.png"} }
; 	Opt2 := { 1:0, 2:0xCAD3DE, 7:0xA5AFBF, icon:{file:A_ScriptDir "\ui\icon\copy.png"} }
; 	Opt3 := { 1:0, 2:0xC1CAD7, 7:0x99A5B7, icon:{file:A_ScriptDir "\ui\icon\copy.png"} }
; 	ImageButton.Create(HBT1, Opt1, Opt2, Opt3)

; Gui,Ae: Add, Button, vB2 w32 h32 hwndHBT2 gSave,
; 	Opt1 := { 1:0, 2:0xECEFF3, 7:0xBCC4D0, icon:{file:A_ScriptDir "\ui\icon\save.png"} }
; 	Opt2 := { 1:0, 2:0xCAD3DE, 7:0xA5AFBF, icon:{file:A_ScriptDir "\ui\icon\save.png"} }
; 	Opt3 := { 1:0, 2:0xC1CAD7, 7:0x99A5B7, icon:{file:A_ScriptDir "\ui\icon\save.png"} }
; 	ImageButton.Create(HBT2, Opt1, Opt2, Opt3)

;Gui, Ae: Show,, Image Buttons

Gui,Ae: Tab, Basic
Gui,Ae: Add, Button, x298 y142 w20 h20 , C
Gui,Ae: Add, Button, x276 y112 w60 h30 gDynamicComp, Dynamic
Gui,Ae: Add, Button, x218 y142 w80 h20 , Mask
Gui,Ae: Add, Button, x318 y142 w80 h20 gCompsitionOption,合成设置
Gui,Ae: Add, Button, x276 y162 w60 h30 , 切图动画
Gui,Ae: Add, Button, x336 y112 w40 h30 , Zoom
Gui,Ae: Add, Button, x336 y162 w40 h30 , ??
Gui,Ae: Add, Button, x236 y162 w40 h30 , ??
Gui,Ae: Add, Button, x236 y112 w40 h30 , Hand
Gui,Ae: Add, Button, x196 y122 w40 h20 , Text
Gui,Ae: Add, Button, x376 y122 w40 h20 -Wrap +Left, Puppet

Gui,Ae: Tab, Delete
Gui,Ae: Add, Button, x298 y142 w20 h20 , C
Gui,Ae: Add, Button, x276 y112 w60 h30 , 位置0
Gui,Ae: Add, Button, x218 y142 w80 h20 , D遮罩
Gui,Ae: Add, Button, x318 y142 w80 h20 , D标记
Gui,Ae: Add, Button, x278 y162 w60 h30 , 重置所有
Gui,Ae: Add, Button, x336 y112 w40 h30 , D帧
Gui,Ae: Add, Button, x338 y162 w40 h30 , 0_Exp
Gui,Ae: Add, Button, x248 y162 w40 h30 , 1_Exp
Gui,Ae: Add, Button, x236 y112 w40 h30 , D特效
Gui,Ae: Add, Button, x196 y122 w40 h20 , D_Exp
Gui,Ae: Add, Button, x376 y122 w40 h20 -Wrap +Left, 轴心0

return

CompsitionOption:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\CompSetter.jsx
	getAeScript(AeScriptPath)
return

DynamicComp:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\Dynamic_Comp.jsxbin	
	getAeScript(AeScriptPath)
Return

AeButton切图动画:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\Sprite-O-Matic.jsx	
	getAeScript(AeScriptPath)
Return

;表达式转关键帧
BakeExpressionsKey:
	Gui,Ae: Hide   
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\bakeExpressionsKey.jsxbin ;
    getAeScript(AeScriptPath)
return

;图层特效属性统一链接到调节层上控制
PropertiesToFxControls: 
	Gui,Ae: Hide   
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\PropertiesToFxControls.jsxbin ;
    getAeScript(AeScriptPath)
return
;独立复制和重组
CompDuplicator:
	Gui,Ae: Hide   
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\trueCompDuplicator.jsx ;
    getAeScript(AeScriptPath)
return

ProjectConver:
	Gui,Ae: Hide   
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\OpenSesame.jsx ;
    getAeScript(AeScriptPath)
return

SaveCompAsProject:
	Gui,Ae: Hide   
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\saveCompAsProject.jsxbin ;
    getAeScript(AeScriptPath)
return

BatchReplaceFile:
	Gui,Ae: Hide   
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\BatchReplaceFileLocationsWithTextFile.jsx ;
    getAeScript(AeScriptPath)
return

RenderGarden:
	Gui,Ae: Hide   
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\RenderGarden.jsx ;RG10-6441-1070-2018注册码
    getAeScript(AeScriptPath)
return
Name:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\BRender_CreateFolderAndOutputForSelectedComps_Name.jsx
    getAeScript(AeScriptPath)
return

Render:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\BRender_CreateFolderAndOutputForSelectedComps_AttackDirection.jsx
    getAeScript(AeScriptPath)
return
NameRENDER:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\BRender_CreateFolderAndOutputForSelectedComps_NameAttackDirection.jsx
    getAeScript(AeScriptPath)
return
NameDirection:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\BRender_CreateFolderAndOutputForSelectedComps_NameDirection.jsx
    getAeScript(AeScriptPath)
return
ImmigrationREG:
	Gui,Ae: Hide 
	AeScriptPath = %A_ScriptDir%\custom\ae_scripts\(BOBOToolsFunctions)\Immigration.jsx
    getAeScript(AeScriptPath)
return

BatchRename:
	Gui,Ae: Hide 
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\AEGlobalRenamer.jsxbin
    getAeScript(AeScriptPath)
return
COPY:
	Gui,Ae: Hide 
	MsgBox Copy
return
SAVE:
	Gui,Ae: Hide 
	MsgBox Save
return
;;DropDownList Auto Expand
AeTimerLabel:
	SetTimer, AeCheckMouseOver, 0
Return

AeCheckMouseOver:
{
	IfWinActive, ahk_class AutoHotkeyGUI
	{ 
	Aeact:
	SetTimer, AeCheckMouseOver, 10
	
		MouseGetPos,,,,Control

		if  (control = "ComboBox1")
		{
		}


		if  (control = "ComboBox2")
		{
		}

		if  (control = "ComboBox3")
		{
		}
	}
}
Return


;;Objects List
AeObjectSwitch:
	Gui,Ae: Submit, 
	if ObjectList=Box
		{
		Gui,Ae: Hide
		Return
		}
		
	if ObjectList=Plane
		{
		Gui,Ae: Hide
		Return
		}
    if ObjectList=Sphere
		{
		Gui,Ae: Hide
		Return
		}
Return

;;Modifiers List
AeModifierSwitch:
	Gui,Ae: Submit, 
	if ModifierList=EditPoly
		{
		Gui,Ae: Hide
		Return
		}
		
	if ModifierList=EditSpline
		{
		Gui,Ae: Hide
		Return
		}
Return

;;Scripts List
AeScriptSwitch:
	Gui,Ae: Submit, 
	if ScriptList= Clear UVW1 Channel
		{
		Gui,Ae: Hide
		Return
		}
Return


;;Buttons Actions
;Button C
AeButtonC:
	Gui,Ae: Hide
Return

;Button EPoly_Selection
AeButtonSelection:
	Gui,Ae: Hide
	Send,{v}
Return

AeButtonHand:
Gui,Ae: Hide
	Send,{h}
Return

AeButtonZoom:
Gui,Ae: Hide
	Send,{z}
Return

AeButtonMask:
Gui,Ae: Hide
	Send,{q}
Return

AeButtonPen:
Gui,Ae: Hide
	Send,{g}
Return
;激活Ae面板

AeButton位置0:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\resetTransformations.jsx
    getAeScript(AeScriptPath)
Return

AeButtonD遮罩:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\deleteMasks.jsx
    getAeScript(AeScriptPath)
Return

AeButtonD标记:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\deleteMarkers.jsx
    getAeScript(AeScriptPath)
Return

AeButton重置所有:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\resetAll.jsx
    getAeScript(AeScriptPath)
Return

AeButtonD帧:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\deleteKeys.jsx
    getAeScript(AeScriptPath)
Return

AeButton0_Exp:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\disableExpressions.jsx
    getAeScript(AeScriptPath)
Return

AeButton1_Exp:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\enableExpressions.jsx
    getAeScript(AeScriptPath)
Return

AeButtonD特效:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\deleteEffects.jsx
    getAeScript(AeScriptPath)
Return

AeButtonD_Exp:
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\deleteExpressions.jsx
    getAeScript(AeScriptPath)
Return

AeButton轴心0:
	Gui,Ae: Hide
	send ^!{Home}
Return


   


;<Ae_AHK>:
; Space::
;  	ControlGetFocus, ctrl, A
;     if RegExMatch(ctrl, "i)Edit")  ; or WinExist("ahk_class #32770"))
;     {
; 		send {Space} 
; 		Return
;     }
;     else
;     {
; 		WinActivate, ahk_exe AfterFX.exe
; 		MouseGetPos, MX, MY
; 		MouseX:=MX-305
; 		MouseY:=MY-155 
; 		Gui,Ae: Show,X%MouseX% Y%MouseY% ,NoActivate ; NoActivate avoids deactivating the currently active window.
; 		;保存当前信息
; 		KeyWait,Space ; ,D                                
; 		Sleep, 20                                                                                              
; 		IfWinActive, ahk_class AutoHotkeyGUI
; 	{ 
; 		Click down 
; 		Sleep, 20  
; 		Click up
; 		Sleep, 20                 
; 		Gui,Ae: Hide 
; 	}
; 	else
; 	{
; 		Return
; 	}
;     }
;     return

; Return

; getAeScript(AeScriptPath){
; 	WinActivate, ahk_exe AfterFX.exe
;     WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
;     run, %activePath% -r %AeScriptPath% ,,Hide
; 	send, +{Enter}
; 	Click 1
; 	return
; }



; Gosub,AutoReloadInit
; AutoReloadInit:
; 	SetTimer, AE_Reload, % GV_ReloadTimer
; return

; CreatTrayMenu()
; {
; Menu,Tray,NoStandard
; Menu,Tray,add,重启(&R),AE_Reload
; Menu,Tray,add
; Menu,Tray,add,暂停热键(&S),Menu_Suspend
; Menu,Tray,add,暂停脚本(&A),Menu_Pause
; Menu,Tray,add,退出(&X),Menu_Exit
; }
; AE_Reload:
; 	Reload
; return
; Menu_Suspend:
; 	Menu,tray,ToggleCheck,暂停热键(&S)
; 	Suspend
; return
; Menu_Pause:
; 	Menu,tray,ToggleCheck,暂停脚本(&A)
; 	Pause
; return
; Menu_Exit:
; 	ExitApp
; return

; Quit:
; ExitApp


