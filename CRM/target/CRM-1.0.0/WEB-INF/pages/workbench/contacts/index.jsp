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
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/cn.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	
	<script type="text/javascript">
	
		$(function(){
			
			//定制字段
			$("#definedColumns > li").click(function(e) {
				//防止下拉菜单消失
		        e.stopPropagation();
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
			$(".birthday").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				startView : 4,
				minView : "month",
				autoclose : true,
				todayBtn : true,
				clearBtn : true
			});
			//调用自动全部工具
			$(".typeahead").typeahead({
				//每次键盘弹起，都自动触发本函数；我们可以向后台送请求，查询客户表中所有的名称，把客户名称以[]字符串形式返回前台，赋值给source
				//process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
				//jquery：在容器中输入的关键字
				source : function (jquery,process) {
					$.ajax({
						url : "workbench/customer/queryCustomerNameByName.do",
						data : {
							customerName : jquery
						},
						type : "post",
						dataType : "json",
						success : function (data) {
							//['xxx','xxxxx','xxxxxx',.....]
							process(data);
						}
					})
				}
			});
			//给"查询"按键添加单击事件
			$("#queryContactsBtn").click(function () {
				//分页查询联系人信息
				queryContactsByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
				//初始化查询表单
				$("#queryContactsForm").get(0).reset();
			});
			//分页查询所有的联系人信息
			queryContactsByConditionForPage(1,10);
            //给全选框添加单击事件
            $("#checkAll").click(function () {
               $("#contactsBody input[type='checkbox']").prop("checked",this.checked);
            });
            //给单选框添加单击事件
            $("#contactsBody").on("click","input[type='checkbox']",function () {
               if ($("#contactsBody input[type='checkbox']").size() == $("#contactsBody input[type='checkbox']:checked").size()) {
				   $("#checkAll").prop("checked",true);
			   } else {
				   $("#checkAll").prop("checked",false);
			   }
            });
			//给"创建"按键添加单击事件
			$("#createContactsBtn").click(function () {
				//展示模态窗口
				$("#createContactsModal").modal("show");
			});
			//给创建联系人的模态窗口中的"保存"按键添加单击事件
			$("#saveCreateContactsBtn").click(function () {
				//收集参数
				var owner = $("#create-owner").val();
				var source = $("#create-source").val();
				var customerName = $("#create-customerName").val();
				var fullname = $("#create-fullname").val();
				var appellation = $("#create-appellation").val();
				var email = $("#create-email").val();
				var mphone = $("#create-mphone").val();
				var birthday = $("#create-birthday").val();
				var job = $("#create-job").val();
				var description = $("#create-description").val();
				var contactSummary = $("#create-contactSummary").val();
				var nextContactTime = $("#create-nextContactTime").val();
				var address = $("#create-address").val();
				//表单验证
				if (owner == "") {
					alert("所有者不能为空,请重新选择!");
					return;
				}

				if (fullname == "") {
					alert("姓名不能为空,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/contacts/saveCreateContacts.do",
					data : {
						owner : owner,
						source : source,
						customerName : customerName,
						fullname : fullname,
						appellation : appellation,
						email : email,
						mphone : mphone,
						birthday : birthday,
						job : job,
						description : description,
						contactSummary: contactSummary,
						nextContactTime: nextContactTime,
						address : address
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#createContactsModal").modal("hide");
							//刷新联系人列表
							queryContactsByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#createContactsModal").modal("show");
						}
					}
				})
			});
			//给"修改"按键添加单击事件
			$("#editContactsBtn").click(function () {
				//收集参数
				var id = $("#contactsBody input[type='checkbox']:checked").val();
				//表单验证
				if ($("#contactsBody input[type='checkbox']:checked").size() == 0) {
					alert("修改的线索未选择,请重新选择!");
					return;
				}
				if ($("#contactsBody input[type='checkbox']:checked").size() > 1) {
					alert("每次能且只能修改一条市场活动,请重新选择!");
					return;
				}

				$.ajax({
					url : "workbench/contacts/queryContactsById.do",
					data : {
						id : id
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						//填写参数
						$("#edit-id").val(data.id);
						$("#edit-owner").val(data.owner);
						$("#edit-source").val(data.source);
						$("#edit-customerName").val(data.customerId);
						$("#edit-fullname").val(data.fullname);
						$("#edit-appellation").val(data.appellation);
						$("#edit-email").val(data.email);
						$("#edit-mphone").val(data.mphone);
						$("#edit-birthday").val(data.birthday);
						$("#edit-job").val(data.job);
						$("#edit-description").val(data.description);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-address").val(data.address);
						//打开模态窗口
						$("#editContactsModal").modal("show");
					}
				});
			});
			//给修改模态窗口中的"更新"按键添加单击事件
			$("#saveEditContactsBtn").click(function () {
				//收集参数
				var id = $("#edit-id").val();
				var owner = $("#edit-owner").val();
				var source = $("#edit-source").val();
				var customerName = $("#edit-customerName").val();
				var fullname = $("#edit-fullname").val();
				var appellation = $("#edit-appellation").val();
				var email = $("#edit-email").val();
				var mphone = $("#edit-mphone").val();
				var birthday = $("#edit-birthday").val();
				var job = $("#edit-job").val();
				var description = $("#edit-description").val();
				var contactSummary = $("#edit-contactSummary").val();
				var nextContactTime = $("#edit-nextContactTime").val();
				var address = $("#edit-address").val();
				//表单验证
				if (owner == "") {
					alert("所有者不能为空,请重新选择!");
					return;
				}

				if (fullname == "") {
					alert("姓名不能为空,请重新输入!");
					return;
				}

				var emailExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
				if (email != "" && !emailExp.test(email)) {
					alert("邮箱格式不正确,请重新输入!");
					return;
				}

				var mphoneExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
				if (mphone != "" && !mphoneExp.test(mphone)) {
					alert("手机号码格式不正确,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/contacts/saveEditContacts.do",
					data : {
						id : id,
						owner : owner,
						source : source,
						customerName : customerName,
						fullname : fullname,
						appellation : appellation,
						email : email,
						mphone : mphone,
						birthday : birthday,
						job : job,
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
							$("#editContactsModal").modal("hide");
							//刷新联系人列表,保持页号和每页显示条数都不变
							queryContactsByConditionForPage($("#pageDiv").bs_pagination("getOption","currentPage"),$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#editContactsModal").modal("show");
						}
					}
				})
			});
			//给"删除"按键添加单击事件
			$("#deleteContactsBtn").click(function () {
				var checkedBoxes = $("#contactsBody input[type='checkbox']:checked");
				//表单验证
				if (checkedBoxes.size() == 0) {
					alert("每次至少得删除一条市场活动,请重新选择!");
					return;
				}
				if (window.confirm("确认删除吗?")) {
					//收集参数
					var ids = "";
					$.each(checkedBoxes,function () {
						ids += "id=" + this.value + "&";
					});
					ids = ids.substring(0,ids.length - 1);

					$.ajax({
						url : "workbench/contacts/deleteContactsByIds.do",
						data : ids,
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								//刷新联系人列表,显示第一页数据,保持每页显示条数不变
								queryContactsByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
							} else {
								//提示错误信息
								alert(data.message);
							}
						}
					})
				}
			});
			
		});

		//分页查询联系人函数
		function queryContactsByConditionForPage(pageNo,pageSize) {
			//收集参数
			var owner = $("#query-owner").val();
			var fullname = $("#query-fullname").val();
			var customerName = $("#query-customerName").val();
			var source = $("#query-source").val();
			var birthday = $("#query-birthday").val();

			$.ajax({
				url : "workbench/contacts/queryContactsByConditionForPage.do",
				data : {
					owner : owner,
					fullname : fullname,
					customerName : customerName,
					source : source,
					birthday : birthday,
					pageNo : pageNo,
					pageSize : pageSize
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					var htmlStr = "";
					$.each(data.contactsList,function (index,contacts) {
						htmlStr += "<tr>";
						htmlStr += "	<td><input type=\"checkbox\" value=\""+ contacts.id +"\" /></td>";
						htmlStr += "	<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/contacts/detailContacts.do?id="+ contacts.id +"';\">"+ contacts.fullname +"</a></td>";
						htmlStr += "	<td>"+ contacts.customerId +"</td>";
						htmlStr += "	<td>"+ contacts.owner +"</td>";
						htmlStr += "	<td>"+ contacts.source +"</td>";
						htmlStr += "	<td>"+ contacts.birthday +"</td>";
						htmlStr += "</tr>";
					});
					$("#contactsBody").html(htmlStr);

					var totalPages = 1;
					if (data.totalRows % pageSize == 0) {
						totalPages = data.totalPages / pageSize;
					} else {
						totalPages = parseInt(data.totalPages / pageSize + 1);
					}
					$("#pageDiv").bs_pagination({
						currentPage : pageNo,

						rowsPerPage : pageSize,
						totalRows : data.totalRows,
						totalPages : totalPages,

						showGoToPage : true,
						showRowsInfo : true,
						showRowsPerPage : true,

						onChangePage : function (event,pageObj) {
							//当切换页号时,重新查询市场活动
							queryContactsByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
							//初始化全选框
							$("#checkAll").prop("checked",false);
						}
					});
				}
			})
		};
		
	</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${sourceList}" var="source">
									  <option value="${source.id}">${source.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellationList}" var="appellation">
									  <option value="${appellation.id}">${appellation.value}</option>
								  </c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birthday" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control birthday" id="create-birthday" readonly>
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control typeahead" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
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
					<button type="button" class="btn btn-primary" id="saveCreateContactsBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<!-- 修改的联系人的id -->
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
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birthday" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control birthday" id="edit-birthday" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control typeahead" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
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
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditContactsBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="queryContactsForm">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="query-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control typeahead" type="text" placeholder="支持自动补全" id="query-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
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
				      <div class="input-group-addon">生日</div>
				      <input class="form-control birthday" type="text" id="query-birthday" readonly>
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryContactsBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createContactsBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editContactsBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteContactsBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四</a></td>
                            <td>动力节点</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>2000-10-10</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="pageDiv">

				</div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 10px;">
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