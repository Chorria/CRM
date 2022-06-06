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
			//查询线索
			queryClueByConditionForPage(1,10);
			//给"创建"按键添加单击事件
			$("#createClueBtn").click(function () {
				//初始化创建信息
				$("#createClueForm").get(0).reset();
				//弹出模态窗口
				$("#createClueModal").modal("show");
			});
			//给"查询"按键添加单击事件
			$("#queryClueBtn").click(function () {
				//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
				queryClueByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
				//初始化
				$("#queryCustomerForm").get(0).reset();
			});
			//给创建线索中的"保存"按键添加单击事件
			$("#saveCreateClueBtn").click(function () {
				//收集参数
				var owner = $("#create-owner").val();
				var company = $.trim($("#create-company").val());
				var appellation = $("#create-appellation").val();
				var fullname = $.trim($("#create-fullname").val());
				var job = $.trim($("#create-job").val());
				var email = $.trim($("#create-email").val());
				var phone = $.trim($("#create-phone").val());
				var website = $.trim($("#create-website").val());
				var mphone = $.trim($("#create-mphone").val());
				var state = $("#create-state").val();
				var source = $("#create-source").val();
				var description = $.trim($("#create-description").val());
				var contactSummary = $.trim($("#create-contactSummary").val());
				var nextContactTime = $.trim($("#create-nextContactTime").val());
				var address = $.trim($("#create-address").val());
				//表单验证
				if (owner == "") {
					alert("未选择线索的所有者,请选择!");
					return;
				}
				if (company == "") {
					alert("公司名字不能为空,请重新输入!");
					return;
				}
				if (fullname == "") {
					alert("名称不能为空,请重新输入!");
					return;
				}

				var emailExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
				if (email != "" && !emailExp.test(email)) {
					alert("邮箱格式不正确,请重新输入!");
					return;
				}

				var phoneExp = /\d{3}-\d{8}|\d{4}-\d{7}/;
				if (phone != "" && !phoneExp.test(phone)) {
					alert("公司座机的电话格式不正确,请重新输入!");
					return;
				}

				var webSiteExp = /[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/;
			    if (website != "" && !webSiteExp.test(website)) {
					alert("公司网站格式不正确,请重新输入!");
					return;
				}

				var mphoneExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
				if (mphone != "" && !mphoneExp.test(mphone)) {
					alert("手机号码格式不正确,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/clue/saveCreateClue.do",
					data : {
						owner : owner,
						company : company,
						appellation : appellation,
						fullname : fullname,
						job : job,
						email  : email,
						phone : phone,
						website : website,
						mphone : mphone,
						state : state,
						source : source,
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
							$("#createClueModal").modal("hide");
							//刷新线索列表，显示第一页数据，保持每页显示条数不变
							queryClueByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#createClueModal").modal("show");
						}
					}
				});
			});

			//给"全选"复选框添加单击事件
			$("#checkAll").click(function () {
				//如果"全选"按钮是选中状态，则列表中所有checkbox都选中
				$("#tBody input[type='checkbox']").prop("checked",this.checked);
			});

			//若单选没被全部选中,取消"全选"
			$("#tBody").on("click","input[type='checkbox']",function () {
				if ($("#tBody input[type='checkbox']:checked").size() == $("#tBody input[type='checkbox']").size()) {
					$("#checkAll").prop("checked",true);
				} else {
					$("#checkAll").prop("checked",false);
				}
			});

			//给"修改"按键添加单击事件
			$("#editClueBtn").click(function () {
				var checkedBox = $("#tBody input[type='checkbox']:checked");
				//表单验证
				if (checkedBox.size() == 0) {
					alert("请选择所需要修改的线索!");
					return;
				}

				if (checkedBox.size() > 1) {
					alert("每次只能修改一条线索,请重新选择!");
					return;
				}

				var id = checkedBox.val();

				$.ajax({
					url : "workbench/clue/queryClueById.do",
					data : {
						id : id
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						//把线索的信息显示在修改的模态窗口上
						$("#edit-id").val(data.id);
						$("#edit-fullname").val(data.fullname);
						$("#edit-appellation").val(data.appellation);
						$("#edit-owner").val(data.owner);
						$("#edit-company").val(data.company);
						$("#edit-job").val(data.job);
						$("#edit-email").val(data.email);
						$("#edit-phone").val(data.phone);
						$("#edit-website").val(data.website);
						$("#edit-mphone").val(data.mphone);
						$("#edit-state").val(data.state);
						$("#edit-source").val(data.source);
						$("#edit-description").val(data.description);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-address").val(data.address);
						//展示模态窗口
						$("#editClueModal").modal("show");
					}
				});
			});
			//给修改线索模态窗口中的”更新“按键添加单击事件
			$("#saveEditClueBtn").click(function () {
				//收集参数
				var id = $("#edit-id").val();
				var fullname = $.trim($("#edit-fullname").val());
				var appellation = $("#edit-appellation").val();
				var owner = $("#edit-owner").val();
				var company = $("#edit-company").val();
				var job = $.trim($("#edit-job").val());
				var email = $.trim($("#edit-email").val());
				var phone = $.trim($("#edit-phone").val());
				var website = $.trim($("#edit-website").val());
				var mphone = $.trim($("#edit-mphone").val());
				var state = $("#edit-state").val();
				var source = $("#edit-source").val();
				var description = $.trim($("#edit-description").val());
				var contactSummary = $.trim($("#edit-contactSummary").val());
				var nextContactTime = $.trim($("#edit-nextContactTime").val());
				var address = $.trim($("#edit-address").val());
				//表单验证
				if (owner == "") {
					alert("未选择线索的所有者,请选择!");
					return;
				}
				if (company == "") {
					alert("公司名字不能为空,请重新输入!");
					return;
				}
				if (fullname == "") {
					alert("名称不能为空,请重新输入!");
					return;
				}

				var emailExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
				if (email != "" && !emailExp.test(email)) {
					alert("邮箱格式不正确,请重新输入!");
					return;
				}

				var phoneExp = /\d{3}-\d{8}|\d{4}-\d{7}/;
				if (phone != "" && !phoneExp.test(phone)) {
					alert("公司座机的电话格式不正确,请重新输入!");
					return;
				}

				var webSiteExp = /[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/;
				if (website != "" && !webSiteExp.test(website)) {
					alert("公司网站格式不正确,请重新输入!");
					return;
				}

				var mphoneExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
				if (mphone != "" && !mphoneExp.test(mphone)) {
					alert("手机号码格式不正确,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/clue/saveEditClue.do",
					data : {
						id : id,
						fullname : fullname,
						appellation : appellation,
						owner : owner,
						company : company,
						job : job,
						email : email,
						phone : phone,
						website : website,
						mphone : mphone,
						state : state,
						source : source,
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
							$("#editClueModal").modal("hide");
							//刷新线索,保持页号和每页显示条数都不变
							queryClueByConditionForPage($("#pageDiv").bs_pagination("getOption","currentPage"),$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#editClueModal").modal("hide");
						}
					}
				})
			});
			//给"删除"按键添加单击事件
			$("#deleteClueBtn").click(function () {
				var checkedBoxes = $("#tBody input[type='checkbox']:checked");
				//表单验证
				if (checkedBoxes.size() == 0) {
					alert("请选择所需要删除的线索!");
					return;
				}
				if (window.confirm("确认删除吗?")) {
					//收集参数
					var ids = "";
					$.each(checkedBoxes,function () {
						ids += "id=" + this.value + "&";
					});
					ids = ids.substring(0,ids.lastIndexOf("&"));

					$.ajax({
						url : "workbench/clue/deleteClueByIds.do",
						data : ids,
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								//初始化
								$("#checkAll").prop("checked",false);
								//刷新市场活动列表,显示第一页数据,保持每页显示条数不变
								queryClueByConditionForPage(1,$("#pageDiv").bs_pagination("getOption","rowsPerPage"));
							} else {
								//提示错误信息,列表不刷新
								alert(data.message);
							}
					    }
					})
				}
			});
		});

		function queryClueByConditionForPage(pageNo,pageSize){
			//收集参数
			var fullname = $.trim($("#query-fullname").val());
			var company = $.trim($("#query-company").val());
			var phone = $.trim($("#query-phone").val());
			var source = $("#query-source").val();
			var owner = $.trim($("#query-owner").val());
			var mphone = $.trim($("#query-mphone").val());
			var state = $("#query-state").val();

			$.ajax({
				url : "workbench/clue/queryClueByConditionForPage.do",
				data : {
					fullname : fullname,
					company : company,
					phone : phone,
					source : source,
					owner : owner,
					mphone : mphone,
					state : state,
					pageNo : pageNo,
					pageSize : pageSize
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					//显示线索的列表
					//遍历clueList，拼接所有行数据
					var htmlStr = "";
					$.each(data.clueList,function (index,clue) {
						htmlStr += "<tr class=\"active\">";
						htmlStr += "	<td><input type=\"checkbox\" value=\"" + clue.id + "\"/></td>";
						htmlStr += "	<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?id="+ clue.id +"' \">"+clue.fullname+"</a></td>";
						htmlStr += "	<td>" + clue.company + "</td>";
						htmlStr += "	<td>" + clue.phone+ "</td>";
						htmlStr += "	<td>" + clue.mphone + "</td>";
						if (clue.source == null) {
							htmlStr += "	<td> </td>";
						} else {
							htmlStr += "	<td>" + clue.source + "</td>";
						}
						htmlStr += "	<td>" + clue.owner + "</td>";
						if (clue.state == null) {
							htmlStr += "	<td> </td>";
						} else {
							htmlStr += "	<td>" + clue.state + "</td>";
						}
						htmlStr += "</tr>";
					});
					$("#tBody").html(htmlStr);
					//计算总页数
					var totalPages = 1;
					if (data.totalRows % pageSize == 0) {
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

						showGoToPage : true,
						showRowsPerPage : true,
						showRowsInfo : true,

						//用户每次切换页面,都自动触发本函数
						//每次返回切换页号之后的pageNo和pageSize
						onChangePage : function (event,pageObj) {
							//当切换页号时,重新查询市场活动
							queryClueByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
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

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellationList}" var="appellation">
									  <option value="${appellation.id}">${appellation.value}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <c:forEach items="${clueStateList}" var="clueState">
									  <option value="${clueState.id}">${clueState.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
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
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
					<button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
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
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <c:forEach items="${appellationList}" var="appellation">
									  <option value="${appellation.id}">${appellation.value}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
								  <c:forEach items="${clueStateList}" var="clueState">
									  <option value="${clueState.id}">${clueState.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
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
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="query-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="query-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="query-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="query-source">
					  	  <option></option>
					  	  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="query-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="query-state">
					  	<option></option>
					  	<c:forEach items="${clueStateList}" var="clueState">
							<option value="${clueState.id}">${clueState.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryClueBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="pageDiv">

				</div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 60px;">
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