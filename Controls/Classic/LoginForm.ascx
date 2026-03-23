<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LoginForm.ascx.cs" Inherits="AgentSite4.Controls.LoginForm" %>
<div class="inset">
        <div class="form-group">
            <div class="col-xs-12">
                <input class="form-control form-control-sm" type="text" name="Account" id="Account" placeholder="Agent ID" required />
            </div>
        </div>
        <div class="form-group">
            <div class="col-xs-12">
                <input class="form-control form-control-sm" type="password" name="Password" id="Password" placeholder="Password" />
            </div>
        </div>
    </div>
    <div class="form-group">
        <button class="btn btn-info btn-lg btn-block text-uppercase waves-effect waves-light" type="submit" value="Login" />Sign In</button>
    </div>
    <div runat="server" id="divError" class="alert alert-danger" role="alert" visible="false">
        <%=ErrorMsg%> 
    </div>
