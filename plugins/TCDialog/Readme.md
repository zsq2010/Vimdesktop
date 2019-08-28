﻿## 插件基本信息

```
Name=TCDialog
Comment=将TotalCommander作为文件打开、选择对话框
Author=杜立涛
Version=2016-4-14

```

## 帮助

### 运行模式
* 配置文件中AsOpenFileDialog设置为0
  * 使用`lwin + o`激活TC进行文件选择
* 配置文件中AsOpenFileDialog设置为1
  * 打开文件选择对话框时，会自动跳转到TC，仅支持打开文件，不支持保存文件

### 快捷键
* `win + o`：在文件对话框或任意文字编辑界面按下快捷键跳转至TC，再次按下快捷键可选择文件并返回调用者
* `esc`：离开TC，回到调用者
* `ctrl + 回车`：将选择结果返回调用者
* `shift + 回车`： 当前目录返回调用者（一般用于保存文件）
* `回车`：和ctrl + 回车类似，但当仅选择一个目录时，进入目录而不返回调用者

### 已知问题

### 可用命令
* `<TC_OpenTCDialog>`：打开TC进行文件选择
 
### 可用配置

```
;===================================================
;---===此处仅供示例，必须拷贝至vimd.ini才起作用==---
;===================================================
[TotalCommander_Config]
;设置为 1 -- 将使用TC作为文件选择对话框，打开文件选择对话框时，会自动跳转到TC
;设置为 0 -- 将禁用TC作为文件选择对话框，此时仍可使用<lwin>o激活TC进行文件选择
;选定文件后，回车打开选定文件
AsOpenFileDialog=1

;含有指定字符串的窗体被打开时，禁用自动跳转到TC的功能,以逗号间隔
OpenFileDialogExclude = password , 密码
```

## 更新历史

```
2016-4-14 @杜立涛
--------------------------
优化将当前目录返回调用方的实现方法:方便保存文件时改名
修正路径名过长时，选定文件的字符串被截断的问题：
 * 第一步：粘贴文件夹路径，回车
 * 第二部：粘贴不带路径的文件名，回车

2016-2-23 @陌辞寒
--------------------------
不再新增select模式，改为重新映射快捷键，返回调用方前再清楚快捷键，绕过normal模式下快捷键依然有效的bug
支持将当前目录返回调用方（用于保存文件对话框）

2014-8-8 @杜立涛
--------------------------
跳过对标题栏为空的文件选择对话框--如Eclipse的已打开文件的列表

2014-3-12 @杜立涛
--------------------------
初步实现，并增加帮助说明
```