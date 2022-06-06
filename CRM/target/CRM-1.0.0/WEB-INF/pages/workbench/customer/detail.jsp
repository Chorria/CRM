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
	<link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	
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

			$(".birthday").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				startView : 4,
				minView : "month",
				autoclose : true,
				todayBtn : true,
				clearBtn : true
			});


			//给客户备注模态窗口的"保存"按键添加单击事件
			$("#saveCreateCustomerRemarkBtn").click(function () {
				//收集参数
				var customerId = "${customer.id}";
				var noteContent = $("#remark").val();
				//表单验证
				if (noteContent == "") {
					alert("备注内容不能为空,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/customer/saveCreateCustomerRemark.do",
					data : {
						customerId : customerId,
						noteContent : noteContent
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							alert(data.retData.id);
							//清空输入框
							$("#remark").val("");
							var htmlStr = "";
							htmlStr += "<div id=\"div_"+ data.retData.id +"\" class=\"remarkDiv\" style=\"height: 60px;\">";
							htmlStr += "	<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							htmlStr += "		<div style=\"position: relative; top: -40px; left: 40px;\" >";
							htmlStr += "			<h5 id=\"h5_"+ data.retData.id +"\">"+ data.retData.noteContent +"</h5>";
							htmlStr += "			<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>${customer.name}</b> <small style=\"color: gray;\" id=\"small_"+ data.retData.id +"\"> "+ data.retData.createTime +" 由${sessionScope.sessionUser.name}创建</small>";
							htmlStr += "			<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							htmlStr += "				<a class=\"myHref\" name=\"editA\" remarkId=\""+ data.retData.id +"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr += "				&nbsp;&nbsp;&nbsp;&nbsp;";
							htmlStr += "				<a class=\"myHref\" name=\"removeA\"remarkId=\""+ data.retData.id +"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr += "			</div>";
							htmlStr += "		</div>";
							htmlStr += "</div>";
							$("#remarkDiv").before(htmlStr);
						} else {
							//提示错误信息
							alert(data.message);
						}
					}
				})
			});
            //给客户备注中的"修改"按键添加单击事件
            $("#remarkDivList").on("click","a[name='editA']",function () {
                //收集参数
				var id = $(this).attr("remarkId");
				var noteContent = $("#h5_" + id).text();
                //填写参数到客户备注的模态窗口
                $("#edit-remarkId").val(id);
                $("#edit-noteContent").val(noteContent);
                //展开模态窗口
                $("#editRemarkModal").modal("show");
            });
			//给客户备注模态窗口中的"更新"按键添加单击事件
			$("#updateRemarkBtn").click(function () {
				//收集参数
				var id = $("#edit-remarkId").val();
				var noteContent = $("#edit-noteContent").val();
				//表单验证
				if (noteContent == "") {
					alert("备注内容不能为空,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/customer/saveEditCustomerRemark.do",
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
							$("#small_" + id).text(data.retData.editTime + " 由${sessionScope.sessionUser.name}修改");
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#editRemarkModal").modal("show");
						}
					}
				})
			});
            //给客户备注中的"删除"按键添加单击事件
            $("#remarkDivList").on("click","a[name='removeA']",function () {
                //收集参数
                var id = $(this).attr("remarkId");

				$.ajax({
					url : "workbench/customer/deleteCustomerRemarkById.do",
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
            });
			//给"新建联系人"按键添加单击事件
			$("#createContactsBtn").click(function () {
				$("#create-customerName").val("${customer.name}");
				//开展模态窗口
				$("#createContactsModal").modal("show");
			});
			//给创建联系人的模态窗口中的"保存"按键添加单击事件
			$("#saveCreateContactsBtn").click(function () {
				//收集参数
				var owner = $("#create-owner").val();
				var source = $("#create-source").val();
				var fullname = $.trim($("#create-fullname").val());
				var appellation = $("#create-appellation").val();
				var job = $.trim($("#create-job").val());
				var mphone = $.trim($("#create-mphone").val());
				var email = $.trim($("#create-email").val());
				var birthday = $.trim($("#create-birthday").val());
				var customerId = "${customer.id}";
				var description = $.trim($("#create-description").val());
				var contactSummary = $.trim($("#create-contactSummary").val());
				var nextContactTime = $("#create-nextContactTime").val();
				var address = $.trim($("#create-address").val());
				//表演验证
				if (owner == "") {
					alert("所有者不能为空,请重新选择!");
					return;
				}

				if (fullname == "") {
					alert("姓名不能为空,请重新输入");
					return;
				}

				var mphoneExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
				if (mphone != "" && !mphoneExp.test(mphone)) {
					alert("手机号码格式不正确,请重新输入!");
					return;
				}

				var emailExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
				if (email != "" && !emailExp.test(email)) {
					alert("邮箱格式不正确,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/customer/saveCreateContactsForDetail.do",
					data : {
						owner : owner,
						source : source,
						fullname : fullname,
						appellation : appellation,
						job : job,
						mphone : mphone,
						email : email,
						birthday : birthday,
						customerId : customerId,
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
							$("#createContactsModal").modal("hide");
							//刷新联系人列表
							var htmlStr = "";
							htmlStr += "<tr id=\"tr_"+ data.retData.id +"\">";
							htmlStr += "	<td><a href=\"workbench/contacts/detailContacts.do?id="+ data.retData.id +"\" style=\"text-decoration: none;\">"+ data.retData.fullname +"</a></td>";
							htmlStr += "	<td>"+ data.retData.email +"</td>";
							htmlStr += "	<td>"+ data.retData.mphone +"</td>";
							htmlStr += "	<td><a href=\"javascript:void(0);\" contactsId=\""+ data.retData.id +"\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>删除</a></td>";
							htmlStr += "</tr>";
							$("#contactsBody").append(htmlStr);
							//初始化
							$("#createCustomerForm")[0].reset();
						} else {
							//提示错误信息
							alert(data.message);
							//模态窗口不关闭
							$("#createContactsModal").modal("show");
						}
					}
				})
			});
			//给联系人的"删除"按键添加单击事件
			$("#contactsBody").on("click","a",function () {
				$("#contacts-id").val($(this).attr("contactsId"));
				//打开模态窗口
				$("#removeContactsModal").modal("show");
			});
			//给删除联系人的模态窗口的"删除"按键添加单击事件
			$("#deleteContactsBtn").click(function () {
				//收集参数
				var id = $("#contacts-id").val();

				$.ajax({
					url : "workbench/customer/deleteContactsForDetail.do",
					data : {
						id : id
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#removeContactsModal").modal("hide");
							//刷新列表
							$("#contactsTr_" + id).remove();
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#removeContactsModal").modal("show");
						}
					}
				})
			});
			//给交易的"删除"按键添加单击事件
			$("#transacationBody").on("click","a",function () {
				$("#transaction-id").val($(this).attr("transactionId"));
				//打开模态窗口
				$("#removeTransactionModal").modal("show");
			});
			//给删除交易模态窗口的"删除"按键添加单击事件
			$("#deleteTransactionBtn").click(function () {
				//收集参数
				var id = $("#transaction-id").val();

				$.ajax({
					url : "workbench/customer/deleteTransactionById.do",
					data : {
						id : id
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#removeTransactionModal").modal("hide");
							//刷新列表
							$("#transactionTr_" + id).remove();
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#removeTransactionModal").modal("show");
						}
					}
 				})
			});
			//给客户明细的"编辑"按键添加单击事件
			$("#editCustomerBtn").click(function () {
				//收集参数
				var customerOwner = "${customer.owner}";
				var customerOwnerId = "";
				<c:forEach items="${userList}" var="user">
					var userName = "${user.name}";
					if (customerOwner == userName) {
						customerOwnerId = "${user.id}";
					}
				</c:forEach>
				//填写客户数据
				$("#edit-id").val("${customer.id}");
				$("#edit-owner").val(customerOwnerId);
				$("#edit-name").val("${customer.name}");
				$("#edit-website").val("${customer.website}");
				$("#edit-phone").val("${customer.phone}");
				$("#edit-description").val("${customer.description}");
				$("#edit-contactSummary").val("${customer.contactSummary}");
				$("#edit-nextContactTime").val("${customer.nextContactTime}");
				$("#edit-address").val("${customer.address}");
				//打开模态窗口
				$("#editCustomerModal").modal("show");
			});
			//给修改客户的模态窗口里的"更新"按键添加单击事件
			$("#saveEditCustomerBtn").click(function () {
				//收集参数
				var id = $("#edit-id").val();
				var owner = $.trim($("#edit-owner").val());
				var name = $.trim($("#edit-name").val());
				var website = $.trim($("#edit-website").val());
				var phone = $.trim($("#edit-phone").val());
				var description = $.trim($("#edit-description").val());
				var contactSummary = $.trim($("#edit-contactSummary").val());
				var nextContactTime = $("#edit-nextContactTime").val();
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
							//跳转页面
							/*window.location.href = "workbench/customer/queryCustomerForDetailById.do?id=" + id;*/
							window.location.reload();
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#editCustomerModal").modal("show");
						}

					}
				})
			});
			//给客户明细的"删除"添加单击事件
			$("#deleteCustomerBtn").click(function () {
				//收集参数
				var id = "${customer.id}";

				if (window.confirm("确认删除吗?")) {
					$.ajax({
						url : "workbench/customer/deleteCustomerByIds.do",
						data : {
							id : id
						},
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								//跳转页面
								window.location.href = "workbench/customer/index.do";
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
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改客户</h4>
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
    <!-- 修改客户备注的模态窗口 -->
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
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<input type="hidden" id="contacts-id"/>
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该联系人吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="deleteContactsBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
    <div class="modal fade" id="removeTransactionModal" role="dialog">
		<input type="hidden" id="transaction-id"/>
        <div class="modal-dialog" role="document" style="width: 30%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title">删除交易</h4>
                </div>
                <div class="modal-body">
                    <p>您确定要删除该交易吗？</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-danger" id="deleteTransactionBtn">删除</button>
                </div>
            </div>
        </div>
    </div>
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel3">创建联系人</h4>
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
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
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
	
	

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${customer.name} <small><a href="${customer.website}" target="_blank">${customer.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 10px; left: 40px;" id="remarkDivList">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${customerRemarkList}" var="customerRemark">
			<div id="div_${customerRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${customerRemark}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="h5_${customerRemark.id}">${customerRemark.noteContent}</h5>
					<font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;" id="small_${customerRemark.id}"> ${customerRemark.editFlag == "0" ? customerRemark.createTime : customerRemark.editTime} 由${customerRemark.editFlag == "0" ? customerRemark.createBy : customerRemark.editBy}${customerRemark.editFlag == "0" ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editA" remarkId="${customerRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="removeA" remarkId="${customerRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">客户</font> <font color="gray">-</font> <b>北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">客户</font> <font color="gray">-</font> <b>北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button type="button" class="btn btn-primary" id="saveCreateCustomerRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="transacationBody">
						<%--<tr>
							<td><a href="../transaction/detail.html" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeTransactionModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
						<c:forEach items="${transactionList}" var="transaction">
							<tr id="transactionTr_${transaction.id}">
								<td><a href="workbench/transaction/detailTransaction.do?id=${transaction.id}" style="text-decoration: none;">${transaction.name}</a></td>
								<td>${transaction.money}</td>
								<td>${transaction.stage}</td>
								<td>${transaction.possibility}</td>
								<td>${transaction.expectedDate}</td>
								<td>${transaction.type}</td>
								<td><a href="javascript:void(0);" transactionId="${transaction.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/customer/createTransaction.do?id=${customer.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactsBody">
						<%--<tr>
							<td><a href="../contacts/detail.html" style="text-decoration: none;">李四</a></td>
							<td>lisi@bjpowernode.com</td>
							<td>13543645364</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
						<c:forEach items="${contactsList}" var="contacts">
							<tr id="contactsTr_${contacts.id}">
								<td><a href="workbench/contacts/detailContacts.do?id=${contacts.id}" style="text-decoration: none;">${contacts.fullname}</a></td>
								<td>${contacts.email}</td>
								<td>${contacts.mphone}</td>
								<td><a href="javascript:void(0);" contactsId="${contacts.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="createContactsBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>