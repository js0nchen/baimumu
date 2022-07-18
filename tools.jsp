<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script src="https://code.jquery.com/jquery-3.1.1.min.js" type="text/javascript"></script>


<script type="text/javascript">
$(document).ready(function() {
	$("#pay").click(function() {
		let url = "alipays://platformapi/startapp?appId=2021002154625058&page=pages/index/index&query=tradeNo=BHT21101700004641634";
		alert(url)
		window.location.href = url;
	});
 
});
function IdentityCodeValid() {
	let code = $("#num").val()
    var city = { 11: "北京", 12: "天津", 13: "河北", 14: "山西", 15: "内蒙古", 21: "辽宁", 22: "吉林", 23: "黑龙江 ", 31: "上海", 32: "江苏", 33: "浙江", 34: "安徽", 35: "福建", 36: "江西", 37: "山东", 41: "河南", 42: "湖北 ", 43: "湖南", 44: "广东", 45: "广西", 46: "海南", 50: "重庆", 51: "四川", 52: "贵州", 53: "云南", 54: "西藏 ", 61: "陕西", 62: "甘肃", 63: "青海", 64: "宁夏", 65: "新疆", 71: "中国台湾", 81: "中国香港", 82: "中国澳门", 91: "国外 " };
	 
    if (!code || !/^\d{6}(18|19|20)?\d{2}(0[1-9]|1[12])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$/i.test(code)) {
        $(".result").html("身份证号格式错误");
        return;
    }
    if (!city[code.substr(0, 2)]) {
        $(".result").html("地址编码错误");
        return;
    }
    if (code.length == 18) {
        sBirthday = code.substr(6, 4) + "-" + Number(code.substr(10, 2)) + "-" + Number(code.substr(12, 2));
        var d = new Date(sBirthday.replace(/-/g, "/"))
        if (sBirthday != (d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate())) {
            $(".result").html("非法生日");
            return;
        }
    }
  //18位身份证需要验证最后一位校验位
    if (code.length == 18) {
        code = code.split('');
        //∑(ai×Wi)(mod 11)
        //加权因子
        var factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
        //校验位
        var parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
        var sum = 0;
        var ai = 0;
        var wi = 0;
        for (var i = 0; i < 17; i++) {
            ai = code[i];
            wi = factor[i];
            sum += ai * wi;
        }
        var last = parity[sum % 11];
        if (parity[sum % 11] != code[17]) {
            $(".result").html("校验位错误,正确校验位["+last+"]");
            return;
        }
    }
    $(".result").html("规则验证通过");
}
function luhnCheck(){
	let bankno = $("#num").val()
	var lastNum=bankno.substr(bankno.length-1,1);//取出最后一位（与luhn进行比较）
	   
    var first15Num=bankno.substr(0,bankno.length-1);//前15或18位
    var newArr=new Array();
    for(var i=first15Num.length-1;i>-1;i--){    //前15或18位倒序存进数组
        newArr.push(first15Num.substr(i,1));
    }
    var arrJiShu=new Array();  //奇数位*2的积 <9
    var arrJiShu2=new Array(); //奇数位*2的积 >9
   
    var arrOuShu=new Array();  //偶数位数组
    for(var j=0;j<newArr.length;j++){
        if((j+1)%2==1){//奇数位
            if(parseInt(newArr[j])*2<9)
            arrJiShu.push(parseInt(newArr[j])*2);
            else
            arrJiShu2.push(parseInt(newArr[j])*2);
        }
        else //偶数位
        arrOuShu.push(newArr[j]);
    }
   
    var jishu_child1=new Array();//奇数位*2 >9 的分割之后的数组个位数
    var jishu_child2=new Array();//奇数位*2 >9 的分割之后的数组十位数
    for(var h=0;h<arrJiShu2.length;h++){
        jishu_child1.push(parseInt(arrJiShu2[h])%10);
        jishu_child2.push(parseInt(arrJiShu2[h])/10);
    }       
   
    var sumJiShu=0; //奇数位*2 < 9 的数组之和
    var sumOuShu=0; //偶数位数组之和
    var sumJiShuChild1=0; //奇数位*2 >9 的分割之后的数组个位数之和
    var sumJiShuChild2=0; //奇数位*2 >9 的分割之后的数组十位数之和
    var sumTotal=0;
    for(var m=0;m<arrJiShu.length;m++){
        sumJiShu=sumJiShu+parseInt(arrJiShu[m]);
    }
   
    for(var n=0;n<arrOuShu.length;n++){
        sumOuShu=sumOuShu+parseInt(arrOuShu[n]);
    }
   
    for(var p=0;p<jishu_child1.length;p++){
        sumJiShuChild1=sumJiShuChild1+parseInt(jishu_child1[p]);
        sumJiShuChild2=sumJiShuChild2+parseInt(jishu_child2[p]);
    }     
    //计算总和
    sumTotal=parseInt(sumJiShu)+parseInt(sumOuShu)+parseInt(sumJiShuChild1)+parseInt(sumJiShuChild2);
   
    //计算luhn值
    var k= parseInt(sumTotal)%10==0?10:parseInt(sumTotal)%10;       
    var luhn= 10-k;
   
    if(lastNum==luhn){
    	$(".result").html("银行卡号luhn验证通过");
    	return true;
    }
    else{
    	$(".result").html("银行卡号不符合luhn校验");
    	return false;
    }       
}
</script>
<title>测试页面</title>
</head>
<body>
	<!--<input type="button" id="pay" value="测试">  -->
	<!--网银跳转form示例  -->
	<form action="#" method="post">
		<!-- <input type="text" name="epccGwMsg" value="PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgio1ODo0N"/> -->
	</form> 
	<div>
		输入号码:<input type="text" id="num" name="num" value="" size="20">
		<button onclick="IdentityCodeValid()">身份证验证</button>
		<button onclick="luhnCheck()">银行卡验证</button>
		<div class="result" style="color:#F00"></div>
	</div>
	
</body>
</html>
