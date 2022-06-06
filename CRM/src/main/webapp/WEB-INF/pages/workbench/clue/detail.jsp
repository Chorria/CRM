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
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/cn.js"></script>
	
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
			});
			
			$(".remarkDiv").mouseout(function(){
				$(this).children("div").children("div").hide();
			});
			
			$(".myHref").mouseover(function(){
				$(this).children("span").css("color","red");
			});
			
			$(".myHref").mouseout(function(){
				$(this).children("span").css("color","#E6E6E6");
			});*/

			$("#remarkDivList").on("mouseover",".remarkDiv",function () {
				$(this).children("div").children("div").show();
			});

			$("#remarkDivList").on("mouseout",".remarkDiv",function () {
				$(this).children("div").children("div").hide();
			});

			$("#remarkDivList").on("mouseover",".myHref",function () {
				$(this).children("span").css("color","red");
			});

			$("#remarkDivList").on("mouseout",".myHref",function () {
				$(this).children("span") .css("color","#E6E6E6");
			});
			//给线索备注中的"保存"按键添加单击事件
			$("#saveCreateClueRemarkBtn").click(function () {
				//收集参数
				var noteContent = $.trim($("#remark").val());
				var clueId = "${clue.id}";
				//表单验证
				if (noteContent == "") {
					alert("备注内容不能为空,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/clue/saveCreateClueRemark.do",
					data : {
						noteContent : noteContent,
						clueId : clueId
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//清空输入框
							$("#remark").val("");
							//刷新备注列表
							var htmlStr = "";
							htmlStr += "<div id=\"div_"+ data.retData.id +"\" class=\"remarkDiv\" style=\"height: 60px;\">";
							htmlStr += "	<img title=\"${sessionScope.sessionUser.name}\" src=\"image/takagi.jpg\" style=\"width: 30px; height:30px;\">";
							htmlStr += "		<div style=\"position: relative; top: -40px; left: 40px;\" >";
							htmlStr += "			<h5 id=\"h5_"+ data.retData.id +"\">"+ data.retData.noteContent +"</h5>";
							htmlStr += "			<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small id=\"small_"+ data.retData.id +"\" style=\"color: gray;\"> "+ data.retData.createTime +" 由${sessionScope.sessionUser.name}创建</small>";
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
			//给线索备注中的"删除"按键添加单击事件
			$("#remarkDivList").on("click","a[name='removeA']",function () {
				//收集参数
				var id = $(this).attr("remarkId");

				$.ajax({
					url : "workbench/clue/deleteClueRemarkById.do",
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
			//给线索备注中的"修改"按键添加单击事件
			$("#remarkDivList").on("click","a[name='editA']",function () {
				//收集参数
				var id = $(this).attr("remarkId");
				var noteContent = $("#h5_" + id).text();
				//记录参数id和noteContent
				$("#edit-id").val(id);
				$("#edit-noteContent").text(noteContent);
				//展示模态窗口
				$("#editRemarkModal").modal("show");
			});
			//给修改线索备注模态窗口中的"更新"按键添加单击事件
			$("#updateRemarkBtn").click(function () {
				//收集参数
				var id = $("#edit-id").val();
				var noteContent = $("#edit-noteContent").val();
				//表单验证
				if (noteContent == "") {
					alert("备注内容不能为空,请重新输入!");
					return;
				}

				$.ajax({
					url : "workbench/clue/saveEditClueRemark.do",
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
			//给"关联市场活动"按键添加单击事件
			$("#bundActivityBtn").click(function () {
				//初始化
				$("#bund-queryActivity").val("");
				$("#bundActivityBody").html("");
				//展开模态窗口
				$("#bundModal").modal("show");
			});
			//查询该线索未关联的所有市场活动
			$("#bund-queryActivity").keyup(function () {
				//收集参数
				var clueId = "${clue.id}";
				var activityName = $("#bund-queryActivity").val();

				$.ajax({
					url : "workbench/clue/queryActivityForDetailByNameAndClueId.do",
					data : {
						clueId : clueId,
						activityName : activityName
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						//遍历data，显示搜索到的线索列表
						var htmlStr = "";
						console.log(data);
						$.each(data,function (index,activity) {
							htmlStr += "<tr>";
							htmlStr += "	<td><input type=\"checkbox\" value=\""+ activity.id +"\"/></td>";
							htmlStr += "	<td>"+ activity.name +"</td>";
							htmlStr += "	<td>"+ activity.startDate +"</td>";
							htmlStr += "	<td>"+ activity.endDate +"</td>";
							htmlStr += "	<td>"+ activity.owner +"</td>";
							htmlStr += "</tr>";
						});
						$("#bundActivityBody").html(htmlStr);
					}
				});
			});
			//给关联市场活动模态窗口的全选框添加单击事件
			$("#checkAll").click(function () {
				 $("#bundActivityBody input[type='checkbox']").prop("checked",this.checked);
			});
			//关联市场活动模态窗口中,若单选没被全部选中,取消"全选"
			$("#bundActivityBody").on("click","input[type='checkbox']",function () {
				var checkedBox = $("#bundActivityBody input[type='checkbox']:checked");
				var checkBox = $("#bundActivityBody input[type='checkbox']");
				if (checkedBox.size() == checkBox.size() ) {
					$("#checkAll").prop("checked",true);
				} else {
					$("#checkAll").prop("checked",false);
				}
			});
			//给关联市场活动模态窗口的"关联"按键添加单击事件
			$("#saveBundActivityBtn").click(function () {
				var ids = "";
				var checkedBoxes = $("#bundActivityBody input[type='checkbox']:checked");
				//表单验证
				if (checkedBoxes.size() == 0) {
					alert("每次至少得关联一个市场活动,请重新选择!");
					return;
				}
				$.each(checkedBoxes,function () {
					ids += "id=" + this.value + "&";
				});
				ids = ids.substring(0,ids.length - 1);

				ids += "&clueId=${clue.id}";

				$.ajax({
					url : "workbench/clue/saveBundActivity.do",
					data : ids,
					type : "post",
					dataType : "json",
					success : function (data) {
						if (data.code == "1") {
							//关闭模态窗口
							$("#bundModal").modal("hide");
							//刷新已经关联过的市场活动列表
							var htmlStr = "";
							$.each(data.retData,function (index,activity) {
								htmlStr += "<tr id=\"tr_"+ activity.id +"\">";
								htmlStr += "	<td>"+ activity.name +"</td>";
								htmlStr += "	<td>"+ activity.startDate +"</td>";
								htmlStr += "	<td>"+ activity.endDate +"</td>";
								htmlStr += "	<td>"+ activity.owner +"</td>";
								htmlStr += "	<td><a activityId=\""+ activity.id +"\" href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
								htmlStr += "</tr>";
							});
							$("#activityBody").append(htmlStr);
						} else {
							//提示错误信息
							alert(data.message);
							//不关闭模态窗口
							$("#bundModal").modal("hide");
						}
					}
				});
			});
			//给关联的市场活动的”解除关联“添加单击事件
			$("#activityBody").on("click","a",function () {
				//收集参数
				var clueId = "${clue.id}";
				var activityId = $(this).attr("activityId");

				if (window.confirm("确认删除吗?")) {
					$.ajax({
						url : "workbench/clue/deleteBundActivity.do",
						data : {
							clueId : clueId,
							activityId : activityId
						},
						type : "post",
						dataType : "json",
						success : function (data) {
							if (data.code == "1") {
								//刷新已经关联的市场活动列表
								$("#tr_" + activityId).remove();
							} else {
								//提示错误信息
								alert(data.message);
							}
						}
					});
				};
			});
		});
		
	</script>
</head>
<body>

	<!-- 修改线索备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<input type="hidden" id="edit-id"/>
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

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
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
						    <input id="bund-queryActivity" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
					<div id="pageDiv">

					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveBundActivityBtn">关联</button>
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
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.do?id=${clue.id}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job == "" ? "无" : clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email == "" ? "无" : clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone == "" ? "无" : clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website == "" ? "无" : clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone == "" ? "无" : clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state == null ? "无" : clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source == null ? "无" : clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy == null ? "无" : clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description == "" ? "无" : clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary == "" ? "无" : clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime == "" ? "无" : clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address == "" ? "无" : clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;" id="remarkDivList">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${clueRemarkList}" var="clueRemark">
			<div id="div_${clueRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${clueRemark.createBy}" src="image/takagi.jpg" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="h5_${clueRemark.id}">${clueRemark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small id="small_${clueRemark.id}" style="color: gray;"> ${clueRemark.editFlag == "0"? clueRemark.createTime : clueRemark.editTime } 由${clueRemark.editFlag == "0" ? clueRemark.createBy : clueRemark.editBy}${clueRemark.editFlag == "0" ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editA" remarkId="${clueRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="removeA" remarkId="${clueRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button id="saveCreateClueRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
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
								<td>${activity.name}</td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a href="javascript:void(0);"  style="text-decoration: none;" activityId="${activity.id}"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
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