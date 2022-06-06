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
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">
		$(function () {
			//对"预计成交日期"容器调用日历工具
			$(".expectedDate").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				minView : "month",
				initialDate : new Date(),
				autoclose : true,
				todayBtn : true,
				clearBtn : true
			});
			//给"下次联系事件"容器调用日历工具
			$(".nextContactTime").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				minView : "month",
				initialDate : new Date(),
				autoclose : true,
				todayBtn : true,
				clearBtn : true,
				pickerPosition : "top-right"
			});
			//调用自动补全工具
			$("#create-customerName").typeahead({
				source : function (jquery,process) {
					$.ajax({
						url : "workbench/customer/queryCustomerNameByName.do",
						data : {
							customerName : jquery
						},
						type : "post",
						dataType : "json",
						success : function (data) {
							process(data)
						}
					})
				}
			});
			//配置交易的可能性
			$("#create-stage").change(function () {
				//收集参数
				var stage = $("#create-stage").find("option:checked").text();
				//表单验证
				if (stage == "") {
					//清空可能性输入框
					$("#create-possibility").val("");
					alert("交易阶段不能为空,请重新选择!");
					return;
				}

				$.ajax({
					url : "workbench/transaction/getPossibilityByStage.do",
					data : {
						stage : stage
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						//填写可能性参数
						$("#create-possibility").val(data);
					}
				})
			});
			if ("${customer}" != null) {
				//自动补全客户名称
				$("#create-customerName").val("${customer.name}");
				//半补全<名称框>
				$("#create-name").val("${customer.name}-");

			};
			if ("${contacts}" != null) {
				//自动补全客户名称
				$("#create-customerName").val("${customerName}");
				//半补全<名称框>
				$("#create-name").val("${customerName}-");
				//记录联系人名称在联系人名称框
				$("#create-contactsName").val("${contacts.fullname}");
				$("#contacts-id").val("${contacts.id}");
			}
			//给市场活动源的搜索按键添加单击事件
			$("#activityId").click(function () {
				//打开模态窗口
				$("#findMarketActivity").modal("show");
			});
			//给市场活动源模糊查询添加键盘弹起事件
			$("#activityName").keyup(function () {
				//收集参数
				var activityName = $("#activityName").val();

				$.ajax({
					url : "workbench/transaction/queryActivityByName.do",
					data : {
						activityName : activityName
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						var htmlStr = "";
						$.each(data,function (index,activity) {
							htmlStr += "<tr>";
							htmlStr += "	<td><input value=\""+ activity.id +"\" type=\"radio\" name=\""+ activity.name +"\"/></td>";
							htmlStr += "	<td>"+ activity.name +"</td>";
							htmlStr += "	<td>"+ activity.startDate +"</td>";
							htmlStr += "	<td>"+ activity.endDate +"</td>";
							htmlStr += "	<td>"+ activity.owner +"</td>";
							htmlStr += "</tr>";
						});
						$("#activityBody").html(htmlStr);
					}
				})
			});
			//将市场活动源的选择结果记录在市场活动源框中
			$("#activityBody").on("click","input[type='radio']",function () {
				//记录市场活动名字在市场活动源框
				$("#create-activityId").val($(this).prop("name"));
				$("#activity-id").val(this.value);
				//关闭模态窗口
				$("#findMarketActivity").modal("hide");
			});
			//给联系人名称的搜索按键添加单击事件
			$("#contactsId").click(function () {
				//开展模态窗口
				$("#findContacts").modal("show");
			});
			//给联系人名称模糊查询添加键盘弹起事件
			$("#contactsName").keyup(function () {
				//收集参数
				var contactsName = $("#contactsName").val();

				$.ajax({
					url : "workbench/transaction/queryContactsByName.do",
					data : {
						contactsName : contactsName
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						var htmlStr = "";
						$.each(data,function (index,contacts) {
							htmlStr += "<tr>";
							htmlStr += "	<td><input value=\""+ contacts.id +"\" type=\"radio\" name=\""+ contacts.fullname +"\"/></td>";
							htmlStr += "	<td>"+ contacts.fullname +"</td>";
							htmlStr += "	<td>"+ contacts.email +"</td>";
							htmlStr += "	<td>"+ contacts.mphone +"</td>";
							htmlStr += "</tr>";
						})
						$("#contactsBody").html(htmlStr);
					}
				})
			});
			//将联系人名称查询结果记录在联系人名称框中
			$("#contactsBody").on("click","input[type='radio']",function () {
				//记录联系人名称在联系人名称框
				$("#create-contactsName").val($(this).prop("name"));
				$("#contacts-id").val(this.value);
				//关闭模态窗口
				$("#findContacts").modal("hide");
			});
			//给"保存"按键添加单击事件
			$("#saveCreateTransactionBtn").click(function () {
				//收集参数
				var owner = $("#create-owner").val();
				var money = $.trim($("#create-money").val());
				var name = $.trim($("#create-name").val());
				var expectedDate = $("#create-expectedDate").val();
				var customerName = $("#create-customerName").val();
				var stage = $("#create-stage").val();
				var type = $("#create-type").val();
				var possibility = $.trim($("#create-possibility").val());
				var source = $("#create-source").val();
				var activityId = $("#activity-id").val();
				var contactsId = $("#contacts-id").val();
				var description = $.trim($("#create-description").val());
				var contactSummary = $.trim($("#create-contactSummary").val());
				var nextContactTime = $("#create-nextContactTime").val();
				//表单验证
				if (owner == "") {
					alert("所有者不能为空,请重新选择!");
					return;
				}

				var regExp=/^(([1-9]\d*)|0)$/;
				if(money !="" && !regExp.test(money)){
					alert("成本只能为非负整数!");
					return;
				}

				if (name == "") {
					alert("名称不能为空,请重新输入!");
					return;
				}

				if (expectedDate == "") {
					alert("预计成交日期不能为空,请重新输入!");
					return;
				}

				if (customerName == "") {
					alert("客户名称不能为空,请重新输入!");
					return;
				}

				if (stage == "") {
					alert("阶段不能为空,请重新选择!");
					return;
				}

				$.ajax({
					url : "workbench/transaction/saveCreateTransaction.do",
					data : {
						owner : owner,
						money : money,
						name : name,
						expectedDate : expectedDate,
						customerName : customerName,
						stage : stage,
						type : type,
						possibility : possibility,
						source : source,
						activityId : activityId,
						contactsId : contactsId,
						description : description,
						contactSummary : contactSummary,
						nextContactTime : nextContactTime
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//跳转到交易主页面
							window.location.href = "workbench/transaction/index.do";
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

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="activityName" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityBody">
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

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="contactsName" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveCreateTransactionBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">
					<c:forEach items="${userList}" var="user">
						<option value="${user.id}">${user.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control expectedDate" id="create-expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-type">
				  <option></option>
				  <c:forEach items="${transactionTypeList}" var="transactionType">
					  <option value="${transactionType.id}">${transactionType.value}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source">
				  <option></option>
				  <c:forEach items="${sourceList}" var="source">
					  <option value="${source.id}">${source.value}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-activityId" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="activityId"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<%-- 市场活动源的id --%>
				<input type="hidden" id="activity-id">
				<input type="text" class="form-control" id="create-activityId" placeholder="点击左侧放大镜进行搜索" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="contactsId"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<%-- 联系人名称的id --%>
				<input type="hidden" id="contacts-id">
				<input type="text" class="form-control" id="create-contactsName" placeholder="点击左侧放大镜进行搜索" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control nextContactTime" id="create-nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>