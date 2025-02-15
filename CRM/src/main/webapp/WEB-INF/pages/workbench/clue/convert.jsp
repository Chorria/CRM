﻿<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
	+ request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<script type="text/javascript">
		$(function(){
			$("#isCreateTransaction").click(function(){
				if(this.checked){
					$("#create-transaction2").show(200);
				}else{
					$("#create-transaction2").hide(200);
				}
			});
			//调用日历工具
			$(".date").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				initialDate : new Date(),
				todayBtn : true,
				clearBtn : true,
				minView : "month",
				autoclose : true,
				pickerPosition : "top-right"
			});
			//填充交易名称
			$("#name").val("${clue.company}-");
			//给市场活动源的搜索按键添加单击事件
			$("#queryActivitySource").click(function () {
				//打开模态窗口
				$("#searchActivityModal").modal("show");
			});
			//给市场活动源文本框添加键盘弹起事件
			$("#searchActivity").keyup(function () {
				//收集参数
				var clueId = "${clue.id}";
				var activityName = this.value;

				$.ajax({
					url : "workbench/clue/queryActivityForConvertByNameAndClueId.do",
					data : {
						clueId : clueId,
						activityName : activityName
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						var htmlStr = "";
						$.each(data,function (index, activity) {
							htmlStr += "<tr>";
							htmlStr += "	<td><input type=\"radio\" value=\""+ activity.id +"\" activityName=\""+ activity.name +"\" name=\"activity\"/></td>";
							htmlStr += "	<td>"+ activity.name +"</td>";
							htmlStr += "	<td>"+ activity.startDate +"</td>";
							htmlStr += "	<td>"+ activity.endDate +"</td>";
							htmlStr += "	<td>"+ activity.owner +"</td>";
							htmlStr += "</tr>";
						});
						$("#activitySourceBody").html(htmlStr);
					}
				})
			});
			//给搜索市场活动模态窗口的单选框添加单击事件
			$("#activitySourceBody").on("click","input[type='radio']",function () {
				//填写参数
				$("#activityId").val(this.value);
				$("#activityName").val($(this).attr("activityName"));
				//关闭模态窗口
				$("#searchActivityModal").modal("hide");
			});
			//给"转换"按键添加单击事件
			$("#convertClueBtn").click(function () {
				//收集参数
				var clueId = "${clue.id}";
				var isCreateTransaction = $("#isCreateTransaction").prop("checked");
				var money = $.trim($("#money").val());
				var name = $.trim($("#name").val());
				var expectedDate = $("#expectedDate").val();
				var stage = $("#stage").val();
				var activityId = $("#activityId").val();
				//表单验证
				var regExp=/^(([1-9]\d*)|0)$/;
				if(money !="" && !regExp.test(money)){
					alert("金额只能为非负整数!");
					return;
				}

				$.ajax({
					url : "workbench/clue/convertClue.do",
					data : {
						clueId : clueId,
						isCreateTransaction : isCreateTransaction,
						money : money,
						name : name,
						expectedDate : expectedDate,
						stage : stage,
						activityId : activityId
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//跳转到线索主页面
							window.location.href = "workbench/clue/index.do";
						} else {
							//提示错误信息
							alert(data.message);
						}
					}
				})
			});
		});
	</script>
</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivity" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activitySourceBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="money">金额</label>
		    <input type="text" class="form-control" id="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="name">交易名称</label>
		    <input type="text" class="form-control" id="name" value="动力节点-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedDate">预计成交日期</label>
		    <input type="text" class="form-control date" id="expectedDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
		    	<c:forEach items="${stageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
			<input type="hidden" id="activityId">
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="queryActivitySource" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="convertClueBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>