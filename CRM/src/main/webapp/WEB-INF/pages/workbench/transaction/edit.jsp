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
			//填写参数
			$("#edit-id").val("${transaction.id}");
			$("#edit-owner").val("${transaction.owner}");
			$("#edit-money").val("${transaction.money}");
			$("#edit-name").val("${transaction.name}");
			$("#edit-expectedDate").val("${transaction.expectedDate}");
			$("#edit-customerName").val("${transaction.customerId}");
			$("#edit-stage").val("${transaction.stage}");
			$("#edit-type").val("${transaction.type}");
			$("#edit-possibility").val("${transaction.possibility}");
			$("#edit-source").val("${transaction.source}");
			//填写隐藏参数contactsId
			$("#edit-contactsId").val("${transaction.contactsId}");
			$("#edit-contactsName").val("${transaction.contactsName}");
			//填写隐藏参数contactsId
			$("#edit-activityId").val("${transaction.activityId}");
			$("#edit-activityName").val("${transaction.activityName}");
			$("#edit-description").val("${transaction.description}");
			$("#edit-contactSummary").val("${transaction.contactSummary}");
			$("#edit-nextContactTime").val("${transaction.nextContactTime}");
			//调用自动补全工具
			$("#edit-customerName").typeahead({
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
			//调用日历工具
			$(".date").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				initialDate : new Date(),
				minView : "month",
				autoclose : true,
				todayBtn : true,
				clearBtn : true,
				pickerPosition : "top-right"
			});
			$(".expectedDate").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				initialDate : new Date(),
				minView : "month",
				autoclose : true,
				todayBtn : true,
				clearBtn : true
			});
			//配置可能性
			$("#edit-stage").change(function () {
				//收集参数
				var stage = $("#edit-stage").find("option:selected").text();
				//表单验证
				if (stage == "") {
					//初始化
					$("#edit-possibility").val("");
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
						//配置可能性
						$("#edit-possibility").val(data);
					}
				})
			})
			//给市场活动源的搜索图标添加单击事件
			$("#queryActivitySourceBtn").click(function () {
				//打开模态窗口
				$("#findMarketActivity").modal("show");
			});
			//给查找市场活动窗口添加键盘弹起事件
			$("#query-activityName").keyup(function () {
				//收集参数
				var activityName = $("#query-activityName").val();

				$.ajax({
					url : "workbench/transaction/queryActivityByName.do",
					data : {
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
			//给查找市场活动的radio框添加添加事件
			$("#activitySourceBody").on("click","input[type='radio']",function () {
				//收集参数
				var activityId = this.value;
				var activityName = $(this).attr("activityName");
				//填写参数
				$("#edit-activityId").val(activityId);
				$("#edit-activityName").val(activityName);
				//关闭模态窗口
				$("#findMarketActivity").modal("hide");
			});
			//给联系人名称的搜索图标添加单击事件
			$("#queryContactsNameBtn").click(function () {
				//打开模态窗口
				$("#findContacts").modal("show");
			});
			//给给查找联系人窗口添加键盘弹起事件
			$("#query-contactsName").keyup(function () {
				//收集参数
				var contactsName = $("#query-contactsName").val();

				$.ajax({
					url : "workbench/transaction/queryContactsByName.do",
					data : {
						contactsName : contactsName
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						var htmlStr = "";
						$.each(data,function (index, contacts) {
							htmlStr += "<tr>";
							htmlStr += "	<td><input type=\"radio\" value=\""+ contacts.id +"\" contactsName=\""+ contacts.fullname +"\" name=\"activity\"/></td>";
							htmlStr += "	<td>"+ contacts.fullname +"</td>";
							htmlStr += "	<td>"+ contacts.email +"</td>";
							htmlStr += "	<td>"+ contacts.mphone+"</td>";
							htmlStr += "</tr>";
						});
						$("#contactsNameBody").html(htmlStr);
					}
				})
			});
			//给查找联系人窗口的radio框添加单击事件
			$("#contactsNameBody").on("click","input[type='radio']",function () {
				//获取参数
				var contactsId = this.value;
				var contactsName = $(this).attr("contactsName");
				//填写参数
				$("#edit-contactsId").val(contactsId);
				$("#edit-contactsName").val(contactsName);
				//关闭模态窗口
				$("#findContacts").modal("hide");
			});
			//给"保存"按键添加单击事件
			$("#saveEditTransactionBtn").click(function () {
				//收集参数
				var id = $.trim($("#edit-id").val());
				var owner = $("#edit-owner").val();
				var money = $.trim($("#edit-money").val());
				var name = $.trim($("#edit-name").val());
				var expectedDate = $("#edit-expectedDate").val();
				var customerName = $.trim($("#edit-customerName").val());
				var stage = $("#edit-stage").val();
				var type = $("#edit-type").val();
				var source = $("#edit-source").val();
				var contactsId = $("#edit-contactsId").val();
				var activityId = $("#edit-activityId").val();
				var description = $.trim($("#edit-description").val());
				var contactSummary = $.trim($("#edit-contactSummary").val());
				var nextContactTime = $.trim($("#edit-nextContactTime").val());
				//表单验证
				if (owner == "") {
					alert("所有者不能为空,请重新选择!");
					return;
				}

				var regExp=/^(([1-9]\d*)|0)$/;
				if(money !="" && !regExp.test(money)){
					alert("金额只能为非负整数,请重新输入!");
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
					url : "workbench/transaction/saveEditTransaction.do",
					data : {
						id : id,
						owner : owner,
						money : money,
						name : name,
						expectedDate : expectedDate,
						customerName : customerName,
						stage : stage,
						type : type,
						source : source,
						contactsId : contactsId,
						activityId : activityId,
						description : description,
						contactSummary : contactSummary,
						nextContactTime : nextContactTime
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//跳转交易主页页面
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
						    <input type="text" class="form-control" style="width: 300px;" id="query-activityName" placeholder="请输入市场活动名称，支持模糊查询">
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
						    <input type="text" class="form-control" style="width: 300px;" id="query-contactsName" placeholder="请输入联系人名称，支持模糊查询">
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
						<tbody id="contactsNameBody">
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
		<h3>修改交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveEditTransactionBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<input type="hidden" id="edit-id">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner">
				  <c:forEach items="${userList}" var="user">
					  <option value="${user.id}">${user.name}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name">
			</div>
			<label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control expectedDate" id="edit-expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type">
				  <option></option>
				  <c:forEach items="${transactionTypeList}" var="transactionType">
					  <option value="${transactionType.id}">${transactionType.value}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source">
				  <option></option>
				  <c:forEach items="${sourceList}" var="source">
					  <option value="${source.id}">${source.value}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="queryActivitySourceBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-activityId">
				<input type="text" class="form-control" id="edit-activityName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="queryContactsNameBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-contactsId">
				<input type="text" class="form-control" id="edit-contactsName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control date" id="edit-nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>