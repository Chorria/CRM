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
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
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

			//调用日历工具
			$(".date").datetimepicker({
				language : "zh-CN",
				initialDate : new Date(),
				format : "yyyy-mm-dd",
				miniView : "month",
				todayBtn : true,
				autoclose : true,
				clearBtn : true,
				pickerPosition : "top-right"
			});
			$(".birthday").datetimepicker({
				language : "zh-CN",
				format : "yyyy-mm-dd",
				startView : 4,
				autoclose : true,
				clearBtn : true
			});
			//调用自动补全工具
			$("#edit-customerName").typeahead({
				source : function (jquery,process) {
					$.ajax({
						url : "workbench/customer/queryCustomerNameByName.do",
						data : jquery,
						type : "post",
						dataType : "json",
						success : function (data) {
							process(data);
						}
					})
				}
			});
			//给"编辑"按键添加单击事件
			$("#editContactsBtn").click(function () {
				//收集参数
				var id = "${contacts.id}";

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
							//重刷页面
							window.location.reload();
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
				if (window.confirm("确认删除吗?")) {
					//收集参数
					var id = "${contacts.id}";

					$.ajax({
						url : "workbench/contacts/deleteContactsByIds.do",
						data : {
							id : id
						},
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								window.location.href = "workbench/contacts/index.do";
							} else {
								//提示错误信息
								alert(data.message);
							}
						}
					})
				}
			});
			//给联系人备注窗口的"保存"按键添加单击事件
			$("#saveCreateContactsRemarkBtn").click(function () {
				//收集参数
				var contactsId = "${contacts.id}";
				var noteContent = $("#remark").val();
				//表单验证
				if (noteContent == "") {
					alert("备注内容不能为空,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/contacts/saveCreateContactsRemark.do",
					data : {
						contactsId : contactsId,
						noteContent : noteContent
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//清空联系人备注框
							$("#remark").val("");
							//刷新备注列表
							var htmlStr = "";
							htmlStr += "<div class=\"remarkDiv\" id=\"div_"+ data.retData.id +"\" style=\"height: 60px;\">";
							htmlStr += "	<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							htmlStr += "		<div style=\"position: relative; top: -40px; left: 40px;\" >";
							htmlStr += "			<h5 id=\"h5_"+ data.retData.id +"\">"+ data.retData.noteContent +"</h5>";
							htmlStr += "			<font color=\"gray\">联系人</font> <font color=\"gray\">-</font> <b>${contacts.fullname}${contacts.appellation}-${contacts.customerId}</b> <small style=\"color: gray;\" id=\"small_"+ data.retData.id +"\"> "+ data.retData.createTime +" 由${sessionScope.sessionUser.name}创建</small>";
							htmlStr += "			<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							htmlStr += "				<a class=\"myHref\" name=\"editA\" remarkId=\""+ data.retData.id +"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr += "				&nbsp;&nbsp;&nbsp;&nbsp;";
							htmlStr += "				<a class=\"myHref\" name=\"removeA\" remarkId=\""+ data.retData.id +"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
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
			//给联系人备注的"修改"图标添加单击事件
			$("#remarkDivList").on("click","a[name='editA']",function () {
				var id = $(this).attr("remarkId");
				var noteContent = $("#h5_" + id).text();
				console.log("#h5_" + id)
				console.log(noteContent)
				//填写参数
				$("#edit-remarkId").val(id);
				$("#edit-noteContent").val(noteContent);
				//打开模态窗口
				$("#editRemarkModal").modal("show");
			});
			//给联系人备注模态窗口的"更新"按键添加单击事件
			$("#saveEditContactsRemarkBtn").click(function () {
				var id = $("#edit-remarkId").val();
				var noteContent = $("#edit-noteContent").val();
				//表单验证
				if (noteContent == "") {
					alert("备注内容不能为空,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/contacts/saveEditContactsRemark.do",
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
							$("#h5_" + data.retData.id).text(data.retData.noteContent);
							$("#small_" + data.retData.id).text(" "+data.retData.editTime +" 由${sessionScope.sessionUser.name}修改");
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#editRemarkModal").modal("show");
						}
					}
				})
			});
            //给联系人备注的"删除"图标添加单击事件
            $("#remarkDivList").on("click","a[name='removeA']",function () {
               //收集参数
               var id = $(this).attr("remarkId");

               $.ajax({
                   url : "workbench/contacts/deleteContactsRemarkById.do",
                   data : {
                       id: id
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
			//给交易窗口的"删除"图标添加单击事件
			$("#deleteTransactionBtn").click(function () {
				//填写参数
				$("#transaction-id").val($(this).attr("transactionId"));
				//打开模态窗口
				$("#removeTransactionModal").modal("show");
			});
			//给删除交易模态窗口的"删除"按键添加单击事件
			$("#saveDeleteTransactionBtn").click(function () {
				//收集参数
				var id = $("#transaction-id").val();

				$.ajax({
					url : "workbench/contacts/deleteTransactionById.do",
					data : {
						id : id
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#removeTransactionModal").modal("hide");
							//刷新交易列表
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
			//给"关联市场活动"图标添加单击事件
			$("#bundActivityBtn").click(function () {
				//初始化
				$("#activityName").val("");
				$("#bundActivityBody").html("");
				//打开模态窗口
				$("#bundActivityModal").modal("show");
			});
            //给联系人和市场活动关联的模态窗口中的搜索文本框添加键盘弹起事件
			$("#activityName").keyup(function () {
				//收集参数
				 var activityName = $("#activityName").val();
				 var contactsId = "${contacts.id}";

				 $.ajax({
					 url : "workbench/contacts/queryActivityForDetailByNameAndContactsId.do",
					 data : {
						 activityName : activityName,
						 contactsId : contactsId
					 },
					 type : "post",
					 dataType : "json",
					 success : function (data) {
						 var htmlStr = "";
						 $.each(data,function (index,activity) {
							htmlStr += "<tr>";
							htmlStr += "	 <td><input type=\"checkbox\" value=\""+ activity.id +"\"/></td>";
							htmlStr += "	 <td>"+ activity.name +"</td>";
							htmlStr += "	 <td>"+ activity.startDate +"</td>";
							htmlStr += "	 <td>"+ activity.endDate +"</td>";
							htmlStr += "	 <td>"+ activity.owner +"</td>";
							htmlStr += "</tr>";
						 });
						 $("#bundActivityBody").html(htmlStr);
					 }
				 })
			});
			//给联系人和市场活动关联的模态窗口中的全选框添加单击事件
			$("#checkAll").click(function () {
				$("#bundActivityBody input[type='checkbox']").prop("checked",this.checked);
			});
			//给联系人和市场活动关联的模态窗口中的单选框添加单击事件
			$("#bundActivityBody").on("click","input[type='checkbox']",function () {
				if ($("#bundActivityBody input[type='checkbox']:checked").size() == $("#bundActivityBody input[type='checkbox']").size()) {
					$("#checkAll").prop("checked",true);
				} else {
					$("#checkAll").prop("checked",false);
				}
			});
			//给联系人和市场活动关联的模态窗口中的"关联"按键添加单击事件
			$("#saveBundActivityBtn").click(function () {
				//收集参数
				var checkedBoxes = $("#bundActivityBody input[type='checkbox']:checked");
				var params = "";
				$.each(checkedBoxes,function () {
					params += "id=" + this.value + "&";
 				});
				params += "contactsId=${contacts.id}";

				$.ajax({
					url : "workbench/contacts/bundActivity.do",
					data : params,
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#bundActivityModal").modal("hide");
							var htmlStr = "";
							$.each(data.retData,function (index,activity) {
								htmlStr += "<tr id=\"tr_"+ activity.id +"\">";
								htmlStr += "	<td><a href=\"workbench/activity/detailActivity.do?id="+ activity.id +"\" style=\"text-decoration: none;\">"+ activity.name +"</a></td>";
								htmlStr += "	<td>"+ activity.startDate +"</td>";
								htmlStr += "	<td>"+ activity.endDate +"</td>";
								htmlStr += "	<td>"+ activity.owner +"</td>";
								htmlStr += "	<td><a href=\"javascript:void(0);\" name=\"unbundA\" activityId=\""+ activity.id +"\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
								htmlStr += "</tr>";
							});
							$("#activityBody").append(htmlStr);
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#bundActivityModal").modal("show");
						}
					}
				})
			});
			//给市场活动窗口的"解除关联"添加单击事件
			$("#activityBody").on("click","a[name='unbundA']",function () {
				//填写参数
				$("#unbund-activityId").val($(this).attr("activityId"));
				//打开模态窗口
				$("#unbundActivityModal").modal("show");
			});
			//给解除联系人和市场活动关联的模态窗口中的"删除"按键添加单击事件
			$("#saveUnbundActivityBtn").click(function () {
				//收集参数
				var activityId = $("#unbund-activityId").val();

				$.ajax({
					url : "workbench/contacts/unbundActivity.do",
					data : {
						activityId : activityId
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#unbundActivityModal").modal("hide");
							//刷新关联市场活动列表
							$("#tr_" + activityId).remove();
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#unbundActivityModal").modal("show");
						}
					}
				})
			});
		});
		
	</script>

</head>
<body>

	<!-- 修改联系人备注的模态窗口 -->
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
					<button type="button" class="btn btn-primary" id="saveEditContactsRemarkBtn">更新</button>
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
					<button type="button" class="btn btn-danger" id="saveDeleteTransactionBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<input type="hidden" id="unbund-activityId">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="saveUnbundActivityBtn">解除</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="activityName">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="checkAll"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="bundActivityBody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveBundActivityBtn">关联</button>
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
					<h4 class="modal-title" id="myModalLabel">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
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
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${contacts.fullname}${contacts.appellation} <small> - ${contacts.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editContactsBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteContactsBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.fullname}${contacts.appellation}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.birthday}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contacts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contacts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contacts.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contacts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contacts.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contacts.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${contacts.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div style="position: relative; top: 20px; left: 40px;" id="remarkDivList">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${contactsRemarkList}" var="contactsRemark">
			<div class="remarkDiv" id="div_${contactsRemark.id}" style="height: 60px;">
				<img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="h5_${contactsRemark.id}">${contactsRemark.noteContent}</h5>
					<font color="gray">联系人</font> <font color="gray">-</font> <b>${contacts.fullname}${contacts.appellation}-${contacts.customerId}</b> <small style="color: gray;" id="small_${contactsRemark.id}"> ${contactsRemark.editFlag == "0" ? contactsRemark.createTime : contactsRemark.editTime} 由${contactsRemark.editFlag == "0" ? contactsRemark.createBy : contactsRemark.editBy}${contactsRemark.editFlag == "0" ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editA" remarkId="${contactsRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="removeA" remarkId="${contactsRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>

		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button type="button" class="btn btn-primary" id="saveCreateContactsRemarkBtn">保存</button>
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
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
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
					<tbody>
						<c:forEach items="${transactionList}" var="transaction">
							<tr id="transactionTr_${transaction.id}">
								<td><a href="workbench/transaction/detailTransaction.do?id=${transaction.id}" style="text-decoration: none;">${transaction.name}</a></td>
								<td>${transaction.money}</td>
								<td>${transaction.stage}</td>
								<td>${transaction.possibility}</td>
								<td>${transaction.expectedDate}</td>
								<td>${transaction.type}</td>
								<td><a href="javascript:void(0);" id="deleteTransactionBtn" style="text-decoration: none;" transactionId="${transaction.id}"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td><a href="../transaction/detail.html" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/contacts/createTransaction.do?id=${contacts.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<c:forEach items="${activityList}" var="activity">
							<tr id="tr_${activity.id}">
								<td><a href="workbench/activity/detailActivity.do?id=${activity.id}" style="text-decoration: none;">${activity.name}</a></td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a href="javascript:void(0);" name="unbundA" activityId="${activity.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td><a href="../activity/detail.html" style="text-decoration: none;">发传单</a></td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="bundActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>