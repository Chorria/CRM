<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
	+ request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	
	<style type="text/css">.mystage{
		font-size: 20px;
		vertical-align: middle;
		cursor: pointer;
	}
	.closingDate{
		font-size : 15px;
		cursor: pointer;
		vertical-align: middle;
	}
	</style>
	
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	
	<script type="text/javascript">
		//默认情况下取消和保存按钮是隐藏的
		var cancelAndSaveBtnDefault = true;
		
		$(function(){
			$("#remark").focus(function(){
				if(cancelAndSaveBtnDefault){
					//设置remarkDiv的高度为130px
					$("#remarkDiv").css("height","130px");
					//显示
					$("#cancelAndSaveBtn").show("2000");
					cancelAndSaveBtnDefault = false;
				}
			});
			
			$("#cancelBtn").click(function(){
				//显示
				$("#cancelAndSaveBtn").hide();
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","90px");
				cancelAndSaveBtnDefault = true;
			});
			
			/*$(".remarkDiv").mouseover(function(){
				$(this).children("div").children("div").show();
			});*/

			$("#remarkDivList").on("mouseover",".remarkDiv",function () {
				$(this).children("div").children("div").show();
			});
			
			/*$(".remarkDiv").mouseout(function(){
				$(this).children("div").children("div").hide();
			});*/

			$("#remarkDivList").on("mouseout",".remarkDiv",function () {
				$(this).children("div").children("div").hide();
			});

			/*$(".myHref").mouseover(function(){
				$(this).children("span").css("color","red");
			});*/

			$("#remarkDivList").on("mouseover",".myHref",function () {
				$(this).children("span").css("color","red");
			});
			
			/*$(".myHref").mouseout(function(){
				$(this).children("span").css("color","#E6E6E6");
			});*/

			$("#remarkDivList").on("mouseout",".myHref",function () {
				$(this).children("span").css("color","#E6E6E6");
			});
			
			
			//阶段提示框
			$(".mystage").popover({
				trigger:'manual',
				placement : 'bottom',
				html: 'true',
				animation: false
			}).on("mouseenter", function () {
				var _this = this;
				$(this).popover("show");
				$(this).siblings(".popover").on("mouseleave", function () {
					$(_this).popover('hide');
				});
			}).on("mouseleave", function () {
				var _this = this;
				setTimeout(function () {
					if (!$(".popover:hover").length) {
						$(_this).popover("hide")
					}
				}, 100);
			});
			//给交易阶段图标添加单击事件
			$(".mystage").click(function () {
				//记录当前阶段名称和名称ID
				var currentStageName = $("#currentStageName").val();
				var currentStageId = $("#currentStageId").val();
				//收集参数
				var id = "${transaction.id}";
				var stage = $(this).attr("stageId");
				//表单验证
				if (stage == currentStageId) {
					return;
				}
				if (currentStageName == "成交") {
					alert("已经成交的交易不能修改阶段!");
					return;
				}


				$.ajax({
					url : "workbench/transaction/saveEditTransactionForDetailByMap.do",
					data : {
						id : id,
						stage : stage
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//刷新页面
							window.location.reload();
						} else {
							//提示错误信息
							alert(data.message);
						}
					}
				})
			});
			//给交易备注窗口中的"保存"按键添加单击事件
			$("#saveCreateTransactionRemarkBtn").click(function () {
				//收集参数
				var noteContent = $("#remark").val();
				var tranId = "${transaction.id}";
				//表单验证
				if (noteContent == "") {
					alert("备注内容不能为空,请重新输入!");
					return;
				}
				
				$.ajax({
					url : "workbench/transaction/saveCreateTransactionRemark.do",
					data : {
						noteContent : noteContent,
						tranId : tranId
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//清空输入框,刷新备注列表
							$("#remark").val("");
							var htmlStr = "";
							htmlStr += "<div id=\"div_"+ data.retData.id +"\" class=\"remarkDiv\" style=\"height: 60px;\">";
							htmlStr += "	<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							htmlStr += "	<div style=\"position: relative; top: -40px; left: 40px;\" >";
							htmlStr += "	<h5 id=\"h5_"+ data.retData.id +"\">"+ data.retData.noteContent +"</h5>";
							htmlStr += "		<font color=\"gray\">交易</font> <font color=\"gray\">-</font> <b>${transaction.name}</b> <small id=\"small_"+ data.retData.id +"\" style=\"color: gray;\"> "+ data.retData.createTime +" 由${sessionScope.sessionUser.name}创建</small>";
							htmlStr += "		<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							htmlStr += "			<a class=\"myHref\" name=\"editA\" transactionRemarkId=\""+ data.retData.id +"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr += "			&nbsp;&nbsp;&nbsp;&nbsp;";
							htmlStr += "			<a class=\"myHref\" name=\"removeA\" transactionRemarkId=\""+ data.retData.id +"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr += "		</div>";
							htmlStr += "	</div>";
							htmlStr += "</div>";
							$("#remarkDiv").before(htmlStr);
						} else {
							//提示错误信息
							alert(data.message);
						}
					}
				})
			});
			//给交易备注窗口的"编辑"图标添加单击事件
			$("#remarkDivList").on("click","a[name='editA']",function () {
				//收集参数
				var transactionRemarkId = $(this).attr("transactionRemarkId");
				$("#edit-remarkId").val(transactionRemarkId);
				$("#edit-noteContent").val($("#h5_" + transactionRemarkId).text());
				//打开模态窗口
				$("#editRemarkModal").modal("show");
			});
			//给修改交易备注的模态窗口中的"更新"按键添加单击事件
			$("#saveEditTransactionRemarkBtn").click(function () {
				//收集参数
				var id = $("#edit-remarkId").val();
				var noteContent = $("#edit-noteContent").val();
				//表单验证
				if (noteContent == "") {
					alert("备注内容不能为空,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/transaction/saveEditTransactionRemark.do",
					data : {
						id : id,
						noteContent : noteContent
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#editRemarkModal").modal("hide");
							//刷新备注列表
							$("#h5_" + id).text(data.retData.noteContent);
							$("#small_" + id).text(" " + data.retData.editTime + " 由${sessionScope.sessionUser.name}修改");
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#editRemarkModal").modal("show");
						}
					}
				})
			});
			//给修改交易备注的模态窗口中的"删除"图标添加单击事件
			$("#remarkDivList").on("click","a[name='removeA']",function () {
				if (window.confirm("确认删除吗?")) {
					//收集参数
					var id = $(this).attr("transactionRemarkId");

					$.ajax({
						url : "workbench/transaction/deleteTransactionRemarkById.do",
						data : {
							id : id
						},
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								//刷新备注列表
								$("#div_" + id).remove();
							} else {
								//提示错误信息
								alert(data.message);
							}
						}
					})
				}
			});
		});
		
		
		
	</script>
	
</head>
<body>

	<!-- 修改交易备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="edit-remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditTransactionRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${transaction.name} <small>￥${transaction.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;" id="stageDivList">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<!--遍历stageList,依次显示每一个阶段对应的图标-->
		<input type="hidden" id="currentStageId">
		<input type="hidden" id="currentStageName">
		<c:forEach items="${stageList}" var="stage">
			<!--如果stage处在当前交易所处阶段前边，则图标显示为ok-circle，颜色显示为绿色-->
			<c:if test="${transaction.orderNo > stage.orderNo}">
				<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" stageId="${stage.id}" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
				-----------
			</c:if>
			<!--如果stage就是当前交易所处阶段，则图标显示为map-marker，颜色显示为绿色-->
			<c:if test="${transaction.stage == stage.value}">
				<script type="text/javascript">
					<!-- 记录当前交易的阶段 -->
					$("#currentStageId").val("${stage.id}");
					$("#currentStageName").val("${transaction.stage}");
				</script>
				<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" stageId="${stage.id}" data-placement="bottom" data-content="${transaction.stage}" style="color: #90F790;"></span>
				-----------
			</c:if>
			<!--如果stage处在当前交易所处阶段的后边。则图标显示为record，颜色为黑色-->
			<c:if test="${transaction.orderNo < stage.orderNo}">
				<span class="glyphicon glyphicon-record mystage" data-toggle="popover" stageId="${stage.id}" data-placement="bottom" data-content="${stage.value}"></span>
				-----------
			</c:if>
		</c:forEach>
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${transaction.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${transaction.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${transaction.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${transaction.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${transaction.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;" id="remarkDivList">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${transactionRemarkList}" var="transactionRemark">
			<div id="div_${transactionRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${transactionRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="h5_${transactionRemark.id}">${transactionRemark.noteContent}</h5>
					<font color="gray">交易</font> <font color="gray">-</font> <b>${transaction.name}</b> <small id="small_${transactionRemark.id}" style="color: gray;"> ${transactionRemark.editFlag == "0" ? transactionRemark.createTime : transactionRemark.editTime} 由${transactionRemark.editFlag == "0" ? transactionRemark.createBy : transactionRemark.editBy}${transactionRemark.editFlag == "0" ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editA" transactionRemarkId="${transactionRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="removeA" transactionRemarkId="${transactionRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveCreateTransactionRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${transactionHistoryList}" var="transactionHistory">
							<tr>
								<td>${transactionHistory.stage}</td>
								<td>${transactionHistory.money}</td>
								<td>${transactionHistory.expectedDate}</td>
								<td>${transactionHistory.createTime}</td>
								<td>${transactionHistory.createBy}</td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>