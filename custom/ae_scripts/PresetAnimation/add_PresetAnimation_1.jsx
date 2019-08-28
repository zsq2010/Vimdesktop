var enDir = $.getenv("vimdir") ; //获取VIMD环境路径

var getDir=enDir.replace(/\\/g, '\/'); //转换字符

var getPath = "/custom/ae_presetAnimation/Transform@场景.ffx";//请在这行修改预设文件

var myPreset = File(getDir+getPath);//合并路径

var layer = app.project.activeItem.selectedLayers[0];

layer.applyPreset(myPreset);