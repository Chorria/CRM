<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/cn.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script type="text/javascript">

		$(function(){
			//给全选框添加单击事件
			$("#checkAll").click(function () {
				$("#transactionBody input[type='checkbox']").prop("checked",this.checked);
			});
			//给单选框添加单击事件
			$("#transactionBody").on("click","input[type='checkbox']",function () {
				if ($("#transactionBody input[type='checkbox']:checked").size() == $("#transactionBody input[type='checkbox']").size()) {
					$("#checkAll").prop("checked",true);
				} else {
					$("#checkAll").prop("checked",false);
				}
			});
			//调用自动补全工具
			$("#query-customerName").typeahead({
				source : function (jquery, process) {
					$.ajax({
						url : "workbench/customer/queryCustomerNameByName.do",
						data : {
							customerName : jquery,
						},
						type : "post",
						dataType : "json",
						success : function (data) {
							process(data)
						}
					})
				}
			});
			//分页查询交易
			queryTransactionByConditionForPage(1,10);
			//给"查询"按键添加单击事件
			$("#queryTransactionBtn").click(function () {
				//分页查询交易
				queryTransactionByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
				//初始化查询表单
				$("#queryTransactionForm").get(0).reset();
			});
			//给"修改"按键添加单击事件
			$("#editTransactionBtn").click(function () {
				//收集参数
				var id = $("#transactionBody input[type='checkbox']:checked").val();

				//表单验证
				if ($("#transactionBody input[type='checkbox']:checked").size() == 0) {
					alert("未选择要修改的交易,请重新选择!");
					return;
				}
				if ($("#transactionBody input[type='checkbox']:checked").size() > 1) {
					alert("每次能且只能修改一条市场活动,请重新选择!");
					return;
				}
				//跳转页面
				window.location.href = "workbench/transaction/edit.do?id=" + id;
			});
			//给"删除"按键添加单击事件
			$("#deleteTransactionBtn").click(function () {
				//表单验证
				if ($("#transactionBody input[type='checkbox']:checked").size() == 0) {
					alert("每次至少得删除一条市场活动,请重新选择!");
					return;
				}
				if (window.confirm("确认删除吗?")) {
					//收集参数
					var ids = "";
					$.each($("#transactionBody input[type='checkbox']:checked"),function () {
						ids += "id=" + this.value + "&";
					});
					ids = ids.substring(0,ids.length - 1);

					$.ajax({
						url : "workbench/transaction/deleteTransactionByIds.do",
						data : ids,
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								//刷新交易列表,显示第一页数据,保持每页显示条数不变
								queryTransactionByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
							} else {
								//提示错误信息
								alert(data.message);
							}
						}
					})
				}
			});
		});
		//分页查询交易
		function queryTransactionByConditionForPage(pageNo,pageSize) {
			//收集参数
			var owner = $.trim($("#query-owner").val());
			var name = $.trim($("#query-name").val());
			var customerName = $.trim($("#query-customerName").val());
			var stage = $("#query-stage").val();
			var type = $("#query-type").val();
			var source = $("#query-source").val();
			var contactsName = $.trim($("#query-contactsName").val());

			$.ajax({
				url : "workbench/transaction/queryTransactionByConditionForPage.do",
				data : {
					owner : owner,
					name : name,
					customerName : customerName,
					stage : stage,
					type : type,
					source : source,
					contactsName : contactsName,
					pageNo : pageNo,
					pageSize : pageSize
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					var htmlStr = "";
					$.each(data.transactionList,function (index, transaction) {
						htmlStr += "<tr class=\"active\" id=\"tr_"+ transaction.id+"\">";
						htmlStr += "	<td><input type=\"checkbox\" value=\""+ transaction.id +"\" /></td>";
						htmlStr += "	<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/transaction/detailTransaction.do?id="+ transaction.id +"';\">"+ transaction.name +"</a></td>";
						htmlStr += "	<td>"+ transaction.customerId +"</td>";
						htmlStr += "	<td>"+ transaction.stage +"</td>";
						htmlStr += "	<td>"+ transaction.type +"</td>";
						htmlStr += "	<td>"+ transaction.owner +"</td>";
						htmlStr += "	<td>"+ transaction.source +"</td>";
						htmlStr += "	<td>"+ transaction.contactsId+"</td>";
						htmlStr += "</tr>";
					});
					$("#transactionBody").html(htmlStr);

					var totalPages = 1;
					if (data.totalRows % pageSize == 0) {
						totalPages = data.totalRows / pageSize;
					} else {
						totalPages = parseInt(data.totalRows / pageSize + 1);
					}
					//调用分页工具
					$("#pageDiv").bs_pagination({
						currentPage : pageNo,

						totalRows : data.totalRows,
						rowsPerPage : pageSize,
						totalPages : totalPages,

						visiblePageLinks : true,

						showRowsInfo : true,
						showGoToPage : true,
						showRowsPerPage : true,

						onChangePage : function (event,pageObj) {
							//当切换页号时,重新查询交易信息
							queryTransactionByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
							//初始化全选框
							$("#checkAll").prop("checked",false);
						}
					})

				}
			})
		}

	</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="queryTransactionForm">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="query-customerName" placeholder="支持自动补全">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="query-stage">
					  	<option></option>
					  	<c:forEach items="${stageList}" var="stage">
							<option value="${stage.id}">${stage.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="query-type">
					  	<option></option>
					  	<c:forEach items="${transactionTypeList}" var="transactionType">
							<option value="${transactionType.id}">${transactionType.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="query-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="query-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryTransactionBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/save.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editTransactionBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteTransactionBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="pageDiv">

				</div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 20px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>