VimChrome:
;操作方面请使用Surfingkeys，只做功能补充
;定义注释
    vim.SetAction("<VimGoogle_NormalMode>", "返回正常模式")
    vim.SetAction("<VimGoogle_InsertMode>", "进入VIM模式")
    vim.SetWin("VimChrome", "","chrome.exe")

;normal模式（必需）
    vim.SetMode("normal", "VimChrome")
    vim.map("<insert>","<VimGoogle_InsertMode>","VimChrome")
;vim.comment("<Phantom_切换到【VIM模式】>","按下Esc键可以切换为VIM模式")

;insert模式
    vim.SetMode("insert", "VimChrome")
    vim.Map("<esc>", "<VimGoogle_NormalMode>", "VimChrome")
    vim.Map("<f9>", "<VimGoogle_Double_OpenVimGoogle>", "VimChrome")
    vim.Map("<Delete>", "<VimChrome_清除浏览数据>", "VimChrome")
    vim.Map("<f1>", "<VimChrome_无痕>", "VimChrome")
    vim.Map("<f5>", "<VimGoogle_刷新>", "VimChrome")
    vim.Map("<f8>", "<VimChrome_无痕>", "VimChrome")
    vim.Map("-", "<VimGoogle_最小化>", "VimChrome")
    vim.Map("<SP-1>1", "<VimGoogle_访问_仙谕服务端>", "VimChrome")
    vim.Map("<SP-1>2", "<VimGoogle_访问_仙谕本地端>", "VimChrome")
    vim.Map("<SP-1>3", "<VimGoogle_本地游戏打包>", "VimChrome")
    vim.Map("<Space>", "<VimGoogle_空格_Space>", "VimChrome")
    vim.BeforeActionDo("VimChrome_BeforeActionDo", "VimChrome") 
return
; 对符合条件的控件使用insert模式，而不是normal模式
VimChrome_BeforeActionDo()
{
    ControlGetFocus, ctrl, AHK_CLASS Chrome_WidgetWin_1
	If RegExMatch(ctrl,"Chrome_RenderWidgetHostHWND1") ; || RegExMatch(ctrl,"i)qwidget")
        return true
    return false
}

<Run_VimChrome>:
{
    ExePath := ini.BOBOPath_Config.QutebrowserPath
    tClass := ini.ahk_class_Config.QutebrowserClass
    FunBoBO_RunActivation(ExePath,tClass)
    return
}
    
VimChrome_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS VimChrome_Class
    ; msgbox, ctrl
    if RegExMatch(ctrl, "Edit2")
        return true
    return false
}

<VimChrome_关闭标签>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_x, %t%
    if (t == "off")
    goto VimGoogle_double_x
    return

    VimGoogle_tappedkey_x:
    Send {x}
    return

    VimGoogle_double_x:
    send, ^w
    return
}
return

<VimChrome_全部关闭>:
send, !{F4}
return

<VimChrome_下载>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_d, %t%
    if (t == "off")
    goto VimGoogle_double_d
    return

    VimGoogle_tappedkey_d:
    Send {d}
    return

    VimGoogle_double_d:
    send, ^j
    return
}

return

<VimChrome_清除浏览数据>:
    send,^{t}
    send ^+{Del}
    sleep 1000
    send,{Enter}
    sleep 1000
    send,^w
    sleep 500
    send,^{f5}
return

<VimChrome_新建标签>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_n, %t%
    if (t == "off")
    goto VimGoogle_double_n
    return

    VimGoogle_tappedkey_n:
    Send {n}
    return

    VimGoogle_double_n:
    send, ^t
    return
}
return

<VimChrome_撤销>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_z, %t%
    if (t == "off")
    goto VimGoogle_double_z
    return

    VimGoogle_tappedkey_z:
    Send {z}
    return

    VimGoogle_double_z:
    send, ^z
    return
}

<VimChrome_无痕>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_f, %t%
    if (t == "off")
    goto VimGoogle_double_f
    return

    VimGoogle_tappedkey_f:
        send, ^t
    return

    VimGoogle_double_f:
        Send ^+{n}
    return
}

<VimGoogle_Double_OpenVimGoogle>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_g, %t%
    if (t == "off")
    goto VimGoogle_double_g
    return

    VimGoogle_tappedkey_g:
        url=www.google.com ; <-- place url here.
        run % "chrome.exe" ( winExist("ahk_class Chrome_WidgetWin_1") ? " --new-window " : " " ) url
    return

    VimGoogle_double_g:
        Send ^+{n}
        sleep 300
        Clipboard := "www.google.com"
        sleep 200
        send ^v
        send {Enter}
    return
}

<VimGoogle_搜索>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_f1, %t%
    if (t == "off")
    goto VimGoogle_double_f1
    return

    VimGoogle_tappedkey_f1:
    Send,f
    return

    VimGoogle_double_f1:
    send,^f
    return
}

<VimGoogle_刷新>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_f5, %t%
    if (t == "off")
    goto VimGoogle_double_f5
    return

    VimGoogle_tappedkey_f5:
    Send,{f5}
    return

    VimGoogle_double_f5:
    send,^{f5}
    return
}
<VimGoogle_最小化>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, VimGoogle_tappedkey_Down, %t%
    if (t == "off")
    goto VimGoogle_double_Down
    return

    VimGoogle_tappedkey_Down:
        send,{-}
    return

    VimGoogle_double_Down:
        send,!{Space}
        Sleep,100
        send,x
        return
}

<VimGoogle_访问_仙谕服务端>:
{
    send,^t
    sleep,100
    ; send,{F6}
    ; sleep,100
    ; send,^a
    Clipboard=http://192.168.1.5:8000/month/index.html?host=192.168.1.5:10001&debug=true&uid=BoBO
    send,^v
    sleep 100
    send,{Enter}
    return
}
<VimGoogle_访问_仙谕本地端>:
{
    send,^t
    sleep,100
    ; send,{F6}
    ; sleep,100
    ; send,^a
    Clipboard=http://192.168.1.89/asset/index.html?host=192.168.1.5:10001&debug=true&uid=BoBO
    send,^v
    sleep,100
    send,{Enter}
    return
}

<VimGoogle_本地游戏打包>:
{
    Run,e:\project\xm4\asset\bldData.bat
    return
}
<VimGoogle_空格_Space>:
{
    send,{Space}
    return
}
<VimGoogle_InsertMode>:
    vim.SetMode("insert","VimChrome")
    MsgBox, 0, 提示, 【VIM模式】, 0.5
return

<VimGoogle_NormalMode>:
    vim.SetMode("normal","VimChrome")
    MsgBox, 0, 提示, 【正常模式】, 0.5
return