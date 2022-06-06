<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
		+ request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>"/>
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/cn.js"></script>
	<script type="text/javascript">
	
		$(function(){
			
			//定制字段
			$("#definedColumns > li").click(function(e) {
				//防止下拉菜单消失
		        e.stopPropagation();
		    });
            //给全选框添加单击事件
            $("#checkAll").click(function () {
                $("#tBody input[type='checkbox']").prop("checked",this.checked);
            });
            //若单选框没有全部选上，则取消点击全选框
            $("tBody").on("click","input[type='checkbox']",function () {
               var checkBox = $("#tBody input[type='checkbox']");
               var checkedBox = $("#tBody input[type='checkbox']:checked");
               if (checkedBox.size() == checkBox.size()) {
                   $("#checkAll").prop("checked",true);
               } else {
                   $("#checkAll").prop("checked",false);
               }
            });

			//当容器加载完成之后，对容器调用日历工具函数
			$(".date").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				minView : "month",
				initialDate : new Date(),
				autoclose : true,
				todayBtn : true,
				clearBtn : true,
				pickerPosition : "top-right"
			});
			//当客户主页面加载完成之后,显示所有数据的第一页
			queryCustomerByConditionForPage(1,10);
			//给"创建"按键添加单击事件
			$("#createCustomerBtn").click(function () {
				//初始化
				$("#createCustomerForm").get(0).reset();
				//展示模态窗口
				$("#createCustomerModal").modal("show");
			});
			//给创建客户模态窗口中的"保存"按键添加单击事件
			$("#saveCreateCustomerBtn").click(function () {
				//收集参数
				var owner = $("#create-owner").val();
				var name = $.trim($("#create-name").val());
				var website = $.trim($("#create-website").val());
				var phone = $.trim($("#create-phone").val());
				var description = $.trim($("#create-description").val());
				var contactSummary = $.trim($("#create-contactSummary").val());
				var nextContactTime = $("#create-nextContactTime").val();
				var address = $.trim($("#create-address").val());
				//表单验证
				if (owner == "") {
					alert("未选择线索的所有者,请选择!");
					return;
				}

				if (name == "") {
					alert("名称不能为空,请重新输入!");
					return;
				}

				var webSiteExp = /[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/;
				if (website != "" && !webSiteExp.test(website)) {
					alert("公司网站格式不正确,请重新输入!");
					return;
				}

				var phoneExp = /\d{3}-\d{8}|\d{4}-\d{7}/;
				if (phone != "" && !phoneExp.test(phone)) {
					alert("公司座机的电话格式不正确,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/customer/saveCreateCustomer.do",
					data : {
						owner : owner,
						name : name,
						website : website,
						phone : phone,
						description : description,
						contactSummary : contactSummary,
						nextContactTime : nextContactTime,
						address : address
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#createCustomerModal").modal("hide");
							//刷新客户列表
							queryCustomerByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#createCustomerModal").modal("show");
						}
					}
				});
			});
			//给"查询"按键添加单击事件
			$("#queryCustomerBtn").click(function () {
				//条件查询客户
				queryCustomerByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
				//初始化
				$("#queryCustomerForm").get(0).reset();
			});
			//给"修改"按键添加单击事件
			$("#editCustomerBtn").click(function () {
				//表单验证
				if ($("#tBody input[type='checkbox']:checked").size() == 0) {
					alert("请选择所需要修改的线索!");
					return;
				}
				if ($("#tBody input[type='checkbox']:checked").size() > 1) {
					alert("每次只能修改一条线索,请重新选择!");
					return;
				}
				//收集参数
				var id = $("#tBody input[type='checkbox']:checked").val();
				$("#editCustomerModal").modal("show");

				$.ajax({
					url : "workbench/customer/queryCustomerById.do",
					data : {
						id : id
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						//将查询的客户信息显示在修改模态窗口里
						$("#edit-id").val(data.id);
						$("#edit-owner").val(data.owner);
						$("#edit-name").val(data.name);
						$("#edit-website").val(data.website);
						$("#edit-phone").val(data.phone);
						$("#edit-description").val(data.description);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-address").val(data.address);
					}
				});
				//给修改客户模态窗口中的"更新"按键添加单击事件
				$("#saveEditCustomerBtn").click(function () {
					//收集参数
					var id = $("#edit-id").val();
					var owner = $("#edit-owner").val();
					var name = $.trim($("#edit-name").val());
					var website = $.trim($("#edit-website").val());
					var phone = $.trim($("#edit-phone").val());
					var description = $.trim($("#edit-description").val());
					var contactSummary = $.trim($("#edit-contactSummary").val());
					var nextContactTime = $("#edit-nextContactTime").val()
					var address = $.trim($("#edit-address").val());
					//表单验证
					if (owner == "") {
						alert("所有者不能为空,请重新选择!");
						return;
					}

					if (name == "") {
						alert("名称不能为空,请重新输入!");
						return;
					}

					var webSiteExp = /[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/;
					if (website != "" && !webSiteExp.test(website)) {
						alert("公司网站格式不正确,请重新输入!");
						return;
					}

					var phoneExp = /\d{3}-\d{8}|\d{4}-\d{7}/;
					if (phone != "" && !phoneExp.test(phone)) {
						alert("公司座机的电话格式不正确,请重新输入!");
						return;
					}

					$.ajax({
						url : "workbench/customer/saveEditCustomer.do",
						data : {
							id : id,
							owner : owner,
							name : name,
							website : website,
							phone : phone,
							description : description,
							contactSummary : contactSummary,
							nextContactTime : nextContactTime,
							address : address
						},
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								//关闭模态窗口
								$("#editCustomerModal").modal("hide");
								//刷新客户列表,保持页号和每页显示条数都不变
								queryCustomerByConditionForPage($("#pageDiv").bs_pagination("getOption","currentPage"),$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
							} else {
								//提示错误信息
								alert(data.message);
								//不关闭模态窗口
								$("#editCustomerModal").modal("show");
							}
						}
					})
				});
			});
			//给"删除"按键添加单击事件
			$("#deleteCustomerBtn").click(function () {
				var checkedBox = $("#tBody input[type='checkbox']:checked");
				//表单验证
				if (checkedBox.size() == 0) {
					alert("请选择所需要删除的线索!");
					return;
				}

				if (window.confirm("确认删除吗?")) {
					var ids = "";
					$.each(checkedBox,function(){
						ids += "id=" + this.value + "&";
					})
					ids = ids.substring(0,ids.length - 1);

					$.ajax({
						url : "workbench/customer/deleteCustomerByIds.do",
						data : ids,
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								//初始化
								$("#checkAll").prop("checked",false);
								//刷新列表
								queryCustomerByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
							} else {
								//提示错误信息
								alert(data.message);
							}
						}
					});
				}
			});
		});
        function queryCustomerByConditionForPage(pageNo,pageSize) {
            //收集参数
            var name = $.trim($("#query-name").val());
            var owner = $.trim($("#query-owner").val());
            var phone = $.trim($("#query-phone").val());
            var website = $.trim($("#query-website").val());

            $.ajax({
                url : "workbench/customer/queryCustomerByConditionForPage.do",
                data : {
                    name : name,
                    owner : owner,
                    phone : phone,
                    website : website,
					pageNo : pageNo,
					pageSize : pageSize
                },
                type : "post",
                dataType : "json",
                success : function (data) {
					//显示顾客的列表
					//遍历customerList，拼接所有行数据
                    var htmlStr = "";
                    $.each(data.customerList,function (index,customer) {
                        htmlStr += "<tr class=\"active\">";
                        htmlStr += "    <td><input type=\"checkbox\" value=\""+ customer.id +"\" /></td>";
                        htmlStr += "    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/customer/detailCustomer.do?id="+ customer.id +"'\">"+ customer.name +"</a></td>";
                        htmlStr += "    <td>"+ customer.owner +"</td>";
                        htmlStr += "    <td>"+ customer.phone +"</td>";
                        htmlStr += "    <td>"+ customer.website +"</td>";
                        htmlStr += "</tr>";
                    });
					$("#tBody").html(htmlStr);

					var totalPages = 1;
					if (data.totalRows % pageSize == 0 ) {
						totalPages = data.totalRows / pageSize;
					} else {
						totalPages = parseInt(data.totalRows / pageSize + 1);
					}
                    $("#pageDiv").bs_pagination({
                        currentPage : pageNo,

						rowsPerPage : pageSize,
						totalRows : data.totalRows,
						totalPages : totalPages,

						visiblePageLinks : 5,

						showGotoPage : true,
						showRowsPerPage : true,
						showRowsInfo : true,
						//用户每次切换页面,都自动触发本函数
						//每次返回切换页号之后的pageNo和pageSize
						onChangePage : function (event,pageObj) {
							//当切换页号时,重新查询客户信息
							queryCustomerByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
							//初始化全选框
							$("#checkAll").prop("checked",false);
						}
                    });
                }
            });
        };
		
	</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createCustomerForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control date" id="create-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"/>
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control date" id="edit-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditCustomerBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="queryCustomerForm">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="query-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input id="query-website" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryCustomerBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createCustomerBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>
                            <td>zhangsan</td>
                            <td>010-84846003</td>
                            <td>http://www.bjpowernode.com</td>
                        </tr>--%>
					</tbody>
				</table>
                <div id="pageDiv">

                </div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 30px;">
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