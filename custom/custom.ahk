
;在窗口内点击坐标
CoordWinClick(x,y){
	CoordMode, Mouse, Relative
;	WinGetPos, X, Y, W, H, A
	ControlClick, x%x% y%y%,,,,, Pos
	return
}
;无视输入法状态发送字符串
;其实还有一种方法，就是把字符串赋值给粘贴板，然后粘贴
uStr(str)
{
    charList:=StrSplit(str)
	SetFormat, integer, hex
    for key,val in charList
    out.="{U+ " . ord(val) . "}"
	return out
}

