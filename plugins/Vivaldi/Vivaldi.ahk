Vivaldi:
;定义注释
    vim.SetAction("<Vivaldi_NormalMode>", "返回正常模式")
    vim.SetAction("<Vivaldi_InsertMode>", "进入VIM模式")
    vim.SetWin("Vivaldi","ahk_exe", "vivaldi.exe")

;normal模式（必需）
    vim.SetMode("normal", "Vivaldi")
    vim.map("<insert>","<Vivaldi_InsertMode>","Vivaldi")
;vim.comment("<Phantom_切换到【VIM模式】>","按下Esc键可以切换为VIM模式")

;insert模式
    vim.SetMode("insert", "Vivaldi")
    vim.Map("<esc>", "<Vivaldi_NormalMode>", "Vivaldi")
    vim.Map("<SP-1>1", "<Vivaldi_访问_仙谕服务端>", "Vivaldi")
    vim.Map("<SP-1>2", "<Vivaldi_访问_仙谕本地端>", "Vivaldi")
    vim.Map("<space>", "<Vivaldi_Space>", "Vivaldi")
    <>
return

;【全局运行】
<RunVivaldi>:
    VivaldiPath := ini.BOBOPath_Config.VivaldiPath
    Vivaldi_Class := ini.ahk_class_Config.Vivaldi_Class
    DetectHiddenWindows, on
    IfWinNotExist VivaldiPath Vivaldi_Class 
    { 
   		Run %VivaldiPath%
    	WinActivate 
    } 
    	Else IfWinNotActive ahk_class Vivaldi_Class 
    { 
    	WinActivate
    } 
    Else 
    { 
        WinMinimize 
    } 
 Return
 ; 对符合条件的控件使用insert模式，而不是normal模式
Vivaldi_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS Vivaldi_Class
    ; msgbox, ctrl
    if RegExMatch(ctrl, "Edit2")
        return true
    return false
}
<Vivaldi_NormalMode>:
    Send,{Esc}
    vim.Mode("normal","Vivaldi")
;    gosub,<normalmode_LED1>
    ;emptymem()
return
; <insert_TC> {{{1
<Vivaldi_InsertMode>:
    vim.Mode("insert","Vivaldi")
;    gosub,<insertmode_LED1>
return
<Vivaldi_访问_仙谕服务端>:
{
    send,^t
    sleep,100
    ; send,{F6}
    ; sleep,100
    ; send,^a
    Clipboard=http://192.168.1.5/month/?host=jiany.f3322.net:10001&uid=BoBO
    send,^v
    sleep 100
    send,{Enter}
    return
}
<Vivaldi_访问_仙谕本地端>:
{
    send,^t
    sleep,100
    ; send,{F6}
    ; sleep,100
    ; send,^a
    Clipboard=http://localhost/asset/?host=jiany.f3322.net:10001&uid=BoBO55
    send,^v
    sleep,100
    send,{Enter}
    return
}
<Vivaldi_Space>:
{
    send,{Space}
    return
}