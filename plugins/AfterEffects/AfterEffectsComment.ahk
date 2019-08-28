curver = 1.0 ; 声明当前版本
IfNotExist, vimd.ini
IniWrite, CN, vimd.ini, config, Language
else
IniRead, Language, vimd.ini, config, Language
; if (A_Language = "0804")
If Language=CN
{
;定义注释
    vim.Comment("<Ae_Open>","打开")
    vim.Comment("<Ae_Save>","保存")
    vim.Comment("<Ae_SaveAs>","另存为")
    vim.Comment("<Ae_OpenRecent>","最近打开")
    vim.Comment("<Ae_Import>","导入")
    vim.Comment("<Ae_Exit>","退出")
    vim.Comment("<Ae_Script_BoboTools>","BoBO_AeTools")
    vim.Comment("<Ae_Script_QuickMenu>","QuickMenu")
    vim.Comment("<Ae_Script_KeyBoard>","KeyBoard")
    vim.Comment("<Ae_Script_CompSetter>","批合成重设")
    vim.Comment("<Ae_Script_batchFootage>","批素材重设")
    vim.Comment("<Ae_Script_AutoMatte>","AE自动遮罩分层")
;双按    
    vim.Comment("<Ae_Double_q>","双按_【q】_渲染")
    vim.Comment("<Ae_Double_c>","合成(创建|预合成|设置)")
    vim.Comment("<Ae_Double_x>","双按_【x】_退出AE")
    vim.Comment("<Ae_Double_w>","双按_【w】_打开")
    vim.Comment("<Ae_Double_z>","双按_【z】_窗口100%%")
    vim.Comment("<Ae_Double_o>","双按_【o】_打开")
    vim.Comment("<Ae_Double_k>","双按_【k】_合成设置")
    vim.Comment("<Ae_Double_y>", "层(创建|设置|删除)")
    vim.Comment("<Ae_Double_d>", "粘贴|删除(长按)")
    vim.Comment("<Ae_Double_F9>", "渲染工具")
    

    vim.Comment("<Ae_Press_p>","长按_K位置关键帧")
    vim.Comment("<Ae_Press_s>","长按_K缩放关键帧")
    vim.Comment("<Ae_Press_r>","长按_K旋转关键帧|双按查找层源")
    vim.Comment("<Ae_Press_t>","长按_K透明关键帧")


    vim.Comment("<Ae_OpenClose_Solo>","图层独立显示")
    vim.Comment("<Ae_OpenClose_Lock>","图层锁定")
    vim.Comment("<Ae_OpenClose_Hides>","图层隐藏显示")
    vim.Comment("<AfterEffects_新建合成>", "新建合成")
    vim.Comment("<AfterEffects_固态层>", "新建固态层")
    vim.Comment("<AfterEffects_调节层>", "新建调节层")
    vim.Comment("<AfterEffects_Null>", "新建Null")
    vim.Comment("<Ae_Remove>", "删除所有效果")
    vim.Comment("<ShowHelp2>","隐藏帮助")
    vim.Comment("<Ae_CllectFiles>","打包文件")
    vim.Comment("<Ae_AllMemoryDisk>","清理内存和数据")
    vim.Comment("<Ae_UpDater>","插件更新")
    vim.Comment("<Ae_Help3>","vimAE帮助文档")
    vim.Comment("<Ae_Help_Script>","AEScriptHelp")

    vim.Comment("<AfterEffects_优化合成时间>","按工作区设置时间")

    vim.Comment("<Ae_CopyPaste>","按单键复制双键粘贴")
    vim.Comment("<Ae_foolParent>","Ae_foolParent")
    vim.Comment("<Ae_differenceToggle>", "切换 图层模式")
    vim.Comment("<Ae_layerGuideLayer>", "网格层")
    vim.Comment("<Ae_jumpToKey>", "跳至关键帧")
    vim.Comment("<Ae_MaskAndShapeVisibility>", "显示 遮罩图形")
    vim.Comment("<Ae_simpleNamer>", "简单重命名")
    vim.Comment("<Ae_PointCenter>", "中心点 归位")
    vim.Comment("<Ae_LayerInterceptLeft>", "图层截取 左边")
    vim.Comment("<Ae_LayerInterceptRight>", "图层截取 右边")
    vim.Comment("<Ae_SwitchLabel>", "切换 标签|长按s删除")    
    
    
;预设动画说明
    vim.Comment("<Ae_Preset_Ani1>","位置")
    vim.Comment("<Ae_Preset_Apply>","预设应用")
    vim.Comment("<HelpAe>","帮助")
    vim.Comment("<AeSpace>","空格")
    vim.Comment("<Ae_ProjectCleaner>","项目清理")
    vim.Comment("<Ae_ReloadFootage>","重载素材")
    vim.Comment("<Ae_Script_GlobalRename>","重命名工具")
}
else
{

}

 