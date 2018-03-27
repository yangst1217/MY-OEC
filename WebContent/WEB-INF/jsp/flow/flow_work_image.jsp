<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程图</title>
    <style type="text/css">
        .containerDIV {
            height: 60px;
            text-align: center;
            width: 100%;
        }

        .flowNode {
            height: 50px;
            text-align: center;
            margin: 3px;
            border: 1px solid #CECECE;
            display: inline-block;
            padding: 3px;
            line-height: 50px;
        }
    </style>
</head>
<body>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript">
    var nodes = eval('${nodes}');
    $(function () {
        var maxLevel = nodes[nodes.length - 1].NODE_LEVEL

        for (var i = 0; i < maxLevel; i++) {
            $("body").append("<div id='containerDIV_" + (i + 1) + "' class='containerDIV'></div>");
            if (i != maxLevel - 1) {
                $("body").append("<div style='text-align:center;margin-top: 3px;'><img src='static/img/down.png'></div>");
            }
        }

        for (var i = 0; i < nodes.length; i++) {
            $("#containerDIV_" + nodes[i].NODE_LEVEL).append("<div class='flowNode'>" + nodes[i].NODE_NAME + "</div>");

        }
    });
</script>
</body>
</html>