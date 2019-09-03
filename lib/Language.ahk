curver = 1.0 ; 声明当前版本
IfNotExist, vimd.ini
IniWrite, CN, vimd.ini, config, Language
else
IniRead, Language, vimd.ini, config, Language
; if (A_Language = "0804")
If Language=CN
{
    global _AppName:="VimDesktop"
    global _Welcome:="欢迎使用"
    global _Author="BoBO"
    global _Exit="退出 VIMD"
    global _Restart="重启 VIMD"
    global _Path="路径配置"
    global _Updating="正在更新 VimDesktop_BoBO魔改版"
    global _Updater="更新主程序"
    global _UpdatPlugins="更新插件"
    global _UpdateCompleted="更新成功"
    global _AeUpdating="正在更新AfterEffect..."
    global _MaxUpdating="正在更新3DsMax..."
    global _HotKeyManagement="热键管理"
    global _aboutMe="关于我"
    global _BackupRestore="备份还原Vimd.ini"
    
    

    global _StartUp="开机自启"
    global _Config="配置快捷键"
    global _Help="帮助文档"
    global _Feedback="反馈与建议"
    global _Update="更新 VIMD"
    global _Language = "语言(&L)"

    global _PoorNetwork="与 网络 连接不畅！请稍后再试。"
    global _ConfirmExit="遇到问题？请尝试下列解决方法！`n`n1. 阅读帮助文档`n2. 重启 Vimdesktop`n3. 更新 Vimdesktop`n4. 反馈您的问题`n`n仍然退出 Vimdesktop？"
    ;Plugins_Photoshop
    global _Photoshop_OpenSave = "打开&关闭"
    global _Photoshop_NewFile ="创建新文件"

    global _AutoUpdate ="正在更新插件，更新完毕自动重启脚本！"
}
; if ( A_Language != "0404" and A_Language != "0804" )
Else
{

    global _AppName:="VimDesktop"
    global _Welcome:="Welcome Use..."
    global _Author="BoBO"
    

    global _MaxUpdating="Update 3DsMax..."
    global _UpdateCompleted="Update Completed"
    global _Path="Path Config"
    global _HotKeyManagement="Hot Key Management"

    global _Exit="Exit"
    global _Restart="Restart"
    global _Updater="Check for Update"
    global _Updating="Updating"
    global _AeUpdating="Update AfterEffect..."
    global _MaxUpdating="Update 3DsMax..."
    global _UpdateCompleted="Update Completed"

    global _StartUp="Start VIMD on system startup"
    global _Config="VIMD Configure"
    global _Help="VIMD Help"
    global _Feedback="Feedback and Request"
    global _Language = "&Language"

    global _PoorNetwork="Poor connection with Internet! Please try again later."
    global _ConfirmExit="Encountered an issue? Please try these solutions!`n`n1. Read the help file`n2. Restart VIMD`n3. Update VIMD`n4. Report the issue`n`nExit Vimdesktop anyway?"

    global _Photoshop_OpenSave ="OpenSave"
    global _Photoshop_NewFile :="NewFile"
}