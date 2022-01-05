function GetHTMLElementTagsAtPoint(x,y){
    var tags = ",";
    var e = document.elementFromPoint(x,y);
    while (e) {
        if (e.tagName) {
            tags += e.tagName + ',';
        }
        e = e.parentNode;
    }
    return tags;
}

function GetHTMLElementAtPoint(x,y){
    var e = document.elementFromPoint(x,y);
    return e.toString;
}

function GetVideoSRCAtPoint(x,y){
    var e = document.elementFromPoint(x,y);
    var src = "";
    if(e.tagName == "VIDEO"){
        if(e.src){
            src = e.src;
        } else {
            var children = e.childNodes;
            for (var i = 0 ; i < children.length; i++){
                child = children[i];
                if(child.src){
                    src = child.src;
                    break;
                }
            }
        }
    }else if(e.parentNode.id == "youku-html5-player-info"){
        src += (e.parentNode.getElementsByTagName("video"))[0].src;
    }
    return src;
}

function GetVideoSRCAtPoint1(px,py){
    var videos = document.getElementsByTagName("video");
    var src = "";
    for (var i = 0 ; i < videos.length; i++){
        video = videos[i];

        var x = 0;
        var y = 0;
        var ele = video;
        while(ele) {
            x += ele.offsetLeft;
            y += ele.offsetTop;
            ele = ele.offsetParent;
        }
        x -= window.scrollX;
        y -= window.scrollY;
        var height = video.clientHeight;
        var width = video.clientWidth;
        
        if(px>x&&px<x+width&&py>y&&py<y+height){
            if(video.src){
                src = video.src;
            } else {
                var children = video.childNodes;
                for (var i = 0 ; i < children.length; i++){
                    child = children[i];
                    if(child.src){
                        src = child.src;
                        break;
                    }
                }
            }
            break;
        }
    }
    if(src.length == 0){
        var iframes = document.getElementsByTagName("iframe");
        for (var i = 0 ; i < iframes.length; i++){
            iframe = iframes[i];
            
            var x = 0;
            var y = 0;
            var ele = iframe;
            while(ele) {
                x += ele.offsetLeft;
                y += ele.offsetTop;
                ele = ele.offsetParent;
            }
            x -= window.scrollX;
            y -= window.scrollY;
            var height = iframe.clientHeight;
            var width = iframe.clientWidth;
            
            if(px>x&&px<x+width&&py>y&&py<y+height){
                var oDoc = (iframe.contentWindow || iframe.contentDocument);
                if (oDoc.document) {
                    oDoc = oDoc.document;
                }
                var videos = oDoc.getElementsByTagName("video");
                if(videos.length>0){
                    src = videos[0].src;
                    break;
                }
            }
        }
    }
    return src
}

function GetImgSrcAtPoint(px,py){
    var imgs = document.getElementsByTagName("img");
    var src = "";
    for (var i = 0 ; i < imgs.length; i++){
        img = imgs[i];
        
        var x = 0;
        var y = 0;
        var ele = img;
        while(ele) {
            x += ele.offsetLeft;
            y += ele.offsetTop;
            ele = ele.offsetParent;
        }
        x -= window.scrollX;
        y -= window.scrollY;
        var height = img.clientHeight;
        var width = img.clientWidth;
        
        if(px>x&&px<x+width&&py>y&&py<y+height){
            src += img.src;
            break;
        }
    }
    return src
}

function GetImgDataAtPoint(px,py){
    var imgs = document.getElementsByTagName("img");
    var img = new Image();
    img.crossOrigin = "anonymous";
    for (var i = 0 ; i < imgs.length; i++){
        var x = 0;
        var y = 0;
        var ele = imgs[i];
        while(ele) {
            x += ele.offsetLeft;
            y += ele.offsetTop;
            ele = ele.offsetParent;
        }
        x -= window.scrollX;
        y -= window.scrollY;
        var height = img.clientHeight;
        var width = img.clientWidth;
        
        if(px>x&&px<x+width&&py>y&&py<y+height){
            img.src = ele.src;
            break;
        }
    }
    console.log(img);
   var canvas=document.createElement("canvas"); 
   var context=canvas.getContext("2d"); 
   canvas.width=img.width; canvas.height=img.height; 
   context.drawImage(img,0,0,img.width,img.height);
    
   return canvas.toDataURL("image/jpg")
}

function GetLinkSRCAtPoint(x,y) {
    var src = "";
    var e = document.elementFromPoint(x,y);
    
    while (e) {
        if (e.src) {
            src += e.src;
            break;
        }
        e = e.parentNode;
    }
    return src;
}

function GetLinkHREFAtPoint(x,y) {
    var href = "";
    var e = document.elementFromPoint(x,y);
    while (e) {
        if (e.href) {
            href += e.href;
            break;
        }
        e = e.parentNode;
    }
    return href;
}

function GetLinkTextAtPoint(x,y) {
    var text = "";
    var e = document.elementFromPoint(x,y);
    while (e) {
        if (e.text) {
            text += e.text;
            break;
        }
        e = e.parentNode;
    }
    return text;
}

function GetSelectedString(){
    return window.getSelection().toString();
}

//测试函数，如果这个函数可以正常的弹出敬告框，说明所有的js都被正确的解析了
//function MTT_ParseCorrectTest()
//{
//    alert("all func is right!");
//}

//设置字体大小
function SetTextSize(textSize) {
    switch(textSize)
    {
        case 0:
            document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='80%';
            break;
        case 1:
            document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='100%';
            break;
        case 2:
            document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='120%';
            break;
        case 3:
            document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='150%';
            break;
        default:
            break;
    }
}

//关闭弹出框
function WebkitTouchCalloutEnable(enable){
    switch(enable)
    {
        case 0:
            document.body.style.webkitTouchCallout='none';
            break;
        case 1:
            document.body.style.webkitTouchCallout='yes';
            break;
        default:
            break;
    }
}

//设置编码
//function MTT_SetHTMLCharset(){
//    var element = document.createElement('meta');
//    element.httpEquiv = "content-type";
//    element.content = "text/html; charset=GBK";
//    var head = document.getElementsByTagName('head')[0];
//    head.appendChild(element);
//}

//设置页面的缩放
function SetPageScale(pageScale){
    var element = document.createElement('meta');
    element.name = "viewport";
    element.content = "minimum-scale=0; maximum-scale=10; initial-scale=";
    
    element.content = element.content + pageScale;
    
    var head = document.getElementsByTagName('head')[0];
    head.appendChild(element);
}

function GetOffsetX(obj){
	var offsetX = 0;
	while(obj)
	{
		if(typeof obj.offsetLeft == "number")
		{
            offsetX += obj.offsetLeft;
		}
		obj = obj.parentNode;
	}
	return offsetX;
}

function GetOffsetY(obj){
    var offsetY = 0;
    while(obj)
    {
        if(typeof obj.offsetTop == "number")
        {
            offsetY += obj.offsetTop;
        }
        obj = obj.parentNode;
    }
    return offsetY;
}
// 设置放大上限
function IncreaseMaxZoomFactor(){
	var head = document.getElementsByTagName('head')[0];
	var metaList = head.getElementsByTagName('meta');
	var isFind = 0;
	for (var i = 0 ; i < metaList.length; i++){
		if(metaList[i].getAttribute("name") == "viewport")
		{
			isFind=1;
			break;
		}
	}
	if (isFind == 0)
	{
		var element = document.createElement('meta');
		element.name = "viewport";
		element.content = "maximum-scale=5";
		head.appendChild(element);
	} 
}

function GetRectForSelectedText(){
    var selection = window.getSelection(); 
    var range = selection.getRangeAt(0); 
    var rect = range.getBoundingClientRect(); 
    return "{{" + rect.left + "," + rect.top + "}, {" + rect.width + "," + rect.height + "}}";
}
