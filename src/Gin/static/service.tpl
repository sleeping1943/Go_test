<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0,user-scalable=no">
    <script src="https://cdn.staticfile.org/jquery/1.10.2/jquery.min.js"> </script> 
    <script>
        var get_funcs_url="http://{{.}}/Service/func"
        var get_url="http://{{.}}/Service/funcParams"
        var post_url="http://{{.}}/Service/call"
        // 页面加载完成时调用的函数
        $(document).ready(function(){
            get_funcs()
        });  

        function get_funcs() {
            $.post(get_funcs_url, function(data){
                //$('.ret_str').text(JSON.stringify(data))
                $("#slt_func").empty();
                $("#slt_func").append("<option value='default'>---请选择函数名---</option>"); 
                for (var func_name in data) {
                    var option_str = "<option value='"
                    option_str += func_name
                    option_str += "'>"
                    option_str += func_name
                    option_str += "</option>"
                    //alert(option_str);
                    $("#slt_func").append(option_str); 
                }
            });
        }
        // 调用函数
        function invoke_ice() {
            //alert($("#slt_func").get(0).selectedIndex)
            if ($("#slt_func").get(0).selectedIndex == 0) {
                alert("当前函数名无效，请选择函数名！")
                return
            }
            var func_name = 'funcName='
            var options=$("#slt_func option:selected");
            var func_name = 'funcName='

            func_name += options.val()
            func_name += '&params='
            func_name += $('.params').val()
            func_name += '&ip='
            func_name += $('#ip').val()
            func_name += '&port='
            func_name += $('#port').val()
            func_name += '&flag='
            func_name += $('#svr_flag').val()
            $.post(post_url, func_name, function(data){
                json_data = JSON.parse(data["info"])
                json_str = JSON.stringify(json_data, null, "\t")
                $('.ret_str').val(json_str)
            });
        }

        // 获取函数对应参数
        function funcChanged(tx){
            var options=$("#slt_func option:selected");
            var func_name = 'funcName='
            func_name += options.val()
            $.getJSON(get_url, func_name, function(data){
                for (var func_name in data) {
                    //alert(option_str);
                    if (func_name == "func_name") {
                        $('.params').val(data[func_name])
                        break;
                    }
                }
            });
		}
    </script>
    <style type="text/css">
        html,body{
            height:100%;
        }
        textarea {
            resize: none;
        }
        .yongyin {
            width:100px;
            text-align:center;
            line-height:100%;
            padding:0.3em;
            font:16px Arial,sans-serif bold;
            font-style:normal;
            text-decoration:none;
            margin:2px;
            vertical-align:text-bottom;
            zoom:1;
            outline:none;
            font-size-adjust:none;
            font-stretch:normal;
            border-radius:50px;
            box-shadow:0px 1px 2px rgba(0,0,0,0.2);
            text-shadow:0px 1px 1px rgba(0,0,0,0.3);
            color:#080808;
            border:0.2px solid #acaaa9;
            background-repeat:repeat;
            background-size:auto;
            background-origin:padding-box;
            background-clip:padding-box;
            background-color:#8f9092;
            background: linear-gradient(to bottom, #eeeff9 0%,#868788 100%);
        }
    
        .yongyin:hover {
            background: rgb(174, 176, 177);
        }
    </style>
    <head>
    <title>Ice测试工具(made by sleeping)</title> 
    </head>
    <body>
        <div id="container">

            <div id="header" style="background-color:rgb(149, 149, 147);clear:both;text-align:center;">
            <h1 style="margin-bottom:0;">Ice测试工具</h1></div>
    
            <!--<div id="nav" style="width:10%;"> -->
            <div id="nav">
                <label>函数名:</label>
                <select id="slt_func" onchange="funcChanged(this.options[this.options.selectedIndex].text);">
                <option value ="default">--请选择函数名--</option>
                <option value ="volvo">Volvo111111111111111111111</option>
                <option value ="saab">Saab</option>
                <option value="opel">Opel</option>
                <option value="audi">Audi</option>
                </select>
                <label>IP:</label>
                <input id="ip" type="text"  value="192.168.2.77"/>
                <label>PORT:</label>
                <input id="port" type="text" value="20071"/>
                <label>服务标识:</label>
                <input id="svr_flag" type="text" value="SaasService"/>
                <button class="yongyin" onclick="invoke_ice();" style="width:50px;">调用</button>
                <!--<button class="yongyin" onclick="get_funcs();" style="width:50px;">获取函数名</button> -->
            </div> 

            <div id="section">
                <div id="div_params" style="background-color:#EEEEEE;height:1000px;width:35%;float:left;">
                <textarea class="params" style="height:100%;width:100%;float:left;"></textarea>
                </div>

                <div id="div_ret_str" style="background-color:rgb(114, 107, 107);height:1000px;width:65%;float:left;">
                <textarea class="ret_str" style="height:100%;width:100%;float:left;"></textarea>
                </div>
            </div>
            <!--
            <div id="btn_call" style="float:right;">
            </div>
            -->
            <div id="footer" style="background-color:rgb(149, 149, 147);clear:both;text-align:center;">
            版权 © csleeping@163.com
            </div>
        </div>

  </body>
</html>
